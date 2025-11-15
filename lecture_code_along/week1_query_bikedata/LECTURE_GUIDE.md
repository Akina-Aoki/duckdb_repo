# Week 1 Lecture 1
## Bike.duckdb join concept illustration and figure
**After Joining the tables: Concept of o and oi**
**“Match each order with its related order items, using the order_id as the link.”**
```sql
SELECT *
FROM staging.orders o -- base on this table, "o" means alias, no need to provide alias when using "o"
LEFT JOIN staging.order_items oi ON o.order_id = oi.order_id
```

- `o` is just a short nickname (alias) for the table "staging.order"
- `oi` is a nickname for the table "staging.order_items"
- `o.order_id = oi.order_id` tells SQL how the two tables are connected
- `LEFT JOIN` means “keep all rows from o (order) even if no matching items exist in oi (order_items)
- In human terms:
Keep every order, and attach the items that belong to each order. If an order has no items, still show the order, the item fields will just be empty.

```yaml
 
   ┌──────────────────────────┐       ┌──────────────────────────┐
   │        o (orders)        │ LEFT  │      oi (order_items)    │
   └──────────────────────────┘  JOIN └──────────────────────────┘
        order_id | customer            order_id | item_name
        ----------+---------            ----------+-----------
           1      |  A                     1      |  Shirt
           2      |  B                     1      |  Shoes
           3      |  C                     2      |  Hat
           4      |  D                     5      |  Keyboard
```

<br>
## Result:

```yaml
┌───────────┬───────────┬──────────┐
│ order_id  │ customer  │ item     │
├───────────┼───────────┼──────────┤
│     1     │    A      │ Shirt    │
│     1     │    A      │ Shoes    │
│     2     │    B      │ Hat      │
│     3     │    C      │ NULL     │   ← no matching item
│     4     │    D      │ NULL     │   ← no matching item
```

## Summary:
**The unique key is order_id from the orders table (o).**

That’s the stable, one-row-per-order identifier.

The relationship looks like this:

`orders` (o) → one row per order

`order_items` (oi) → many rows per order_id (because an order can have multiple items)

So the “unique table” is the `orders` table.

It’s the left table.
**It’s the parent.**
It’s the one that must keep all its rows.

