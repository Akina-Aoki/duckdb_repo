-- a) Which movies are longer than 3 hours (180 minutes), show the title and its length.
SELECT 
    title,
    length
FROM
    film
WHERE
    length > 180
ORDER BY
    length DESC;

-- b) Which movies have the word "love" in its title? Show the following columns (title, rating,  length,  description)
SELECT
    title,
    rating,
    length,
    description
FROM 
    film
WHERE
    title ILIKE '%love%'; -- ILIKE instead of LIKE for case-insensitive search

-- c) Calculate descriptive statistics on the length column, The Manager wants, shortest, average, median and longest movie length
SELECT
    MIN(length) AS shortest,
    AVG(length) AS average,
    MEDIAN(length) AS median,
    MAX(length) AS longest
FROM film;


/* ==========================================================================================================
d) The rental rate is the cost to rent a movie 
and the rental duration is the number of days a customer can keep the movie. 
The Manager wants to know the 10 most expensive movies to rent per day.

Key points to implement:

1. Daily cost per movie: 
cost_per_day = rental_rate / rental_duration
 
2. Sort by: cost_per_day in descending order and limit to 10 rows.

3. Exclude or guard against ZeroDivisionError: rental_duration = 0

4. Decide how to handle NULLs in rental_rate or rental_duration (e.g., filter them out).

5. Optionally add secondary sorting (e.g., by title) to make ordering deterministic when there are ties.
==========================================================================================================*/

-- Check the required tables 
SELECT *
FROM film;

SELECT *
FROM rental;

-- quick check of the columns I need from film table
SELECT
  film_id,
  rental_rate,
  rental_duration
FROM film
GROUP BY film_id, rental_rate, rental_duration
ORDER BY rental_rate DESC;


-- Phase 2 — Business Logic Pre-Validation
-- Diagnose risk rows / bad inputs

SELECT *
FROM film 
WHERE rental_rate IS NULL
OR rental_duration IS NULL
OR rental_duration = 0;
-- Output: 0 rows, so no bad inputs found


-- Phase 3 — Build the Core Metric as a Reusable Asset
-- Generate the computation layer (cost_per_day) in isolation.
SELECT
    film_id,
    title,
    rental_rate,
    rental_duration,
    ROUND(rental_rate / rental_duration, 2) AS daily_price
FROM film
WHERE rental_rate IS NOT NULL
AND rental_duration > 0;

-- Finalized Query
-- Phase 4 — Finalize the Query with Sorting and Limiting
SELECT
    film_id,
    title,
    rental_rate,
    rental_duration,
    ROUND(rental_rate / rental_duration, 2) AS daily_price
FROM film
WHERE rental_rate IS NOT NULL
AND rental_duration > 0
ORDER BY daily_price DESC
LIMIT 10;


/* ==========================================================================================================
e) Which actors have played in most movies?
Show the top 10 actors with the number of movies they have played in.
==========================================================================================================*/

/* Phase 1 - scan of both actors and their film links.
This validates structure, data volume, and uniqueness. */

-- Explore actor table
SELECT *
FROM actor
ORDER BY actor_id
LIMIT 10;

-- Explore film_actor table
-- This confirms that 'film_actor' column acts as a bridge table.
SELECT *
FROM film_actor
ORDER BY actor_id, film_id
LIMIT 10;



/* Phase 2 - Data Integrity Validation
Check whether there are actors without movies or movies without actors.
This gives operational confidence before aggregate work. 
If this returns rows, you know the dataset carries orphans.
If not, the model is clean.
*/

-- Actors with no movies
SELECT
  a.actor_id,
  a.first_name,
  a.last_name  
FROM actor a
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
WHERE fa.actor_id IS NULL;


-- 2. Check for Duplicate Actor IDs
-- Table is compromised of I get rows
SELECT 
  actor_id
FROM actor
GROUP BY actor_id
HAVING COUNT(*) > 1;
-- No duplicate actor IDs found


-- 3. Check for duplicates in actor and film table.
-- This is one of the most critical integrity checks in any bridge table.
SELECT actor_id, film_id
FROM film_actor
GROUP BY actor_id, film_id
HAVING COUNT(*) > 1;


-- 4. Check for Actors Missing Essential Fields
SELECT *
FROM actor
WHERE first_name IS NULL 
OR last_name IS NULL;
-- No actors with missing essential fields found


