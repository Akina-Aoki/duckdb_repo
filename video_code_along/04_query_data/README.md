# 04 – Querying Data: Filtering & Selection in DuckDB

A walkthrough of practical SQL filtering techniques using a real salary dataset.  
This readme summarizes essential patterns, correct SQL terminology, and workflow examples to support both learning and quick review.

---

## Project Structure

```
04_query_data/
    ├─ data/
    │   └─ salaries.csv            # Main dataset
    ├─ sql/
    │   ├─ ingest_salaries.sql     # Loads salaries.csv into DuckDB (as data_jobs)
    │   ├─ query_salaries.sql      # Querying and selecting data (SELECT, LIMIT, OFFSET)
    │   ├─ alias.sql               # Using column/table aliases in queries
    │   ├─ aggregate_functions.sql # Aggregation: SUM, AVG, MIN, MAX, MEDIAN
    │   └─ sorting.sql             # ORDER BY — sorting result sets
    └─ README.md
```

---

## Dataset Summary

**`data/salaries.csv`**  
A single-table dataset for hands-on SQL exercises.  
Sample columns:

- `work_year` — The year of salary data
- `experience_level` — EN=Entry, MI=Mid, SE=Senior, EX=Executive
- `employment_type` — FT=Full-time, PT=Part-time, CT=Contract
- `job_title`
- `salary`, `salary_currency`, `salary_in_usd`
- `employee_residence`
- `remote_ratio` — 0=onsite, 50=hybrid, 100=remote
- `company_location`
- `company_size` — S=small, M=medium, L=large

---

## Key Filtering and Selection Concepts

### 1. Filtering Rows with `WHERE`

The `WHERE` clause filters rows returned by a query based on one or more conditions.

**Example:** Return all rows for Machine Learning Engineers in the US:
```sql
SELECT * FROM data_jobs WHERE job_title = 'Machine Learning Engineer' AND employee_residence = 'US';
```

### 2. Using `IN` and `NOT IN` for Membership

Test for inclusion or exclusion from a set of values.  
Handy for filtering based on lists.

**IN Example:**  
All Data Scientist or Data Engineer roles:
```sql
SELECT * FROM data_jobs WHERE job_title IN ('Data Scientist', 'Data Engineer');
```

**NOT IN Example:**  
Non-full-time jobs:
```sql
SELECT * FROM data_jobs WHERE employment_type NOT IN ('FT');
```

### 3. Limiting and Skipping Rows: `LIMIT` & `OFFSET`

- `LIMIT N`: Only return the first N rows.
- `OFFSET N`: Skip the first N rows (commonly used for pagination).

**Examples:**  
Return 5 rows:
```sql
SELECT * FROM data_jobs LIMIT 5;
```
Skip first 10 rows:
```sql
SELECT * FROM data_jobs OFFSET 10;
```
Combine OFFSET and LIMIT (get rows 11–20):
```sql
SELECT * FROM data_jobs OFFSET 10 LIMIT 10;
```

### 4. Column Selection and “Projection”

You don’t have to select all columns. Choose just those needed.

**Example:**  
```sql
SELECT job_title, salary_in_usd FROM data_jobs WHERE remote_ratio = 100;
```

**Excluding columns (DuckDB supports EXCLUDE):**
```sql
SELECT * EXCLUDE (salary, work_year) FROM data_jobs;
```

### 5. Distinct Values

Return unique entries (no duplicates) for a column.

**Example:**  
List all unique currencies:
```sql
SELECT DISTINCT salary_currency FROM data_jobs;
```

Or count unique currencies, possibly providing an alias for readability:
```sql
SELECT COUNT(DISTINCT salary_currency) AS number_currencies FROM data_jobs;
```

---

## Aliases with `AS`

Aliases make output column or table names clearer, especially after applying functions.

**Example:**  
```sql
SELECT COUNT(DISTINCT salary_currency) AS number_currencies FROM data_jobs;
```

DuckDB also allows aliasing when using built-in window functions:
```sql
SELECT ROW_NUMBER() OVER () AS row_id, * FROM data_jobs;
```

---

## Aggregates with Filtering

SQL aggregate functions (`COUNT`, `AVG`, `SUM`, `MEDIAN`, etc.) can be used with specific filters.

**Example:** Find salary stats for the whole table:
```sql
SELECT
    MIN(salary_in_usd) AS min_salary_usd,
    ROUND(AVG(salary_in_usd)) AS mean_salary_usd,
    MEDIAN(salary_in_usd) AS median_salary_usd,
    MAX(salary_in_usd) AS max_salary_usd
FROM data_jobs;
```

Count remote jobs and percentage:
```sql
SELECT
    COUNT(*) AS total_jobs,
    COUNT(*) FILTER (WHERE remote_ratio = 100) AS remote_jobs,
    ROUND(100.0 * COUNT(*) FILTER (WHERE remote_ratio = 100) / COUNT(*)) AS pct_remote_jobs
FROM data_jobs;
```

---

## Sorting with `ORDER BY`

Change the order of results with `ORDER BY`, asc or desc.  
Multiple sorting keys allowed.

**Examples:**
```sql
SELECT * FROM data_jobs ORDER BY salary_in_usd DESC;
```
Sort by salary descending, then by residence for tiebreaks:
```sql
SELECT * FROM data_jobs ORDER BY salary_in_usd DESC, employee_residence ASC;
```

---

## Practical Examples

- Find all Entry and Mid-level Data Analysts earning more than $100,000:
    ```sql
    SELECT *
    FROM data_jobs
    WHERE job_title = 'Data Analyst'
      AND experience_level IN ('EN', 'MI')
      AND salary_in_usd > 100000;
    ```

- Count unique job titles among fully-remote roles:
    ```sql
    SELECT COUNT(DISTINCT job_title) FROM data_jobs WHERE remote_ratio = 100;
    ```

- See the 10 highest-paying ML Engineer jobs in Canada:
    ```sql
    SELECT *
    FROM data_jobs
    WHERE job_title = 'Machine Learning Engineer' AND company_location = 'CA'
    ORDER BY salary_in_usd DESC
    LIMIT 10;
    ```

---

## References & Further Reading

- [DuckDB SQL: SELECT Clause](https://duckdb.org/docs/sql/select)
- [DuckDB SQL: WHERE Clause](https://duckdb.org/docs/sql/statements/select.html#where-clause)
- [DuckDB SQL: Aggregate Functions](https://duckdb.org/docs/sql/aggregates.html)
- [ORDER BY Documentation](https://duckdb.org/docs/sql/query_syntax/orderby)
- [DuckDB: Aliases and EXCLUDE](https://duckdb.org/docs/sql/select.html#column-selection)
- [Modern SQL: FILTER](https://modern-sql.com/feature/filter)

---