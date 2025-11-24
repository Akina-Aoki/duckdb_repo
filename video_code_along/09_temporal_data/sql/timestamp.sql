/* ==========
   Timestamp 
   functions 
   ========== */

desc staging.train_schedules; -- has TIMESTAMP columns
FROM staging.train_schedules;

-- time difference
-- age function to show difference between two timestamps
select 
  scheduled_arrival,
  actual_arrival,
  delay_minutes,
  age(actual_arrival,scheduled_arrival) as delay_interval, -- note this will be interval data type
  typeof(delay_interval),
from staging.train_schedules;

-- current timestamp
select current_localtimestamp();

-- truncate a timestamp to a specific precision
-- truncation will zero out the less significant parts of the timestamp
select 
  scheduled_arrival,
  date_trunc('hour', scheduled_arrival) as scheduled_arrival_trunc 
FROM staging.train_schedules;

-- truncate by the mninute
SELECT current_localtimestamp() AS current_time,
date_trunc('minute', current_time) as min;


-- extract subfield of timestamp
-- show arrival hour in text
SELECT
    scheduled_arrival,
    'kl. ' || extract(  -- concat to make a string
        'hour'
        FROM
            scheduled_arrival
    ) AS scheduled_arrival_hour
FROM
    staging.train_schedules;