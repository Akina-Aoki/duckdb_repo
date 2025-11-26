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
ADD COLUMN salary_level INTEGER;

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


/*  ==============================================================
    Task : Create a new column avg_salary_by_role to see average monthly salary per job title
    ==============================================================
*/
-- Alter table and column to add job_title_avg
UPDATE TABLE staging.final_salaries
ADD COLUMN avg_salary_by_role INTEGER;


-- populate the avg_salary_by_role column
UPDATE staging.final_salaries
SET avg_salary_by_role = (
    SELECT AVG(monthly_salary_in_sek)
    FROM staging.final_salaries AS c2
    WHERE c2.job_title = staging.final_salaries.job_title
);



/*  ==============================================================
    Task : Rank the top 10 highest paying job titles based on
    monthly salary in SEK.
    ==============================================================
*/
-- Top 10 highest paying job titles based on monthly salary in SEK
SELECT job_title, monthly_salary_in_sek
FROM staging.final_salaries
ORDER BY monthly_salary_in_sek DESC
LIMIT 10;