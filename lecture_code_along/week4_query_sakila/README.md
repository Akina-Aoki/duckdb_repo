#### When thr jupyter notebook brokedown, ran this in the terminal
git reset --hard HEAD
git pull

# Sakila + DuckDB + pandas — Step-by-step beginner guide

This guide explains how the notebook in the repository ingests the Sakila SQLite database into DuckDB, loads data into pandas, registers DataFrames in DuckDB, and performs basic EDA. It includes copy‑pasteable code snippets you can run in a Jupyter notebook.

Short roadmap
- Prerequisites: install duckdb and have the Sakila sqlite file ready.
- Use the SQL script (`sql/load_sakila.sql`) to attach the sqlite Sakila DB inside a DuckDB session.
- From Python, run that SQL to create/use a DuckDB file and read tables into pandas DataFrames.
- Register pandas DataFrames in DuckDB so you can run SQL on them (clean joins + analytics).
- Do EDA using a combination of DuckDB SQL and pandas (and optional plotting with seaborn/matplotlib).

---
## Mapping tasks
- Task 0 (data ingestion): the notebook demonstrates how to attach the sqlite file and create `data/sakila.duckdb`. Copying selected tables into DuckDB makes the ingestion persistent.
- Task 1 (EDA in Python): Use DuckDB SQL for joins/aggregations, and convert to pandas DataFrames for visualization and downstream analysis. Put your EDA cells, code, and plots into a Jupyter notebook as deliverables.

---

## Short checklist to follow
1. pip install duckdb pandas matplotlib seaborn  
2. Put `sqlite-sakila.db` at `data/sqlite-sakila.db`  
3. Run the notebook `18_pandas_duckdb/duckdb_pandas.ipynb` or create a new notebook with:
   - create DuckDB file + run `sql/load_sakila.sql`
   - `conn.sql("DESC;").df()` — see tables
   - loop to read tables into `dfs` dict
   - `duckdb.register(...)` for tables you will query
   - run SQL joins, call `.df()` to return pandas DataFrames
   - do groupbys, plots, and export CSVs  
4. Save the notebook with your EDA results and explanations for the manager.


## 1) Prerequisites (what to install and files to have)
- Install packages:
```bash
uv init
```

```bash
uv add duckdb pandas matplotlib
```
- Place the Sakila SQLite file at `data/sqlite-sakila.db` (the notebook expects that path). If you don't have it, download the Sakila sqlite DB from Kaggle or the course materials.
- Files included in the course repo you saw:
  - `sql/load_sakila.sql` — SQL to INSTALL/LOAD sqlite and attach the sqlite file
  - `18_pandas_duckdb/duckdb_pandas.ipynb` — example notebook with ingestion + EDA

---

## 2) What `load_sakila.sql` does
Contents:
```sql
INSTALL sqlite;
LOAD sqlite;
CALL sqlite_attach (
    'data/sqlite-sakila.db'
);
```

- `INSTALL sqlite;` → tells DuckDB to download/install the sqlite extension.
- `LOAD sqlite;` → loads that extension into the session.
- `CALL sqlite_attach('data/sqlite-sakila.db');` → attaches the SQLite file to DuckDB so you can query its tables.

Why: DuckDB can access sqlite tables directly after the attach, so you can query them with DuckDB SQL.

---

## 3) How the notebook creates a DuckDB database and ingests the data (annotated)
This pattern appears in the notebook. Each step is annotated so it’s clear what happens.

### a) Create (or overwrite) a DuckDB file and connect:
```python
import duckdb
from pathlib import Path

duckdb_path = "data/sakila.duckdb"
# delete any existing file so we start fresh
Path(duckdb_path).unlink(missing_ok=True)
```
- Creates a DuckDB file at `data/sakila.duckdb`. DuckDB will persist metadata and any created tables there.

