/* To start the database workflow
-- then run in terminal:
-- duckdb sakila.duckdb < sql/01_load_sakila.sql
-- duckdb sakila.duckdb
-- after checking with: 'desc;' and 'from film;'
-- exit and open in ui: duckdb -ui sakila.duckdb
 */


/* ============================================================
            Task 1: More extensive EDA on the sakila database
============================================================= */

-- a) Describe all tables.
desc;

--b) Select all data on all tables.
SELECT
    *
FROM
    actor;

SELECT
    *
FROM
    address;

SELECT
    *
FROM
    category;

SELECT
    *
FROM
    city;

SELECT
    *
FROM
    country;

SELECT
    *
FROM
    customer;

SELECT
    *
FROM
    film;

SELECT
    *
FROM
    film_actor;

SELECT
    *
FROM
    film_category;

SELECT
    *
FROM
    inventory;

SELECT
    *
FROM
    language;

SELECT
    *
FROM
    payment;

SELECT
    *
FROM
    rental;

SELECT
    *
FROM
    staff;

SELECT
    *
FROM
    store;

-- c) Find out how many rows there are in each table.
-- MANUALLY
SELECT
    COUNT(*)
FROM
    actor;

-- USING UNION ALL
SELECT
    'actor' AS table_name,
    COUNT(*) AS row_count
FROM
    actor
UNION ALL
SELECT
    'address',
    COUNT(*)
FROM
    address
UNION ALL
SELECT
    'category',
    COUNT(*)
FROM
    category
UNION ALL
SELECT
    'city',
    COUNT(*)
FROM
    city
UNION ALL
SELECT
    'country',
    COUNT(*)
FROM
    country
UNION ALL
SELECT
    'customer',
    COUNT(*)
FROM
    customer
UNION ALL
SELECT
    'film',
    COUNT(*)
FROM
    film
UNION ALL
SELECT
    'film_actor',
    COUNT(*)
FROM
    film_actor
UNION ALL
SELECT
    'film_category',
    COUNT(*)
FROM
    film_category
UNION ALL
SELECT
    'inventory',
    COUNT(*)
FROM
    inventory
UNION ALL
SELECT
    'language',
    COUNT(*)
FROM
    language
UNION ALL
SELECT
    'payment',
    COUNT(*)
FROM
    payment
UNION ALL
SELECT
    'rental',
    COUNT(*)
FROM
    rental
UNION ALL
SELECT
    'staff',
    COUNT(*)
FROM
    staff
UNION ALL
SELECT
    'store',
    COUNT(*)
FROM
    store;

-- d) Calculate descriptive statistics on film length.
/* Common descriptive statistics include measures of central tendency (mean, median, mode) 
and measures of spread (minimum, maximum, range, standard deviation, quartiles).
Calculate many of these using aggregate functions. */
SELECT
    COUNT(length) AS count,
    MIN(length) AS min_length,
    MAX(length) AS max_length,
    AVG(length) AS avg_length,
    STDDEV (length) AS stddev_length,
    MEDIAN (length) AS median_length
FROM
    film;

-- e) What are the peak rental times?
SELECT
    EXTRACT(
        HOUR
        FROM
            rental_date
    ) AS rental_hour,
    COUNT(*) AS rental_count
FROM
    rental
GROUP BY
    rental_hour
ORDER BY
    rental_count DESC
LIMIT
    10;

-- f) What is the distribution of film ratings?
SELECT
    rating,
    COUNT(*) AS ratings_count
FROM
    film
GROUP BY
    rating
ORDER BY
    ratings_count DESC;

-- g) Who are the top 10 customers by number of rentals?
/* Query the rental table (which contains one row per rental transaction) 
and join it with the customer table to get customer names. 
You'll group by customer and count their rentals, 
then order by count descending and limit to 10:*/
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
    JOIN rental r ON c.customer_id = r.customer_id -- type of join is inner join by default
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY
    rental_count DESC
LIMIT
    10;

/* h) Retrieve a list of all customers and what films they have rented.
Join multiple tables: customer (for customer names), 
rental (the transaction record), inventory (which links rentals to specific film copies), 
and film (for film titles). */
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    r.rental_id,
    r.rental_date,
    f.film_id,
    f.title
    
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY c.customer_id, r.rental_date;

/* i) Make a more extensive EDA of your choice on the Sakila database. 
Find the top 5 most rented films */
SELECT
    f.film_id,
    f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id 
GROUP BY f.film_id, f.title -- group by film to count rentals per film
ORDER BY COUNT(r.rental_id) DESC -- most rented films at the top
LIMIT 5;


/* ============================================================
                Task 2: Sets and joins on sakila
============================================================= */

-- a) Retrieve a list of all customers and actors which last name starts with G.
-- beginner way customers
SELECT customer_id, first_name, last_name
FROM customer
WHERE
    last_name LIKE 'G%';

-- beginner way actors
SELECT actor_id, first_name, last_name
FROM actor
WHERE
    last_name LIKE 'G%';

-- UNION ALL way
SELECT customer_id, first_name, last_name
FROM customer
WHERE
    last_name LIKE 'G%'

UNION ALL

SELECT actor_id, first_name, last_name
FROM actor
WHERE
    last_name LIKE 'G%'
ORDER BY last_name ASC;

/* b) How many customers and actors starts have the the letters 'ann' in there first names?
use the LIKE operator with wildcard patterns (%ann%) to match 'ann' anywhere in the first_name column, 
then count the results from both customer and actor tables. 
Since the question asks for totals, you can either return separate counts or sum them.
*/
SELECT 
    'Customer' AS type,
    COUNT(*) AS count
FROM customer
WHERE first_name ILIKE '%ann%'

UNION ALL

SELECT 
    'Actor' AS type,
    COUNT(*) AS count
FROM actor
WHERE first_name ILIKE '%ann%'

UNION ALL

SELECT
    'Total' AS type,
    (SELECT COUNT(*) FROM customer WHERE first_name ILIKE '%ann%') +
    (SELECT COUNT(*) FROM actor WHERE first_name ILIKE '%ann%') AS count;



-- c) In which cities and countries do the customers live in?
/* customer → address → city → country. 

Join along those foreign keys: 
(customer.address_id → address.address_id, 
address.city_id → city.city_id, 
city.country_id → country.country_id)
and project the city and country names.
*/

SELECT DISTINCT
    ci.city AS city_name,
    co.country AS country_name
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN  city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
ORDER BY co.country, ci.city;

-- counts per city / country
SELECT
    ci.city AS city_name,
    co.country AS country_name,
    COUNT(*) AS customer_count
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY co.country, ci.city
ORDER BY customer_count DESC;

-- d) In which cities and countries do the customers with initials JD live in?
SELECT DISTINCT
    ci.city AS city_name,
    co.country AS country_name
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN  city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
ORDER BY co.country, ci.city

-- e) Retrieve a list of all customers and what films they have rented.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    r.rental_id,
    r.rental_date,
    f.film_id,
    f.title
FROM
    customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY customer_id, f.title;


-- f) What else cool information can you find out with this database using what you know about SQL.