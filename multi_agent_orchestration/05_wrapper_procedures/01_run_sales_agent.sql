-- =============================================================
-- WRAPPER PROCEDURE: RUN_SALES_AGENT
-- =============================================================
-- Acts as a telephone operator between the MULTIAGENT
-- orchestrator and the SALES_AGENT specialist.
--
-- The orchestrator can only call "tools" — it cannot call
-- another agent directly. By wrapping DATA_AGENT_RUN in a
-- stored procedure, we turn the Sales Agent into a callable
-- tool registered under the "generic" tool type.
--
-- HOW IT WORKS:
--   1. Receives QUERY (a natural language question) from the
--      orchestrator
--   2. Wraps it in the JSON request format expected by the
--      Cortex Agents API (OpenAI-style messages array)
--   3. Calls SNOWFLAKE.CORTEX.DATA_AGENT_RUN() — the built-in
--      function that runs a Cortex Agent programmatically
--   4. Parses and returns the JSON response as a VARIANT
--
-- NOTE: DATA_AGENT_RUN ignores stream:false/true and always
-- returns a complete non-streaming JSON response.
-- =============================================================

CREATE OR REPLACE PROCEDURE DEMOS.WEWORK.RUN_SALES_AGENT(
    QUERY STRING   -- Natural language question from the orchestrator
)
RETURNS VARIANT   -- JSON response from the Sales Agent
LANGUAGE SQL
AS
BEGIN
    -- :QUERY uses colon-prefix syntax (Snowflake bind variable)
    -- to safely reference the procedure parameter inside SQL.
    -- TO_JSON() wraps the string in JSON quotes AND escapes any
    -- special characters (double-quotes, backslashes, newlines),
    -- preventing malformed JSON if the query contains those chars.
    RETURN PARSE_JSON(
        SNOWFLAKE.CORTEX.DATA_AGENT_RUN(
            'DEMOS.WEWORK.SALES_AGENT',
            '{"messages":[{"role":"user","content":[{"type":"text","text":'
                || TO_JSON(:QUERY) ||
            '}]}],"stream":false}'
        )
    );
END;

-- Quick test (uncomment to run):
-- CALL DEMOS.WEWORK.RUN_SALES_AGENT('What are our top 3 deals by amount?');
