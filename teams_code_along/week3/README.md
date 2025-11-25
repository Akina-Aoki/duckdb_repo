# In-class exercise, week 4
This exercise covers knowledge in chapter 9 and previous chapters. The background is that you are a data engineer in a construction company. This company will start analyzing weather data together with other operational data in order to understand how weather has affected its operation, like project delays, material damages and safety risks etc. With these insights, the company can plan ahead based on weather forecasts. 

Your manager wants you to show some EDA from a sample weather data to understand what can be analyzed from weather data, before adding weather data to the existing database with other operational data. 

You will need to make sure of TIMESTAMP With TIME ZONE functions of DuckDB. Check more on this [here](https://duckdb.org/docs/stable/sql/functions/timestamptz). 

Follow the tasks below: 

## Task 1
You are asked to create a database with:
- a schema called *staging*
- a table under the schema, called *weather*

Use the file *daily_weather_2020.csv* from [kaggle](https://www.kaggle.com/datasets/vishalvjoseph/weather-dataset-for-covid19-predictions) to ingest rows into table. Use `read_csv_auto()` function to automatically detect column data types.

## Task 2
What are the data types of the following columns:
- sunriseTime
- sunsetTime
- temperatureHighTime
- temperatureLowTime
- windGustTime
- precipIntensityMaxTime

Understand the meaning of each data type in the DuckDB's documentation [here](https://duckdb.org/docs/stable/sql/data_types/overview).

Columns above are represented as UNIX time, what do their values mean?

>[!Note]
>For the purpose of this exercise, ignore the time column in this dateset.

## Task 3
Show the number of records/rows for each combination of Country/Region and Province/State. How many records are there for each combination?

In the following tasks, analyze only records in Sweden.

## Task 4
Show the columns below as TIMESTAMP (WITH TIME ZONE) data type and with the timezone in Sweden:
- sunriseTime
- sunsetTime

## Task 5
For each year-month, show the largest gap between sunrise and sunset hours. In your result, show these columns:
- year
- month
- the time with time zone of sunrise when the gap is largest in that month
- the time with time zone of sunset when the gap is largest in that month
- the gap in hours

## Task 6
Show a new column which prints a text of warning, 'It's dangerous to use the crane at kl. ...', where ... is the hour of windGustTime during the day. For instance, the result of one row can be: 'It's dangerous to use the crane at kl. 16'
