/* ==================================================================================================
    0. Cleaning malformed text data
    Continue working on the data from lecture 09_strings. 
    In this lecture you created a schema called staging and ingested the raw data into the staging schema.

    Task A: Create a schema called refined. This is the schema where you'll put the transformed data.

    - Workflow before creating the refined schema
    - I opened the temporal_data lecture in the duckdb ui and created refined schema there.
    - The following below are the following queries for exercise 0 for refined schema creation.
    ================================================================================================== */

-- Create refined schema
CREATE SCHEMA IF NOT EXISTS refined;

-- Verify the refinde schema exists
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name = 'refined';

-- List all schemas to verify
SELECT schema_name
FROM information_schema.schemata;


/* ==================================================================================================
    Task B: Now transform and clean the data and place the cleaned table inside the refined schema.
    ================================================================================================== */

-- check staging.trains_schedule again
SELECT * 
FROM staging.train_schedules;


-- clean  from staging.trains_schedule to refined.trains_schedules
CREATE OR REPLACE TABLE refined.train_schedules AS -- create the refined table from staging table
SELECT                                              -- select and transform columns
    train_id,
    TRIM(route) AS route, -- text, trim whitespace
    TRY_CAST(scheduled_arrival AS TIMESTAMP) AS scheduled_arrival, -- try_cast used to convert text to timestamp
    TRY_CAST(actual_arrival AS TIMESTAMP)    AS actual_arrival,
    TRY_CAST(departure_time AS TIMESTAMP)    AS departure_time,
    platform, -- numeric, no need to trim
    TRIM(status)   AS status, -- text
    delay_minutes,
    passengers
FROM staging.train_schedules;

-- verify refined.train_schedules
SELECT *
FROM refined.train_schedules;

-- check staging.sweden_holidays again
-- very clean data set, no need to transform or clean
SELECT * 
FROM staging.sweden_holidays;

-- clean from staging.sweden_holidays to refined.sweden_holidays
CREATE OR REPLACE TABLE refined.sweden_holidays AS          -- create the refined table from staging table  
SELECT
    TRY_CAST(Date AS DATE) AS holiday_date,                 -- convert text to date
    TRIM("Holiday Name (English)") AS holiday_english,       -- trim whitespace from text
    TRIM("Holiday Name (Swedish)") AS holiday_swedish
FROM staging.sweden_holidays; 

-- verify refined.sweden_holidays
SELECT *
FROM refined.sweden_holidays;


/* ==================================================================================================
    Task C: Practice filtering and searching for different keywords in different columns. 
    Discuss with a friend why this could be useful in this case.
    ================================================================================================== */
1. 
-- Find all trains that were delayed from 0 to 30 minutes, 30 to 60 minutes and more than 60 minutes.
-- Group by delay ranges.

-- Delayed from 0 to 30 minutes
SELECT *
FROM refined.train_schedules
WHERE delay_minutes BETWEEN 1 AND 30
ORDER BY delay_minutes;



-- Delayed from 30 to 60 minutes
SELECT *
FROM refined.train_schedules
WHERE delay_minutes BETWEEN 31 AND 60
ORDER BY delay_minutes;


-- Delayed more than 60 minutes
SELECT *
FROM refined.train_schedules
WHERE delay_minutes >= 60
ORDER BY delay_minutes;


-- Use UNION ALL to combine the above three queries into one result set 
SELECT *
FROM refined.train_schedules
WHERE delay_minutes BETWEEN 1 AND 30

UNION ALL

SELECT *
FROM refined.train_schedules
WHERE delay_minutes BETWEEN 31 AND 60

UNION ALL

SELECT *
FROM refined.train_schedules
WHERE delay_minutes > 60

ORDER BY delay_minutes;


