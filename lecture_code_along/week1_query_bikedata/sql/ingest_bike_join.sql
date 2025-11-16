/*Create a new table to named ingest_bike.duckdb

Query after I have opened the DUCKDB UI
duckdb bike.duckdb < sql/ingest_bike.sql - create staging tables in DUCKDB
duckdb -ui bike.duckdb - Open DUCKDB in UI mode
 */

 
-- First create a schema. Common practice is to name schema as staging
CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE
    IF NOT EXISTS staging.joined_table AS ( -- create a table named joined_table in staging schema
        SELECT
            *
        FROM
            read_csv_auto ('data/joined_table.csv')
    );


