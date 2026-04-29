-- =============================================================
-- AGENT: SALES_AGENT
-- =============================================================
-- Specialist agent for sales data.
-- Tools: sales_pipeline_analyst, sales_revenue_analyst
-- Semantic views: SV_SALES_PIPELINE, SV_SALES_REVENUE
--
-- This agent answers questions about deals, pipeline stages,
-- rep performance, revenue by product/region, and monthly trends.
-- =============================================================

CREATE OR REPLACE AGENT DEMOS.WEWORK.SALES_AGENT
    COMMENT = 'Specialist sales agent — pipeline, deals, revenue, rep performance'
    PROFILE = '{"display_name": "Sales Agent", "color": "blue"}'
    FROM SPECIFICATION
    $$
    models:
      orchestration: auto

    instructions:
      system: "You are a helpful Sales Agent. You answer questions about sales pipeline, deals, revenue trends, and product performance using live data."
      response: "Respond in a clear, data-driven tone. Cite specific numbers and trends from the data."
      orchestration: "Use sales_pipeline_analyst for questions about deals, stages, reps, accounts, and pipeline. Use sales_revenue_analyst for questions about revenue, products, units sold, and monthly trends."
      sample_questions:
        - question: "What are our top deals by amount?"
          answer: "I'll look up the highest-value deals in our pipeline."
        - question: "What was our total revenue in January?"
          answer: "I'll pull the revenue figures for January from our sales data."

    tools:
      - tool_spec:
          type: "cortex_analyst_text_to_sql"
          name: "sales_pipeline_analyst"
          description: "Answers questions about the sales pipeline including deals, stages, amounts, reps, accounts and regions. Use for pipeline health, deal status, and rep performance questions."
      - tool_spec:
          type: "cortex_analyst_text_to_sql"
          name: "sales_revenue_analyst"
          description: "Answers questions about monthly sales revenue by product and region including units sold and revenue trends. Use for revenue analysis, product performance, and regional breakdowns."

    tool_resources:
      sales_pipeline_analyst:
        semantic_view: "DEMOS.WEWORK.SV_SALES_PIPELINE"
        execution_environment:
          warehouse: "CORTEX_ANALYST_WH"
      sales_revenue_analyst:
        semantic_view: "DEMOS.WEWORK.SV_SALES_REVENUE"
        execution_environment:
          warehouse: "CORTEX_ANALYST_WH"
    $$;
