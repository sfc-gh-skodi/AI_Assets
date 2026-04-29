-- =============================================================
-- STEP 3: EXTERNAL ACCESS INTEGRATION (EAI)
-- =============================================================
-- An External Access Integration (EAI) is the "keycard" that
-- bundles a Network Rule + Secrets together into a single
-- object you can attach to a Python UDF or stored procedure.
--
-- Without an EAI, the Network Rule and Secret exist but cannot
-- be used by any UDF — the EAI is what activates them.
--
-- ALLOWED_NETWORK_RULES     → which destinations are permitted
-- ALLOWED_AUTHENTICATION_SECRETS → which secrets can be read
-- ENABLED = TRUE            → the integration is live
--
-- In production, replace ALL with the specific secret name:
--   ALLOWED_AUTHENTICATION_SECRETS = (DEMOS.WEWORK.CORTEX_AGENT_PAT)
-- =============================================================

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION DEMOS.WEWORK.CORTEX_AGENT_EXTERNAL_ACCESS
    ALLOWED_NETWORK_RULES          = (DEMOS.WEWORK.CORTEX_AGENT_EGRESS_RULE)
    ALLOWED_AUTHENTICATION_SECRETS = ALL
    ENABLED                        = TRUE
    COMMENT                        = 'EAI for Python UDFs calling the Cortex Agents REST API';
