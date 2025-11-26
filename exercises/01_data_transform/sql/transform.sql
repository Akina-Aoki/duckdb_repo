/*
In this transform.sql file, executes the data transformation steps needed to
clean and prepare the salaries data from the tasks.

Begin with a statement that creates a table for the cleaned salaries data
*/

/*  ======================================
    Task A: Transform employment type codes
    Create new table 'cleaned_salaries'
    ======================================
*/
-- See that 'employment_type' column needs to be transformed to a more understandable version
SELECT DISTINCT employment_type
FROM staging.salaries;


-- Create the new table cleaned_salaries with transformed employment_type column
-- Convert to full descriptions using CASE WHEN END
CREATE TABLE IF NOT EXISTS staging.cleaned_salaries AS (
  SELECT *, 
-- keep all columns from the source table (salaries) included in the new table + additional new columns (employment_type_full)
  
  -- start transformed column here
  CASE employment_type
    WHEN 'PT' THEN 'Part Time'
    WHEN 'CT' THEN 'Contract'
    WHEN 'FT' THEN 'Full Time'
    WHEN 'FL' THEN 'Freelance'
  END AS employment_type_full
  FROM staging.salaries);

-- check new table with transformed column
desc staging.cleaned_salaries;
SELECT * FROM staging.cleaned_salaries;


/*  ======================================
    Task B: Do similar for company size, 
    but you have to figure out what the 
    abbreviations could stand for.
    ======================================
*/
-- check the distinct values in the company_size column
SELECT DISTINCT company_size
FROM staging.cleaned_salaries;

-- Add a new column for company_size_full
ALTER TABLE staging.cleaned_salaries
ADD COLUMN company_size_full VARCHAR;

-- populate the company_size_full column
UPDATE staging.cleaned_salaries
  SET company_size_full =
    CASE company_size
      WHEN 'S' THEN 'Small'
      WHEN 'M' THEN 'Medium'
      WHEN 'L' THEN 'Large'
    END;

-- check the updated table with new column
SELECT DISTINCT company_size_full
FROM staging.cleaned_salaries;

/*  ======================================
    Task C: Make a salary column with 
    Swedish currency for YEARLY salary.
    ======================================
*/  
-- check the distinct values in the currency column
SELECT DISTINCT currency
FROM staging.cleaned_salaries;
-- Swedish Kronor (SEK) does not exists so need to create a new column for SEK

-- Checking that salary is USD based on salary column
SELECT salary, salary_in_usd
FROM staging.cleaned_salaries;

-- Add a new column for salary_in_sek
ALTER TABLE staging.cleaned_salaries
ADD COLUMN salary_in_sek INTEGER;


/*
populate the salary_in_sek column using UPDATE, SET AND WHERE (filter)
Assume 1 USD = 10.0 SEK for conversion

What WHERE does

WHERE filters which rows the UPDATE affects. Only rows where the WHERE expression evaluates to true will be updated.
Without a WHERE, every row in the table is updated.
What AND does

AND is a logical operator that requires both sub-conditions to be true. In your query: WHERE salary_in_usd IS NOT NULL AND salary_in_sek IS NULL a row is updated only if:
salary_in_usd IS NOT NULL (there is a USD amount to convert) AND
salary_in_sek IS NULL (you haven’t already set a SEK value)*/
UPDATE staging.cleaned_salaries
  SET salary_in_sek = salary_in_usd *10.0
    WHERE salary_in_usd IS NOT NULL
    AND salary_in_sek IS NULL;


/*  ======================================
    Task D: Make a salary column with 
    Swedish currency for MONTHLY salary.
    ======================================
    basically just divide the yearly salary by 12
    and populate the new column salary_in_sek_monthly 
*/  

-- Add a new column for salary_in_sek_monthly
ALTER TABLE staging.cleaned_salaries
ADD COLUMN salary_in_sek_monthly INTEGER; 

-- populate the salary_in_sek_monthly column
UPDATE staging.cleaned_salaries
  SET salary_in_sek_monthly = salary_in_sek / 12
    WHERE salary_in_sek IS NOT NULL
    AND salary_in_sek_monthly IS NULL;

-- check the updated table with new column
SELECT  monthly_salary_in_sek
FROM staging.cleaned_salaries;


/*  ===============================================
    Task E: Make a salary_level column with the following 
    categories: low, medium, high, insanely_high. 
    Decide your thresholds for each category. 
    Make it base on the monthly salary in SEK.
    ==============================================
*/
-- checking the max salary
SELECT  MAX(monthly_salary_in_sek)
FROM staging.cleaned_salaries;

