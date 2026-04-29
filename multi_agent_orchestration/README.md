# Multi-Agent Orchestration — Setup Guide

## Overview

This module builds a multi-agent orchestration framework on Snowflake Intelligence using Cortex Agents. Three specialist agents (Sales, HR, Finance) are each backed by live Snowflake data via Cortex Analyst semantic views. A top-level orchestrator routes user questions to the right specialist automatically.

## Prerequisites

| Requirement | Notes |
|---|---|
| Snowflake account | AWS recommended for Claude 4 availability |
| ACCOUNTADMIN role | Or a role with CREATE AGENT, CREATE SEMANTIC VIEW, CREATE FUNCTION |
| Warehouse | Named `CORTEX_ANALYST_WH` (or update all SQL files with your warehouse name) |
| Cortex cross-region inference | Recommended: `ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION'` |
| PAT token | Required for Step 6 (Python UDFs) only — generate in Snowsight |

## Deployment Steps

### Step 1 — Infrastructure

```sql
-- Run in order:
01_infrastructure/01_network_rule.sql
01_infrastructure/02_secret.sql          ← replace <YOUR_PAT_TOKEN_HERE> first
01_infrastructure/03_external_access_integration.sql
01_infrastructure/04_stage.sql
01_infrastructure/05_role_grants.sql
```

**What this creates:**
- **Network Rule** — allowlist for outbound calls to Snowflake's Cortex API endpoint
- **Secret** — encrypted vault for your PAT token
- **External Access Integration (EAI)** — bundles the network rule + secret into a keycard for Python UDFs
- **Stage** — SSE-encrypted file storage for agent-generated reports
- **Role Grants** — all required privileges

### Step 2 — Synthetic Data

```sql
02_data/01_sales_pipeline.sql
02_data/02_sales_revenue.sql
02_data/03_employees.sql
02_data/04_open_roles.sql
02_data/05_budget.sql
02_data/06_expenses.sql
```

Creates and populates 6 tables:

| Table | Rows | Used By |
|---|---|---|
| SALES_PIPELINE | 10 deals | Sales Agent |
| SALES_REVENUE | 10 records | Sales Agent |
| EMPLOYEES | 15 employees | HR Agent |
| OPEN_ROLES | 10 positions | HR Agent |
| BUDGET | 20 rows | Finance Agent |
| EXPENSES | 15 transactions | Finance Agent |

### Step 3 — Semantic Views

Upload the 6 YAML files using the Cortex CLI upload script:

```bash
SKILL=~/.local/share/cortex/<version>/bundled_skills/semantic-view

for f in 03_semantic_views/*.yaml; do
  uv run --project "$SKILL" python "$SKILL/scripts/upload_semantic_view_yaml.py" \
    "$f" DEMOS.WEWORK --connection YOUR_CONNECTION_NAME
done
```

| Semantic View | Backing Table | Agent |
|---|---|---|
| SV_SALES_PIPELINE | SALES_PIPELINE | Sales |
| SV_SALES_REVENUE | SALES_REVENUE | Sales |
| SV_EMPLOYEES | EMPLOYEES | HR |
| SV_OPEN_ROLES | OPEN_ROLES | HR |
| SV_BUDGET | BUDGET | Finance |
| SV_EXPENSES | EXPENSES | Finance |

### Step 4 — Specialist Agents

```sql
04_agents/01_sales_agent.sql
04_agents/02_hr_agent.sql
04_agents/03_finance_agent.sql
```

Creates 3 specialist agents, each with 2 Cortex Analyst tools pointing at the semantic views.

### Step 5 — Wrapper Stored Procedures

```sql
05_wrapper_procedures/01_run_sales_agent.sql
05_wrapper_procedures/02_run_hr_agent.sql
05_wrapper_procedures/03_run_finance_agent.sql
```

Each procedure wraps `SNOWFLAKE.CORTEX.DATA_AGENT_RUN()` so that the orchestrator can call a specialist agent as a generic custom tool.

### Step 6 — Orchestrator

```sql
04_agents/04_multiagent_orchestrator.sql
```

Creates `MULTIAGENT` — registers the 3 stored procedures as `generic` tools and configures routing instructions.

### Step 7 (Optional) — Python UDFs

Advanced alternative to the SQL stored procedure pattern. Uses the Cortex Agents REST API directly with PAT token authentication via External Access Integration.

```sql
06_python_udfs/01_call_sales_agent.sql
06_python_udfs/02_call_hr_agent.sql
06_python_udfs/03_call_finance_agent.sql
```

Requires Steps 1–6 to be complete and a valid PAT token in the secret.

## Testing

```sql
-- Test a specialist agent directly:
CALL DEMOS.WEWORK.RUN_SALES_AGENT('What are our top 3 deals by amount?');
CALL DEMOS.WEWORK.RUN_HR_AGENT('How many active employees by department?');
CALL DEMOS.WEWORK.RUN_FINANCE_AGENT('Which department is most over budget?');

-- Test the full orchestrator (cross-domain question):
SELECT SNOWFLAKE.CORTEX.DATA_AGENT_RUN(
    'DEMOS.WEWORK.MULTIAGENT',
    '{"messages":[{"role":"user","content":[{"type":"text","text":
     "How many open Engineering roles and what is the Engineering budget variance?"}]}],"stream":false}'
);
```

## Architecture Decisions

| Decision | Rationale |
|---|---|
| SQL stored procs (not Python UDFs) as wrappers | Simpler, no external network needed, no PAT required |
| `DATA_AGENT_RUN` over REST API | Native built-in, runs in services plane, no EAI setup |
| `generic` tool type in orchestrator | Only way to call a stored procedure from an agent |
| Separate semantic view per table | Keeps each view focused and improves Cortex Analyst accuracy |
| `execution_environment.warehouse` on every tool | Required — Cortex Analyst tools need explicit warehouse |

## Limitations vs Native A2A / LangGraph

See the [limitations discussion](../docs/limitations.md) for a detailed comparison.
