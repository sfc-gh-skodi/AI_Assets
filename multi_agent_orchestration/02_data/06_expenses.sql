-- =============================================================
-- SYNTHETIC DATA: EXPENSES
-- =============================================================
-- Individual expense transactions submitted by employees.
-- Used by the Finance Agent via the SV_EXPENSES semantic view.
-- =============================================================

CREATE OR REPLACE TABLE DEMOS.WEWORK.EXPENSES (
    EXPENSE_ID    NUMBER        COMMENT 'Unique expense transaction identifier',
    EXPENSE_DATE  DATE          COMMENT 'Date the expense was incurred',
    DEPARTMENT    VARCHAR       COMMENT 'Department that incurred the expense',
    CATEGORY      VARCHAR       COMMENT 'Expense category: Software, Travel, Hardware, Marketing, Training, Recruiting',
    AMOUNT        NUMBER(10,2)  COMMENT 'Expense amount in USD',
    VENDOR        VARCHAR       COMMENT 'Vendor or supplier name',
    EMPLOYEE_ID   NUMBER        COMMENT 'FK to EMPLOYEES.EMPLOYEE_ID — who submitted the expense',
    APPROVED      BOOLEAN       COMMENT 'Whether the expense has been approved (TRUE/FALSE)'
);

INSERT INTO DEMOS.WEWORK.EXPENSES VALUES
(1,  '2025-01-08', 'Engineering', 'Software',   1200, 'AWS',            4,  TRUE),
(2,  '2025-01-10', 'Sales',       'Travel',      850, 'Delta Airlines', 5,  TRUE),
(3,  '2025-01-14', 'Sales',       'Marketing',  5000, 'Google Ads',    10,  TRUE),
(4,  '2025-01-20', 'Engineering', 'Software',   3500, 'GitHub',         3,  TRUE),
(5,  '2025-01-22', 'HR',          'Training',    600, 'Coursera',      13,  TRUE),
(6,  '2025-02-03', 'Sales',       'Travel',     1200, 'United Airlines',14, TRUE),
(7,  '2025-02-11', 'Engineering', 'Hardware',   4500, 'Apple',          8,  TRUE),
(8,  '2025-02-15', 'Finance',     'Software',    900, 'QuickBooks',    11,  TRUE),
(9,  '2025-02-19', 'Sales',       'Marketing',  4200, 'LinkedIn Ads',  10,  TRUE),
(10, '2025-02-25', 'Engineering', 'Travel',      700, 'Marriott',       3,  TRUE),
(11, '2025-03-04', 'Engineering', 'Software',   8500, 'Snowflake',      1,  TRUE),
(12, '2025-03-10', 'Sales',       'Travel',     1500, 'Hilton',         5,  TRUE),
(13, '2025-03-14', 'HR',          'Recruiting', 3000, 'LinkedIn',       6,  TRUE),
(14, '2025-03-18', 'Engineering', 'Software',   2200, 'Datadog',        4,  TRUE),
(15, '2025-03-25', 'Finance',     'Training',    450, 'CFI',           11,  FALSE);
