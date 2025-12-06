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

/* Analyze monthly rental revenue. It aggregates payments by truncating each payment_date to 
the first day of its month and summing the amount per month. The result is a time series of revenue, 
ordered chronologically, which is useful for spotting seasonality and growth trends. 
*/
/*
2. Revenue trend by month
Understand seasonality and revenue growth.
Tables/cols: payment(payment_date, amount), rental(rental_date, return_date) optionally join inventory/film
*/

-- Preview payment data
SELECT
  payment_id,
  payment_date,
  amount
FROM payment
ORDER BY payment_date
LIMIT 10;

-- check the last year and month date in the payment table
SELECT MAX(payment_date) AS last_payment_date
FROM payment;
-- in the final query, 2006 - 02 should display the final revenue

/* DATE_TRUNC('month', payment_date) normalizes all timestamps within the same month to a single month key,
making GROUP BY month straightforward. SUM(amount) computes total revenue for that period. 
The ORDER BY month ensures the output is in time order for plotting or reporting. */

-- 2) Normalize to month (check the month key)
SELECT 
  date_trunc('month', payment_date) AS month,
FROM payment
ORDER BY payment_date
LIMIT 10;
-- 3) Aggregate revenue by month
SELECT 
  DATE_TRUNC('month', payment_date) AS month, 
  SUM(amount) AS revenue
FROM payment
GROUP BY month;

-- 4) Final ordered time series
SELECT DATE_TRUNC('month', payment_date) AS month, SUM(amount) AS revenue
FROM payment
GROUP BY month
ORDER BY month;



/*
3) Inventory: Most number of films per genre
Tables/cols: film -> film_category -> category
*/

-- 1) Peek at base tables
SELECT film_id, title FROM film ORDER BY film_id;
SELECT film_id, category_id FROM film_category ORDER BY film_id, category_id;
SELECT category_id, category FROM category ORDER BY category_id, category;
SELECT DISTINCT category FROM film_list ORDER BY category;


-- 2) Final Query: Check how many films there are per genre
-- Count films per category using film_list
SELECT
  fl.category AS category,
  COUNT(*) AS film_count
FROM film_list AS fl
GROUP BY fl.category
ORDER BY film_count DESC, category;



/*
4) Customer rental number activity
Why: Send promotional offers to least active customers.
Tables/cols: customer, rental(rental_date)
*/

-- Step 1: Peek at base tables (customer)
SELECT
  customer_id, first_name, last_name
FROM customer
ORDER BY customer_id
LIMIT 5;

-- Step 1: Peek at base tables (rental)
SELECT
  rental_id,
  customer_id,
  rental_date
FROM rental
ORDER BY rental_date
LIMIT 5;

-- Step 2: See rentals per customer (sanity check)
/*In this context, customer_id is the identifier column for each customer row. 
It serves as the primary key in the customer table and is the foreign key referenced
by related tables like rental, enabling accurate joins between customers and their rental activity.

Because customer_id uniquely identifies a customer, it is safe to use in GROUP BY and ORDER BY clauses, 
and it helps avoid duplicate counting when aggregating rentals per customer. 
*/
SELECT
  customer_id,
  rental_date,
  COUNT(*) AS rental_count
  FROM rental
  GROUP BY customer_id, rental_date
  ORDER BY rental_count DESC, customer_id
  LIMIT 5;
  

-- Step 3: Identify least active customers (overall rental counts)
SELECT
  customer_id,
  COUNT(*) AS total_rentals
FROM rental
GROUP BY customer_id
ORDER BY total_rentals ASC, customer_id
LIMIT 10;

-- Step 3: Identify most active customers (overall rental counts)
SELECT
  customer_id,
  COUNT(*) AS total_rentals
FROM rental
GROUP BY customer_id
ORDER BY total_rentals DESC, customer_id
LIMIT 10;