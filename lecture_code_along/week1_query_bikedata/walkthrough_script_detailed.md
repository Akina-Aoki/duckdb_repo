# DuckDB Week 1 Project — Complete Walkthrough Script

---

**Intro:**  
"Hi everyone, in this walkthrough I’ll take you through my full DuckDB week 1 project setup. We’ll go from table creation and data ingestion, to complex joins and core SQL queries—all inside the DuckDB UI. I’ll show my code, explain the logic, and highlight best practices and lessons for learners."

---

## 1. [create_table.sql](https://github.com/Akina-Aoki/duckdb_repo/blob/main/lecture_code_along/week1_query_bikedata/sql/create_table.sql)

**What I did & Why:**  
"I started by experimenting with how easy it is to load data in DuckDB using `read_csv_auto()`. This function reads CSVs and automatically infers schema, which is really helpful if you just want a quick look or prototype."

**What to show & say:**  
- Open `create_table.sql` in VSCode.
- Explain:  
  "This script creates a `bike_data` table by reading all CSV files from the `../data` directory. Using `read_csv_auto` means fewer manual steps."
- In the UI, run this:
    ```sql
    CREATE TABLE IF NOT EXISTS bike_data AS (
        SELECT * FROM read_csv_auto('../data')
    );
    ```
- "The table now exists, populated directly from my data folder—great for quick exploration."

**Tip:**  
"If you do want specific control—like table names or types—it’s better to explicitly define your table structure, but this is a great first step for data discovery."

---

## 2. [ingest_bike.sql](https://github.com/Akina-Aoki/duckdb_repo/blob/main/lecture_code_along/week1_query_bikedata/sql/ingest_bike.sql)

**What I did & Why:**  
"After experimenting, I built a proper ingestion pipeline that mirrors best practices for analytics engineering. Instead of one big table, I ingested each CSV as a staging table. This approach better reflects a normalized, flexible database and helps catch schema mismatches early."

**What to show & say:**  
- Open `ingest_bike.sql`
- "I start by creating a `staging` schema. Then, for each CSV, I create its own table in `staging`. For example:"
    ```sql
    CREATE SCHEMA IF NOT EXISTS staging;
    CREATE TABLE IF NOT EXISTS staging.brands AS (
        SELECT * FROM read_csv_auto('data/brands.csv')
    );
    ```
- "I repeat this for every major data file: categories, customers, order_items, orders, products, staffs, stocks, stores."

**Ingest/Create Your Staging Tables**
- duckdb bike.duckdb < sql/ingest_bike.sql
- duckdb -ui bike.duckdb

- In the UI, run:
    ```sql
    SELECT table_schema, table_name FROM information_schema.tables WHERE table_schema = 'staging';
    ```
- "As you can see, we now have fully normalized data in our staging schema."

**Why:**  
"This is the scalable, production-friendly way—each table maps to a CSV, and you have clarity and safety in your model."

---

## 3. [join_tables.sql](https://github.com/Akina-Aoki/duckdb_repo/blob/main/lecture_code_along/week1_query_bikedata/sql/join_tables.sql)

**What I did & Why:**  
"Next, I wanted to create a fully joined table for richer analytics. I wrote one big query to LEFT JOIN all the staging tables by their key columns. This lets me consolidate all info about orders, customers, products, etc. into one denormalized result."

**What to show & say:**  
- Open `join_tables.sql`.
- Show the actual LEFT JOIN code, and mention:
    "I alias tables—`o` for orders, `c` for customers, `oi` for order_items, etc.—to make the joins readable. Each join is designed so that missing data (like an order with no items) still appears, thanks to the LEFT JOIN."
- "One common issue to watch for: typos in table names. Here I accidentally used `orders_items` instead of `order_items`—always double check these!"

**In the UI, run a join query (after fixing any typos if needed), for example:**
    ```sql
    SELECT o.order_id, o.order_date, c.first_name AS customer_first_name, p.product_name, b.brand_name
    FROM staging.orders o
    LEFT JOIN staging.customers c ON o.customer_id = c.customer_id
    LEFT JOIN staging.order_items oi ON o.order_id = oi.order_id
    LEFT JOIN staging.products p ON oi.product_id = p.product_id
    LEFT JOIN staging.brands b ON p.brand_id = b.brand_id
    LIMIT 10;
    ```

**Why:**  
"Doing complex joins yourself is excellent practice for understanding how real database relationships work—and this lays the foundation for creating analytic tables you’ll use throughout the course."

---

## 4. [ingest_bike_join.sql](https://github.com/Akina-Aoki/duckdb_repo/blob/main/lecture_code_along/week1_query_bikedata/sql/ingest_bike_join.sql)

