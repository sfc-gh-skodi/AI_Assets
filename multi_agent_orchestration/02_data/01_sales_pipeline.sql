-- =============================================================
-- SYNTHETIC DATA: SALES_PIPELINE
-- =============================================================
-- Tracks active and closed sales deals.
-- Used by the Sales Agent via the SV_SALES_PIPELINE semantic view.
-- =============================================================

CREATE OR REPLACE TABLE DEMOS.WEWORK.SALES_PIPELINE (
    DEAL_ID       NUMBER        COMMENT 'Unique deal identifier',
    DEAL_NAME     VARCHAR       COMMENT 'Descriptive name of the deal',
    ACCOUNT_NAME  VARCHAR       COMMENT 'Customer/prospect company name',
    STAGE         VARCHAR       COMMENT 'Pipeline stage: Discovery, Proposal, Negotiation, Closed Won, Closed Lost',
    AMOUNT        NUMBER(12,2)  COMMENT 'Deal value in USD',
    REP_NAME      VARCHAR       COMMENT 'Sales rep responsible for the deal',
    REGION        VARCHAR       COMMENT 'Sales region: West, East, Central',
    CLOSE_DATE    DATE          COMMENT 'Actual or expected close date'
);

INSERT INTO DEMOS.WEWORK.SALES_PIPELINE VALUES
(1,  'Acme Corp Expansion',     'Acme Corp',         'Closed Won',  125000, 'Sarah Lee',   'West',    '2025-01-15'),
(2,  'Globex Q1 Renewal',       'Globex',            'Closed Won',   85000, 'Mike Torres', 'East',    '2025-01-28'),
(3,  'Initech Platform Deal',   'Initech',           'Negotiation', 200000, 'Sarah Lee',   'West',    '2025-02-28'),
(4,  'Umbrella Co Upsell',      'Umbrella Co',       'Proposal',     60000, 'Dana Kim',    'Central', '2025-03-10'),
(5,  'Stark Industries New',    'Stark Industries',  'Discovery',   350000, 'Mike Torres', 'East',    '2025-03-31'),
(6,  'Wayne Enterprises',       'Wayne Enterprises', 'Closed Won',   95000, 'Dana Kim',    'Central', '2025-01-20'),
(7,  'Oscorp Renewal',          'Oscorp',            'Closed Lost',  45000, 'Sarah Lee',   'West',    '2025-02-05'),
(8,  'Pied Piper SaaS',         'Pied Piper',        'Proposal',     78000, 'Tom Nguyen',  'West',    '2025-04-15'),
(9,  'Hooli Enterprise',        'Hooli',             'Closed Won',  310000, 'Tom Nguyen',  'West',    '2025-02-18'),
(10, 'Dunder Mifflin Upgrade',  'Dunder Mifflin',    'Negotiation',  42000, 'Dana Kim',    'Central', '2025-03-22');
