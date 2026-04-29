-- =============================================================
-- AGENT: FINANCE_AGENT
-- =============================================================
-- Specialist agent for financial data.
-- Tools: budget_analyst, expenses_analyst
-- Semantic views: SV_BUDGET, SV_EXPENSES
--
-- This agent answers questions about department budgets vs
-- actuals, expense transactions, vendor spend, and categories.
-- =============================================================

CREATE OR REPLACE AGENT DEMOS.WEWORK.FINANCE_AGENT
    COMMENT = 'Specialist finance agent — budgets, actuals, expenses, vendors'
    PROFILE = '{"display_name": "Finance Agent", "color": "red"}'
    FROM SPECIFICATION
    $$
    models:
      orchestration: auto

    instructions:
      system: "You are a helpful Finance Agent. You answer questions about budgets, actuals, expenses, vendors, and financial performance using live data."
      response: "Respond in a precise, analytical tone. Highlight variances, trends, and key financial metrics."
      orchestration: "Use budget_analyst for questions about budget vs actuals, departmental spend, and monthly financial performance. Use expenses_analyst for questions about individual expense transactions, vendors, categories, and approved spend."
      sample_questions:
        - question: "Which department is most over budget?"
          answer: "I'll compare budget vs actuals across departments to find the biggest overage."
        - question: "What are our top expense vendors?"
          answer: "Let me pull the expense data and rank vendors by total spend."

    tools:
      - tool_spec:
          type: "cortex_analyst_text_to_sql"
          name: "budget_analyst"
          description: "Answers questions about departmental budgets vs actuals by category and month. Use for budget variance analysis, over/under budget questions, and monthly financial performance."
      - tool_spec:
          type: "cortex_analyst_text_to_sql"
          name: "expenses_analyst"
          description: "Answers questions about individual expense transactions including department, category, vendor, amount, date and approval status. Use for detailed spend analysis and vendor questions."

    tool_resources:
      budget_analyst:
        semantic_view: "DEMOS.WEWORK.SV_BUDGET"
        execution_environment:
          warehouse: "CORTEX_ANALYST_WH"
      expenses_analyst:
        semantic_view: "DEMOS.WEWORK.SV_EXPENSES"
        execution_environment:
          warehouse: "CORTEX_ANALYST_WH"
    $$;
