# AI_Assets

Snowflake AI Assets — reusable patterns for building production-grade AI applications on Snowflake.

---

## Multi-Agent Orchestration

A fully worked example of multi-agent orchestration using Snowflake Intelligence (Cortex Agents).

### Architecture

```
User Question
      │
      ▼
 MULTIAGENT  (orchestrator — routes the question via LLM)
 ├── sales_agent tool   ──► SALES_AGENT
 │                           ├── Cortex Analyst → SV_SALES_PIPELINE
 │                           └── Cortex Analyst → SV_SALES_REVENUE
 ├── hr_agent tool      ──► HR_AGENT
 │                           ├── Cortex Analyst → SV_EMPLOYEES
 │                           └── Cortex Analyst → SV_OPEN_ROLES
 └── finance_agent tool ──► FINANCE_AGENT
                             ├── Cortex Analyst → SV_BUDGET
                             └── Cortex Analyst → SV_EXPENSES
```

Each sub-agent is exposed to the orchestrator as a **custom tool** backed by a SQL stored procedure calling `SNOWFLAKE.CORTEX.DATA_AGENT_RUN()`.

### Folder Structure

```
multi_agent_orchestration/
├── 01_infrastructure/     Network rule, secret, EAI, stage, role grants
├── 02_data/               Synthetic tables with INSERT data (6 tables)
├── 03_semantic_views/     FastGen-generated YAML specs (6 semantic views)
├── 04_agents/             CREATE AGENT SQL for all 4 agents
├── 05_wrapper_procedures/ SQL stored procs wrapping DATA_AGENT_RUN
├── 06_python_udfs/        Advanced REST API pattern: 1 generic Python UDF + 3 thin SQL wrappers
└── deploy_all.sql         Master deployment script
```

### Quick Start

See [`multi_agent_orchestration/README.md`](multi_agent_orchestration/README.md) for full setup instructions.

---

## License

Apache 2.0
