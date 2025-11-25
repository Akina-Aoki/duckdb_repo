/* Ingest daily weather data into a staging table 
$ duckdb weather_data.duckdb < sql/ingest.sql
$ duckdb -ui weather_data.duckdb */

/*
## Task 1
You are asked to create a database with:
- a schema called *staging*
- a table under the schema, called *weather*
*/

CREATE SCHEMA IF NOT EXISTS staging;
CREATE SEQUENCE IF NOT EXISTS id_sequence START 1;

CREATE TABLE IF NOT EXISTS staging.weather AS (
    SELECT * FROM read_csv_auto('data/daily_weather_2020.csv')
);