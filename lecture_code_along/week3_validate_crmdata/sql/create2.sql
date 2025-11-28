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



/* ==========================================================================================================================================
    Task 3: Create a new schema called *constrained* 
    and create two tables under it. 
    For each table, create column constraints for the rules specified in task 2 
    and insert rows fulfilling these constraints separately from the two tables in the staging schema. 
 ==============================================================================================================================================
*/

-- create schema constrained
CREATE SCHEMA IF NOT EXISTS constrained;

-- create constrained.crm_new table with column constraints
-- the contraints that need to be added:
-- email VARCHAR CHECK (email LIKE '%@%.%')
-- region VARCHAR CHECK (region IN ('EU', 'US'))
-- status VARCHAR CHECK (status IN ('active', 'inactive'))
CREATE TABLE IF NOT EXISTS constrained.crm_all AS (
    customer_id INTEGER UNIQUE,
    name VARCHAR NOT NULL,
    email VARCHAR CHECK (email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+'), 
    region VARCHAR CHECK (region IN ('EU', 'US')),
    status VARCHAR CHECK (status IN ('active', 'inactive'))
);

-- insert valid rows from staging.crm_old into constrained.crm_all
INSERT INTO constrained.crm_all
SELECT *
FROM staging.crm_old
WHERE regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+')
  AND region IN ('EU', 'US')
  AND status IN ('active', 'inactive');

/*
-- insert valid rows from staging.crm_new into constrained.crm_all
INSERT INTO constrained.crm_all
SELECT *
FROM staging.crm_new
WHERE regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+')
  AND region IN ('EU', 'US')
  AND status IN ('active', 'inactive');
*/


/* ==========================================================================================================================================
    Task 4 & 5: use the data in the *staging* schema that store customer records before column constraints are enforced.

    To validate whether the old and new CRM systems keep the same customer records, use the column *customer_id* as the unique identifier of customers and find out:
    - customers only recorded in the old CRM system
    - customers only recorded in the new CRM system
    - customers recorded in both CRM system
    ============================================================================*/

-- how many customers are only in the new system
-- 7 customers only in the old system
SELECT customer_id
FROM staging.crm_old
EXCEPT
SELECT customer_id
FROM staging.crm_new


-- how many customers are only in the old system
-- 6 customers only in the old system
SELECT customer_id
FROM staging.crm_new
EXCEPT
SELECT customer_id
FROM staging.crm_old


-- how many customers are only in the old system
-- using intersect to find common customers that exist in both systems
-- 7 customers exist in both systems
SELECT customer_id
FROM staging.crm_new
INTERSECT
SELECT customer_id
FROM staging.crm_old


-- =====================================================================
-- Task 5 (Simpler for beginners)
-- Produce a discrepancy report using FOUR simple subqueries.
-- Each subquery returns the same columns so we can UNION them.
--  - customers only in old system (full rows, issue = 'only_in_old')
--  - customers only in new system (full rows, issue = 'only_in_new')
--  - rows in old that violate the rules (issue = 'invalid_old')
--  - rows in new that violate the rules (issue = 'invalid_new')
-- This is easy to read and easy to explain to colleagues.
-- =====================================================================

-- Subquery 1: customers only in the old CRM system (full rows)
SELECT
  'only_in_old' AS issue,
  customer_id,
  name,
  email,
  region,
  status
FROM staging.crm_old
WHERE customer_id IN (
  SELECT customer_id FROM staging.crm_old
  EXCEPT
  SELECT customer_id FROM staging.crm_new
)

UNION

-- Subquery 2: customers only in the new CRM system (full rows)
SELECT
  'only_in_new' AS issue,
  customer_id,
  name,
  email,
  region,
  status
FROM staging.crm_new
WHERE customer_id IN (
  SELECT customer_id FROM staging.crm_new
  EXCEPT
  SELECT customer_id FROM staging.crm_old
)

UNION

-- Subquery 3: rows in old that violate any rule
SELECT
  'invalid_old' AS issue,
  customer_id,
  name,
  email,
  region,
  status
FROM staging.crm_old
WHERE NOT (
  email LIKE '%@%.%' AND
  region IN ('EU','US') AND
  status IN ('active','inactive')
)

UNION

-- Subquery 4: rows in new that violate any rule
SELECT
  'invalid_new' AS issue,
  customer_id,
  name,
  email,
  region,
  status
FROM staging.crm_new
WHERE NOT (
  email LIKE '%@%.%' AND
  region IN ('EU','US') AND
  status IN ('active','inactive')
)

ORDER BY issue, customer_id;