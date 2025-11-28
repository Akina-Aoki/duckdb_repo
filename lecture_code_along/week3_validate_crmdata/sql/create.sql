/* ==========================================================================================================================================
Task 1: You are given two csv files exported from the two CRM systems for customer information.
Create a database called crm with a staging schema. Then, create two tables under the staging schema to store the data of the two csv files.
=============================================================================================================================================
 */

-- create schema staging
CREATE SCHEMA IF NOT EXISTS staging;

-- create a table under the crm staging schema for the crm_new
CREATE TABLE IF NOT EXISTS staging.crm_new AS (
    SELECT *
    FROM read_csv_auto('data/crm_new.csv')
);

-- create a 2nd table under the staging schema for the crm_old
CREATE TABLE IF NOT EXISTS staging.crm_old AS (
    SELECT *
    FROM read_csv_auto('data/crm_old.csv')
);

-- Use UNION to combine crm_new and crm_old into a single table crm_all
CREATE TABLE IF NOT EXISTS staging.crm_all AS (
    SELECT *
    FROM staging.crm_new

    UNION

    SELECT *
    FROM staging.crm_old
);

-- desc the staging.crm_all;
DESC staging.crm_all;

-- select all from staging.crm_all to verify the data
SELECT *
FROM staging.crm_all;

/* ==========================================================================================================================================
Task 2
Both CRM datasets may contain invalid records. Identify all rows in both datasets that fail to meet the following rules:

1. The email address must include an @ symbol followed later by a .
2. The region value must be either EU or US
3. The status must be either active or inactive
=============================================================================================================================================
*/
-- The email address must include an @ symbol followed later by a .
-- '%@%.%' means there is at least one character before @, at least one character between @ and ., and at least one character after . 
SELECT *
FROM staging.crm_new
WHERE email NOT LIKE '%@%.%'; 

-- The email address must include an @ symbol followed later by a .
SELECT 
  customer_id,
  name,
  email
FROM staging.crm_all
WHERE email LIKE '%@%.%';

-- Using the regular expression to validate the email address
SELECT *
FROM staging.crm_all
WHERE regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]');

-- Regular expression to filter out the problematic values
SELECT *
FROM staging.crm_all
WHERE NOT regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]');


/*================================
 3 conditions under 1 WHERE clause to also solve the other tasks
 ================================*/
 SELECT *
 FROM staging.crm_all
 WHERE NOT regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]') OR
       NOT region IN ('EU', 'US') OR
       NOT status IN ('active', 'inactive');


-- 2. The region value must be either EU or US
-- Check distinct region values in the staging.crm_all table
SELECT DISTINCT region
FROM staging.crm_all;

-- more than one value found, now check invalid region values
SELECT region
FROM staging.crm_all
WHERE NOT region IN ('EU', 'US'); 

-- Boolean check for invalid region values
SELECT NOT region = 'EU'
FROM staging.crm_all

-- 3. The status must be either `active` or `inactive`
SELECT *
FROM staging.crm_all;

-- Check distinct status values in the staging.crm_all table
SELECT DISTINCT status
FROM staging.crm_all;


-- trim the status column to remove the unnecessary values
-- place in a new column ''trimmed_status''
ALTER TABLE stgaing.crm_all
ADD COLUMN trimmed_status STRING AS (
    TRIM(status)
FROM staging.crm_all);





ADD COLUMN staging.crm_all_trimmed AS (
  SELECT 
    *,
    TRIM(status) AS trimmed_status
  FROM staging.crm_all
);
