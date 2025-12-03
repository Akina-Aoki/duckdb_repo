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
# PART B — Sakila (SQLite attach) exercise — separate workflow
---------------------------------------------------------------------------------------------------

## Workflow diagram (Sakila)
1. Create the DuckDB file and load Sakila (run once):
```bash
duckdb sakila.duckdb < sql/01_load_sakila.sql
```

2. Open the database in the DuckDB CLI:
```bash
duckdb sakila.duckdb
```

3. Quick checks inside the CLI (examples shown in the exercise file):
```bash   
desc;
   SELECT * FROM film LIMIT 5;
```

4. Exit CLI and open the DuckDB UI (optional):
```bash
duckdb -ui sakila.duckdb
```

## Exercise highlights
### 4) Top 10 customers by number of rentals
- Why: join customer → rental, group by customer, count rentals and sort. Shows most active customers.
```sql
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS rental_count
FROM
    customer c
    JOIN rental r ON c.customer_id = r.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY
    rental_count DESC
LIMIT
    10;
```
- Notes: Use COUNT(r.rental_id) to count only actual rental rows.

### 5) List all customers and the films they rented (multi-join)
- Why: demonstrates joining across multiple foreign keys: customer → rental → inventory → film to get titles per rental.
```sql
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    r.rental_id,
    r.rental_date,
    f.film_id,
    f.title
FROM
    customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY
    c.customer_id, r.rental_date;
```
- Notes: If you only want distinct customer–film pairs, add DISTINCT f.film_id, f.title or GROUP BY those columns.

### 6) Top 5 most rented films
- Why: join film → inventory → rental, then aggregate rentals per film to rank them.
```sql
SELECT
    f.film_id,
    f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id 
GROUP BY f.film_id, f.title
ORDER BY COUNT(r.rental_id) DESC
LIMIT 5;
```
- Notes: This counts each rental row (rental_id) — multiple inventory copies of the same film are aggregated correctly by grouping by film_id.

### 7) Cities and countries where customers live (with counts)
- Why: follow foreign keys customer → address → city → country to get location info and counts per city.
```sql
-- Distinct city/country pairs
SELECT DISTINCT
    ci.city AS city_name,
    co.country AS country_name
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
ORDER BY co.country, ci.city;

-- Counts per city/country
SELECT
    ci.city AS city_name,
    co.country AS country_name,
    COUNT(*) AS customer_count
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY co.country, ci.city
ORDER BY customer_count DESC;
```
- Notes: The first query lists unique locations; the second ranks cities by number of customers.

## References
- [SQL Set Operations](https://www.youtube.com/watch?v=LUSPRn2zxSo)
- [SQLITE Database in Duckdb](https://motherduck.com/blog/analyze-sqlite-databases-duckdb/)
- [Set Operations DuckDB](https://duckdb.org/docs/stable/sql/query_syntax/setops)
