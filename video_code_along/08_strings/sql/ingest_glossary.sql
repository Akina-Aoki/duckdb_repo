CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE
    IF NOT EXISTS staging.sql_glossary AS ( -- name of the schema and table
        SELECT
            *
        FROM
            read_csv_auto ('data/sql_glossary.csv')
    );