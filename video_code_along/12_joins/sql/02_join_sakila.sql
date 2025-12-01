-- can we get which actors played which films?

SELECT * FROM main.film;
SELECT * FROM main.film_actor;
SELECT * FROM main.actor;


--Sample 1: which actor has played which film_id
/*"I am keeping the Actor (a) table... 
and joining the Film_Actor (fa) table... 
ON the condition that the fa actor_id matches the a actor_id."
*/
SELECT
	a.actor_id,
	a.first_name,
	a.last_name,
	fa.film_id 
FROM
	main.actor a -- left table
LEFT JOIN main.film_actor fa  -- right table 
ON 	fa.actor_id = a.actor_id;  


-- Sample 2: which actor has played which film?
-- joining 3 tables (left, middle, right)
/*
You cannot connect Actors directly to Films because the Actor table doesn't list movies, and the Film table doesn't list actors. You need a "middleman" to introduce them.
Here is the step-by-step logic of how these two joins work together like a chain.

1. The First Link: Finding the "IDs"
LEFT JOIN main.film_actor fa ON fa.actor_id = a.actor_id

Goal: Connect the Person to the Bridge.

The Logic:

Take the Actor (e.g., "Brad Pitt", ID #10).

Look at the film_actor table (fa) for any row with ID #10.

Result: The database now knows that Brad Pitt is connected to Film ID #55, Film ID #90, and Film ID #102.

Problem: We only have numbers (#55, #90), not movie names.

2. The Second Link: Getting the "Names"
LEFT JOIN main.film f ON f.film_id = fa.film_id

Goal: Connect the Bridge to the Movie Title.

The Logic:

Take the Film IDs we found in the previous step (e.g., #55).

Look at the film table (f) to match that number.

Result: The database finds that #55 is "Fight Club". It grabs the title and puts it in your result row.

How to visualize the "Handshake"
Notice how the handshakes change?

Handshake 1: a shakes hands with fa (using actor_id).

Handshake 2: fa turns around and shakes hands with f (using film_id).

The film_actor table (fa) is the critical connector. It holds the actor_id in its left hand and the film_id in its right hand.

Why use LEFT JOIN twice?
By using LEFT JOIN for the whole chain, you are prioritizing the Actor.

If an actor has no films: They appear in the list, but film_id is NULL, and consequently title is NULL.

If you used INNER JOIN: Any actor who hasn't acted in a movie yet would simply be deleted from the results.

*/
SELECT
	a.first_name,
	a.last_name,
	f.title
FROM
	main.actor a -- left table
LEFT JOIN main.film_actor fa  -- middle table
ON fa.actor_id = a.actor_id -- joining condition 1

LEFT JOIN main.film f  -- right table
ON f.film_id = fa.film_id ;  -- joining condition 2


-- Sample 3: if doing LEFT JOIN get all films including those without a category -> the category becomes NULL
-- INNER JOIN - get all films with associated category
SELECT
	f.title,
	c.name AS category,
FROM
	main.film_category fc
INNER JOIN main.category c ON
	fc.category_id = c.category_id
INNER JOIN main.film f ON
	f.film_id = fc.film_id; 


-- a cross join since it category_id doesn't exist in film 
SELECT
	COUNT(*)
FROM
	main.film f
INNER JOIN main.category c ON category_id ; 

-- a cross join since it category_id doesn't exist in film
SELECT
	f.title,
  c.name as Category
FROM
	main.film f
INNER JOIN main.category c ON category_id ; 
	

-- in which address, city and country does the staff live?

-- address_id, first_name, last_name
SELECT * FROM main.staff;

-- address_id, address, city_id
SELECT * FROM main.address;

-- city_id, city, country_id
SELECT * FROM main.city c; 

-- country_id, country
SELECT * FROM main.country; 


-- lets do the joining, note that the order of join doesn't matter 
SELECT
	s.first_name,
	s.last_name,
	a.address,
	c.city,
	ctry.country
FROM
	main.staff s -- left table
LEFT JOIN main.address a ON -- middle table
	s.address_id = a.address_id -- joining condition 1
LEFT JOIN main.city c ON -- right table
	c.city_id = a.city_id -- joining condition 2
LEFT JOIN main.country ctry ON -- fourth table
	ctry.country_id = c.country_id -- joining condition 3; 