**`order_items` is the child table.`**

It repeats the same order_id for multiple items.
---------------------------------------------------------

# Week 1 Lecture 2:

## Bike Data (DuckDB) — Lecture notes & step-by-step

This document explains, step-by-step, how I set up the repository, ingested the bike CSV files into DuckDB, launched the DuckDB UI, and ran the example queries used in the lecture. I also note a few corrections and gotchas that I discovered while working through the SQL files in this folder.

**Summary flow:**
place CSVs in `data/` -> run ingestion SQL(s) to create `.duckdb` file -> open UI -> run queries from `query_bike.sql`.

Below is a more detailed walkthrough and explanations to re-run this lecture end-to-end.


## 1. Repo & folder setup (what I did)
- Created a week 1 folder and added two folders at the lecture level:
  - `data/` — put the CSV files here (9 CSVs + `joined_table.csv` for lecture).
  - `sql/` — placed all SQL scripts used in lecture:
    - `create_table.sql`
    - `ingest_bike.sql`
    - `ingest_bike_join.sql`
    - `join_tables.sql`
    - `query_bike.sql`
    - this `README.md`

- Downloaded the 9 CSV files from the Kaggle dataset used in class, plus a `joined_table.csv` already prepared for the lecture. Put all CSVs in `data/`.

**Notes:**
- I keep CSVs as-is in `data/`.
- When running DuckDB, paths in SQL are evaluated relative to the directory where to run the DuckDB command (i.e. current working directory). See the "Paths & working directory" note below.

## 2. Tools & prerequisites

- DuckDB CLI (install via package manager, pip, or from duckdb.org)
    - pip: `pip install duckdb` in VSCode (This is done first in the DuckDB Set up, also available in the beginning of this repo)
    - running all CLI in the VSCode terminal

## 3. Paths & working directory gotcha

- All SQL scripts use relative paths like `data/...` or `../data`. These are resolved relative to where to run the DuckDB command.
  - If run `duckdb bike_joined.duckdb < sql/ingest_bike_join.sql` from the repo root:
    - `sql/ingest_bike_join.sql` will be loaded, and `data/...` resolves to `./data/...`
  - If a script uses `../data` (like `create_table.sql`), that expects the SQL to be executed from inside `sql/` directory (because `../data` points to the sibling `data/`).
- Recommendation: run everything from the repo root and use `data/...` in SQL, or be consistent.

## 4.  Ingestion SQLs (what each file does and how to run them)

### A. create_table.sql
- **Purpose**: Demonstrate how to create a table directly from CSV(s).
- Key SQL:
  ```sql
  CREATE TABLE IF NOT EXISTS bike_data AS (
    SELECT *
    FROM read_csv_auto('../data')
  );
  ```
- **Notes**:
  - `read_csv_auto` infers the CSV schema automatically.
  - Using `read_csv_auto('../data')` will behave differently depending on working directory: if run the SQL from `sql/` (e.g., `duckdb db.duckdb < create_table.sql` while in the `sql/` directory), `../data` points to the repo `data/` directory. If run from repo root, update to `read_csv_auto('data/<file>.csv')` or use `read_csv_auto('data')` intentionally.
  - In practice, for predictable ingestion, I prefer to specify explicit file paths like `read_csv_auto('data/orders.csv')` when creating individual staging tables.

### B. ingest_bike.sql
- **Purpose**: Create a `staging` schema and ingest the nine CSV files as separate staging tables (one CSV = one table).
- **Tables created**:
  - staging.brands
  - staging.categories
  - staging.customers
  - staging.order_items
  - staging.orders
  - staging.products
  - staging.staffs
  - staging.stocks
  - staging.stores
- **Key pattern used**:
  ```sql
  CREATE SCHEMA IF NOT EXISTS staging;

  CREATE TABLE IF NOT EXISTS staging.brands AS (
    SELECT * FROM read_csv_auto('data/brands.csv')
  );
  ```
- **How to run (from repo root)**:
  - `duckdb bike.duckdb < sql/ingest_bike.sql`
  - This will create (or open) `bike.duckdb` and create the staging schema + tables inside it.

### C. ingest_bike_join.sql
- **Purpose**: Create a single staging table named `staging.joined_table` from a prepared `joined_table.csv` that already contains all joined fields.
- SQL used:
  ```sql
  CREATE SCHEMA IF NOT EXISTS staging;

  CREATE TABLE IF NOT EXISTS staging.joined_table AS (
    SELECT * FROM read_csv_auto('data/joined_table.csv')
  );
  ```
- **How to run**:
  - `duckdb bike_joined.duckdb < sql/ingest_bike_join.sql`
  - This creates `bike_joined.duckdb` with `staging.joined_table` inside.


## 5. DuckDB CLI & UI commands (what I ran)

From the repo root:

### 1. Ingest the prepared joined_table into a new DuckDB file:
   - `duckdb bike_joined.duckdb < sql/ingest_bike_join.sql`
   - Explanation: This opens (or creates) `bike_joined.duckdb` and executes the SQL in `sql/ingest_bike_join.sql`. The `staging.joined_table` table will be created inside `bike_joined.duckdb`.

### 2. Launch the DuckDB UI (interactive web-based UI):
   - `duckdb bike_joined.duckdb -ui`
   - Explanation: Opens a browser UI at a local address where you can run SQL interactively and browse tables and schemas.

### 3. Alternative (non-UI interactive shell):
   - `duckdb bike_joined.duckdb`
   - Then at the duckdb prompt, run SQL lines and commands like `SELECT * FROM staging.joined_table LIMIT 10;`

Notes:
- If used `ingest_bike.sql` instead, run:
  - `duckdb bike.duckdb < sql/ingest_bike.sql`
  - then `duckdb bike.duckdb -ui`


## 6. Querying (what `query_bike.sql` covers)

`query_bike.sql` is a collection of example queries to inspect and analyze `staging.joined_table`.
Explanation available in the sql file itself.

## 7.  The join SQL (`join_tables.sql`) — important correction

`join_tables.sql` attempts to join the individual CSV staging tables into one larger joined view/table. I noticed a small bug in the original script:

- The file uses:
  ```sql
  LEFT JOIN staging.orders_items oi ON o.order_id = oi.order_id
  ```
  but the correct table name (per `ingest_bike.sql`) is `staging.order_items` (singular `order_items`). So update to:
  ```sql
  LEFT JOIN staging.order_items oi ON o.order_id = oi.order_id
  ```

- The script also included `c.customer_id` twice in the column list. Only select it once, or alias appropriately.

- Example corrected join structure:
  ```sql
  SELECT
    o.order_id,
    o.order_date,
    o.customer_id,
    o.staff_id,
    o.order_status,
    o.required_date,
    c.first_name AS customer_first_name,
    c.last_name AS customer_last_name,
    c.phone AS customer_phone,
    -- ...other customer columns...
    oi.product_id,
    oi.quantity,
    oi.list_price,
    oi.discount,
    p.product_name,
    p.brand_id,
    p.category_id,
    ca.category_name,
    b.brand_name,
    s.first_name AS staff_first_name,
    s.last_name AS staff_last_name,
    s.manager_id
  FROM staging.orders o
  LEFT JOIN staging.customers c ON o.customer_id = c.customer_id
  LEFT JOIN staging.order_items oi ON o.order_id = oi.order_id
  LEFT JOIN staging.products p ON oi.product_id = p.product_id
  LEFT JOIN staging.categories ca ON p.category_id = ca.category_id
  LEFT JOIN staging.brands b ON p.brand_id = b.brand_id
  LEFT JOIN staging.staffs s ON o.staff_id = s.staff_id;
  ```

- After fixing, you can either:
  - Run the join query in the UI to inspect results, or
  - Create a new `staging.joined_table` from it using `CREATE TABLE AS (SELECT ...)` to persist the join.


## 8 — Useful terminal examples (step-by-step)


1. Put CSVs inside `lecture_code_along/week1_query_bikedata/data/` (or the repo-level `data/` as used in SQLs). Use the same folder structure the SQL expects.

2. From repo root, ingest the prepared joined_table:
   - `cd lecture_code_along/week1_query_bikedata`
   - `duckdb bike_joined.duckdb < sql/ingest_bike_join.sql`

3. Confirm table exists (duckdb interactive):
   - `duckdb bike_joined.duckdb`
   - at duckdb prompt: `SELECT COUNT(*) FROM staging.joined_table;`

4. Start UI:
   - Exit duckdb prompt, then run:
   - `duckdb bike_joined.duckdb -ui`
   - Open the URL printed in terminal (it usually opens automatically).

5. Run queries from `sql/query_bike.sql` either by copy/paste into UI or run script:
   - Non-interactive run of a script that prints results to stdout:
     - `duckdb bike_joined.duckdb < sql/query_bike.sql`


## 9. What's next / study suggestions
- Persist the joined result into a table and write example analytic queries:
  - e.g., top 10 products by revenue, revenue by brand, revenue over time.
- Create indexes (if needed) and test query performance.
- Write small unit queries to validate row counts between original CSVs and staging tables.
- Practice window functions to detect duplicate customers by name (e.g., `ROW_NUMBER()` partitioned by name).

