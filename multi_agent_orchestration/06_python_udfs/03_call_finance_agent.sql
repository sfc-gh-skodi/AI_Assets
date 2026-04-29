-- =============================================================
-- AGENT-SPECIFIC UDF: CALL_FINANCE_AGENT
-- =============================================================
-- Thin SQL wrapper around the generic CALL_CORTEX_AGENT UDF.
-- Hardcodes the Finance Agent FQN so callers don't need to know
-- the agent's fully qualified name.
--
-- ALL SSE streaming logic lives in 00_call_agent_generic.sql.
-- To change the streaming behaviour, edit that file only.
--
-- PRE-REQUISITE: Deploy 00_call_agent_generic.sql first.
-- =============================================================

CREATE OR REPLACE FUNCTION DEMOS.WEWORK.CALL_FINANCE_AGENT(USER_QUERY STRING)
RETURNS STRING
AS
$$
    DEMOS.WEWORK.CALL_CORTEX_AGENT('DEMOS.WEWORK.FINANCE_AGENT', USER_QUERY)
$$;

-- Quick test (uncomment to run):
-- SELECT DEMOS.WEWORK.CALL_FINANCE_AGENT('Which department is most over budget?');
