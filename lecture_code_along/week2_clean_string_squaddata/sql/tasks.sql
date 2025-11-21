/*
## Task 2
Find rows that do not contain the *title* column value in the *context* column value.
*/
SELECT *
FROM staging.squad
WHERE POSITION NOT (title IN context) = 0;

/*
## Task 3
Find rows that start with *title* column value in the *context* column value.
*/
