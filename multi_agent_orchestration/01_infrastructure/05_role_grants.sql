-- =============================================================
-- STEP 5: ROLE GRANTS
-- =============================================================
-- Creates a general-purpose role for users who need to interact
-- with the multi-agent orchestration framework.
--
-- Run as ACCOUNTADMIN or a role with MANAGE GRANTS privilege.
--
-- ROLE: MULTI_AGENT_USER_ROLE
--   A least-privilege role scoped to running agents and reading
--   data. Does NOT have CREATE or DDL privileges — those stay
--   with ACCOUNTADMIN (or a separate admin role).
-- =============================================================

-- ── CREATE THE ROLE ──────────────────────────────────────────
CREATE ROLE IF NOT EXISTS MULTI_AGENT_USER_ROLE
    COMMENT = 'General user role for the multi-agent orchestration framework — run agents, query data, read reports';

-- ── DATABASE & SCHEMA ACCESS ─────────────────────────────────
-- Allow the role to navigate to the schema
GRANT USAGE ON DATABASE DEMOS         TO ROLE MULTI_AGENT_USER_ROLE;
GRANT USAGE ON SCHEMA   DEMOS.WEWORK  TO ROLE MULTI_AGENT_USER_ROLE;

-- ── DATA TABLES ───────────────────────────────────────────────
-- Read-only access to all synthetic data tables
-- (agents query these via semantic views under the hood)
GRANT SELECT ON ALL TABLES IN SCHEMA DEMOS.WEWORK
    TO ROLE MULTI_AGENT_USER_ROLE;

-- Ensure future tables are also accessible
GRANT SELECT ON FUTURE TABLES IN SCHEMA DEMOS.WEWORK
    TO ROLE MULTI_AGENT_USER_ROLE;

-- ── SEMANTIC VIEWS ────────────────────────────────────────────
-- Required by Cortex Analyst tools inside the specialist agents
GRANT USAGE ON ALL SEMANTIC VIEWS IN SCHEMA DEMOS.WEWORK
    TO ROLE MULTI_AGENT_USER_ROLE;

GRANT USAGE ON FUTURE SEMANTIC VIEWS IN SCHEMA DEMOS.WEWORK
    TO ROLE MULTI_AGENT_USER_ROLE;

-- ── AGENTS ────────────────────────────────────────────────────
-- Allow running all agents (specialist agents + orchestrator)
GRANT USAGE ON ALL AGENTS IN SCHEMA DEMOS.WEWORK
    TO ROLE MULTI_AGENT_USER_ROLE;

GRANT USAGE ON FUTURE AGENTS IN SCHEMA DEMOS.WEWORK
    TO ROLE MULTI_AGENT_USER_ROLE;

-- ── STORED PROCEDURES (WRAPPER PROCS) ────────────────────────
-- Allow calling the DATA_AGENT_RUN wrapper procedures
GRANT USAGE ON ALL PROCEDURES IN SCHEMA DEMOS.WEWORK
    TO ROLE MULTI_AGENT_USER_ROLE;

GRANT USAGE ON FUTURE PROCEDURES IN SCHEMA DEMOS.WEWORK
    TO ROLE MULTI_AGENT_USER_ROLE;

-- ── STAGE ────────────────────────────────────────────────────
-- Read access to agent-generated reports
-- (WRITE is not granted — regular users should not upload files)
GRANT READ ON STAGE DEMOS.WEWORK.AGENT_REPORTS
    TO ROLE MULTI_AGENT_USER_ROLE;

-- ── EXTERNAL ACCESS INTEGRATION ──────────────────────────────
-- Required only if the user will call the Python UDFs (Step 6)
-- Remove this grant if Step 6 (Python UDFs) is not deployed
GRANT USAGE ON INTEGRATION CORTEX_AGENT_EXTERNAL_ACCESS
    TO ROLE MULTI_AGENT_USER_ROLE;

-- ── SECRET ────────────────────────────────────────────────────
-- Required only if the user will call the Python UDFs (Step 6)
-- Remove this grant if Step 6 (Python UDFs) is not deployed
GRANT READ ON SECRET DEMOS.WEWORK.CORTEX_AGENT_TOKEN_SECRET
    TO ROLE MULTI_AGENT_USER_ROLE;

-- ── WAREHOUSE ────────────────────────────────────────────────
-- Allow using the warehouse for agent queries
GRANT USAGE ON WAREHOUSE CORTEX_ANALYST_WH
    TO ROLE MULTI_AGENT_USER_ROLE;

-- ── ASSIGN TO USERS ──────────────────────────────────────────
-- Replace <USERNAME> with the Snowflake user(s) who need access
-- GRANT ROLE MULTI_AGENT_USER_ROLE TO USER <USERNAME>;
