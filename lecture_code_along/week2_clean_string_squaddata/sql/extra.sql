/*
## Task 3
Find rows that start with *title* column value in the *context* column value.
*/
SELECT *
FROM staging.squad
WHERE context LIKE title || '%';
-- explanation: the % is a wildcard that matches any sequence of characters following the title at the start of the context.

/* Task 3; other more solutions:*/
SELECT *
FROM staging.squad
WHERE SUBSTR(context, 1, LENGTH(title)) = title;

-- more samples
SELECT *
FROM staging.squad  
WHERE LEFT(context, LENGTH(title)) = title;