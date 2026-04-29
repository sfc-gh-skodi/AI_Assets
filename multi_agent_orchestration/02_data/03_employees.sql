-- =============================================================
-- SYNTHETIC DATA: EMPLOYEES
-- =============================================================
-- Current employee roster with department, title and salary.
-- Used by the HR Agent via the SV_EMPLOYEES semantic view.
-- =============================================================

CREATE OR REPLACE TABLE DEMOS.WEWORK.EMPLOYEES (
    EMPLOYEE_ID  NUMBER        COMMENT 'Unique employee identifier (primary key)',
    FULL_NAME    VARCHAR       COMMENT 'Employee full name',
    DEPARTMENT   VARCHAR       COMMENT 'Department: Engineering, Sales, HR, Finance, Marketing',
    TITLE        VARCHAR       COMMENT 'Job title',
    HIRE_DATE    DATE          COMMENT 'Date the employee joined the company',
    STATUS       VARCHAR       COMMENT 'Employment status: Active or Inactive',
    SALARY       NUMBER(10,2)  COMMENT 'Annual base salary in USD',
    MANAGER_ID   NUMBER        COMMENT 'FK to EMPLOYEES.EMPLOYEE_ID — direct manager (NULL for VPs)',
    LOCATION     VARCHAR       COMMENT 'Office location: New York, Chicago, Remote'
);

INSERT INTO DEMOS.WEWORK.EMPLOYEES VALUES
(1,  'Alice Johnson', 'Engineering', 'VP Engineering',        '2020-03-01', 'Active',   210000, NULL, 'New York'),
(2,  'Bob Smith',     'Sales',       'VP Sales',              '2019-07-15', 'Active',   195000, NULL, 'Chicago'),
(3,  'Carol White',   'Engineering', 'Senior Engineer',       '2021-01-10', 'Active',   145000, 1,    'New York'),
(4,  'Dan Brown',     'Engineering', 'Software Engineer',     '2022-06-01', 'Active',   120000, 1,    'Remote'),
(5,  'Eva Green',     'Sales',       'Account Executive',     '2021-09-15', 'Active',   105000, 2,    'Chicago'),
(6,  'Frank Lee',     'HR',          'HR Manager',            '2020-11-01', 'Active',   115000, NULL, 'New York'),
(7,  'Grace Kim',     'Finance',     'Finance Director',      '2019-04-01', 'Active',   175000, NULL, 'New York'),
(8,  'Hank Davis',    'Engineering', 'Staff Engineer',        '2018-02-01', 'Active',   165000, 1,    'New York'),
(9,  'Iris Wang',     'Sales',       'Sales Development Rep', '2023-01-15', 'Active',    72000, 2,    'Remote'),
(10, 'James Park',    'Marketing',   'Marketing Manager',     '2022-03-01', 'Active',   125000, NULL, 'Chicago'),
(11, 'Karen Mills',   'Finance',     'Financial Analyst',     '2023-05-01', 'Active',    92000, 7,    'New York'),
(12, 'Leo Cruz',      'Engineering', 'Software Engineer',     '2023-08-01', 'Active',   118000, 1,    'Remote'),
(13, 'Mia Turner',    'HR',          'HR Coordinator',        '2024-01-10', 'Active',    68000, 6,    'Chicago'),
(14, 'Nick Hall',     'Sales',       'Account Executive',     '2022-10-01', 'Active',   108000, 2,    'New York'),
(15, 'Olivia Scott',  'Engineering', 'Data Engineer',         '2021-07-01', 'Inactive', 130000, 1,    'Remote');
