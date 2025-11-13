SELECT
    *
FROM
    funny_jokes;

/* The tutorial up to now wa done by creating the query in dyckdb local host.
But down below, try to create the query here and run in duckdb local server.
 */
-- order the table by rating, ascending order
SELECT
    *
FROM
    funny_jokes
ORDER BY
    rating;

-- shortcut for select *
FROM funny_jokes;

-- descending order
SELECT
    *
FROM
    funny_jokes
ORDER BY
    rating DESC;

-- after updating joke id = 7
SELECT
    *
FROM
    funny_jokes
WHERE
    id = 7;