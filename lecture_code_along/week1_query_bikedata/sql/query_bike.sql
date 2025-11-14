/*
produce a new duckdb database from this called "bike_join"
to start my ui: 
1. Ingest: duckdb bike_joined.duckdb < sql/ingest_bike_join.sql
2. Open the ui: duckdb bike_joined.duckdb -ui
 */
/* 
=============================
Query the data
============================= */
-- overview of * data
desc;

-- overview of joined_table data
desc staging.joined_table;

-- SELECT statement to select all or some columns
SELECT
    *
FROM
    staging.joined_table;

-- select specific columns
SELECT
    order_date,
    customer_first_name,
    customer_last_name,
    product_name
FROM
    staging.joined_table;

-- filter rows with WHERE clause
SELECT
    order_date,
    customer_first_name,
    customer_last_name,
    product_name
FROM
    staging.joined_table
WHERE
    customer_first_name = 'Marvin';

-- order status (1, 2, 3, 4) No description existing in the 9 data tables
-- Need to add columns or create another table to describe the order_status numbers
SELECT
    order_id,
    order_status
FROM
    staging.joined_table;

-- create a new table to show the 'order_status' description
-- at least provide column names
CREATE TABLE
    IF NOT EXISTS staging.status (
        order_status INTEGER,
        order_status_description VARCHAR
    );

-- just to confirm that the new table is created and empty
SELECT
    *
FROM
    staging.status;

-- insert values into the new table
INSERT INTO
    staging.status
VALUES
    (1, 'Pending'),
    (2, 'Processing'),
    (3, 'Rejected'),
    (4, 'Completed');

-- check the ordeer status of a specific order_id (1)
SELECT
    order_id,
    order_status
FROM
    staging.joined_table
    -- check the status of order_id = '1'
WHERE
    order_id = 1;


/* join tables
join order_id, order_status and order description*/
SELECT
    j.order_id, -- pick up the tables to be shown
    j.order_status, -- pick up the tables to be shown
    s.order_status_description
FROM
    staging.joined_table j -- give an alias (distinct left or right)
    JOIN staging.status s ON j.order_status = s.order_status -- order status is the common table
    -- sort, order the data, use ORDER BY
SELECT
    j.order_id, -- pick up the tables to be shown
    j.order_status, -- pick up the tables to be shown
    s.order_status_description
FROM
    staging.joined_table j -- give an alias (distinct left or right)
    JOIN staging.status s ON j.order_status = s.order_status -- order status is the common table
ORDER BY
    j.order_status ASC; -- order the table by ascending order



/*
Investigate unique customer
 */
-- distinct
SELECT DISTINCT
    order_id
FROM
    staging.joined_table
ORDER BY
    order_id;

DESC;

-- find unique values of customer_id
SELECT DISTINCT
    customer_id
FROM
    staging.joined_table
ORDER BY
    customer_id ASC;


/*
Find unique customer_first_name and last_name together. This is non existent, so we have to create that table
and then concatenate first and last names to find unique full names.
Some people might have same first or last names, but different people
 */
-- find unique values of customer full names
SELECT DISTINCT
    customer_first_name,
    customer_last_name
FROM
    staging.joined_table
ORDER BY
    customer_first_name,
    customer_last_name;


-- DUPLICATE (Window functions - skipped for now)
-- 'Justina Jenkins' is the person with multiple customer_id
-- this is an issue but this can be found out by using window function
-- WHERE clause with 2 conditions
SELECT
    customer_id,
    customer_first_name,
    customer_last_name
FROM
    staging.joined_table
WHERE
    customer_first_name = 'Justina'
    AND customer_last_name = 'Jenkins'


/* =============================
        Aggregate functions
   ============================= */
    -- aggregate functions: COUNT, SUM, AVG, MIN, MAX
    -- from this order data, find out the total revenue from all orders?
SELECT
    order_id,
    product_name,
    quantity,
    list_price
FROM
    staging.joined_table;


-- calculate the revenue in a specific column
SELECT
    order_id,
    product_name,
    quantity * list_price AS revenue
FROM
    staging.joined_table;


-- calculate total revenue from all orders
SELECT
    ROUND(SUM(quantity * list_price)) AS total_revenue
FROM
    staging.joined_table;


-- found out the minimun from the list price of all products
SELECT
    ROUND(MIN(quantity * list_price)) AS minimum_revenue,
    ROUND(MAX(quantity * list_price)) AS maximum_revenue
FROM
    staging.joined_table;


/* ============================
            CASE WHEN
   ============================= */
-- Available in lecture 5 video:
-- similar with if...else in other languages
-- replace the order_status column with description using CASE WHEN
-- if value = 1, then 'Pending', etc.
SELECT
    order_id,
    product_name,
    order_status
FROM
    staging.joined_table;


-- update the data in order_status
-- When status = 1, replace with 'Pending'
SELECT
    order_id,
    product_name,
    CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
    END
FROM
    staging.joined_table;
    

-- Update the column name after a Data Manipulation
SELECT
    order_id,
    product_name,
    CASE order_status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Processing'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Completed'
    END AS order_status_description
FROM
    staging.joined_table;