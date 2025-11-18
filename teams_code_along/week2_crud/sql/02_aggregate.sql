/* **********************************************************************
                SQL Aggregate Functions    
 *********************************************************************** */ 

-- 1. Create new table
CREATE TABLE IF NOT EXISTS staging.more_employees AS (
    SELECT * FROM read_csv_auto('data/more_employees.csv')
);

-- count distinct departments
SELECT COUNT(DISTINCT department) AS distinct_departments
FROM staging.more_employees;

-- analyze salary data
SELECT
    department,
    ROUND(AVG(monthly_salary_sek)) AS average_salary_sek,
    ROUND(MEDIAN(monthly_salary_sek)) AS total_salary_sek,
    ROUND(MIN(monthly_salary_sek)) AS min_salary_sek,
    ROUND(MAX(monthly_salary_sek)) AS max_salary_sek
FROM staging.more_employees
GROUP BY department;