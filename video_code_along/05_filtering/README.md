## Overview

Quick guide to filtering and basic data analysis in DuckDB with a jobs salary dataset.  
Covers common filtering techniques: `WHERE`, `IN`/`NOT IN` for lists, column aliases, filtered aggregates, calculating percentages, and skipping rows with `OFFSET`.  
Includes practical SQL code examples for immediate application.

## Project Structure

```
05_filtering/
    |- data/
        |- salaries.csv              # The dataset for exercises
    |- sql/
        |- ingest_salaries.sql       # Loads the data into DuckDB
        |- more_filters.sql          # Filtering SQL examples
README.md
```

## Dataset

**`data/salaries.csv`**  
A dataset containing salary data for data jobs in 2024.  
Columns include:

- `work_year`
- `experience_level` (e.g., EN=Entry, MI=Mid, SE=Senior, EX=Executive)
- `employment_type` (FT=Full Time, PT=Part Time, CT=Contract)
- `job_title`
- `salary` (local)
- `salary_currency`
- `salary_in_usd`
- `employee_residence`
- `remote_ratio` (0 = onsite, 50 = hybrid, 100 = remote)
- `company_location`
- `company_size` (S = small, M = medium, L = large)

## Key Filtering Concepts Illustrated

### 1. Basic Filtering with `WHERE`

The `WHERE` clause lets you filter rows based on conditions.

**Example:**  
Get all jobs for "Data Engineer":
```sql
SELECT * FROM data_jobs WHERE job_title = 'Data Engineer';
```

### 2. Filtering with `IN` and `NOT IN`

Filter for membership in a list of values.

**IN Example:**  
Get jobs that are either Data Engineer or Data Scientist:
```sql
SELECT * FROM data_jobs WHERE job_title IN ('Data Engineer', 'Data Scientist');
```

**NOT IN Example:**  
Count jobs _not_ at medium or small companies:
```sql
SELECT COUNT(*) FROM data_jobs WHERE company_size NOT IN ('S', 'M');
```

### 3. Counting and Aggregation with Filters

Counting rows matching conditions, possibly within groups.

**Example:**  
Count total jobs:

```sql
SELECT COUNT(*) AS total_jobs FROM data_jobs;
```

### 4. Advanced Filter Clauses (`FILTER`)

DuckDB (and some other SQL dialects) allow using `FILTER` with aggregate functions to count conditionally.

**Example:**  
Count jobs and how many are fully remote:
```sql
SELECT
    COUNT(*) AS total_jobs,
    COUNT(*) FILTER (WHERE remote_ratio = 100) AS remote_jobs
FROM data_jobs;
```

Or, calculate the percentage of remote jobs:
```sql
SELECT
    COUNT(*) AS total_jobs,
    COUNT(*) FILTER (WHERE remote_ratio = 100) AS remote_jobs,
    ROUND(100.0 * COUNT(*) FILTER (WHERE remote_ratio = 100) / COUNT(*)) AS percentage_remote_jobs
FROM data_jobs;
```

### 5. `OFFSET` (Skipping Rows)

To skip the first N rows of your result, use `OFFSET`.

**Example:**  
Skip the first 5 rows:
```sql
SELECT * FROM data_jobs OFFSET 5;
```

---

## Practical Examples

All of these examples can be found or adapted from the provided SQL scripts (`more_filters.sql`).

- **Find all Senior (SE) Data Engineers earning over \$150,000:**
    ```sql
    SELECT *
    FROM data_jobs
    WHERE experience_level = 'SE'
      AND job_title = 'Data Engineer'
      AND salary_in_usd > 150000;
    ```

- **How many large companies (L) offer remote jobs in the US?**
    ```sql
    SELECT COUNT(*)
    FROM data_jobs
    WHERE company_size = 'L' AND remote_ratio = 100 AND company_location = 'US';
    ```

- **List unique job titles that have remote roles:**
    ```sql
    SELECT DISTINCT job_title
    FROM data_jobs
    WHERE remote_ratio = 100;
    ```

---

## References & Further Reading

- [DuckDB SQL Reference - WHERE Statements](https://duckdb.org/docs/sql/statements/select.html#where-clause)
- [DuckDB SQL Reference - Aggregates and Filters](https://duckdb.org/docs/sql/aggregates.html#filter-clause)
- [Modern SQL: FILTER clause](https://modern-sql.com/feature/filter)
- [SQL OFFSET/FETCH documentation (DuckDB)](https://duckdb.org/docs/sql/select)