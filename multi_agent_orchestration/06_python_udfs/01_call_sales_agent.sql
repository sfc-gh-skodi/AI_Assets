-- =============================================================
-- PYTHON UDF: CALL_SALES_AGENT
-- =============================================================
-- Calls the SALES_AGENT via the Cortex Agents REST API using
-- Server-Sent Events (SSE) streaming.
--
-- WHY SSE STREAMING INSTEAD OF JSON?
--   The REST API natively returns a streaming response
--   (text/event-stream format). Streaming lets us process the
--   answer incrementally and extract just the text deltas,
--   rather than waiting for a large JSON blob to complete.
--
-- PRE-REQUISITES (run 01_infrastructure/ first):
--   1. Network Rule    → CORTEX_AGENT_EGRESS_RULE
--   2. Secret          → CORTEX_AGENT_TOKEN_SECRET  (PAT token)
--   3. External Access Integration → CORTEX_AGENT_EXTERNAL_ACCESS
--
-- HOW SSE PARSING WORKS:
--   The stream returns lines like:
--     event: response.text.delta
--     data: {"text": "Here is your answer..."}
--   We track the event type, then collect every 'text' value
--   from 'response.text.delta' events and join them at the end.
-- =============================================================

CREATE OR REPLACE FUNCTION DEMOS.WEWORK.CALL_SALES_AGENT(USER_QUERY STRING)
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

def run_agent(user_query):
    """
    Calls the SALES_AGENT via REST API and returns the text response.
    Handles Server-Sent Events (SSE) streaming format.

    The Sales Agent answers questions about:
    - Deals, pipeline stages, amounts, reps, accounts
    - Revenue by product, region, and month
    """
    # Step 1: Retrieve the PAT token securely from Snowflake Secrets.
    # 'agent_token' matches the alias declared in SECRETS = (...) above.
    try:
        token = _snowflake.get_generic_secret_string('agent_token')
    except Exception as e:
        return f"Error: Could not read secret. Verify grants. Details: {str(e)}"

    # Step 2: Build the REST API endpoint.
    # Format: https://<org>-<account>.snowflakecomputing.com
    #         /api/v2/databases/<db>/schemas/<schema>/agents/<agent>:run
    url = "https://sfpscogs-thb83496.snowflakecomputing.com/api/v2/databases/DEMOS/schemas/WEWORK/agents/SALES_AGENT:run"

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
        "Accept": "text/event-stream"  # Request SSE streaming response
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
        # Step 3: POST to the agent endpoint with stream=True so we
        # can process the response line-by-line as it arrives.
        response = requests.post(url, headers=headers, json=payload, stream=True)

        if response.status_code != 200:
            return f"API Error {response.status_code}: {response.text}"

        # Step 4: Parse the SSE stream.
        # Each SSE message looks like:
        #   event: <event_type>
        #   data: <json_payload>
        #   (blank line separating messages)
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
                    break  # Stream complete

                try:
                    data = json.loads(data_str)
                    # Collect only text delta events — these carry the answer
                    if current_event == 'response.text.delta' and 'text' in data:
                        final_answer.append(data['text'])
                except json.JSONDecodeError:
                    continue  # Skip malformed lines

        return "".join(final_answer) if final_answer else "Agent returned no text content."

    except Exception as e:
        return f"Connection error: {str(e)}"
$$;

-- Quick test (uncomment to run):
-- SELECT DEMOS.WEWORK.CALL_SALES_AGENT('What are our top 3 deals by amount?');
