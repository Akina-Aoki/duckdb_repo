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

# SQL Theory Questions & Glossary

## 2. Theory questions

These are short, simple answers.

| Question | Answer |
| --- | --- |
| a) What are the main categories of SQL commands? | DDL (Data Definition Language), DML (Data Manipulation Language), DCL (Data Control Language), TCL (Transaction Control Language) |
| b) Explain the difference between HAVING and WHERE clauses? | WHERE filters individual rows before aggregation; HAVING filters groups after aggregation (after GROUP BY). |
| c) How to make sure you delete the correct rows? | Test the WHERE condition with a `SELECT` first; run `DELETE` inside a transaction so you can `ROLLBACK`; use precise conditions and backups. |
| d) How do you retrieve unique values in a column? | `SELECT DISTINCT column FROM table;` or `SELECT column, COUNT(*) FROM table GROUP BY column;` |
| e) What does data transformation mean? | Converting, cleaning, enriching, or reshaping raw data into a desired format or structure for analysis/storage. |
| f) How do you create a new row in a table? | `INSERT INTO table_name (col1, col2, ...) VALUES (val1, val2, ...);` |
| g) What happens if you omit the WHERE clause in an UPDATE statement? | The UPDATE applies to every row in the table. |
| h) What happens if you omit the WHERE clause in a DELETE statement? | All rows in the table are deleted. |
| i) What is a conditional statement in SQL, and can it be used with SELECT? | `CASE WHEN ... THEN ... ELSE ... END` — yes, it can be used in `SELECT`, `WHERE`, `ORDER BY`, etc. |

---
## Theory questions

| Question | Answer |
| --- | --- |
| a) What are the main categories of SQL commands? | DDL (Data Definition Language), DML (Data Manipulation Language), DCL (Data Control Language), TCL (Transaction Control Language) |
| b) Explain the difference between HAVING and WHERE clauses? | WHERE filters individual rows before aggregation; HAVING filters groups after aggregation (after GROUP BY). |
| c) How to make sure you delete the correct rows? | Test the WHERE condition with a `SELECT` first; run `DELETE` inside a transaction so you can `ROLLBACK`; use precise conditions and backups. |
| d) How do you retrieve unique values in a column? | `SELECT DISTINCT column FROM table;` or `SELECT column, COUNT(*) FROM table GROUP BY column;` |
| e) What does data transformation mean? | Converting, cleaning, enriching, or reshaping raw data into a desired format or structure for analysis/storage. |
| f) How do you create a new row in a table? | `INSERT INTO table_name (col1, col2, ...) VALUES (val1, val2, ...);` |
| g) What happens if you omit the WHERE clause in an UPDATE statement? | The UPDATE applies to every row in the table. |
| h) What happens if you omit the WHERE clause in a DELETE statement? | All rows in the table are deleted. |
| i) What is a conditional statement in SQL, and can it be used with SELECT? | `CASE WHEN ... THEN ... ELSE ... END` — yes, it can be used in `SELECT`, `WHERE`, `ORDER BY`, etc. |


## Glossary

| terminology | explanation |
| --- | --- |
| CRUD | Create, Read, Update, Delete — basic data operations. |
| query | An instruction (usually `SELECT`) to retrieve or compute data from the database. |
| statement | A single SQL command (e.g., `SELECT`, `INSERT`, `CREATE TABLE`). |
| schema | A namespace that groups database objects (tables, views, etc.) and defines structure. |
| aliasing | Renaming a table or column in a query using `AS` (e.g., `column AS c`) for readability. |
| projection | Selecting a subset of columns from a table (the `SELECT` list). |
| selection | Choosing a subset of rows using conditions (the `WHERE` clause). |
| namespace | A context for names (e.g., `schema.table`) to avoid name collisions. |
| SELECT clause | The part of a query that specifies which columns or expressions to return. |
| WHERE clause | Filters rows based on conditions before grouping/aggregation. |
| condition | A boolean expression (e.g., `col > 10`) used in `WHERE`, `HAVING`, `JOIN`, `CASE`. |
| BETWEEN | Shorthand for range checks: `x BETWEEN a AND b` is `x >= a AND x <= b`. |
| aggregate functions | Functions that summarize groups of rows: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `MEDIAN`. |
| range filtering | Filtering rows by numeric or date ranges using `>=`, `<=`, or `BETWEEN`. |
| pattern matching | Matching text patterns using `LIKE`, `ILIKE` or regex (e.g., `name LIKE 'A%'`). |
| list filtering | Filtering by membership using `IN` (e.g., `status IN ('open','closed')`). |
|  |  |
|  |  |
|  |  |
