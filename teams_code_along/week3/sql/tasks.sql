/* ## Task 2
What are the data types of the following columns:
- sunriseTime
- sunsetTime
- temperatureHighTime
- temperatureLowTime
- windGustTime
- precipIntensityMaxTime */

-- My solution:

DESC staging.weather;

SELECT 
    typeof(sunriseTime) AS sunriseTime_type,
    typeof(sunsetTime) AS sunsetTime_type,
    typeof(temperatureHighTime) AS temperatureHighTime_type,
    typeof(temperatureLowTime) AS temperatureLowTime_type,
    typeof(windGustTime) AS windGustTime_type,
    typeof(precipIntensityMaxTime) AS precipIntensityMaxTime_type
FROM
    staging.weather;

-- Debbie's solution:
DESC
SELECT
  sunriseTime,
  sunsetTime,
  temperatureHighTime,
  temperatureLowTime,
  windGustTime,
  precipIntensityMaxTime
FROM staging.weather;

-- Show the UNIX values of these columns
-- the values are the number of seconds counted from a referencetime point
-- (year-month-day 00:00:00)
SELECT
  sunriseTime,
  sunsetTime,
  temperatureHighTime,
  temperatureLowTime,
  windGustTime,
  precipIntensityMaxTime
FROM staging.weather;

/*
## Task 3
Show the number of records/rows for each combination of Country/Region and Province/State. How many records are there for each combination?
In the following tasks, analyze only records in Sweden.
*/

/* Debbie's solution:
Each row in the dataset contains weather data for each
combination of Country/Region and Province/State for each date.
*/
SELECT 
  *
FROM staging.weather;

/*
- it's important to understand which columns can be used to unique identify a record/row
- in this case Country/Region, Province/State and date
- find out how many records there are for US and Indiana
- use aggregation function together with group by clause
*/

-- aggregation WITHOUT GROUP BY, literally counting the whole row
SELECT
  COUNT(*)AS number_of_records,
FROM
  staging.weather

-- aggregation WITH GROUP BY
-- countries include in the select statement
SELECT
  "Country/Region" AS Country,
  "Province/State" AS State,
  COUNT(*)AS number_of_records, 
FROM staging.weather
GROUP BY Country, State
-- put a "" coz we are using escape character / to say it is a column name
ORDER BY Country, State ; -- sort according to country and state



/* ## Task 4
Transfrom the UNIX time columns to TIMESTAMP data type.
Show the columns below as TIMESTAMP (WITH TIME ZONE) data type and with the timezone in Sweden:
- sunriseTime
- sunsetTime
*/
-- check the two columns first to be queried
SELECT sunriseTime, sunsetTime
FROM staging.weather;


-- function to transform numeric columns to timestamp

SELECT 
to_timestamp(sunriseTime) AS sunrise_utc,
to_timestamp(sunriseTime) AT TIME ZONE 'Europe/Stockholm' AS sunrise_utc_swedentime,

to_timestamp(sunsetTime) AS sunset_utc,
to_timestamp(sunsetTime) AT TIME ZONE 'Europe/Stockholm' AS sunset_utc_swedentime

FROM staging.weather
WHERE "Country/Region" = 'Sweden'; -- note the use of single quotations