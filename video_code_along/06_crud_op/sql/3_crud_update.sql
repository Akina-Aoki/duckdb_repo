-- update a column called "learnt" in the dababase
-- update the glossaries that I have learnt from FALSE in alter.sql to TRUE here in crud_update.sql
SELECT * FROM -- check current values
    database.duckdb
WHERE
    id IN (3, 6, 7);


-- perform the update 
UPDATE
    database.duckdb
SET -- set the learnt column to TRUE
    learnt = TRUE
WHERE
    id IN (3, 6, 7); -- for these ids


-- check the updated values
FROM database.duckdb; 


