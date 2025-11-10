# 04 – Querying Data

This folder contains DuckDB scripts and CSV data used for querying and analysis.
- `data_jobs.duckdb` — main database file  
- `sql/` — SQL scripts for ingestion and querying  
- `data/` — raw data files (CSV)

## Ingest data
Create an account on kaggle and download this dataset on data engineering job salaries.

Use input redirection to read the SQL file and use it as input for duckdb database
```bash
duckdb data/salaries.duckdb < sql/ingest_salaries.sql
```
## Query clauses
clause	what it does
select	choose columns
from	identify tables to retrieve data
where	filter rows based on condition
group by	groups rows based on common value
having	filter groups
order by	sorts rows by column(s)

## From duckdb documentation
- select
https://duckdb.org/docs/stable/sql/query_syntax/select<br>
- aggregate functions
https://duckdb.org/docs/stable/sql/functions/aggregates<br>
- order by clause
https://duckdb.org/docs/stable/sql/query_syntax/orderby<br>
  
