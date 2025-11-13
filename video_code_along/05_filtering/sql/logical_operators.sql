-- Retrieve job titles, experience levels, and salaries in USD from the data_jobs table
SELECT
    job_title,
    experience_level,
    salary_in_usd data_jobs;

-- change salary usd to sek and rounded to monthly
SELECT
    job_title,
    experience_level,
    ROUND((9.44 * salary_in_usd) / 12) AS salary_sek_month
FROM
    data_jobs;

-- filter for jobs with salary in sek greater than 200000 and less than 300000
SELECT
    job_title,
    experience_level,
    ROUND((9.44 * salary_in_usd) / 12) AS salary_sek_month
FROM
    data_jobs
WHERE
    (salary_sek_month > 200000)
    AND (salary_sek_month < 300000);

-- filter for jobs with salary in sek greater than 200000 and less than 300000
-- ordered descending
SELECT
    job_title,
    experience_level,
    ROUND((9.44 * salary_in_usd) / 12) AS salary_sek_month
FROM
    data_jobs
WHERE
    (salary_sek_month > 200000)
    AND (salary_sek_month < 300000)
ORDER BY
    salary_sek_month DESC;

-- BETWEEN ... AND
SELECT
    job_title,
    experience_level,
    ROUND((9.44 * salary_in_usd) / 12) AS salary_sek_month
FROM
    data_jobs
WHERE
    salary_sek_month BETWEEN 200000 AND 300000
ORDER BY
    salary_sek_month DESC;


-- OR operator
SELECT
    COUNT(*)
FROM
    data_jobs
WHERE
    experience_level = 'Senior level'
    or experience_level = 'Expert level';


-- NOT operator
SELECT
    COUNT(*)
FROM
    data_jobs
WHERE
    NOT
    experience_level = 'Senior level'
    or experience_level = 'Expert level';