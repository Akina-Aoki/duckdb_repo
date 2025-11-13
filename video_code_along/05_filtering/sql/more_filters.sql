-- IN operator for list filtering
SELECt DISTINCT
    COUNT(*)
FROM
    data_jobs
WHERE
    company_size NOT IN ('S', 'M');

-- Filter Clause with AS alias
SELECT COUNT(*) AS total_jobs
FROM data_jobs;

-- Filter Clause
SELECT
    COUNT(*) AS total_jobs COUNT(*) FILTER (remote_ratio = 100) AS remote_jobs,
    ROUND(COUNT(*) FILTER (remote_jobs / total_jobs * 100)) AS percentage_remote_jobs,
FROM
    data_jobs;


-- Calculate only the % of remote jobs
SELECT
    COUNT(*) AS total_jobs,
    COUNT(*) FILTER (remote_ratio = 100) AS remote_jobs,
    ROUND((remote_jobs / total_jobs * 100)) AS percentage_remote_jobs,
FROM
    data_jobs;

-- offset filtering
-- offset first 5 rows and select evrything else
SELECT * FROM data_jobs OFFSET 6;