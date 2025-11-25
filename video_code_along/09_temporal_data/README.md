# 09 — Temporal data

Short, hands-on examples for working with dates and timestamps in DuckDB.

What’s here
- data/
  - sweden_holidays.csv — holiday dates (English / Swedish)
  - train_schedules.csv — sample train records with timestamps, delays, passengers
- sql/
  - ingest_data.sql — creates staging schema and loads both CSVs
  - datetime.sql — simple date examples (add/subtract, weekday, formatting)
  - timestamp.sql — timestamp examples (age, date_trunc, extract)

Quick start
1. Clone and go to this folder:
   ```
   git clone https://github.com/Akina-Aoki/duckdb_repo.git
   cd duckdb_repo/video_code_along/09_temporal_data
   ```

2. Ingest data
   - DuckDB CLI:
     ```
     duckdb mydb.duckdb < sql/ingest_data.sql
     duckdb mydb.duckdb
     -- then run queries
     ```
   - Python:
     ```python
     import duckdb
     con = duckdb.connect('mydb.duckdb')
     con.execute(open('sql/ingest_data.sql').read())
     ```

Quick examples
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

Data notes
- read_csv_auto guesses types. If a date or timestamp is read as text, use strptime(... ) to parse and cast.

Exercises
- Which route has the biggest average delay?
- Do delays change near holidays?
- Find the busiest platform in a date range.

References (DuckDB)
- DuckDB docs — home: https://duckdb.org/docs
- Date/time functions (date_trunc, date_diff, dayname, today, age):  
  https://duckdb.org/docs/sql/functions/datetime
- DuckDB GitHub: https://github.com/duckdb/duckdb