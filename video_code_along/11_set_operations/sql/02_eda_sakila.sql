FROM actor;
FROM film;
FROM film_actor;

FROM address;
FROM city;
FROM country;

FROM category;
FROM customer;


-- Count number of movies and unique titles
SELECT 
    COUNT(*) AS num_movies,
    COUNT(DISTINCT title) AS unique_num_of_titles
 FROM film;


-- List unique ratings
SELECT DISTINCT rating 
FROM main.film;


-- Show structure of film_actor table
DESC TABLE film_actor;

-- Show structure of customer table
DESC TABLE customer;


-- Compound Queries - union of first names starting with 'D'
SELECT 'customer' AS TYPE, -- alias
c.first_name, -- c. means customer table
c.last_name -- c. means customer table
FROM customer c -- the c is an alias for customer table
WHERE c.first_name LIKE 'D%'; -- wildcard/match for first names starting with D 


/* ================================================
    More samples EDA (exploratory data analysis) 
    BEGINNER SAMPLE QUERIES 
   ===============================================*/

-- 1. Count number of actors
SELECT COUNT(*) AS num_actors
FROM actor;

-- 2. List unique last names of actors
SELECT DISTINCT last_name
FROM actor; 

/* ================================================
    More samples EDA (exploratory data analysis) 
    INTERMEDIATE COMPOUND SAMPLE QUERIES 
   ===============================================*/    

-- 3. Compound query: List first names starting with 'A' from actor and customer tables
SELECT 'actor' AS TYPE, 
a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'A%';

-- 4. Compound query: Union of postal codes from address and city tables
SELECT 'address' AS TYPE,
ad.postal_code AS post
FROM address ad

UNION

SELECT 'city' AS TYPE,
c.city AS city_name
FROM city c;

