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


/* Task 2 */
-- find invalid emails
-- use LIKE operator with wildcards for the old data
SELECT * FROM staging.crm_old_raw
WHERE NOT email LIKE '%@%.%';

-- use REGEXP functions for the new data
-- because the above query cannot deal with the new data
SELECT * FROM staging.crm_new_raw
WHERE NOT regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+');

-- combine all three conditions
SELECT * FROM staging.crm_old_raw
WHERE NOT regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+') OR
      NOT region IN ('EU', 'US') OR
      NOT status IN ('active', 'inactive');

SELECT * FROM staging.crm_new_raw
WHERE NOT regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+') OR
      NOT region IN ('EU', 'US') OR
      NOT status IN ('active', 'inactive');

/* Task 3 */
CREATE SCHEMA IF NOT EXISTS constrained;

CREATE TABLE IF NOT EXISTS constrained.crm_old (
    customer_id INTEGER UNIQUE,
    name VARCHAR NOT NULL,
    email VARCHAR CHECK (email LIKE '%@%.%'),
    region VARCHAR CHECK (region IN ('EU', 'US')),
    status VARCHAR CHECK (status IN ('active', 'inactive'))
);

CREATE TABLE IF NOT EXISTS constrained.crm_new (
    customer_id INTEGER UNIQUE,
    name VARCHAR NOT NULL,
    email VARCHAR CHECK (regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+')),
    region VARCHAR CHECK (region IN ('EU', 'US')),
    status VARCHAR CHECK (status IN ('active', 'inactive'))
);

INSERT INTO constrained.crm_old
SELECT * 
FROM staging.crm_old_raw
WHERE regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+') AND
    region IN ('EU', 'US') AND
    status IN ('active', 'inactive');

INSERT INTO constrained.crm_new
SELECT * 
FROM staging.crm_new_raw
WHERE regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+') AND
    region IN ('EU', 'US') AND
    status IN ('active', 'inactive');

/* Task 4 */
-- 7 customers are only in the old crm system
SELECT customer_id
FROM staging.crm_old_raw
EXCEPT
SELECT customer_id
FROM staging.crm_new_raw

-- 6 customers are only in the new crm system
SELECT customer_id
FROM staging.crm_new_raw
EXCEPT
SELECT customer_id
FROM staging.crm_old_raw

-- 7 common customers in both crm systems
SELECT customer_id
FROM staging.crm_new_raw
INTERSECT 
SELECT customer_id
FROM staging.crm_old_raw

/* Task 5 */
-- subquery 1: customers only in the old crm system
(SELECT *
FROM staging.crm_old_raw
EXCEPT
SELECT *
FROM staging.crm_new_raw)
UNION
-- subquery 2: customers only in the new crm sytem
(SELECT *
FROM staging.crm_new_raw
EXCEPT
SELECT *
FROM staging.crm_old_raw)
UNION
-- subquery 3: customers violating constraints in old crm system
(SELECT * FROM staging.crm_old_raw
WHERE NOT regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+') OR
      NOT region IN ('EU', 'US') OR
      NOT status IN ('active', 'inactive'))
UNION
-- subquery 4: customers violating constraints in new crm system
(SELECT * FROM staging.crm_new_raw
WHERE NOT regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+') OR
      NOT region IN ('EU', 'US') OR
      NOT status IN ('active', 'inactive'))