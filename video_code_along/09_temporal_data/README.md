# 09 — Temporal data

Short, hands-on examples for working with dates and timestamps in DuckDB.

## What's here
```basg
├── data/
│   ├── sweden_holidays.csv        # holiday dates (English / Swedish)
│   └── train_schedules.csv        # sample train records with timestamps, delays, passengers
│
├── sql/
│   ├── ingest_data.sql            # creates staging schema + loads both CSVs
│   ├── datetime.sql               # date examples (add/subtract, weekday, formatting)
│   └── timestamp.sql              # timestamp examples (age, date_trunc, extract)
│
└── exercise 2/
    └── temporal_data              # main exercise folder
```


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
[Date/time functions]: https://duckdb.org/docs/sql/functions/datetime
[DuckDB GitHub]: https://github.com/duckdb/duckdb

____________________________________________________________________________________________________________________

# Exercise 2 - querying multiple tables
## TASK 0: Cleaning malformed text data

Continue working on the data from lecture 09_strings. In this lecture you created a schema called staging and ingested the raw data into the staging schema.

### Environment & Ingestion
All raw data lands in the `staging` schema as the first step in the pipeline.

```bash
duckdb temporal_data.duckdb < sql/ingest_data.sql
duckdb -ui temporal_data.duckdb
```

### a) Create a schema called refined. This is the schema where you'll put the transformed data.
- Workflow before creating the refined schema
- I opened the temporal_data lecture in the duckdb ui and created refined schema there.
- The following below are the following queries for exercise 0 for refined schema creation.

```arduino
┌─────────────────────────────────────────┐
│               Data Base                 │
└─────────────────────────────────────────┘
              │
              ▼
┌──────────────────────────┐
│        staging           │
│  - raw                   │
│  - unmodified            │
│  - ingestion only        │
└──────────────────────────┘
              │  (ETL/ELT)
              ▼
┌──────────────────────────┐
│        refined           │
│  - cleaned               │
│  - typed                 │
│  - analytics-ready       │
└──────────────────────────┘
```

| Zone        | Purpose                        | Allowed Operations                          | Not Allowed                         |
| ----------- | ------------------------------ | ------------------------------------------- | ----------------------------------- |
| **staging** | Raw data landing zone          | Ingestion only                              | No cleaning, no casting, no updates |
| **refined** | Clean, trusted analytics layer | Transforming, type-casting, standardization | No raw ingestion                    |


### b) Now transform and clean the data and place the cleaned table inside the refined schema.
### TIP: The strategic model: Staging → Refined

In any modern data architecture production, the golden rule is:

- Always ingest into staging first.
- Do all cleaning, parsing, and quality checks in staging.
- Push only clean, modeled, high-quality tables into refined.

```sql
CREATE TABLE IF NOT EXISTS refined.trains_schedules AS
SELECT ...
FROM staging.trains_schedules
WHERE ...
```

### Transformation flow
```pgsql    
staging.train_schedules
        │
        ├── Validate structure
        ├── Profile timestamps & integers
        └── Maintain row count
                ▼
refined.trains_schedules
        ├── Cast timestamps
        ├── Retain numeric fields
        └── Prepare for analytics
```


### What not to do

- Do NOT ingest raw CSVs directly into the refined schema.
- Do NOT transform inside refined.
- Do NOT move raw data around.
- That breaks lineage, makes debugging painful, and kills data governance.

### Check the staging.trains_schedule to see what needs to be transformed

```sql
-- check staging.trains_schedule again
SELECT * 
FROM staging.train_schedules;
```

**Data set is already clean**
- `scheduled_arrival`, `actual_arrival`, `departure_time` are already valid TIMESTAMP strings

- `delay_minutes` and `passengers` are clean integers (no quotes)

- No nulls, no weird whitespace, no broken rows
- This means transformation layer can be incredibly lightweight.

### transformation strategy
| Column Name       | Format                     | Status |
| ----------------- | -------------------------- | ------ |
| scheduled_arrival | timestamp-formatted string | Clean  |
| actual_arrival    | timestamp-formatted string | Clean  |
| departure_time    | timestamp-formatted string | Clean  |
| delay_minutes     | integer                    | Clean  |
| passengers        | integer                    | Clean  |


### Create `refined.trains_schedules`
```sql
CREATE TABLE IF NOT EXISTS refined.trains_schedules AS
SELECT
    route,
    CAST(scheduled_arrival AS TIMESTAMP) AS scheduled_arrival,
    CAST(actual_arrival     AS TIMESTAMP) AS actual_arrival,
    CAST(departure_time     AS TIMESTAMP) AS departure_time,
    delay_minutes,
    passengers
FROM staging.train_schedules;
```


### c) Exploratory Queries

1. Delay filtering

```sql
SELECT *
FROM refined.trains_schedules
WHERE delay_minutes > 0;
```


2. Pattern-match routes using `LIKE`

```sql
SELECT *
FROM refined.trains_schedules
WHERE route LIKE '%Stockholm%';
```

3. Date Extraction

```sql
SELECT
    route,
    DATE(departure_time) AS dep_date,
    delay_minutes
FROM refined.trains_schedules;
```

4. Build queries that joins holiday table with refined.Train_schedules to analyze:

```sql
SELECT
    t.route,
    t.departure_time,
    t.delay_minutes,
    h.holiday_english
FROM refined.trains_schedules t
JOIN refined.sweden_holidays h
    ON DATE(t.departure_time) = h.holiday_date
ORDER BY t.departure_time;
```

| Insight                    | Value          |
| -------------------------- | -------------- |
| Holiday detected           | Epiphany       |
| Avg delay (holiday window) | ~12 minutes    |
| Dataset coverage           | −9 to +12 days |

**Result**
- All trains in your dataset departed close to Epiphany
- Average delay in that period was 12 minutes
- Dataset contains trains that occurred between 9 days before and 12 days after Epiphany.