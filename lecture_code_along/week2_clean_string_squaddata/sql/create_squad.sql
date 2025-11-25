/*
## Task 1
You are asked to create a database with:
- a schema called *staging*
- a table under the schema, called *squad* from data/squaddata.csv

STEPS:
adelo@Aira MINGW64 ~/de25/aira_sql/lecture_code_along/week2_clean_string_squaddata (main)
$ duckdb squad_data.duckdb < sql/create_squad.sql
duckdb -ui squad_data.duckdb
*/



CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.squad AS(
    SELECT *
    FROM read_csv_auto('data/squad.csv')
);


