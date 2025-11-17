-- get schema of the table
DESC food;

-- explore the data from food
FROM food;

-- get distinct ids
SELECT DISTINCT id FROM food;

-- count distinct ids (201 different food items)
SELECT COUNT(DISTINCT id) FROM food;

-- count number of rows (25920 rows)
SELECT COUNT (*) AS number_of_rows FROM food;


-- filter data for weeks between April 2004 and June 2004
SELECT * FROM food WHERE week_id BETWEEN '2004-04' AND '2004-06';