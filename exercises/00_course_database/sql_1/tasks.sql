/* b) Make a wildcard selection to checkout the data*/
SELECT
    *
FROM
    hemnet.hemnet_table
LIMIT
    10;

/* c) Find out how many rows there are in the table*/
SELECT
    COUNT(*) AS total_rows
FROM
    hemnet.hemnet_table;

/* d) Describe the table that you have ingested to see the columns and data types.*/
DESCRIBE hemnet.hemnet_table;

/*  e) Find out the 5 most expensive homes sold.*/
SELECT
    address,
    asked_price,
    final_price,
    commune
FROM
    hemnet.hemnet_table
ORDER BY
    final_price DESC
LIMIT
    5;

/*  f) Find out the 5 cheapest homes sold.*/
SELECT
    address,
    asked_price,
    final_price,
    commune
FROM
    hemnet.hemnet_table
ORDER BY
    final_price ASC
LIMIT
    5;

/*g) Find out statistics on minimum, mean, median and maximum prices of homes sold.*/
SELECT
    MIN(final_price) AS min_price,
    AVG(final_price) AS mean_price,
    MEDIAN (final_price) AS median_price,
    MAX(final_price) AS max_price
FROM
    hemnet.hemnet_table;

/* h) Find out statistics on minimum, mean, median and maximum prices of price per area.*/
SELECT
    MIN(price_per_area) AS min_price_per_area,
    AVG(price_per_area) AS mean_price_per_area,
    MEDIAN (price_per_area) AS median_price_per_area,
    MAX(price_per_area) AS max_price_per_area
FROM
    hemnet.hemnet_table;

/* i) How many unique communes are represented in the dataset.*/
SELECT
    COUNT(DISTINCT commune) AS unique_communes
FROM
    hemnet.hemnet_table;

/*  j) How many percentage of homes cost more than 10 million?*/
SELECT
    (COUNT(
            CASE
                WHEN final_price > 10000000 THEN 1
            END) * 100.0 / COUNT(*)) AS percentage_above_10M
FROM
    hemnet.hemnet_table;


