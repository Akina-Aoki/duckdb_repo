/*   a) Create a database file called hemnet.duckdb and ingest the data from the csv file into your database.
path: $ duckdb hemnet_exercise.duckdb < sql_1/01_hemnet_create.sql

adelo@Aira MINGW64 ~/de25/aira_sql/exercises/00_course_database (main)
$ duckdb -ui hemnet_exercise.duckdb*/

CREATE SCHEMA IF NOT EXISTS hemnet;

CREATE TABLE IF NOT EXISTS hemnet.hemnet_table AS(
    SELECT *
    FROM read_csv_auto('data/hemnet.csv')
);