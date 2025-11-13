# DuckDB Ingestion Pipeline — Learning Log & Repeatable Playbook

A reusable operational workflow for loading CSV assets into DuckDB with zero surprises.

This workflow documents how I successfully ingested multiple bike-data CSV files into DuckDB using a dedicated staging schema. It also captures the pitfalls, execution risks, and guardrails I need to remember for future projects.

**The goal is simple: create a predictable ingestion pipeline that always lands data where I expect it, with clean schemas and no UI confusion.**

## 1. Core Idea

DuckDB loads data relative to the folder I’m currently in, not the folder where the files actually live. If I don’t run commands inside the correct working directory, DuckDB silently skips ingestion and no schema is created.

So the mission is maintaining execution alignment between:

- The .duckdb database file

- The data/ folder containing CSVs

- The sql/ folder containing ingestion scripts

- The CLI/UI session

When these four elements point to the same location, the pipeline runs cleanly.

## 2.  Required Project Structure

This structure is the backbone of the workflow:
```pqsql
project/
│
├── bike_data.duckdb
├── data/
│     ├── brands.csv
│     ├── customers.csv
│     ├── …
│
└── sql/
      └── ingest_bike.sql
```

If this structure is not aligned with my working directory, ingestion won’t behave.

## 3. Execution Workflow (The Playbook)
### Step 1 — Navigate into the correct directory

This ensures DuckDB can resolve the CSV paths.
```bash
cd ~/path/to/project/
ls
```

I must see:
```kotlin
data
sql
bike_data.duckdb (optional)
```
If I don’t see all three → I'm in the wrong folder.

### Step 2 — Execute the ingestion script

This creates the staging schema and loads all CSVs.

```pqsql
duckdb bike_data.duckdb < sql/ingest_bike.sql
```
This guarantees ingestion runs inside the intended database file.

### Step 3 — Open DuckDB UI from the same folder
```nginx
duckdb bike_data.duckdb -ui
```

### Step 4 — Validate that schema creation worked
```sql
SELECT schema_name FROM information_schema.schemata;
```

```pgsql
Expected:
main
staging
information_schema
pg_catalog
```


If staging is missing → ingestion never executed in this database file.

### Step 5 — Validate that tables were created
``` sql
SELECT table_schema, table_name
FROM information_schema.tables
ORDER BY table_schema, table_name;
```
Expect the number pf files under `staging`

### Step 6 — Validate row ingestion
If it returns a number > 0, data landed correctly.
```sql
SELECT COUNT(*) FROM staging.brands;
```

## 4. Common Pitfalls to Avoid
### 1. Running DuckDB from the wrong folder

The biggest source of confusion.
Relative paths break, tables load empty, schema doesn’t appear.

### 2. Expecting the UI to show everything

The left panel in DuckDB UI is not the source-of-truth.
Always verify through:

``information_schema.schemata`

`information_schema.tables`

`COUNT(*)`

### 3. Missing semicolons in SQL scripts

DuckDB executes only the first valid statement without complaint.

### 4. Using “duckdb -ui” on an empty or unintended DB file

This creates an empty transient database with no schemas.

### 5. Forgetting CSV paths are relative

If my script says:

`read_csv_auto('data/brands.csv')`


…it only works if the CLI is launched from a directory where ./data/ actually exists.

## 5. Lessons Learned

Schema creation is not the issue — execution context is.

DuckDB is silent when paths are wrong, so visibility checks are critical.

Once everything is aligned, DuckDB is extremely efficient and fast.

Building a repeatable “staging ingestion” workflow is core Data Engineering muscle memory.

This process will repeat in nearly every project: Kaggle datasets, ETL prototypes, personal pipelines, or production-style workloads in your portfolio.