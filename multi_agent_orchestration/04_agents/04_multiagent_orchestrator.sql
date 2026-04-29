-- =============================================================
-- AGENT: MULTIAGENT (ORCHESTRATOR)
-- =============================================================
-- Top-level orchestrator agent that routes questions to the
-- correct specialist agent: Sales, HR, or Finance.
--
-- Uses 3 custom (generic) tools, each backed by a stored
-- procedure that calls SNOWFLAKE.CORTEX.DATA_AGENT_RUN()
-- on the corresponding specialist agent.
--
-- PRE-REQUISITE: Run 05_wrapper_procedures/ first.
-- =============================================================

CREATE OR REPLACE AGENT DEMOS.WEWORK.MULTIAGENT
    COMMENT = 'Multi-agent orchestrator — routes to Sales, HR and Finance specialist agents'
    PROFILE = '{"display_name": "MULTIAGENT"}'
    FROM SPECIFICATION
    $$
    models:
      orchestration: auto

    instructions:
      system: "You are a multi-agent orchestrator. You route user questions to the right specialist agent: Sales, HR, or Finance. You synthesize their responses into a single, clear answer."
      response: "Respond clearly and concisely. Cite the data returned by the specialist agent. If a question spans multiple domains, call the relevant agents and combine the results."
      orchestration: |
        Route questions based on topic:
        - Sales questions (deals, pipeline, revenue, products, reps, accounts) → use sales_agent
        - HR questions (employees, headcount, hiring, open roles, salaries, departments) → use hr_agent
        - Finance questions (budgets, actuals, expenses, vendors, spend) → use finance_agent
        If a question spans multiple domains, call all relevant agents and synthesize the results.
      sample_questions:
        - question: "What is our total pipeline value?"
          answer: "I'll ask the Sales Agent to pull the pipeline data for you."
        - question: "How many open Engineering roles do we have and what is the Engineering budget variance?"
          answer: "I'll check with both the HR Agent and Finance Agent to answer this."

    tools:
      - tool_spec:
          type: "generic"
          name: "sales_agent"
          description: "Routes questions to the Sales Agent which has live data on deals, pipeline stages, revenue by product and region, and rep performance. Use for any sales, pipeline, revenue, or account questions."
          input_schema:
            type: object
            properties:
              QUERY:
                type: string
                description: "The natural language question to send to the Sales Agent."
            required:
              - QUERY
      - tool_spec:
          type: "generic"
          name: "hr_agent"
          description: "Routes questions to the HR Agent which has live data on employees, headcount, salaries, departments, titles, and open job roles. Use for any HR, workforce, hiring, or employee questions."
          input_schema:
            type: object
            properties:
              QUERY:
                type: string
                description: "The natural language question to send to the HR Agent."
            required:
              - QUERY
      - tool_spec:
          type: "generic"
          name: "finance_agent"
          description: "Routes questions to the Finance Agent which has live data on department budgets vs actuals and expense transactions by vendor and category. Use for any budget, spend, or financial questions."
          input_schema:
            type: object
            properties:
              QUERY:
                type: string
                description: "The natural language question to send to the Finance Agent."
            required:
              - QUERY

    tool_resources:
      sales_agent:
        type: "procedure"
        execution_environment:
          type: "warehouse"
          warehouse: "CORTEX_ANALYST_WH"
          query_timeout: 60
        identifier: "DEMOS.WEWORK.RUN_SALES_AGENT"
      hr_agent:
        type: "procedure"
        execution_environment:
          type: "warehouse"
          warehouse: "CORTEX_ANALYST_WH"
          query_timeout: 60
        identifier: "DEMOS.WEWORK.RUN_HR_AGENT"
      finance_agent:
        type: "procedure"
        execution_environment:
          type: "warehouse"
          warehouse: "CORTEX_ANALYST_WH"
          query_timeout: 60
        identifier: "DEMOS.WEWORK.RUN_FINANCE_AGENT"
    $$;
