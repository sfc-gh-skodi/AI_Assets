-- =============================================================
-- PYTHON UDF: CALL_HR_AGENT
-- =============================================================
-- Calls the HR_AGENT via the Cortex Agents REST API using
-- Server-Sent Events (SSE) streaming.
--
-- Same pattern as 01_call_sales_agent.sql — see that file for
-- the full explanation of SSE parsing and PAT token flow.
--
-- The HR Agent answers questions about:
-- - Employee headcount, departments, titles, salaries, locations
-- - Open job roles, hiring pipeline, levels, hiring managers
-- =============================================================

CREATE OR REPLACE FUNCTION DEMOS.WEWORK.CALL_HR_AGENT(USER_QUERY STRING)
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
    Calls the HR_AGENT via REST API and returns the text response.
    Handles Server-Sent Events (SSE) streaming format.
    """
    try:
        token = _snowflake.get_generic_secret_string('agent_token')
    except Exception as e:
        return f"Error: Could not read secret. Verify grants. Details: {str(e)}"

    url = "https://sfpscogs-thb83496.snowflakecomputing.com/api/v2/databases/DEMOS/schemas/WEWORK/agents/HR_AGENT:run"

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
        "Accept": "text/event-stream"
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
        response = requests.post(url, headers=headers, json=payload, stream=True)

        if response.status_code != 200:
            return f"API Error {response.status_code}: {response.text}"

        final_answer = []
        current_event = None

        for line in response.iter_lines():
            if not line:
                continue

            decoded_line = line.decode('utf-8')

            if decoded_line.startswith('event: '):
                current_event = decoded_line[7:].strip()

            if decoded_line.startswith('data: '):
                data_str = decoded_line[6:]
                if data_str == '[DONE]':
                    break

                try:
                    data = json.loads(data_str)
                    if current_event == 'response.text.delta' and 'text' in data:
                        final_answer.append(data['text'])
                except json.JSONDecodeError:
                    continue

        return "".join(final_answer) if final_answer else "Agent returned no text content."

    except Exception as e:
        return f"Connection error: {str(e)}"
$$;

-- Quick test (uncomment to run):
-- SELECT DEMOS.WEWORK.CALL_HR_AGENT('How many active employees do we have by department?');
