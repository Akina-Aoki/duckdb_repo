# Exercise 01 — Data transformations

## Quick overview
--------------
- Load raw CSV into DuckDB (staging.salaries).
- Clean and enrich the data (staging.cleaned_salaries).
- Create a final table for analysis (staging.final_salaries).
- `sql_0/create.sql` — reads data/salaries.csv into staging.salaries (read_csv_auto).
- `sql_0/transform.sql` — performs the cleaning steps and builds cleaned and final tables.

## How to run
----------
1. Load the raw CSV:
   - duckdb salaries.duckdb < sql_0/create.sql

2. Open DuckDB UI:
   - duckdb -ui salaries.duckdb

3. Run the transform script:
   - duckdb salaries.duckdb < sql_0/transform.sql

4. Inspect tables:
   - SELECT * FROM staging.salaries;
   - SELECT * FROM staging.cleaned_salaries;
   - SELECT * FROM staging.final_salaries;

## Project structure
-----------------

```
01_data_transform/
    |- data/
        |- salaries.csv              # The dataset for exercises
    |- sql_0/
        |- create.sql                # Loads the data into staging.salaries
        |- transform.sql             # Cleans data and creates cleaned/final tables
README.md
```


## Small checklist to improve scripts
---------------------------------
- Make column names consistent (e.g., salary_in_sek_monthly vs monthly_salary_in_sek).
- Use ALTER TABLE ... ADD COLUMN to add columns (not UPDATE TABLE).
- Add validation queries at the start of transform.sql: row counts, NULL counts, and distinct checks.

