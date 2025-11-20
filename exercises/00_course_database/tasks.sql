/* a) Select all the exercise column in this course */
SELECT
    exercise
FROM
    database.sql_course_table;

/* b) Select all the lectures in this course */
SELECT
    content
FROM
    database.sql_course_table;

/* c) Select all records for week 48 */
SELECT
    *
FROM
    database.sql_course_table
WHERE
    week = 48;

/* d) Select all records for week 47-49*/
SELECT
    *
FROM
    database.sql_course_table
WHERE
    week BETWEEN 47 AND 49;

/* e) Count how many lectures are in the table?*/
SELECT
    COUNT(*) AS total_lectures
FROM
    database.sql_course_table;

WHERE
    content_type = 'lecture';

/* f) How many other content are there? */
SELECT
    COUNT(*) AS total_other_content
FROM
    database.sql_course_table
WHERE
    -- everyhting except lecture in content_type
    content_type <> 'lecture';

/*  g) Which are the unique content types in this table?*/
SELECT DISTINCT
    content_type
FROM
    database.sql_course_table;

/* h) Delete the row with content 02_setup_duckdb and add it again.*/
-- select item to be deleted
SELECT
    *
FROM
    database.sql_course_table
WHERE
    content = '02_set_up_duckdb';

-- once confirmed, delete the row
DELETE FROM database.sql_course_table
WHERE
    content = '02_set_up_duckdb';

-- VERIFY DELETION
SELECT
    *
FROM
    database.sql_course_table;

-- add deleted row again
INSERT INTO
    database.sql_course_table (
        id,
        week,
        content,
        description,
        content_type,
        exercise
    )
VALUES
    (1, 46, '02_set_up_duckdb', 'Setting up DuckDB environment', 'lecture', 'exercise 0');

-- VERIFY INSERTION
SELECT
    *
FROM
    database.sql_course_table;

/* i) You see that 02_setup_duckdb comes in the end of your table, even though the week is 46. Now make a query where you sort the weeks in ascending order.
02_set_up_duckdb is now in the bottom, I want to change id to 3 and order by ascending by id to move it to the proper order
*/
-- update id of 02_set_up_duckdb to 3
UPDATE database.sql_course_table
SET id = 3
WHERE content = '02_set_up_duckdb';

-- verify update just for that row
SELECT *
FROM database.sql_course_table
WHERE id = 3;

-- now select all and order by id ascending
SELECT *
FROM database.sql_course_table
ORDER BY id ASC;


/* 
Now you can choose what you want to explore in this table.
*/
-- Example: Find all exercises for week 49
SELECT
    *
FROM   
    database.sql_course_table
WHERE
    week = 49 AND content_type = 'exercise';