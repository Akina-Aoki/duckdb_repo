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
CREATE OR REPLACE TABLE refined.train_schedules AS
SELECT
    train_id,
    TRIM(route) AS route, -- text
    TRY_CAST(scheduled_arrival AS TIMESTAMP) AS scheduled_arrival, 
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
CREATE OR REPLACE TABLE refined.sweden_holidays AS
SELECT
    TRY_CAST(Date AS DATE) AS holiday_date,
    TRIM("Holiday Name (English)") AS holiday_english,
    TRIM("Holiday Name (Swedish)") AS holiday_swedish
FROM staging.sweden_holidays;

-- verify refined.sweden_holidays
SELECT *
FROM refined.sweden_holidays;


/* ==================================================================================================
    Task C: Practice filtering and searching for different keywords in different columns. 
    Discuss with a friend why this could be useful in this case.
    ================================================================================================== */