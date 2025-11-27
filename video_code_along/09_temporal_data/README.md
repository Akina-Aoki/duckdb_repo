# 09 — Temporal data

Short, hands-on examples for working with dates and timestamps in DuckDB.

## What’s here
- data/
  - sweden_holidays.csv — holiday dates (English / Swedish)
  - train_schedules.csv — sample train records with timestamps, delays, passengers
- sql/
  - ingest_data.sql — creates staging schema and loads both CSVs
  - datetime.sql — simple date examples (add/subtract, weekday, formatting)
  - timestamp.sql — timestamp examples (age, date_trunc, extract)

## Ingest data
   - DuckDB CLI:
     ```
     duckdb name.duckdb < sql/ingest_data.sql
     duckdb -ui name.duckdb
     -- then run queries in ui
     ```

## Quick examples
- Show holidays:
  ```
  SELECT * FROM staging.sweden_holidays ORDER BY Date;
  ```
- Date math:
  ```
  SELECT Date, Date + INTERVAL '5 days' FROM staging.sweden_holidays;
  ```
- Days until a holiday:
  ```
  SELECT Date, date_diff('day', today(), Date) AS days_until FROM staging.sweden_holidays;
  ```
- Compare scheduled vs actual:
  ```
  SELECT train_id, scheduled_arrival, actual_arrival, age(actual_arrival, scheduled_arrival) AS delay_interval
  FROM staging.train_schedules;
  ```

## Data notes
- read_csv_auto guesses types. If a date or timestamp is read as text, use strptime(... ) to parse and cast.


## References (DuckDB)
- Date/time functions:
  https://duckdb.org/docs/sql/functions/datetime
- DuckDB GitHub: https://github.com/duckdb/duckdb
