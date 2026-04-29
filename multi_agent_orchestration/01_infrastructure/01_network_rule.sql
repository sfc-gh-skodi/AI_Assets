-- =============================================================
-- STEP 1: NETWORK RULE
-- =============================================================
-- A Network Rule is an allowlist entry that tells Snowflake
-- which external destinations your Python UDFs are permitted
-- to reach. By default, UDFs cannot make ANY outbound calls.
--
-- MODE = EGRESS   → outgoing traffic from Snowflake
-- TYPE = HOST_PORT → we identify destinations by hostname
-- VALUE_LIST      → the specific host(s) allowed
--
-- We allow our own Snowflake account URL because the Python UDF
-- runs in the compute plane and must cross a network boundary
-- to reach the Cortex Agents REST API in the services plane.
-- =============================================================

CREATE OR REPLACE NETWORK RULE DEMOS.WEWORK.CORTEX_AGENT_EGRESS_RULE
    MODE       = EGRESS
    TYPE       = HOST_PORT
    VALUE_LIST = ('sfpscogs-thb83496.snowflakecomputing.com')
    COMMENT    = 'Allow Python UDFs to call the Cortex Agents REST API on this account';
