/* In the terminal, go to path:
adelo@Aira MINGW64 ~/de25/aira_sql/exercises/00_course_database (main)
$ duckdb -ui sql_course_structure.duckdb
*/


/* 
1) create schema first named 'database'
-- check if schema created
-- not a stand alone statement, need to SELECT FROM information_schema.schemata to see the schemas
 */
CREATE SCHEMA IF NOT EXISTS database;


-- verify schema creation
SELECT
    *
FROM
    information_schema.schemata
WHERE
    schema_name = 'database';

/*
2) create sequence for id column in table
-- sequences, put several glosseries in the tables
-- generate unique numbers for the id column in each table
-- specific internal table to track sequences
 */
CREATE SEQUENCE IF NOT EXISTS seq START 1;

SELECT 
    * 
FROM
    pg_catalog.pg_sequences;


/*3) creating sql tables and columns (id, week, content, content_type, exercise) in database schema*/

CREATE TABLE database.sql_course_table(
id INTEGER,
week INTEGER,
content VARCHAR,
description VARCHAR,
content_type VARCHAR,
exercise VARCHAR
);

-- verify table creation
DESC database.sql_course_table;

