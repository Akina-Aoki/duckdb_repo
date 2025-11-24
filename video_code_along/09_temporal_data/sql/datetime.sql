desc staging.sweden_holidays;

FROM staging.sweden_holidays
LIMIT 5; -- checking the format of the data

-- addition
SELECT
    date, date + interval 5 day AS plus5days, -- adding 5 days,
    typeof(plus5days) AS plus5days_type -- create new table for +5 days

FROM staging.sweden_holidays;

-- subtraction

SELECT
    date, date - interval 5 day AS minus5days, -- subtracting 5 days,
    typeof(minus5days) AS minus5days_type -- create new table for -5 days

FROM staging.sweden_holidays;

-- date functions
SELECT today();

-- combining with table data
-- show difference between two dates
select 
	*,
	today() as Today,
	date_diff('day', Date, Today) as Days_Diff
from staging.sweden_holidays;

-- show the weekday

select 
	Date,
  	dayname(Date) as Weekday_Name
from staging.sweden_holidays;

-- pick the latest from two dates
select 
	*,
	today() as Today,
	greatest(Date, Today) as Later_Day
from staging.sweden_holidays;

-- convert date to string
select 
	Date,
	strftime(Date, '%d/%m/%Y') as Date_String
from staging.sweden_holidays;

-- convert string to date
SELECT
    date,
    strftime (date, '%d/%m/%Y') as date_string,
    typeof (date_string),
    strptime (date_string, '%d/%m/%Y')::DATE as new_date,
    typeof (new_date)
FROM
    staging.sweden_holidays;


-- convert string to timestamp
select 
	Date,
	strptime('2025-12-31', '%Y-%m-%d') as Date_Timestamp
from staging.sweden_holidays;