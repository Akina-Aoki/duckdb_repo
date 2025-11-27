# Set Operations Study Notes

Repository file tree (relevant files)
```
video_code_along/11_set_operations/
├─ .gitignore
├─ data/
│  ├─ README.txt
│  └─ sqlite-sakila-db/
│     ├─ ReadME.txt
│     ├─ sqlite-sakila-delete-data.sql
│     ├─ sqlite-sakila-drop-objects.sql
│     ├─ sqlite-sakila-insert-data.sql
│     ├─ sqlite-sakila-schema.sql
│     └─ sqlite-sakila.db
├─ sql/
│  ├─ synthetic_data.sql     <-- create synthetic.sales_* and synthetic.products
│  ├─ set_op.sql             <-- set-operation examples (UNION, INTERSECT, EXCEPT)
│  └─ 01_load_sakila.sql     <-- installs sqlite ext & calls sqlite_attach(...)
└─ README.md                 <-- you are reading this
```

---------------------------------------------------------------------------------------------------
PART A — Synthetic-data exercise (create synthetic schema + run set-ops)
---------------------------------------------------------------------------------------------------

Workflow diagram (synthetic)
```
[sql/synthetic_data.sql]  -->  creates DuckDB file (set_operations.duckdb)
                              and populates schema synthetic.*
                                  |
                                  v
                          [Run examples in sql/set_op.sql]
                                  |
                                  v
                          Verify queries & try variations
```

Step-by-step (run from repo root)

1) Create a DuckDB file and populate synthetic tables:

```bash
duckdb set_operations.duckdb < sql/synthetic_data.sql
```

2) Optional: open interactive DuckDB CLI to inspect:

```bash
duckdb set_operations.duckdb
```

Inside the CLI, run these verification queries:

```sql
-- list schemas
SELECT schema_name FROM information_schema.schemata;

-- quick preview of created tables
SELECT * FROM synthetic.sales_jan LIMIT 5;
SELECT * FROM synthetic.sales_feb LIMIT 5;
SELECT * FROM synthetic.products LIMIT 5;
```

Exit the CLI with:
```
.exit
```

3) Run the set-operations examples (non-interactive):

```bash
duckdb set_operations.duckdb < sql/set_op.sql
```

Or open the DB in the DuckDB UI:

```bash
duckdb-ui set_operations.duckdb
```

Key SQL examples to try (copy into the CLI or into set_op.sql):

```sql
-- UNION (deduplicates)
SELECT product_name, amount FROM synthetic.sales_jan
UNION
SELECT product_name, amount FROM synthetic.sales_feb;

-- UNION ALL (keeps duplicates)
SELECT product_name, amount FROM synthetic.sales_jan
UNION ALL
SELECT product_name, amount FROM synthetic.sales_feb;

-- INTERSECT (rows common to both)
SELECT product_name, amount FROM synthetic.sales_jan
INTERSECT
SELECT product_name, amount FROM synthetic.sales_feb;

-- EXCEPT (in jan but not in feb)
SELECT product_name, amount FROM synthetic.sales_jan
EXCEPT
SELECT product_name, amount FROM synthetic.sales_feb;
```

---------------------------------------------------------------------------------------------------
PART B — Sakila (SQLite attach) exercise — separate workflow
---------------------------------------------------------------------------------------------------

Workflow diagram (Sakila)
```
Option A: Automated attach
[sql/01_load_sakila.sql]  --> duckdb sakila.duckdb < 01_load_sakila.sql
                                (INSTALL sqlite; LOAD sqlite; CALL sqlite_attach(...))
                                    |
                                    v
                            sqlite.* tables available in session

Option B: Manual attach (interactive)
duckdb sakila.duckdb
  -> INSTALL sqlite; LOAD sqlite;
  -> CALL sqlite_attach('path/to/sqlite-sakila.db');
```

Attaching the Sakila SQLite DB in `sql/01_load_sakila.sql`
```sql
-- Install and load the sqlite extension, then attach the Sakila DB.
-- If the relative path is wrong, replace with an absolute path.
INSTALL sqlite;
LOAD sqlite;
CALL sqlite_attach('data/sqlite-sakila-db/sqlite-sakila.db');
```


Automated attempt (recommended):

```bash
duckdb sakila.duckdb < sql/01_load_sakila.sql
```

If that fails, do the manual attach:

```bash
duckdb sakila.duckdb
```

Inside DuckDB CLI:

```sql
INSTALL sqlite;
LOAD sqlite;

-- adjust path to the sqlite file if needed
CALL sqlite_attach('data/sqlite-sakila-db/sqlite-sakila.db');
```

Verification queries

```sql
-- List schemas (you should see an attached sqlite schema or attached objects)
SELECT schema_name FROM information_schema.schemata;

-- If the attach maps objects into 'sqlite' schema, inspect tables:
SELECT table_schema, table_name FROM information_schema.tables WHERE table_schema = 'sqlite';

-- Or query known tables:
SELECT * FROM sqlite.film LIMIT 5;
SELECT * FROM sqlite.actor ORDER BY actor_id LIMIT 5;
```

Alternate verification if sqlite_master is exposed:

```sql
SELECT name, type FROM sqlite.sqlite_master WHERE type='table' LIMIT 20;
```

## References
[SQL Set Operations]: https://www.youtube.com/watch?v=LUSPRn2zxSo
[SQLITE Database in Duckdb]: https://motherduck.com/blog/analyze-sqlite-databases-duckdb/
[Set Operations Duckdb]: https://duckdb.org/docs/stable/sql/query_syntax/setops