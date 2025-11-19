CREATE SCHEMA IF NOT EXISTS database; -- create schema if not exists database

CREATE SCHEMA IF NOT EXISTS programming; -- create schema if not exists programming

FROM information_schema.schemata -- get information on what's in the database

-- sequences, put several glosseries in the tables
-- generate unique numbers for the id column in each table
CREATE SEQUENCE IF NOT EXISTS id_sql_sequence START 1;
CREATE SEQUENCE IF NOT EXISTS id_python_sequence START 1;
CREATE SEQUENCE IF NOT EXISTS id_duckdb_sequence START 1;

FROM pg_catalog.pg_sequences -- from pg_catalog.pg_sequences get schemaname, sequencename
-- specific internal table to track sequences

-- creating sql tables in database schema
CREATE TABLE IF NOT EXISTS database.sql(
    id INTEGER PRIMARY KEY DEFAULT nextval('id_sql_sequence'),-- id column with default value from sequence
    -- tell the database that this id columns will get its value from the sequence created above
    word STRING, -- word column
    description STRING -- description column
);


-- creating duckdb tables in database schema
CREATE TABLE IF NOT EXISTS database.duckdb(
    id INTEGER PRIMARY KEY DEFAULT nextval('id_duckdb_sequence'),-- id column with default value from sequence
    word STRING, -- word column
    description STRING -- description column
);


-- creating pyhton tables in programming schema
CREATE TABLE IF NOT EXISTS programming.python(
    id INTEGER PRIMARY KEY DEFAULT nextval('id_python_sequence'),-- id column with default value from sequence
    word STRING, -- word column
    description STRING -- description column
);

desc; -- describe database.sql table