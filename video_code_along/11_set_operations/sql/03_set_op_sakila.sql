-- Find all customers with first names starting with 'D'
SELECT
    'customer' AS TYPE,
    c.first_name,
    c.last_name
FROM
    customer c
WHERE
    c.first_name LIKE 'D%';


-- Using UNION to combine first names starting with 'A' from customer and actor tables
SELECT 'customer' AS TYPE,
c.first_name,
c.last_name
FROM customer c
WHERE c.first_name LIKE 'A%'
UNION -- combines results and removes duplicates
SELECT 'actor',
a.first_name,
a.last_name
FROM actor a
WHERE a.first_name LIKE 'A%'

ORDER BY first_name; -- order the final result by first_name


-- Find all the overlapping names between customer and actor tables
SELECT
    a.first_name,
    a.last_name
FROM actor a
INTERSECT -- finds common records between two queries
SELECT
    c.first_name,
    c.last_name
FROM customer c;

-- to check in actor table for first names starting with 'JENN'
SELECT 
  a.first_name,
  a.last_name
FROM actor a
WHERE a.first_name LIKE 'JENN%';

-- to check in customer table for first names starting with 'JENN'
SELECT 
  c.first_name,
  c.last_name
FROM customer c
WHERE c.first_name LIKE 'JENN%';


-- Find all with initial 'JD' and record its type (actor, customer)
SELECT
    'actor' AS TYPE,
    a.first_name,
    a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION ALL -- includes duplicates 

SELECT
    'customer' AS TYPE,
    c.first_name,
    c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';