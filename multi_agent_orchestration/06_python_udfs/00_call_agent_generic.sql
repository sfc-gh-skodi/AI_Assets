-- =============================================================
-- GENERIC AGENT CALLER UDF (REUSABLE CORE)
-- =============================================================
-- Single Python UDF containing all the SSE streaming logic.
-- Takes any fully-qualified agent name and a query.
--
-- The 3 per-agent UDFs (01/02/03) are thin SQL wrappers that
-- simply call this function with a hardcoded agent name —
-- so all SSE logic lives in one place, maintained once.
--
-- PARAMETERS:
--   AGENT_FQN  — fully qualified agent name: 'DB.SCHEMA.AGENT'
--   USER_QUERY — natural language question to send
--
-- EXAMPLE:
--   SELECT DEMOS.WEWORK.CALL_CORTEX_AGENT(
--       'DEMOS.WEWORK.SALES_AGENT',
--       'What are our top deals this quarter?'
--   );
-- =============================================================

CREATE OR REPLACE FUNCTION DEMOS.WEWORK.CALL_CORTEX_AGENT(
    AGENT_FQN  STRING,   -- Fully qualified agent name (DB.SCHEMA.AGENT)
    USER_QUERY STRING    -- Natural language question
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.12'
PACKAGES = ('requests', 'snowflake-snowpark-python')
EXTERNAL_ACCESS_INTEGRATIONS = (CORTEX_AGENT_EXTERNAL_ACCESS)
SECRETS = ('agent_token' = DEMOS.WEWORK.CORTEX_AGENT_TOKEN_SECRET)
HANDLER = 'run_agent'
AS
$$
import _snowflake
import requests
import json

def run_agent(agent_fqn, user_query):
    """
    Calls any Cortex Agent via the REST API and returns the answer text.
    Parses Server-Sent Events (SSE) streaming response.

    agent_fqn format: 'DATABASE.SCHEMA.AGENT_NAME'
    The FQN is parsed to construct the API endpoint URL dynamically.
    """
    # Step 1: Retrieve PAT token from Snowflake Secrets vault.
    # 'agent_token' matches the alias declared in SECRETS = (...) above.
    try:
        token = _snowflake.get_generic_secret_string('agent_token')
    except Exception as e:
        return f"Error: Could not read secret. Verify grants. Details: {str(e)}"

    # Step 2: Parse the fully qualified name to build the endpoint URL.
    # FQN format: 'DEMOS.WEWORK.SALES_AGENT' → ['DEMOS', 'WEWORK', 'SALES_AGENT']
    try:
        parts = agent_fqn.split('.')
        if len(parts) != 3:
            return f"Error: AGENT_FQN must be in DB.SCHEMA.AGENT format, got: {agent_fqn}"
        db, schema, agent = parts[0], parts[1], parts[2]
    except Exception as e:
        return f"Error parsing AGENT_FQN: {str(e)}"

    # Step 3: Construct the Cortex Agents REST API endpoint.
    # Format: https://<org>-<account>.snowflakecomputing.com
    #         /api/v2/databases/<db>/schemas/<schema>/agents/<agent>:run
    account_url = "https://sfpscogs-thb83496.snowflakecomputing.com"
    url = f"{account_url}/api/v2/databases/{db}/schemas/{schema}/agents/{agent}:run"

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
        "Accept": "text/event-stream"   # Request SSE streaming response
    }

    payload = {
        "messages": [
            {
                "role": "user",
                "content": [{"type": "text", "text": user_query}]
            }
        ]
    }

    try:
        # Step 4: POST with stream=True to process response line-by-line.
        response = requests.post(url, headers=headers, json=payload, stream=True)

        if response.status_code != 200:
            return f"API Error {response.status_code}: {response.text}"

        # Step 5: Parse the SSE stream.
        # SSE format per message:
        #   event: response.text.delta
        #   data: {"text": "partial answer..."}
        #   (blank line between messages)
        # We collect all 'response.text.delta' text values and join them.
        final_answer = []
        current_event = None

        for line in response.iter_lines():
            if not line:
                continue

            decoded_line = line.decode('utf-8')

            # Track the current event type
            if decoded_line.startswith('event: '):
                current_event = decoded_line[7:].strip()

            # Extract the data payload
            if decoded_line.startswith('data: '):
                data_str = decoded_line[6:]
                if data_str == '[DONE]':
                    break   # Stream complete

                try:
                    data = json.loads(data_str)
                    # Only collect text delta events — these are the answer content
                    if current_event == 'response.text.delta' and 'text' in data:
                        final_answer.append(data['text'])
                except json.JSONDecodeError:
                    continue    # Skip malformed lines

        return "".join(final_answer) if final_answer else "Agent returned no text content."

    except Exception as e:
        return f"Connection error: {str(e)}"
$$;
