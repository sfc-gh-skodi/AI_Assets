-- =============================================================
-- PYTHON UDF: CALL_FINANCE_AGENT
-- =============================================================
-- Calls the FINANCE_AGENT via the Cortex Agents REST API.
-- Same pattern as 01_call_sales_agent.sql — see that file
-- for the full explanation of why this approach is used.
--
-- Routes to FINANCE_AGENT for questions about:
--   budgets, actuals, budget variance, expenses, vendor spend
-- =============================================================

CREATE OR REPLACE FUNCTION DEMOS.WEWORK.CALL_FINANCE_AGENT(QUERY STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('requests')
EXTERNAL_ACCESS_INTEGRATIONS = (CORTEX_AGENT_EXTERNAL_ACCESS)
SECRETS = ('pat_token' = DEMOS.WEWORK.CORTEX_AGENT_PAT)
AS $$
import requests
import json
import _snowflake

def call_finance_agent(query: str) -> str:
    pat_token = _snowflake.get_generic_secret_string('pat_token')

    payload = {
        "messages": [
            {"role": "user", "content": [{"type": "text", "text": query}]}
        ],
        "stream": False
    }

    account_url = "https://sfpscogs-thb83496.snowflakecomputing.com"
    endpoint = f"{account_url}/api/v2/databases/DEMOS/schemas/WEWORK/agents/FINANCE_AGENT:run"

    response = requests.post(
        endpoint,
        headers={
            "Authorization": f"Bearer {pat_token}",
            "Content-Type": "application/json",
            "Accept": "application/json"
        },
        json=payload,
        timeout=60
    )

    if response.status_code == 200:
        data = response.json()
        messages = data.get("messages", [])
        for msg in reversed(messages):
            if msg.get("role") == "assistant":
                content = msg.get("content", [])
                if content:
                    return content[0].get("text", "No text in response")
        return json.dumps(data)
    else:
        return f"Error {response.status_code}: {response.text}"
$$;

-- Quick test (uncomment to run):
-- SELECT DEMOS.WEWORK.CALL_FINANCE_AGENT('Which department is most over budget?');
