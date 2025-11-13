/*
Workflow of Sorting the data_jobs Data
 */

-- ascending order by default
SELECT
    *
FROM
    data_jobs
ORDER BY
    salary_in_usd;

-- descending order
SELECT
    *
FROM
    data_jobs
ORDER BY
    salary_in_usd
DESC;

-- descending order; sort by salary_in_usd
-- ascending; employee_residence 
SELECT
    *
FROM
    data_jobs
ORDER BY
    salary_in_usd
DESC,
    employee_residence
ASC;