-- =============================================================
-- AGENT: HR_AGENT
-- =============================================================
-- Specialist agent for HR and workforce data.
-- Tools: employees_analyst, open_roles_analyst
-- Semantic views: SV_EMPLOYEES, SV_OPEN_ROLES
--
-- This agent answers questions about employee headcount,
-- salaries, departments, open positions, and hiring pipeline.
-- =============================================================

CREATE OR REPLACE AGENT DEMOS.WEWORK.HR_AGENT
    COMMENT = 'Specialist HR agent — employees, headcount, hiring, open roles'
    PROFILE = '{"display_name": "HR Agent", "color": "green"}'
    FROM SPECIFICATION
    $$
    models:
      orchestration: auto

    instructions:
      system: "You are a helpful HR Agent. You answer questions about employees, headcount, salaries, open roles, and hiring pipeline using live data."
      response: "Respond in a warm, professional tone. Be concise and highlight key workforce metrics."
      orchestration: "Use employees_analyst for questions about current employees, headcount, departments, salaries, and tenure. Use open_roles_analyst for questions about open positions, hiring pipeline, job levels, and hiring managers."
      sample_questions:
        - question: "How many active employees do we have?"
          answer: "I'll count the active employees from our HR data."
        - question: "How many open roles do we have in Engineering?"
          answer: "I'll check the open roles data for Engineering positions."

    tools:
      - tool_spec:
          type: "cortex_analyst_text_to_sql"
          name: "employees_analyst"
          description: "Answers questions about current employees including headcount, departments, titles, salaries, hire dates, locations and status. Use for workforce analytics and employee data."
      - tool_spec:
          type: "cortex_analyst_text_to_sql"
          name: "open_roles_analyst"
          description: "Answers questions about open job roles including department, level, location, posting date, status and hiring manager. Use for hiring pipeline and open headcount questions."

    tool_resources:
      employees_analyst:
        semantic_view: "DEMOS.WEWORK.SV_EMPLOYEES"
        execution_environment:
          warehouse: "CORTEX_ANALYST_WH"
      open_roles_analyst:
        semantic_view: "DEMOS.WEWORK.SV_OPEN_ROLES"
        execution_environment:
          warehouse: "CORTEX_ANALYST_WH"
    $$;
