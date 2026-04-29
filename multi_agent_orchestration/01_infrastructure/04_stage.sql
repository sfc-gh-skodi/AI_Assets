-- =============================================================
-- STEP 4: INTERNAL STAGE (SSE)
-- =============================================================
-- A Stage is a file storage location inside Snowflake.
-- Agents can write generated reports here (CSVs, PDFs, etc.)
-- and serve them via GET_PRESIGNED_URL — a time-limited
-- download link that works without a Snowflake login.
--
-- ENCRYPTION = SNOWFLAKE_SSE is required for GET_PRESIGNED_URL
-- to function. Without SSE, presigned URLs are not supported.
-- =============================================================

CREATE STAGE IF NOT EXISTS DEMOS.WEWORK.AGENT_REPORTS
    ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE')
    COMMENT    = 'Agent-generated reports — SSE enables GET_PRESIGNED_URL for shareable download links';
