/*
Objective: Understand and apply GROUP BY in DuckDB.

This exercise demonstrates how to take many rows that belong to the same food
category and summarize them into a single row using GROUP BY with an aggregation.

What we want to achieve:
- Each food category (e.g., FROZEN YOGURT, PIZZA) appears many times in the table.
- We collapse all rows of the same category into one row per category.
- We aggregate the number_of_searches column to understand total search volume.
- SUM() is the aggregation function we use to add up all searches in each category.

Step-by-step logic:
1. Use the food category column as the grouping key.
All FROZEN YOGURT rows will be grouped together, all PIZZA rows grouped together, etc.

2. Choose the metric to aggregate.
We will aggregate number_of_searches.

3. Apply SUM(number_of_searches) to calculate the total searches for each category.

4. DuckDB returns one row per food category with the aggregated total.
This condenses a long table into a compact summary view.

Expected UI result:
- The output table becomes shorter.
- Each category appears once.
- SUM(number_of_searches) shows total searches per category.
- FROZEN YOGURT becomes a single summary row instead of many repeated rows.
 */
SELECT
    food,
    SUM(number_of_searches) AS total_searches -- Aggregate total searches per food category
FROM
    cleaned_food
GROUP BY  -- Group rows by food category to summarize them into single rows
    food
ORDER BY
    total_searches DESC; -- Order results by total searches in descending order
LIMIT 10; -- Show top 10 food categories by total searches


-- Total searches by year instead of food
SELECT
    year,
    SUM(number_of_searches) AS total_searches 
FROM
    cleaned_food
GROUP BY 
    year 
ORDER BY
    total_searches; 


-- Filter by the total search greater than 300K
SELECT
    year,
    SUM(number_of_searches) AS total_searches 
FROM
    cleaned_food
GROUP BY 
    year 
HAVING
    total_searches > 300000
ORDER BY
    total_searches; 


-- Group by 2 columns (year and food)
SELECT
    year,
    food,
    SUM(number_of_searches) AS total_searches 
FROM
    cleaned_food
GROUP BY 
    year,
    food 
HAVING
    food IN ('pizza', 'sushi')
ORDER BY
    food, year;