-- checking which roles the max is associated with
SELECT *
FROM staging.cleaned_salaries
WHERE monthly_salary_in_sek = 666667;

-- Add a new column for salary_level
ALTER TABLE staging.cleaned_salaries
ADD COLUMN salary_level VARCHAR;

-- populate the salary_level column
UPDATE staging.cleaned_salaries
SET salary_level =
CASE
  WHEN monthly_salary_in_sek <= 25000 THEN 'low'
  WHEN monthly_salary_in_sek >= 25001 AND monthly_salary_in_sek < 45000 THEN 'medium'
  WHEN monthly_salary_in_sek >= 45001 AND monthly_salary_in_sek < 70000 THEN 'high'
  WHEN monthly_salary_in_sek >= 70000 THEN 'insanely high'
  ELSE NULL
END;

-- check the updated table with new column
SELECT salary_level
FROM staging.cleaned_salaries;


/*  ==============================================================
    Task F: Choose the following columns to include in your table: 
    experience_level, employment_type, job_title, salary_annual_sek, 
    salary_monthly_sek, remote_ratio, company_size, salary_level
    ==============================================================
*/
-- Create the final table with selected columns only
CREATE TABLE IF NOT EXISTS staging.final_salaries AS (
    SELECT
        experience_level,
        employment_type_full,
        job_title,
        salary_in_sek
        monthly_salary_in_sek,
        remote_ratio,
        company_size_full,
        salary_level    
    FROM staging.cleaned_salaries
);

-- Check the final table
SELECT * FROM staging.final_salaries;


/*  ==============================================================
    Task G: Think of other transformation that you want to do.
    Update experience_level to full descriptions
    ==============================================================
*/

-- check the distinct values in the experience_level column
SELECT DISTINCT experience_level
FROM staging.final_salaries;


-- Update experience_level to full descriptions
UPDATE staging.final_salaries
SET experience_level =
    CASE
        WHEN experience_level = 'SE' THEN 'Senior'
        WHEN experience_level = 'MI' THEN 'Mid-level'
        WHEN experience_level = 'EN' THEN 'Entry-level'
        WHEN experience_level = 'EX' THEN 'Executive'   
        ELSE NULL
    END;

-- check for missing values in the table for everything
SELECT *
FROM staging.final_salaries
WHERE experience_level IS NULL
   OR employment_type_full IS NULL
   OR job_title IS NULL
   OR monthly_salary_in_sek IS NULL
   OR remote_ratio IS NULL
   OR company_size_full IS NULL
   OR salary_level IS NULL;

-- remove rows with any NULL values
DELETE FROM staging.final_salaries
WHERE experience_level IS NULL
   OR employment_type_full IS NULL
   OR job_title IS NULL
   OR monthly_salary_in_sek IS NULL
   OR remote_ratio IS NULL
   OR company_size_full IS NULL
   OR salary_level IS NULL;
-- run the query above again to confirm no more NULL values

---------------------------------------------------------------------------------------------------------------

/*  ==============================================================
    Task A: Count number of Data engineers jobs. 
    For simplicity just go for job_title Data Engineer.
    ==============================================================
*/
-- include close variants (e.g., "Data Engineer II", "Senior Data Engineer") use pattern matching

SELECT COUNT(*) AS data_engineer_like_count
FROM staging.salaries
WHERE LOWER(TRIM(job_title)) LIKE '%data engineer%';


/*  ==============================================================
    Task B: Count number of unique job titles in total. 
    ==============================================================
*/
-- To inspect normalized variants and how many map to each normalized label:
SELECT LOWER(TRIM(job_title)) AS normalized_title, 
COUNT(*) AS occurrences
FROM staging.salaries
GROUP BY normalized_title
ORDER BY occurrences DESC;

-- Exact distinct count on the final table
SELECT COUNT(DISTINCT job_title) AS unique_job_titles
FROM staging.final_salaries;


/*  ==============================================================
    Task C: Find out how many jobs that goes into each salary level. 
    ==============================================================
*/
-- Find out how many jobs that goes into each salary level
SELECT DISTINCT salary_level,
COUNT(*) AS occurrences
FROM staging.final_salaries
GROUP BY salary_level
ORDER BY occurrences DESC;


-- Using final_salaries
SELECT
  salary_level,
  COUNT(*) AS num_jobs,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_of_total
