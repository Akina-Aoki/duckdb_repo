# Week 1 DuckDB Bike Data Project — Video Walkthrough Script

---

## [Intro]
**(No File Reference — Say This to Start):**
"Hi, this is a live walkthrough of my DuckDB week 1 project. I’ll show the exact steps I took from setup to building tables, performing joins, and running SQL queries. I’ll share my screen and walk through all code, scripts, and documentation so I can always come back and repeat these steps."

---

## 1. Repository & Folder Setup

**File to Show:**  
- `LECTURE_GUIDE.md` section: **1. Repo & folder setup**
- `ONBOARDING_GUIDE.md` section: **2. Required Project Structure**

**Script:**  
"I started by setting up my folder and file structure. In the `lecture_code_along/week1_query_bikedata` folder, I created a `data` subfolder for all the CSVs and a `sql` folder for my scripts.  
You can see this structure in the `LECTURE_GUIDE.md` and `ONBOARDING_GUIDE.md` files. Following this structure helps DuckDB find the files and keeps my project organized."

---

## 2. Tools & Prerequisites

**File(s) to Show:**  
- (Show your installation guide or script in the repo, if available)
- Optional: Demonstrate terminal and bash usage in your VSCode

**Script:**  
"To get started, I installed DuckDB by following the official installation guide for my operating system. On Mac or Linux, you can use your default terminal. On Windows, I recommend using Git Bash, which you can set as the default profile in VSCode’s integrated terminal.

Once DuckDB is installed, I verified the setup by running:
```
duckdb version
```
in my terminal. This should print the installed version if everything worked.

Here are some bash navigation basics I used throughout:
- `cd` changes the directory.
- `cd ..` moves up a directory.
- `ls` lists files/folders.
- `pwd` prints the current directory path.

To work with DuckDB, I navigated to my project folder and ran:
```
duckdb test_yt.duckdb
```
This creates a persistent DuckDB file. I checked database info using:
```sql
desc;
SELECT * FROM information_schema.schemata;
SELECT * FROM information_schema.tables;
```
To close DuckDB:  
- Use `Ctrl+D` (Mac/Linux) or `Ctrl+C` (Windows) in the terminal.

For ingesting data, I set up a structure like this:
```
├── data/
│   └── your_csv_file.csv
└── sql/
    └── ingest_data.sql
```
In my SQL ingest script, I wrote:
```sql
CREATE TABLE IF NOT EXISTS videos AS (
    SELECT * FROM read_csv_auto('data/your_csv_file.csv')
);
```
I ran the script with:
```
duckdb yt_videos.duckdb < sql/ingest_data.sql
```
and verified the table and data with:
```sql
SELECT * FROM videos;
desc;
```
DuckDB also provides a UI. I launched it with:
```
duckdb -ui yt_videos.duckdb
```
This opened a browser-based SQL interface.

Finally, I made sure to copy any important SQL code from the UI back into version-controlled `.sql` files in my `sql` folder, to keep my work reproducible.

I also updated my `.gitignore` to prevent tracking DuckDB database files and OS-specific system files, like:
```
*.duckdb
*.wal
*.DS_Store
```
This setup ensures a smooth DuckDB workflow with reproducible and portable SQL code."


---

## 3. File Paths & Gotchas

**File to Show:**  
- `LECTURE_GUIDE.md` section: **3. Paths & working directory gotcha**

**Script:**  
"One tricky part with DuckDB is that file paths in your SQL must be relative to wherever you run DuckDB from. If I run commands from the repo root, `data/brands.csv` works. But if I’m in the `sql` folder, I’d have to use `../data/brands.csv` instead. Keeping this consistent avoids ingestion errors."

---

## 4. Ingesting Data

**Files to Show:**  
- `sql/create_table.sql`
- `sql/ingest_bike.sql`
- `sql/ingest_bike_join.sql`
- `LECTURE_GUIDE.md` section: **4. Ingestion SQLs**

