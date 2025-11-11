-- show content inside
desc data_jobs;

-- show number of tables
SELECT
    COUNT(*)
FROM
    data_jobs;

-- FILTERING EXAMPLES
-- row filtering where salary in usd is less than 50000
SELECT
    COUNT(*)
FROM
    data_jobs
WHERE
    salary_in_usd < 50000;

-- find entry level jobs: See what levels are available
SELECT DISTINCT
    experience_level
FROM
    data_jobs;

--find entry level jobs
SELECT
    *
FROM
    data_jobs
WHERE
    experience_level = 'EN';

-- find median salary for entry level jobs, give an alias
SELECT
    MEDIAN(salary_in_usd) AS median_salary_usd,
    AVG (salary_in_usd) AS average_salary_usd
FROM
    data_jobs
WHERE
    experience_level = 'EN';


-- find median salary for middle level jobs, give an alias
SELECT
    MEDIAN(salary_in_usd) AS median_salary_usd,
    AVG (salary_in_usd) AS average_salary_usd
FROM
    data_jobs
WHERE
    experience_level = 'MI';



