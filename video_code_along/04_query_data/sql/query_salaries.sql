-- show all tables
SELECT
    *
FROM
    data_jobs;

-- schema namespace, reference it to tha schema "main"
SELECT
    *
FROM
    main.data_jobs;

-- fully qualified name, database name: data_jobs, schema name: main
SELECT
    *
FROM
    data_jobs.main.data_jobs;

--  use limit clause (chooses num of rows to return)
SELECT
    *
FROM
    data_jobs.main.data_jobs
LIMIT
    5;

-- offset
SELECT
    *
FROM
    data_jobs.main.data_jobs
OFFSET
    2;

-- Get a few column names
desc data_jobs;

-- select specified columns from data jobs "column projection"
SELECT
    work_year,
    job_title,
    salary_in_usd,
    company_location
FROM
    data_jobs;

-- EXCLUDE, select ALL columns except for a few not wanted
SELECT
    * EXCLUDE (salary, work_year)
FROM
    data_jobs;