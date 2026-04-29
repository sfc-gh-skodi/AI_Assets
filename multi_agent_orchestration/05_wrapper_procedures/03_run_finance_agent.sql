-- =============================================================
-- WRAPPER PROCEDURE: RUN_FINANCE_AGENT
-- =============================================================
-- Acts as a telephone operator between the MULTIAGENT
-- orchestrator and the FINANCE_AGENT specialist.
--
-- The orchestrator routes here for questions about:
--   budgets, actuals, budget variance, expenses, vendors,
--   spend by category/department, and approval status.
--
-- CROSS-DOMAIN NOTE:
--   If a user asks a question spanning HR + Finance (e.g.
--   "How many open Engineering roles and what is Engineering's
--   budget variance?"), the orchestrator calls BOTH
--   RUN_HR_AGENT and RUN_FINANCE_AGENT and synthesizes results.
--
-- See 01_run_sales_agent.sql for full pattern explanation.
-- =============================================================

CREATE OR REPLACE PROCEDURE DEMOS.WEWORK.RUN_FINANCE_AGENT(
    QUERY STRING   -- Natural language question from the orchestrator
)
RETURNS VARIANT   -- JSON response from the Finance Agent
LANGUAGE SQL
AS
BEGIN
    RETURN PARSE_JSON(
        SNOWFLAKE.CORTEX.DATA_AGENT_RUN(
            'DEMOS.WEWORK.FINANCE_AGENT',
            '{"messages":[{"role":"user","content":[{"type":"text","text":"'
                || :QUERY ||
            '"}]}],"stream":false}'
        )
    );
END;

-- Quick test (uncomment to run):
-- CALL DEMOS.WEWORK.RUN_FINANCE_AGENT('Which department is most over budget?');
