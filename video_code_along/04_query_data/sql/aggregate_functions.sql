/* Aggregate - operations that summarize or combine multiple rows of data into a single value.
 */
SELECT
    MIN(salary_in_usd) AS min_salary_usd,
    ROUND(AVG(salary_in_usd)) AS mean_salary_usd,
    MEDIAN (salary_in_usd) AS median_salary_usd,
    MAX(salary_in_usd) AS max_salary_usd
FROM
    data_jobs;