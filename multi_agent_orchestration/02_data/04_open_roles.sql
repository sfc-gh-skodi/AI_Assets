-- =============================================================
-- SYNTHETIC DATA: OPEN_ROLES
-- =============================================================
-- Active job postings and hiring pipeline.
-- Used by the HR Agent via the SV_OPEN_ROLES semantic view.
-- =============================================================

CREATE OR REPLACE TABLE DEMOS.WEWORK.OPEN_ROLES (
    ROLE_ID         NUMBER   COMMENT 'Unique job role identifier',
    TITLE           VARCHAR  COMMENT 'Job title being hired for',
    DEPARTMENT      VARCHAR  COMMENT 'Hiring department',
    LEVEL           VARCHAR  COMMENT 'Seniority level: Junior, Mid, Senior, Staff',
    LOCATION        VARCHAR  COMMENT 'Where the role is based: New York, Chicago, Remote',
    POSTED_DATE     DATE     COMMENT 'Date the role was opened',
    STATUS          VARCHAR  COMMENT 'Hiring status: Open, In Interview, Filled, Cancelled',
    HIRING_MANAGER  VARCHAR  COMMENT 'Name of the hiring manager (FK to EMPLOYEES.FULL_NAME)'
);

INSERT INTO DEMOS.WEWORK.OPEN_ROLES VALUES
(1,  'Senior Software Engineer', 'Engineering', 'Senior', 'New York', '2025-01-05', 'Open',         'Alice Johnson'),
(2,  'Account Executive',        'Sales',       'Mid',    'Chicago',  '2025-01-12', 'Open',         'Bob Smith'),
(3,  'Data Scientist',           'Engineering', 'Mid',    'Remote',   '2025-02-01', 'Open',         'Alice Johnson'),
(4,  'Financial Analyst',        'Finance',     'Junior', 'New York', '2025-02-10', 'In Interview', 'Grace Kim'),
(5,  'HR Business Partner',      'HR',          'Senior', 'Chicago',  '2025-02-20', 'Open',         'Frank Lee'),
(6,  'Product Manager',          'Product',     'Senior', 'New York', '2025-03-01', 'Open',         NULL),
(7,  'Sales Development Rep',    'Sales',       'Junior', 'Remote',   '2025-03-10', 'In Interview', 'Bob Smith'),
(8,  'DevOps Engineer',          'Engineering', 'Mid',    'Remote',   '2025-03-15', 'Open',         'Alice Johnson'),
(9,  'Marketing Analyst',        'Marketing',   'Junior', 'Chicago',  '2025-04-01', 'Open',         'James Park'),
(10, 'Staff Engineer',           'Engineering', 'Staff',  'New York', '2025-04-05', 'Open',         'Alice Johnson');