-- 5. Validate Film Counts Are Non-Negative
-- A sanity check. Aggregations shouldn’t produce anomalies.
SELECT actor_id, COUNT(*) AS movie_count
FROM film_actor
GROUP BY actor_id
HAVING COUNT(*) < 0;  -- Should return nothing


/* Phase 3 — Analyze the Distribution

Before ranking anything, quantify the overall activity.
This tells you whether outliers exist and helps calibrate expectations.
*/

SELECT
  actor_id,
  COUNT(*) AS movie_count
FROM film_actor
GROUP BY actor_id
ORDER BY movie_count DESC
LIMIT 10;

/* Phase 4 — A full actor profile with KPIs.

Now extend the metric by iner joining the actor identity back into the counts.
*/
SELECT
  a.actor_id,
  a.first_name,
  a.last_name,
  COUNT(*) AS movie_count
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY movie_count DESC
LIMIT 10;


/* =========================================================================================================
 f) Now it's time for you to choose your own question to explore the sakila database!
 Write down 3-5 questions you want to answer and then answer them using pandas and duckdb.
============================================================================================================*/

/*
f.1) Business — Top 10 revenue-generating films
Why: Identify star content to promote or license.
Tables/cols: payment -> rental -> inventory -> film
Plot: bar chart of revenue by film. Complexity: multiple payments per rental possible; group carefully.
*/

/* 1.1 Start with understanding the base tables*/
-- a) Look at film
SELECT 
  film_id,
  title,
  rental_rate,
  rental_duration
FROM film
LIMIT 10;

-- b) Look at payments
SELECT
  payment_id, 
  rental_id, 
  amount
FROM payment
LIMIT 10;

-- c) Understand how rentals connect
SELECT 
rental_id, 
inventory_id, 
customer_id
FROM rental
LIMIT 10;

-- d) Understand inventory → film mapping
SELECT inventory_id, film_id
FROM inventory
LIMIT 10;


/* 1.2 Join step-by-step (one relationship at a time)
This is the beginner-friendly diagnostic approach.
Step 1: payment → rental */
SELECT
  p.payment_id,
  p.amount,
  r.rental_id,
  r.inventory_id
FROM payment p
INNER JOIN rental r ON p.rental_id = r.rental_id
LIMIT 10;


-- Step 2: bring in film through inventory
SELECT
  p.payment_id,
  p.amount,
  r.rental_id,
  i.inventory_id,
  f.film_id,
  f.title
FROM payment p
INNER JOIN rental r ON p.rental_id = r.rental_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
LIMIT 10;


/*3. Add aggregation and ranking (final KPI)
Once the join path is validated, plug in business logic.
*/
-- Final query for this question f1
SELECT 
  f.film_id,
  f.title, 
  ROUND(SUM(p.amount),2) AS revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY revenue DESC
LIMIT 10;

/*
2) Business — Revenue trend by month
Why: Understand seasonality and revenue growth.
Tables/cols: payment(payment_date, amount), rental(rental_date, return_date) optionally join inventory/film
SQL:
-- monthly rental revenue
SELECT DATE_TRUNC('month', payment_date) AS month, SUM(amount) AS revenue
FROM payment
GROUP BY month
ORDER BY month;
Pandas/plot: line chart (month vs revenue). Complexity: need to decide which payments correspond to which rentals (payment.rental_id).
*/


/*
3) Marketing — Popular film categories/genres
Why: Target marketing and acquisitions.
Tables/cols: film -> film_category -> category
SQL:
SELECT c.category_id, c.name, COUNT(*) AS film_count
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id, c.name
ORDER BY film_count DESC;
Plot: bar chart; pie for distribution. Complexity: films can be in multiple categories depending on dataset.
*/


/*
4) Customer — Churn / activity: customers who haven't rented in X months
Why: Target re-engagement campaigns.
Tables/cols: customer, rental(rental_date)
SQL:
-- customers with last rental date
SELECT c.customer_id, c.first_name, c.last_name, MAX(r.rental_date) AS last_rental
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING MAX(r.rental_date) < DATE('now') - INTERVAL '6 months'
ORDER BY last_rental;
Pandas/plot: count of churned customers by month they became inactive. Complexity: define churn window. */