/* 
Task 2
The products table stores all distinct prodcuts available in the bike store, while the order_items table stores order history from customers.

Check the number of distinct product_id in each of these tables. 
Is the number different between the tables? And why?
*/

-- The products table stores all distinct prodcuts available in the bike store, while the order_items table stores order history from customers.

FROM staging.products;
FROM staging.order_items;

SELECT DISTINCT product_id 
FROM staging.products;

-- Check the number of distinct product_id in each of these tables. 
SELECT COUNT(DISTINCT product_id) AS distinct_product_count
-- 321

SELECT COUNT(DISTINCT product_id)
FROM staging.order_items;
-- 307

-- Checking the products that were never ordered
-- FULL JOIN
SELECT
  p.product_id,
  p.product_name,
FROM staging.products p
FULL JOIN staging.order_items oi
  ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;
-- 14 products were never ordered

-- Checking the products that were never ordered
-- LEFT JOIN
SELECT
  p.product_id,
  p.product_name,
FROM staging.products p
 LEFT JOIN staging.order_items oi
  ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;
-- 14 products were never ordered



/* Task 3
We can perform different join operations on these two tables. It's important to understand if they lead to the same of different results, and why.

Compare queries by groups. Are they doing the same thing and generate the same results, for instance, the same no. of rows?
*/

/* ============
    GROUP 1
   ============ */
-- FULL JOIN, 4736 rows
SELECT oi.product_id
FROM staging.products p
FULL JOIN staging.order_items oi
ON oi.product_id = p.product_id;


--  INNER JOIN, 4722 rows
SELECT oi.product_id
FROM staging.products p
INNER JOIN staging.order_items oi
ON oi.product_id = p.product_id;


-- LEFT JOIN, 4736 rows
SELECT oi.product_id
FROM staging.products p
LEFT JOIN staging.order_items oi
ON oi.product_id = p.product_id;


/* ============
    GROUP 2
   ============ */
-- INNER JOIN, 4722 rows
SELECT oi.product_id
FROM staging.order_items oi
INNER JOIN staging.products p
ON oi.product_id = p.product_id;

-- LEFT JOIN, 4736 ROWS
SELECT oi.product_id
FROM staging.products p
LEFT JOIN staging.order_items oi
ON oi.product_id = p.product_id;

-- RIGHT JOIN, 4736 ROWS
SELECT oi.product_id
FROM staging.order_items oi
RIGHT JOIN staging.products p
ON oi.product_id = p.product_id;


/* ============
    GROUP 3
   ============ */
-- INNER JOIN, 4722
SELECT 
oi.product_id AS product_id_1,
p.product_id AS product_id_2,
FROM staging.order_items oi
INNER JOIN staging.products p
ON oi.product_id = p.product_id
WHERE oi.product_id IS NOT NULL;

-- RIGHT JOIN, 14 ROWS
SELECT 
oi.product_id AS product_id_1,
p.product_id AS product_id_2,
FROM staging.order_items oi
RIGHT JOIN staging.products p
ON oi.product_id = p.product_id
WHERE oi.product_id IS NOT NULL;