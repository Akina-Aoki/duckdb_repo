# Week 3: Beginner Guide: Validate CRM Data with DuckDB

## Purpose
- Validate data quality of two CRM exports.
- Compare records between old and new CRM systems.
- Produce a discrepancy report for records that need follow-up.

## Important notes (key concepts)
- Constraints: use CHECK, NOT NULL, UNIQUE to enforce column-level rules.
- Compound queries: use UNION, EXCEPT, INTERSECT to compare datasets.
- Set operations: EXCEPT = difference, INTERSECT = intersection, UNION = union.
- Staging -> Constrained: ingest raw CSV into a staging schema, inspect and clean, then insert valid rows into a constrained schema.

## Files and purpose

| Path | Type | Purpose |
|---|---:|---|
| lecture_code_along/week3_validate_crmdata/data/crm_new.csv | CSV | New CRM system export (raw). Loaded into staging.crm_new |
| lecture_code_along/week3_validate_crmdata/data/crm_old.csv | CSV | Old CRM system export (raw). Loaded into staging.crm_old |
| lecture_code_along/week3_validate_crmdata/sql/create.sql | SQL | Lecture SQL: staging and constrained examples |
| lecture_code_along/week3_validate_crmdata/sql/create2.sql | SQL | Alternative SQL: crm_all and beginner-friendly discrepancy report |
| lecture_code_along/week3_validate_crmdata/README.md | Markdown | Exercise instructions |
| lecture_code_along/week3_validate_crmdata/BEGINNER_GUIDE.md | Markdown | Beginner friendly documentation (this file) |


## Workflow diagram
| Step | Action |
|---|---|
| ingest | create staging schema; load crm_new.csv and crm_old.csv into staging tables |
| inspect | find invalid emails, regions, and statuses in staging |
| constrain | create constrained schema; define column constraints; insert valid rows |
| compare | use EXCEPT / INTERSECT to find only_in_old, only_in_new, and common customers |
| report | build discrepancy report by UNION of subqueries |


## Setup and ingestion (DuckDB UI or CLI)
- Launch DuckDB from repository root so relative paths work.
- Create staging schema and load CSVs with read_csv_auto().

Example commands:
```sql
CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.crm_new AS
SELECT *
FROM read_csv_auto('lecture_code_along/week3_validate_crmdata/data/crm_new.csv');

CREATE TABLE IF NOT EXISTS staging.crm_old AS
SELECT *
FROM read_csv_auto('lecture_code_along/week3_validate_crmdata/data/crm_old.csv');

-- Quick check
SELECT COUNT(*) AS rows_new FROM staging.crm_new;
SELECT COUNT(*) AS rows_old FROM staging.crm_old;
```

### Data quality rules (used for validation)
1. email must contain '@' and later a '.'  
2. region must be 'EU' or 'US'  
3. status must be 'active' or 'inactive'

### Task: Find invalid records
- Crude LIKE check for simple email rule:
```sql
SELECT *
FROM staging.crm_new
WHERE email NOT LIKE '%@%.%';
```

###  Regex check for stricter email validation:
```sql
SELECT *
FROM staging.crm_new
WHERE NOT regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+');
```

### Combine all three rules in one WHERE clause:
```sql
SELECT *
FROM staging.crm_new
WHERE NOT regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+')
  OR region NOT IN ('EU','US')
  OR status NOT IN ('active','inactive');
```

### Task: Create constrained schema and insert valid rows
- Create constrained schema and tables with CHECK constraints, then insert valid rows from staging.

Example:
```sql
CREATE SCHEMA IF NOT EXISTS constrained;

CREATE TABLE IF NOT EXISTS constrained.crm_new (
  customer_id INTEGER UNIQUE,
  name VARCHAR NOT NULL,
  email VARCHAR CHECK (regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+')),
  region VARCHAR CHECK (region IN ('EU','US')),
  status VARCHAR CHECK (status IN ('active','inactive'))
);

CREATE TABLE IF NOT EXISTS constrained.crm_old (
  customer_id INTEGER UNIQUE,
  name VARCHAR NOT NULL,
  email VARCHAR CHECK (email LIKE '%@%.%'),
  region VARCHAR CHECK (region IN ('EU','US')),
  status VARCHAR CHECK (status IN ('active','inactive'))
);

INSERT INTO constrained.crm_new
SELECT *
FROM staging.crm_new
WHERE regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+')
  AND region IN ('EU','US')
  AND status IN ('active','inactive');

INSERT INTO constrained.crm_old
SELECT *
FROM staging.crm_old
WHERE regexp_matches(email, '[A-Za-z0-9]+@[A-Za-z]+\.[A-Za-z]+')
  AND region IN ('EU','US')
  AND status IN ('active','inactive');
```

### Task: Compare systems (customer_id as unique identifier)
- Customers only in old system:
```sql
SELECT customer_id
FROM staging.crm_old
EXCEPT
SELECT customer_id
FROM staging.crm_new;
```

- Customers only in new system:
```sql
SELECT customer_id
FROM staging.crm_new
EXCEPT
SELECT customer_id
FROM staging.crm_old;
```

- Customers in both systems:
```sql
SELECT customer_id
FROM staging.crm_new
INTERSECT
SELECT customer_id
FROM staging.crm_old;
```

### Task: Discrepancy report 
- Four subqueries combined with UNION:
  - only_in_old: full rows only in old
  - only_in_new: full rows only in new
  - invalid_old: rows in old violating rules
  - invalid_new: rows in new violating rules

Example report:
```sql
SELECT
  'only_in_old' AS issue,
  customer_id, name, email, region, status
FROM staging.crm_old
WHERE customer_id IN (
  SELECT customer_id FROM staging.crm_old
  EXCEPT
  SELECT customer_id FROM staging.crm_new
)

UNION

SELECT
  'only_in_new' AS issue,
  customer_id, name, email, region, status
FROM staging.crm_new
WHERE customer_id IN (
  SELECT customer_id FROM staging.crm_new
  EXCEPT
  SELECT customer_id FROM staging.crm_old
)

UNION

SELECT
  'invalid_old' AS issue,
  customer_id, name, email, region, status
FROM staging.crm_old
WHERE NOT (
  email LIKE '%@%.%' AND
  region IN ('EU','US') AND
  status IN ('active','inactive')
)

UNION

SELECT
  'invalid_new' AS issue,
  customer_id, name, email, region, status
FROM staging.crm_new
WHERE NOT (
  email LIKE '%@%.%' AND
  region IN ('EU','US') AND
  status IN ('active','inactive')
)

ORDER BY issue, customer_id;
```