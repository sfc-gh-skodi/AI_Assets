-- =============================================================
-- PYTHON UDF: CALL_SALES_AGENT
-- =============================================================
-- Advanced alternative to the SQL stored procedure pattern.
-- Uses the Cortex Agents REST API directly via Python's
-- requests library instead of DATA_AGENT_RUN().
--
-- WHY USE THIS OVER THE STORED PROCEDURE?
--   - Full control over request headers and response handling
--   - Supports streaming (Server-Sent Events) if needed
--   - Can be called from outside Snowflake (e.g. Streamlit,
--     external apps) using the same PAT token pattern
--   - Better error handling and response parsing control
--
-- PRE-REQUISITES (run 01_infrastructure/ first):
--   1. Network Rule    → CORTEX_AGENT_EGRESS_RULE
--   2. Secret          → CORTEX_AGENT_PAT  (your PAT token)
--   3. External Access Integration → CORTEX_AGENT_EXTERNAL_ACCESS
--
-- HOW THE PAT TOKEN FLOW WORKS:
--   Secret (vault) → _snowflake.get_generic_secret_string()
--   → Authorization: Bearer <token> header → REST API call
-- =============================================================

CREATE OR REPLACE FUNCTION DEMOS.WEWORK.CALL_SALES_AGENT(QUERY STRING)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('requests')

-- Attach the External Access Integration so this UDF can:
--   a) make outbound HTTP calls to the allowed host
--   b) read the PAT secret from the vault
EXTERNAL_ACCESS_INTEGRATIONS = (CORTEX_AGENT_EXTERNAL_ACCESS)
SECRETS = ('pat_token' = DEMOS.WEWORK.CORTEX_AGENT_PAT)

AS $$
import requests
import json
import _snowflake  # Snowflake internal module — only available inside Snowflake

def call_sales_agent(query: str) -> str:
    """
    Calls the SALES_AGENT via the Cortex Agents REST API.

    Steps:
      1. Read the PAT token from Snowflake Secrets vault
      2. Build the API request payload
      3. POST to the Cortex Agents run endpoint
      4. Extract and return the answer text
    """

    # Step 1: Retrieve PAT token securely from the Snowflake Secret.
    # 'pat_token' matches the alias we declared in SECRETS = (...) above.
    # The actual token value is never visible in SQL query history or logs.
    pat_token = _snowflake.get_generic_secret_string('pat_token')

    # Step 2: Build the request payload.
    # The messages array follows the OpenAI-style chat format:
    #   role: "user"    → the question being asked
    #   content type: "text" → plain text input
    payload = {
        "messages": [
            {
                "role": "user",
                "content": [{"type": "text", "text": query}]
            }
        ],
        "stream": False  # Return full JSON response, not streaming SSE
    }

    # Step 3: Call the Cortex Agents REST API endpoint.
    # URL format: https://<org>-<account>.snowflakecomputing.com
    #             /api/v2/databases/<db>/schemas/<schema>/agents/<name>:run
    account_url = "https://sfpscogs-thb83496.snowflakecomputing.com"
    endpoint = f"{account_url}/api/v2/databases/DEMOS/schemas/WEWORK/agents/SALES_AGENT:run"

    response = requests.post(
        endpoint,
        headers={
            "Authorization": f"Bearer {pat_token}",  # PAT authentication
            "Content-Type": "application/json",
            "Accept": "application/json"
        },
        json=payload,
        timeout=60  # Fail gracefully if agent takes too long
    )

    # Step 4: Parse the response and extract the answer text.
    # The response body contains a messages array; the assistant's
    # answer is in the last message's content.
    if response.status_code == 200:
        data = response.json()
        # Navigate: messages → last message → content → first item → text
        messages = data.get("messages", [])
        for msg in reversed(messages):
            if msg.get("role") == "assistant":
                content = msg.get("content", [])
                if content:
                    return content[0].get("text", "No text in response")
        return json.dumps(data)  # Return raw JSON if structure is unexpected
    else:
        return f"Error {response.status_code}: {response.text}"
$$;

-- Quick test (uncomment to run):
-- SELECT DEMOS.WEWORK.CALL_SALES_AGENT('What are our top 3 deals by amount?');
