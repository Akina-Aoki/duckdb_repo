/*
Task 1
Create a database called bikejoin with a staging schema. 
Then, create two tables under the staging schema to store the data of the two csv files.
Use read_csv_auto option to infer the schema of the tables.
 Use the csv file names for table names.

- duckdb bikejoin.duckdb < sql/create.sql
- duckdb -ui bikejoin.duckdb
*/

CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.order_items AS (
    SELECT * FROM read_csv_auto('data/order_items.csv') 
);

CREATE TABLE IF NOT EXISTS staging.products AS (
    SELECT * FROM read_csv_auto('data/products.csv') 
);