**Script:**  
"My first ingestion script was `create_table.sql`, which loads all CSV files from `../data` to create a single table.  
```sql
-- [show code in create_table.sql]
CREATE TABLE IF NOT EXISTS bike_data AS (
  SELECT * FROM read_csv_auto('../data')
);
```
But this is just a generic demo. For actual use, I created a proper staging schema in `ingest_bike.sql`, making a separate table for each CSV file.
```sql
-- [show code in ingest_bike.sql]
CREATE SCHEMA IF NOT EXISTS staging;
CREATE TABLE IF NOT EXISTS staging.brands AS (
  SELECT * FROM read_csv_auto('data/brands.csv')
);
-- repeat for each table
```
For demos and queries, I also prepared a single table from an already joined CSV with `ingest_bike_join.sql`:
```sql
CREATE SCHEMA IF NOT EXISTS staging;
CREATE TABLE IF NOT EXISTS staging.joined_table AS (
  SELECT * FROM read_csv_auto('data/joined_table.csv')
);
```
This way, I can either demo normalized ingestion or jump straight to the analytics using the big joined table."

---

## 5. Running CLI & UI

**File to Show:**  
- `LECTURE_GUIDE.md` section: **5. DuckDB CLI & UI commands**
- `ONBOARDING_GUIDE.md` section: **3. Execution Workflow**

**Script:**  
"I run all my ingestion scripts using the DuckDB CLI. For example, from repo root I run:

```bash
duckdb bike_joined.duckdb < sql/ingest_bike_join.sql
duckdb bike_joined.duckdb -ui
```
The first line loads the joined CSV as a table, the second launches the DuckDB web UI so I can explore my data interactively. All these commands are explained in the documentation here."

---

## 6. SQL Joins

**Files to Show:**  
- `sql/join_tables.sql`
- `LECTURE_GUIDE.md` section: **7. The join SQL**
- `LECTURE_GUIDE.md` section: **Bike.duckdb join concept illustration**
- Optionally: Open the ER or join diagram in the markdown

**Script:**  
"To combine normalized tables, I have `join_tables.sql`, which shows how to do a multi-table LEFT JOIN.  
```sql
select o.order_id, o.order_date, c.first_name as customer_first_name, ...
from staging.orders o
LEFT JOIN staging.customers c ON o.customer_id = c.customer_id
-- more joins...
```
This follows the join concept I describe here in the markdown — using aliases like `o` for orders and `oi` for order_items, always joining on the key.  
I also discovered and fixed a small bug: the table should be `order_items`, not `orders_items`."

---

## 7. Querying the Data

**Files to Show:**  
- `sql/query_bike.sql`
- `LECTURE_GUIDE.md` section: **6. Querying**

**Script:**  
"Once data is ingested, I use the `query_bike.sql` script, which covers lots of query patterns.

I first describe the schema:

```sql
desc staging.joined_table;
```

Then I can select all data, or specific columns:

```sql
SELECT * FROM staging.joined_table;
SELECT order_date, customer_first_name, product_name FROM staging.joined_table;
```

I show basic filters, find unique customers, and use aggregate functions like `SUM`, `MIN`, and `MAX` to calculate things like total revenue.  
```sql
SELECT ROUND(SUM(quantity * list_price)) AS total_revenue FROM staging.joined_table;
```

I demonstrate how to use the CASE statement to map `order_status` codes to readable descriptions, and I show how to join this lookup table back into my main data.  
All these queries are in `query_bike.sql` with my comments in-line."

---

## 8. Common Pitfalls & Troubleshooting

**File to Show:**  
- `ONBOARDING_GUIDE.md` section: **4. Common Pitfalls to Avoid**  
- and **5. Lessons Learned**

**Script:**  
"My onboarding guide documents a few common pitfalls — like always checking your working directory, double-checking table/schema creation, and not trusting the UI left panel as the only source of truth. I highly recommend always running SQL queries directly to check your schema and row counts."

---

## [Outro]
**(No File Reference)**
"Thanks for watching this walkthrough. If I ever need to rerun or teach from this repo, these scripts and guides will let me set up, ingest, and analyze with DuckDB easily, every time."
