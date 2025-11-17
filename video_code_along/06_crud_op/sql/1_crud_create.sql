/*CRUD operations: Create
Insert some data
 */
INSERT INTO
    database.sql (word, description)
VALUES
    (
        'query',
        'request made to a database to retrieve, modify or manipulate data'
    );

-- show the data in database.sql table
FROM
    database.sql;

--- View the data to confirm it was inserted
-- insert data into database.sql table
INSERT
	INTO
	database.sql
	(word,
	description)
VALUES 
	('CRUD', 'create, read, update, delete - basic actions to be performed on data'),
	('range condition', 'filter data within a specific range of values');

-- show the data in database.sql table
FROM database.sql; -- view data in database.sql table


-- insert data into python sql to programming database
INSERT 
    INTO 
    programming.python (word, description)
VALUES
('class', 'code template for creating objects'),
('type hint', 'hint for which type in parameters, return values in classes and functions'),
('tuple', 'immutable, works similar list, also store records');

FROM programming.python; -- view data in python sql to programming database

-- insert data into database.duckdb table
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

FROM database.duckdb; -- view data in duckdb table