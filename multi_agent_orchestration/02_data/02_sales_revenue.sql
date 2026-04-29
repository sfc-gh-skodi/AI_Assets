-- =============================================================
-- SYNTHETIC DATA: SALES_REVENUE
-- =============================================================
-- Monthly revenue records broken down by product and region.
-- Used by the Sales Agent via the SV_SALES_REVENUE semantic view.
-- =============================================================

CREATE OR REPLACE TABLE DEMOS.WEWORK.SALES_REVENUE (
    REVENUE_ID   NUMBER        COMMENT 'Unique revenue record identifier',
    MONTH        DATE          COMMENT 'First day of the revenue month (e.g. 2025-01-01)',
    PRODUCT      VARCHAR       COMMENT 'Product line: Enterprise Suite, Standard Plan, Add-On Module',
    REGION       VARCHAR       COMMENT 'Sales region: West, East, Central',
    REVENUE      NUMBER(12,2)  COMMENT 'Total revenue in USD for this product/region/month',
    UNITS_SOLD   NUMBER        COMMENT 'Number of units or seats sold',
    DEAL_ID      NUMBER        COMMENT 'FK to SALES_PIPELINE — the originating deal'
);

INSERT INTO DEMOS.WEWORK.SALES_REVENUE VALUES
(1,  '2025-01-01', 'Enterprise Suite', 'West',    125000, 10, 1),
(2,  '2025-01-01', 'Standard Plan',    'East',     85000, 34, 2),
(3,  '2025-01-01', 'Enterprise Suite', 'Central',  95000,  8, 6),
(4,  '2025-02-01', 'Enterprise Suite', 'West',    310000, 25, 9),
(5,  '2025-02-01', 'Standard Plan',    'West',     22000,  9, 7),
(6,  '2025-03-01', 'Enterprise Suite', 'East',     60000,  5, 4),
(7,  '2025-03-01', 'Add-On Module',    'Central',  15000,  6, 4),
(8,  '2025-04-01', 'Standard Plan',    'West',     78000, 31, 8),
(9,  '2025-04-01', 'Enterprise Suite', 'East',    120000, 10, 5),
(10, '2025-04-01', 'Add-On Module',    'Central',  28000, 11, 10);
