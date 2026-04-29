-- =============================================================
-- MASTER DEPLOYMENT SCRIPT
-- multi_agent_orchestration/deploy_all.sql
-- =============================================================
-- Run this file top-to-bottom to deploy the entire framework
-- from scratch into DEMOS.WEWORK.
--
-- BEFORE YOU START:
--   1. Edit 01_infrastructure/02_secret.sql and replace
--      <YOUR_PAT_TOKEN_HERE> with a real PAT token
--   2. Ensure your role has ACCOUNTADMIN or equivalent
--   3. Confirm warehouse CORTEX_ANALYST_WH exists
--   4. Upload semantic view YAMLs using the cortex CLI:
--        cortex artifact create ... (see README.md)
--
-- DEPLOYMENT ORDER (must be sequential — each step depends
-- on the objects created in the previous step):
-- =============================================================

-- ── STEP 1: INFRASTRUCTURE ───────────────────────────────────
-- Network rule, secret, EAI, stage, role grants

!source 01_infrastructure/01_network_rule.sql
!source 01_infrastructure/02_secret.sql
!source 01_infrastructure/03_external_access_integration.sql
!source 01_infrastructure/04_stage.sql
!source 01_infrastructure/05_role_grants.sql

-- ── STEP 2: SYNTHETIC DATA ───────────────────────────────────
-- Create and populate all 6 tables

!source 02_data/01_sales_pipeline.sql
!source 02_data/02_sales_revenue.sql
!source 02_data/03_employees.sql
!source 02_data/04_open_roles.sql
!source 02_data/05_budget.sql
!source 02_data/06_expenses.sql

-- ── STEP 3: SEMANTIC VIEWS ───────────────────────────────────
-- Upload YAMLs via cortex CLI (run from repo root):
--
--   SKILL=/path/to/cortex/bundled_skills/semantic-view
--   for f in 03_semantic_views/*.yaml; do
--     uv run --project "$SKILL" python "$SKILL/scripts/upload_semantic_view_yaml.py" \
--       "$f" DEMOS.WEWORK --connection YOUR_CONNECTION
--   done

-- ── STEP 4: AGENTS ───────────────────────────────────────────
-- Create specialist agents (wrapper procs must exist first
-- before creating the orchestrator)

!source 04_agents/01_sales_agent.sql
!source 04_agents/02_hr_agent.sql
!source 04_agents/03_finance_agent.sql

-- ── STEP 5: WRAPPER PROCEDURES ───────────────────────────────
-- SQL stored procs that expose each agent as a callable tool

!source 05_wrapper_procedures/01_run_sales_agent.sql
!source 05_wrapper_procedures/02_run_hr_agent.sql
!source 05_wrapper_procedures/03_run_finance_agent.sql

-- ── STEP 6: ORCHESTRATOR ─────────────────────────────────────
-- Create the top-level orchestrator AFTER wrapper procs exist

!source 04_agents/04_multiagent_orchestrator.sql

-- ── STEP 7 (OPTIONAL): PYTHON UDFs ───────────────────────────
-- Advanced REST API pattern — requires PAT token in secret

-- !source 06_python_udfs/00_call_agent_generic.sql   ← deploy this FIRST
-- !source 06_python_udfs/01_call_sales_agent.sql      ← thin wrapper
-- !source 06_python_udfs/02_call_hr_agent.sql         ← thin wrapper
-- !source 06_python_udfs/03_call_finance_agent.sql    ← thin wrapper

-- ── VERIFICATION ─────────────────────────────────────────────
SHOW SEMANTIC VIEWS IN SCHEMA DEMOS.WEWORK;
SHOW AGENTS IN SCHEMA DEMOS.WEWORK;

-- Test the full stack via the orchestrator:
-- SELECT SNOWFLAKE.CORTEX.DATA_AGENT_RUN(
--     'DEMOS.WEWORK.MULTIAGENT',
--     '{"messages":[{"role":"user","content":[{"type":"text","text":
--      "How many open Engineering roles and what is the Engineering budget variance?"}]}],"stream":false}'
-- );
