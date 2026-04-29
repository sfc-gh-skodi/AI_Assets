-- =============================================================
-- STEP 5: ROLE GRANTS
-- =============================================================
-- Grant the necessary privileges for the agent framework.
-- Run as ACCOUNTADMIN or a role with MANAGE GRANTS privilege.
--
-- Replace AGENT_ROLE with the role that will own/run agents.
-- =============================================================

-- Allow the role to use the schema
GRANT USAGE ON DATABASE DEMOS           TO ROLE ACCOUNTADMIN;
GRANT USAGE ON SCHEMA   DEMOS.WEWORK   TO ROLE ACCOUNTADMIN;

-- Allow creating agents
GRANT CREATE AGENT ON SCHEMA DEMOS.WEWORK TO ROLE ACCOUNTADMIN;

-- Allow creating semantic views
GRANT CREATE SEMANTIC VIEW ON SCHEMA DEMOS.WEWORK TO ROLE ACCOUNTADMIN;

-- Allow using the External Access Integration
GRANT USAGE ON INTEGRATION DEMOS.WEWORK.CORTEX_AGENT_EXTERNAL_ACCESS TO ROLE ACCOUNTADMIN;

-- Allow reading the PAT secret
GRANT USAGE ON SECRET DEMOS.WEWORK.CORTEX_AGENT_PAT TO ROLE ACCOUNTADMIN;

-- Allow using the stage
GRANT READ, WRITE ON STAGE DEMOS.WEWORK.AGENT_REPORTS TO ROLE ACCOUNTADMIN;

-- Allow SELECT on all data tables (needed by semantic views + agents)
GRANT SELECT ON ALL TABLES IN SCHEMA DEMOS.WEWORK TO ROLE ACCOUNTADMIN;

-- Allow using all semantic views
GRANT USAGE ON ALL SEMANTIC VIEWS IN SCHEMA DEMOS.WEWORK TO ROLE ACCOUNTADMIN;

-- Allow running agents
GRANT USAGE ON ALL AGENTS IN SCHEMA DEMOS.WEWORK TO ROLE ACCOUNTADMIN;