**What I did & Why:**  
"In addition to joining tables on the fly, I also prepared a fully joined CSV. Ingesting this as `staging.joined_table` makes it easy to jump right into analytics for demos and learning."

**What to show & say:**  
- Open `ingest_bike_join.sql`.
- Explain:  
  "This script creates a staging table called `joined_table` by reading the big `joined_table.csv`. This is handy for teaching or demos—no need to write join SQL each time."
- In the UI, run:
    ```sql
    CREATE TABLE IF NOT EXISTS staging.joined_table AS (
        SELECT * FROM read_csv_auto('data/joined_table.csv')
    );
    SELECT COUNT(*) FROM staging.joined_table;
    ```
- "Now I have a big, analysis-friendly table ready to go."

---

## 5. [query_bike.sql](https://github.com/Akina-Aoki/duckdb_repo/blob/main/lecture_code_along/week1_query_bikedata/sql/query_bike.sql)

**What I did & Why:**  
"With my joined table, I can do all sorts of analytics SQL. This script demonstrates exploratory data analysis, row selection, aggregations, creating new descriptive columns, and more."

**What to show & say:**  
- Open `query_bike.sql`.
- Walk through and run key queries, explaining each block:
    - **Schema Inspection & SELECTs:**  
      "Start with basic inspection and selections:"
        ```sql
        desc staging.joined_table;
        SELECT * FROM staging.joined_table LIMIT 5;
        ```
    - **Selecting columns & filtering:**  
      "Select relevant columns, filter with WHERE for customer names, etc. Useful for basic reporting."
        ```sql
        SELECT order_date, customer_first_name, product_name FROM staging.joined_table WHERE customer_first_name = 'Marvin';
        ```
    - **Working with codes (CASE, lookup):**  
      "Map `order_status` numbers to human descriptions using a CASE statement or, better yet, a lookup table:"
        ```sql
        CREATE TABLE IF NOT EXISTS staging.status (
            order_status INTEGER, order_status_description VARCHAR
        );
        INSERT INTO staging.status VALUES (1, 'Pending'), (2, 'Processing'), (3, 'Rejected'), (4, 'Completed');

        -- Join for readable status:
        SELECT j.order_id, j.order_status, s.order_status_description
        FROM staging.joined_table j
        JOIN staging.status s ON j.order_status = s.order_status;
        ```
    - **Aggregation:**  
      "Analyze the data—find revenue, min/max sales, etc.:"
        ```sql
        SELECT ROUND(SUM(quantity * list_price)) AS total_revenue FROM staging.joined_table;
        SELECT ROUND(MIN(quantity * list_price)) AS min_revenue, ROUND(MAX(quantity * list_price)) AS max_revenue FROM staging.joined_table;
        ```
    - **Distinct & duplicates:**  
      "Find unique values for columns and catch issues such as duplicate customers by their (first, last) pair:"
        ```sql
        SELECT DISTINCT customer_first_name, customer_last_name FROM staging.joined_table;
        SELECT customer_id, customer_first_name, customer_last_name FROM staging.joined_table WHERE customer_first_name = 'Justina' AND customer_last_name = 'Jenkins';
        ```

**Why:**  
"Moving from table setup to real analytics is the magic of DuckDB: you can do everything, from data cleaning to reporting, all in one place, and these patterns will repeat in every serious project."

---

## [Best Practices & Wrap-up]

**What to say:**  
- "As a learner, here’s what’s important to remember:  
  - Use `read_csv_auto` for rapid prototyping, but move to normalized schemata quickly for reliability.
  - Always check your working directory—DuckDB file paths are relative!
  - Save all important SQL logic in files, not just in the UI, for reproducibility.
  - Practice joins and aggregations—these skills are critical for analytics.
- Keep your `.gitignore` updated to avoid committing large DB files or system clutter.

**Outro:**  
"That’s the whole journey from raw CSVs to advanced queries in DuckDB. Practicing these steps gives you reliable skills for data engineering, analytics, and portfolio projects. Thanks for following along!"

---

## [Side-by-Side Reference Table]

| Step                      | File/Action to Show                                                                | Example in UI                              |
|---------------------------|------------------------------------------------------------------------------------|--------------------------------------------|
| Create table (explore)    | create_table.sql                                                                   | CREATE TABLE IF NOT EXISTS bike_data ...   |
| Ingest all staging tables | ingest_bike.sql                                                                    | CREATE TABLE IF NOT EXISTS staging.* ...   |
| Join normalized tables    | join_tables.sql                                                                    | Full LEFT JOIN query                       |
| Ingest denormalized table | ingest_bike_join.sql                                                               | CREATE TABLE IF NOT EXISTS staging.joined_table ... |
| Query & analytics         | query_bike.sql                                                                     | Various queries: SELECT, CASE, joins, etc. |

---