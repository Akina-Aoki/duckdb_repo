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
- Dataset contains trains that occurred between 9 days before and 12 days after Epiphany


-----------------------------------------------------------------------------------------------------------------------------------------


## 1. More extensive EDA on the sakila database

You will be using the same database as in 11_joins. Take some time to really understand this database, as we'll come back to this database later in this course and in data modeling course.

### a) Describe all tables.

### b) Select all data on all tables.

### c) Find out how many rows there are in each table.

The questions here might come from a business stakeholder which is not familiar with the table structure. Hence it's your job to find out which table(s) to look at.

### d) Calculate descriptive statistics on film length.

### e) What are the peak rental times?

### f) What is the distribution of film ratings?

### g) Who are the top 10 customers by number of rentals?

### h) Retrieve a list of all customers and what films they have rented.

### i) Make a more extensive EDA of your choice on the Sakila database.

## 2. Sets and joins on sakila

&nbsp; a) Retrieve a list of all customers and actors which last name starts with G.

&nbsp; b) How many customers and actors starts have the the letters 'ann' in there first names?

&nbsp; c) In which cities and countries do the customers live in?

&nbsp; d) In which cities and countries do the customers with initials JD live in?

&nbsp; e) Retrieve a list of all customers and what films they have rented.

&nbsp; f) What else cool information can you find out with this database using what you know about SQL.

## 3. Theory questions

These study questions are good to get an overview of how SQL and relational databases work.

&nbsp; a) What is the difference between INNER JOIN and INTERSECT?

&nbsp; b) When are the purposes of set operations?

&nbsp; c) What are the main difference between joins and set operations?

&nbsp; d) When is set operators used contra logical operators?

&nbsp; e) How to achieve this using set operations in SQL, where A and B are result sets.

<img src ="https://github.com/kokchun/assets/blob/main/sql/set_question_1.png?raw=true" width = 200>

&nbsp; f) How to achieve this using set operations in SQL, where A and B are result sets.

<img src ="https://github.com/kokchun/assets/blob/main/sql/set_question_2.png?raw=true" width = 200>

&nbsp; g) Does joining order matter for three or more tables?

## Glossary

Fill in this table either by copying this into your own markdown file or copy it into a spreadsheet if you feel that is easier to work with.

| terminology    | explanation |
| -------------- | ----------- |
| temporal       |             |
| interval       |             |
| synthetic      |             |
| VALUES         |             |
| subquery       |             |
| compound query |             |
| set operations |             |
| EXCEPT         |             |
| result set     |             |
| UNION          |             |
| UNION ALL      |             |
| operator       |             |
| INTERSECT      |             |
| venn diagram   |             |
| LEFT JOIN      |             |
| INNER JOIN     |             |
| RIGHT JOIN     |             |
| LIKE           |             |
| ILIKE          |             |
| regexp         |             |