-- Count number of trains in each delay range using CASE WHEN
SELECT 
    CASE 
        WHEN delay_minutes BETWEEN 1 AND 30 THEN '0–30 min'
        WHEN delay_minutes BETWEEN 31 AND 60 THEN '30–60 min'
        WHEN delay_minutes > 60 THEN '>60 min'
        ELSE 'on-time or early'
    END AS delay_bucket,
    COUNT(*) AS train_count
FROM refined.train_schedules
WHERE delay_minutes IS NOT NULL
GROUP BY delay_bucket
ORDER BY train_count DESC;


-- Find all trains that were on time
SELECT *
FROM refined.train_schedules
WHERE status = 'On Time'


-- 2. Pattern-match routes using `LIKE`
 
-- how many Stockholm-related trains were On Time / Early / Delayed / Cancelled
SELECT
    status,
    COUNT(*) AS trains_per_status
FROM refined.train_schedules
WHERE route LIKE '%Stockholm%'
GROUP BY status
ORDER BY trains_per_status DESC;

-- busiest Stockholm routes, their delay profile, sorted by the longest average delay
SELECT
    route,
    ROUND(AVG(delay_minutes), 1) AS avg_delay_minutes,
    COUNT (*) AS total_trains
FROM refined.train_schedules
WHERE route LIKE '%Stockholm%'
GROUP BY route
ORDER BY avg_delay_minutes DESC;


-- - How many trains operate on Stockholm related route sorted by the busiest route
SELECT
    route,
    COUNT(*) AS total_trains
FROM refined.train_schedules
WHERE route LIKE '%Stockholm%'
GROUP BY route
ORDER BY total_trains DESC;

-- Find holidays with certain keywords
SELECT *
FROM refined.sweden_holidays
WHERE holiday_english LIKE '%Easter%';


-- Find all holidays in summer months. Teaches date extraction.
SELECT *
FROM refined.sweden_holidays
WHERE EXTRACT(month FROM holiday_date) IN (6, 7, 8);

-- Extract the year of each holiday
SELECT
    holiday_date,
    holiday_english,
    EXTRACT(YEAR FROM holiday_date) AS holiday_year
FROM refined.sweden_holidays;


-- Extract the month (numeric)
SELECT
    holiday_english,
    holiday_date,
    EXTRACT(MONTH FROM holiday_date) AS holiday_month
FROM refined.sweden_holidays;


-- Extract the weekday name
SELECT
    holiday_english,
    holiday_date,
    strftime(holiday_date, '%A') AS weekday_name
FROM refined.sweden_holidays;


-- Group holidays by month name
-- This is excellent for learning aggregation + date formatting
SELECT
    strftime(holiday_date, '%B') AS month_name,  -- extract month name from date, %B gives full month name
    COUNT(*) AS holidays_in_month -- count holidays per month
FROM refined.sweden_holidays
GROUP BY month_name
ORDER BY holidays_in_month DESC;


/* ===================================================================================================
    3. Build queries that joins holiday table with refined.train_schedules to analyze:
    ===================================================================================================
*/

--  Did trains experience higher delays in the days surrounding Swedish holidays?”
WITH holiday_window AS (
    SELECT
        h.holiday_english,
        h.holiday_date,
        t.train_id,
        t.route,
        DATE(t.departure_time) AS train_date,
        t.delay_minutes,
        
        -- Calculate +/- window distance
        DATE(t.departure_time) - h.holiday_date AS days_from_holiday
        
    FROM refined.train_schedules t
    JOIN refined.sweden_holidays h
      ON DATE(t.departure_time)
         BETWEEN h.holiday_date - INTERVAL 12 DAY
         AND     h.holiday_date + INTERVAL 12 DAY
)

SELECT
    holiday_english,
    holiday_date,
    AVG(delay_minutes) AS avg_delay,
    COUNT(train_id) AS train_count,
    
    -- Show how far from the holiday the trains were (useful trend indicator)
    MIN(days_from_holiday) AS earliest_day_offset,
    MAX(days_from_holiday) AS latest_day_offset

FROM holiday_window
GROUP BY holiday_english, holiday_date
ORDER BY holiday_date;
