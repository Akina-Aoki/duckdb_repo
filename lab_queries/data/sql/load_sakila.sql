INSTALL sqlite;

LOAD sqlite;

CALL sqlite_attach('data/sqlite-sakila.db'); -- had a problem with the path

-- then run in terminal:
-- duckdb sakila.duckdb < sql/load_sakila.sql
-- duckdb sakila.duckdb
-- after checking with: 'desc;' and 'from film;'
-- exit and open in ui: duckdb -ui sakila.duckdb

-- once opened in ui, work on 02_eda_sakila.sql next
