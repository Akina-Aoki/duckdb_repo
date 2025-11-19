-- drop all the schemas and tables created in the previous files
-- DDL: Data Definition Language


DROP TABLE database.sql; -- drop the table created in create_statement.sql
-- just deleting that one specific TABLE

-- see here after the drop that glossary only has now 2 tables, sql schema gone.
desc;

-- delete a schema containing all the tables
-- CASCADE will drop all the tables in that schema as well
DROP schema programming CASCADE; -- drop the schema created in create_statement.sql

-- now there's only the duckdb left
desc;

FROM information_schema.schemata; -- see that programming schema is gone

