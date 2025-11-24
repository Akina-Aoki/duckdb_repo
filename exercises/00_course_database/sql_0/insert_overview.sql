/*CRUD operations: Create
Creating the spine of the course database and inserting data into it
*/
Insert some data
*/
INSERT INTO
    database.sql_course_table (id,week, content, description, content_type, exercise)
VALUES
    (1, '00_intro', 1, 'Introduction to SQL with DuckDB', 'lecture', 'N/A' );


-- verify creation
SELECT * FROM database. sql_course_table;


-- Insert more values in database.sql_course_table
INSERT INTO
    database.sql_course_table (id, week, content, description, content_type, exercise)
VALUES 
    (2, 1, '01_course_structure', 'Description of course structure', 'lecture', 'N/A'),
    (3, 1, '02_set_up_duckdb', 'Setting up DuckDB environment', 'lecture', 'N/A'),
    (4, 1, '03_sql_introduction', 'Understanding SQL basics', 'lecture', 'N/A'),
    (5, 2, '04_querying_data', 'How to query data using SQL', 'lecture', 'N/A'),
    (6, 2, '05_filtering_data', 'Techniques for filtering data', 'lecture', 'N/A'),
    (7, 2, '06_crud_operations', 'CRUD operations in SQL', 'lecture', 'N/A'),
    (8, 2, '07_grouping_data', 'Grouping and aggregating data', 'lecture', 'N/A'),
    (9, 2, '08_string_functions', 'Using string functions in SQL', 'lecture', 'N/A'),
    (10, 3, '09_temporal_data', 'Working with temporal data types', 'lecture', 'N/A'),
    (11, 3, '10_enforce_constraints', 'Enforcing data integrity with constraints', 'lecture', 'N/A'),
    (12, 3, '11_set_operations', 'Set operations in SQL', 'lecture', 'N/A'),
    (13, 3, '12_joins', 'Understanding different types of joins', 'lecture', 'N/A'),
    (14, 4, '13_subquery', 'Using subqueries in SQL', 'lecture', 'N/A'),
    (15, 4, '14_views', 'Creating and using views', 'lecture', 'N/A'),
    (16, 4, '15_cte', 'Common Table Expressions', 'lecture', 'N/A'),
    (17, 5, '16_window_functions', 'Window functions in SQL', 'lecture', 'N/A'),
    (18, 5, '17_python_connect_duckdb', 'Connecting DuckDB with Python', 'lecture', 'N/A'),
    (19, 6, '18_pandas_duckdb', 'Using Pandas with DuckDB', 'lecture', 'N/A'),
    (20, 6, '19_dlt', 'Data Loading Techniques', 'lecture', 'N/A');

-- verify all insertions
SELECT * FROM database.sql_course_table;


-- Insert values for exercises without weeks and exercises
INSERT INTO
    database.sql_course_table (id, content, description, content_type)
VALUES
    (21, 'exercises', 'Exercises for SQL course', 'exercise');

-- verify insertion
SELECT * FROM database.sql_course_table;


/*Correction: Update the variables of week from id 1 to id 20
-- update week column based on id ranges
*/
UPDATE database.sql_course_table
SET week = 
    CASE
        WHEN id BETWEEN 1 AND 4 THEN 46
        WHEN id BETWEEN 5 AND 9 THEN 47
        WHEN id BETWEEN 10 AND 13 THEN 48
        WHEN id BETWEEN 14 AND 16 THEN 49
        WHEN id BETWEEN 17 AND 18 THEN 50
        WHEN id BETWEEN 19 AND 20 THEN 51
        ELSE NULL
    END
WHERE id BETWEEN 1 AND 20;

-- verify updates
SELECT * FROM database.sql_course_table;


/*CORRECTION: Add exercise numbers into exercise column for weeks 46 to 47
-- update exercise column based on week ranges

Another option:
UPDATE database.sql_course_table
SET exercise =
    CASE
        WHEN week = 46 THEN 'Exercise 46'
        WHEN week = 47 THEN 'Exercise 47'
    END
WHERE week IN (46, 47);
*/

UPDATE database.sql_course_table
SET exercise = 'exercise 0'
WHERE week IN (46, 47);

-- update week 48, 49 and 50 with exercise numbers
UPDATE database.sql_course_table
SET exercise = 
    CASE
        WHEN week = 48 THEN 'exercise 1'
        WHEN week = 49 THEN 'exercise 2'
        WHEN week = 50 THEN 'exercise 3'
    END
WHERE week IN (48, 49, 50);

-- forgot week 51, update with exercise 3
UPDATE database.sql_course_table
SET exercise = 'exercise 3'
WHERE week = 51;

-- verify all updates
SELECT * FROM database.sql_course_table;

