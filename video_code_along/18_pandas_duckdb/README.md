# pandas + DuckDB (video_code_along/18_pandas_duckdb) — Workflow

This document explains the intended workflow for the video_code_along/18_pandas_duckdb folder: how to prepare the Sakila sample data, load it into DuckDB, work with it from pandas, and reproduce the example EDA shown in the notebook.

## Purpose
Demonstrate how to combine pandas and DuckDB:
- Ingest an existing SQLite "Sakila" sample database into DuckDB.
- Read DuckDB tables into pandas DataFrames.
- Register pandas DataFrames back into DuckDB for SQL joins and analysis.
- Do EDA with a combination of SQL (DuckDB) and pandas.

## Files (what's in this folder)
📂 project-root/
├── 📁 data/
│   ├── README.txt                # Provenance notes for the Sakila dataset
│   └── sqlite-sakila.db          # Source SQLite database (local only, not tracked)
│
├── 📁 sql/
│   └── load_sakila.sql           # Extension install + SQLite attach workflow
│
├── duckdb_pandas.ipynb           # E2E pipeline: DB build, ingestion, EDA, DF registration
├── pyproject.toml                # Environment contract (DuckDB, pandas, matplotlib, IPykernel)
│
└── README.md                     # Solution overview, architecture notes, usage guidelines


---

## Prerequisites
- Python >= 3.12 (per pyproject.toml) — adjust if needed.
- Recommended: virtual environment (venv, tox, or poetry).
- Packages required (examples below install them directly):
  - duckdb
  - pandas
  - matplotlib
  - ipykernel
  - jupyterlab or notebook (if you want interactive notebook)

Install example (pip):
**Refer to Kokchun's video since I am not using pip install, instead I am using `uv add` of the packages.


---

## High-level workflow (commands & steps)

1. Prepare the SQLite Sakila DB
   - The folder includes `data/README.txt` describing the origin. If `data/sqlite-sakila.db` is not present, create it by running the sqlite scripts (if available) or download a ported copy:
     - From repository copies like `ivanceras/sakila` or `ivanceras` ports, or a pre-built sqlite file from the original project.
   - If you have the schema & insert scripts in a `sqlite-sakila-db` subfolder, create the DB:
     ```sql
     sqlite> .open sqlite-sakila.db
     sqlite> .read sqlite-sakila-schema.sql
     sqlite> .read sqlite-sakila-insert-data.sql
     ```
   - Place the resulting `sqlite-sakila.db` under `video_code_along/18_pandas_duckdb/data/` (path used in the repo).

2. Ingest the SQLite Sakila into a DuckDB file
   - Option A — Use the DuckDB CLI:
     ```bash
     # from repository root
     duckdb data/sakila.duckdb < sql/load_sakila.sql
     ```
     This will create `data/sakila.duckdb` and attach `data/sqlite-sakila.db` for reading.
   - Option B — Use the included notebook (recommended for following the tutorial):
     - Launch Jupyter and open `duckdb_pandas.ipynb`.
     - The notebook runs a Python cell that:
       - removes any existing `data/sakila.duckdb` (Path(...).unlink(missing_ok=True))
       - connects to DuckDB and executes the contents of `sql/load_sakila.sql` (which runs `INSTALL sqlite; LOAD sqlite;` and `CALL sqlite_attach('data/sqlite-sakila.db')`).
     - Running that cell produces a DuckDB database and exposes the Sakila tables to DuckDB.

3. Load tables into pandas DataFrames
   - The notebook runs:
     - `description = conn.sql("DESC;").df()` to list tables and their columns.
     - Then loops through table names and runs `conn.sql(f"FROM {name};").df()` to fetch each table into a pandas DataFrame stored in a dict `dfs`.
   - Example snippet (from notebook):
     ```python
     dfs = {}
     with duckdb.connect(duckdb_path) as conn:
         for name in description["name"]:
             dfs[name] = conn.sql(f"FROM {name};").df()
     ```

4. Register pandas DataFrames back to DuckDB and run SQL joins
   - Register DataFrames as temporary DuckDB relations:
     ```python
     import duckdb
     duckdb.register("film", dfs["film"])
     duckdb.register("actor", dfs["actor"])
     # ...
     ```
   - Then run complex joins in SQL (clear and concise) and convert results to pandas:
     ```sql
     SELECT a.first_name || ' ' || a.last_name AS actor,
            a.actor_id::INT AS actor_id,
            f.title,
            f.description,
            f.release_year,
            f.rental_duration,
            f.rating,
            c.name AS category
     FROM film f
       LEFT JOIN film_actor fa ON f.film_id = fa.film_id
       LEFT JOIN actor a ON a.actor_id = fa.actor_id
       LEFT JOIN film_category fc ON fc.film_id = f.film_id
       LEFT JOIN category c ON fc.category_id = c.category_id
     ```
     The notebook shows using `duckdb.sql(...).df()` to get the joined result into pandas for EDA.


