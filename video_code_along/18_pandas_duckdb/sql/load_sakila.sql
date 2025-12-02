-- Install and load the SQLite extension

INSTALL sqlite;

LOAD sqlite;

CALL sqlite_attach (
    'data/sqlite-sakila.db'
);

-- Load the Sakila database from SQLite to DuckDB
-- duckdb data/sakila.duckdb < sql/01_load_sakila.sql

-- To interactively explore the loaded Sakila database, run:
-- duckdb -ui data/sakila.duckdb