FROM staging.final_salaries
GROUP BY salary_level
ORDER BY pct_of_total DESC;


/*  ==============================================================
    Task D: Find out the median and mean salaries for each seniority levels.
    ==============================================================
*/

-- Find out the median and mean salaries for each seniority levels.
SELECT
  experience_level,
  COUNT(*) AS n_jobs,
  ROUND(AVG(COALESCE(monthly_salary_in_sek, salary_in_sek / 12.0)), 2) AS mean_monthly_sek,
  ROUND(median(COALESCE(monthly_salary_in_sek, salary_in_sek / 12.0)), 2) AS median_monthly_sek
FROM staging.cleaned_salaries
GROUP BY experience_level
ORDER BY experience_level;

-- exlpain COALESCE: The COALESCE function returns the first non-null value in a list of expressions. 
-- In this query, it checks if monthly_salary_in_sek is NULL; if it is, it calculates the monthly salary by dividing salary_in_sek by 12. 
-- This ensures that the average and median calculations use available salary data, whether it's provided monthly or yearly.

/*  ==============================================================
    Task E: Find out the top earning job titles based on their median salaries 
    and how much they earn.
    ==============================================================
*/
WITH src AS (
  SELECT
    job_title,
    COALESCE(salary_in_sek, salary_in_usd * 10.0) AS annual_sek
  FROM staging.cleaned_salaries
)
SELECT
  job_title,
  COUNT(*) AS n_jobs,
  ROUND(median(annual_sek), 2) AS median_annual_sek
FROM src
WHERE annual_sek IS NOT NULL
GROUP BY job_title
ORDER BY median_annual_sek DESC
LIMIT 10;

/*  ==============================================================
    Task F:  How many percentage of the jobs are fully remote, 
    50 percent remote and fully not remote.
    ==============================================================
*/
-- Count per remote_ratio value (simple grouping):
SELECT remote_ratio, COUNT(*) AS num_jobs
FROM staging.cleaned_salaries
GROUP BY remote_ratio
ORDER BY remote_ratio DESC;

-- Counts for the three categories in one row:
SELECT
  SUM(CASE WHEN remote_ratio = 100 THEN 1 ELSE 0 END) AS fully_remote,
  SUM(CASE WHEN remote_ratio = 50  THEN 1 ELSE 0 END) AS fifty_percent_remote,
  SUM(CASE WHEN remote_ratio = 0   THEN 1 ELSE 0 END) AS not_remote
FROM staging.cleaned_salaries;

-- Percentages (rounded to 2 decimals) for those three categories:
SELECT
  ROUND(100.0 * SUM(CASE WHEN remote_ratio = 100 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_fully_remote,
  ROUND(100.0 * SUM(CASE WHEN remote_ratio = 50  THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_50_remote,
  ROUND(100.0 * SUM(CASE WHEN remote_ratio = 0   THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_not_remote
FROM staging.cleaned_salaries;


/*  ==============================================================
    Task G: Pick out a job title of interest and figure out if company size
    affects the salary. Make a simple analysis as a comprehensive one 
    requires causality investigations which are much harder to find.
    ==============================================================
*/

-- Quick check: how many rows per company size for Data Engineer
SELECT
  company_size_full,
  COUNT(*) AS n_jobs
FROM staging.cleaned_salaries
WHERE LOWER(job_title) LIKE '%data engineer%'
GROUP BY company_size_full
ORDER BY n_jobs DESC;

-- Median annual salary (SEK) by company size
SELECT company_size_full,
       COUNT(*) AS n_jobs,
       ROUND(median(COALESCE(salary_in_sek, salary_in_usd * 10.0)), 2) AS median_annual_sek,
       ROUND(AVG(COALESCE(salary_in_sek, salary_in_usd * 10.0)), 2) AS mean_annual_sek
FROM staging.cleaned_salaries
WHERE LOWER(TRIM(job_title)) = 'data engineer'
GROUP BY company_size_full
ORDER BY median_annual_sek DESC;


-- Median monthly salary (SEK) by company size
SELECT company_size_full,
       COUNT(*) AS n_jobs,
       ROUND(median(COALESCE(monthly_salary_in_sek, salary_in_sek / 12.0, salary_in_usd * 10.0 / 12.0)), 2) AS median_monthly_sek
FROM staging.cleaned_salaries
WHERE LOWER(TRIM(job_title)) = 'data engineer'
GROUP BY company_size_full
ORDER BY median_monthly_sek DESC;