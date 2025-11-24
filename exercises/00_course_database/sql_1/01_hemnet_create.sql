/*   a) Create a database file called hemnet.duckdb and ingest the data from the csv file into your database.*/

CREATE SCHEMA IF NOT EXISTS hemnet;

CREATE TABLE IF NOT EXISTS hemnet.hemnet_table AS(
    SELECT *
    FROM read_csv_auto('data/hemnet.csv')
);