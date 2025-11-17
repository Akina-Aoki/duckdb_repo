/* GOALS:
1. Change name of id into food.
2. Remove google topic column.
3. Chnage value into number_of_searches
4. Change week_id into week.
5. Extract a year column.
 */
-- 1. Change name of id into food.
-- explnataion: we can use aliasing to rename columns
SELECT
    id as food,
    week_id as week,
    SUBSTRING(week, 1, 4) as year, -- extract year from week_id
    value as number_of_searches,
FROM
    food;

/* Query Explanation from above:
1. id AS food
You’re rebranding the id column to food.
This is called aliasing

2. week_id AS week
Same principle.
week_id becomes week

3. SUBSTRING(week, 1, 4) AS year
Using a string function to extract the first four characters from the week column.
start point = 1, length = 4.
In dataset, the first four characters represent the year (e.g., "2023W14" → "2023").
Result: a new virtual column called year that can use for aggregation or filtering.

4. value AS number_of_searches
Another semantic upgrade. Instead of a generic value, you now communicate what the metric represents—search volume.
 */


-- Final transformation query to create a new cleaned_food table
CREATE TABLE
    IF NOT EXISTS cleaned_food AS (
        SELECT
            id as food,
            week_id as week,
            SUBSTRING(week, 1, 4) as year, -- extract year from week_id
            value as number_of_searches,
        FROM
            food
    );

-- cleaned_food, new version of table with the transformation
FROM cleaned_food;