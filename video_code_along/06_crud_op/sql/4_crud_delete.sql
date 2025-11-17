-- Delete a record from the programming.python table where the id is 2

SELECT * FROM programming.python
WHERE id = 2;


-- Now delete the record
DELETE FROM programming.python
WHERE id = 2;

-- check that id = 2 is deleted
FROM programming.python;


-- Going back to the insert, run again and see that id 11 copied id 1
INSERT
	INTO
	database.duckdb (word,
	description)
VALUES 
('DuckDB',
'An in-process SQL OLAP database management system designed for fast analytical queries.'),
('Sequence',
'A database object that generates a sequence of unique numbers, typically used for auto-incrementing columns.'),
('VARCHAR',
'A variable-length character data type that stores text strings of varying lengths.'),
('TIMESTAMPTZ',
'A data type that stores both date and time, including time zone information.'),
('ARRAY',
'A data type in DuckDB that allows for the storage of ordered collections of elements of the same type.'),
('CREATE TABLE',
'A SQL statement used to define a new table in DuckDB.'),
('DROP SCHEMA',
'A SQL statement used to remove a schema and all its contained objects like tables.'),
('AUTO_INCREMENT',
'In DuckDB, achieved by using sequences to automatically generate unique values for an ID column.'),
('pg_catalog',
'A schema in DuckDB that stores system tables and metadata about the database objects.'),
('INFORMATION_SCHEMA',
'A set of views in DuckDB that provides information about the database metadata such as tables, columns, and data types.');

-- see that id 11 is now same as id 1
SELECT * FROM database.duckdb

-- pre-select all id that is after 10
SELECT * FROM database.duckdb
WHERE id > 10;

-- delete them
DELETE FROM database.duckdb
WHERE id > 10; 