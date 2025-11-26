/* This file only handles loading raw data into the ui, then start 
transforming in another sql file called transform.sql
$
duckdb salaries.duckdb < sql/create.sql
duckdb -ui salaries.duckdb
*/

-- Create the staging schema
CREATE SCHEMA IF NOT EXISTS staging;

-- Create a table for the salaries.csv file using read csv auto-detection
CREATE TABLE IF NOT EXISTS staging.salaries AS (
    SELECT *
    FROM read_csv_auto('data/salaries.csv')
);


