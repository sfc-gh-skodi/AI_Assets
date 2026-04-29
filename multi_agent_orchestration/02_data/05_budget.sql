-- =============================================================
-- SYNTHETIC DATA: BUDGET
-- =============================================================
-- Monthly department budget allocations vs actual spend.
-- Used by the Finance Agent via the SV_BUDGET semantic view.
-- =============================================================

CREATE OR REPLACE TABLE DEMOS.WEWORK.BUDGET (
    BUDGET_ID    NUMBER        COMMENT 'Unique budget record identifier',
    DEPARTMENT   VARCHAR       COMMENT 'Department name',
    CATEGORY     VARCHAR       COMMENT 'Spend category: Headcount, Software, Travel, Marketing, Recruiting',
    MONTH        DATE          COMMENT 'First day of the budget month (e.g. 2025-01-01)',
    BUDGET_AMT   NUMBER(12,2)  COMMENT 'Planned budget amount in USD',
    ACTUAL_AMT   NUMBER(12,2)  COMMENT 'Actual spend amount in USD (positive = over budget if > BUDGET_AMT)'
);

INSERT INTO DEMOS.WEWORK.BUDGET VALUES
(1,  'Engineering', 'Headcount', '2025-01-01', 450000, 432000),
(2,  'Engineering', 'Software',  '2025-01-01',  25000,  27500),
(3,  'Engineering', 'Travel',    '2025-01-01',   8000,   5200),
(4,  'Sales',       'Headcount', '2025-01-01', 320000, 315000),
(5,  'Sales',       'Marketing', '2025-01-01',  40000,  43000),
(6,  'Sales',       'Travel',    '2025-01-01',  20000,  22400),
(7,  'Finance',     'Headcount', '2025-01-01', 180000, 180000),
(8,  'HR',          'Headcount', '2025-01-01',  95000,  95000),
(9,  'Engineering', 'Headcount', '2025-02-01', 450000, 445000),
(10, 'Engineering', 'Software',  '2025-02-01',  25000,  24000),
(11, 'Sales',       'Headcount', '2025-02-01', 320000, 318000),
(12, 'Sales',       'Marketing', '2025-02-01',  40000,  38500),
(13, 'Finance',     'Headcount', '2025-02-01', 180000, 180000),
(14, 'HR',          'Headcount', '2025-02-01',  95000,  97000),
(15, 'Engineering', 'Headcount', '2025-03-01', 450000, 460000),
(16, 'Engineering', 'Software',  '2025-03-01',  25000,  31000),
(17, 'Sales',       'Headcount', '2025-03-01', 320000, 320000),
(18, 'Sales',       'Travel',    '2025-03-01',  20000,  19000),
(19, 'Finance',     'Headcount', '2025-03-01', 180000, 182000),
(20, 'HR',          'Headcount', '2025-03-01',  95000,  95000);
