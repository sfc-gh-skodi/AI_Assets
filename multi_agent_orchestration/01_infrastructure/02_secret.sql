-- =============================================================
-- STEP 2: SECRET (PAT TOKEN)
-- =============================================================
-- A Secret is Snowflake's secure vault for storing credentials.
-- The value is encrypted at rest and never exposed in query
-- results or logs.
--
-- We store a Programmatic Access Token (PAT) here.
-- A PAT is a long-lived API key tied to your Snowflake user,
-- used to authenticate REST API calls without a password.
--
-- HOW TO GENERATE A PAT:
--   Snowsight → your username (bottom-left) →
--   My Profile → Programmatic access tokens → + Token
--   Copy the token value — it is only shown once.
--
-- Replace <YOUR_PAT_TOKEN_HERE> with the token you generated.
-- =============================================================

CREATE OR REPLACE SECRET DEMOS.WEWORK.CORTEX_AGENT_TOKEN_SECRET
    TYPE         = GENERIC_STRING
    SECRET_STRING = '<YOUR_PAT_TOKEN_HERE>'
    COMMENT      = 'PAT token for authenticating Cortex Agents REST API calls';
