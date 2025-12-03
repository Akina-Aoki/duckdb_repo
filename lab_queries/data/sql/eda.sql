/*
 e) Which actors have played in most movies? Show the top 10 actors with the number of movies they have
 played in.
 f) Now it's time for you to choose your own question to explore the sakila database! Write down 3-5
 questions you want to answer and then answer them using pandas and duckdb.
 */

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


/* d) The rental rate is the cost to rent a movie and the rental duration is the number of days a customer can 
keep the movie. The Manager wants to know the 10 most expensive movies to rent per day. */