### b) Execute the SQL ingestion script:
```python
with duckdb.connect(duckdb_path) as conn, open("sql/load_sakila.sql") as ingest_script:
    conn.sql(ingest_script.read())
```
- Runs the `load_sakila.sql` script within the DuckDB file. After this, DuckDB has access to the sqlite tables.

### c) Inspect available tables:
```python
description = conn.sql("DESC;").df()
# `description` is a pandas DataFrame listing tables and their columns
```
- `DESC;` returns metadata and `.df()` converts it to a pandas DataFrame.

### d) Read a table directly into pandas:
```python
films = conn.sql("FROM film;").df()
```
- Equivalent to `SELECT * FROM film;` and returns a pandas DataFrame.

---

## 4) Load all tables into a dictionary of pandas DataFrames
A convenient way to work with the whole dataset:
```python
dfs = {}
for name in description["name"]:
    dfs[name] = conn.sql(f"FROM {name};").df()
# `dfs` maps table_name -> pandas.DataFrame
```
- You can access `dfs["film"]`, `dfs["actor"]`, etc.

Why store them in pandas?
- Use pandas functions, visualize with plotting libraries, or apply ML/DataFrame workflows.

---

## 5) Register pandas DataFrames in DuckDB for SQL operations
DuckDB can query pandas DataFrames when registered:
```python
film_names = ("film", "film_actor", "film_category", "actor", "category")

for film_name in film_names:
    duckdb.register(film_name, dfs[film_name])
# Now SQL can reference 'film', 'actor', etc. as in-memory tables
```
Why register?
- DuckDB SQL is often more concise/readable for joins and complex aggregations than equivalent pandas code.
- Registered DataFrames are available for queries in the current process.

---

## 6) Example join — do joins in SQL and return to pandas
A multi-table join as used in the notebook:
```python
films_joined = duckdb.sql("""
    SELECT
        a.first_name || ' ' || a.last_name AS actor,
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
""").df()
```
- This yields a pandas DataFrame `films_joined` with rows combining actor, film, and category info — ready for EDA.

---

## 7) EDA ideas & copy‑paste code (beginner-friendly)
Examples combine DuckDB SQL with pandas and plotting.

a) Count films per category:
```python
q = """
SELECT category, COUNT(DISTINCT f.film_id) AS films
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY category
ORDER BY films DESC
"""
films_per_category = duckdb.sql(q).df()
print(films_per_category)
```

b) Top 10 actors by number of films:
```python
q = """
SELECT a.first_name || ' ' || a.last_name AS actor,
       COUNT(*) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY actor
ORDER BY film_count DESC
LIMIT 10
"""
top_actors = duckdb.sql(q).df()
print(top_actors)
```

c) Average rental rate per rating (G, PG, R, …):
```python
q = """
SELECT rating, AVG(rental_rate) AS avg_rental
FROM film
GROUP BY rating
ORDER BY avg_rental DESC
"""
avg_rental_by_rating = duckdb.sql(q).df()
print(avg_rental_by_rating)
```

d) Revenue by customer:
```python
q = """
SELECT p.customer_id, c.first_name || ' ' || c.last_name AS customer,
       SUM(p.amount) AS total_paid
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
GROUP BY p.customer_id, customer
ORDER BY total_paid DESC
LIMIT 20
"""
top_customers = duckdb.sql(q).df()
print(top_customers)
```

e) Quick plotting with pandas:
```python
import seaborn as sns
import matplotlib.pyplot as plt

# Barplot: films per category
sns.barplot(data=films_per_category, x="films", y="category")
plt.title("Films per category")
plt.show()
```

---

## 8) Save results or persist tables
- Save DataFrame to CSV:
```python
films_per_category.to_csv("out/films_per_category.csv", index=False)
```
- Persist joined table into the DuckDB file:
```python
with duckdb.connect(duckdb_path) as conn:
    conn.register("films_joined", films_joined)
    conn.sql("CREATE TABLE films_joined_persist AS SELECT * FROM films_joined")
```

---



