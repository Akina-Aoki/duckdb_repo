/*
## Task 1
You are given two csv files exported from the two CRM systems for customer information. 
Create a database called *crm* with a *staging* schema. Then, create two tables under the *staging* schema to store the data of the two csv files. 
*/

CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.crm_new AS
(
    SELECT *
    FROM read_csv_auto('data/crm_new.csv')
);

CREATE TABLE IF NOT EXISTS staging.crm_old AS
(
    SELECT *
    FROM read_csv_auto('data/crm_old.csv')
);

-- Combined table for both crm_new and crm_old
CREATE TABLE IF NOT EXISTS staging.crm_all AS
(
    SELECT *
    FROM staging.crm_new
    UNION
    SELECT *
    FROM staging.crm_old
);