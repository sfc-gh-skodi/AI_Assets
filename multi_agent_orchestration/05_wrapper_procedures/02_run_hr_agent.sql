-- =============================================================
-- WRAPPER PROCEDURE: RUN_HR_AGENT
-- =============================================================
-- Acts as a telephone operator between the MULTIAGENT
-- orchestrator and the HR_AGENT specialist.
--
-- The orchestrator routes here for questions about:
--   employees, headcount, salaries, departments, open roles,
--   hiring pipeline, hiring managers, and job levels.
--
-- See 01_run_sales_agent.sql for full pattern explanation.
-- =============================================================

CREATE OR REPLACE PROCEDURE DEMOS.WEWORK.RUN_HR_AGENT(
    QUERY STRING   -- Natural language question from the orchestrator
)
RETURNS VARIANT   -- JSON response from the HR Agent
LANGUAGE SQL
AS
BEGIN
    RETURN PARSE_JSON(
        SNOWFLAKE.CORTEX.DATA_AGENT_RUN(
            'DEMOS.WEWORK.HR_AGENT',
            '{"messages":[{"role":"user","content":[{"type":"text","text":"'
                || :QUERY ||
            '"}]}],"stream":false}'
        )
    );
END;

-- Quick test (uncomment to run):
-- CALL DEMOS.WEWORK.RUN_HR_AGENT('How many active employees do we have by department?');
