# DuckDB "Group By" Lesson – Video Walkthrough Narration Script

> **Lesson Theme:** Aggregation and Group By in DuckDB  
> **File Presentation Order:**  
> 1. ingest_food.sql  
> 2. eda_food.sql  
> 3. transformations.sql  
> 4. group_by.sql

---

## 1. `ingest_food.sql`  
**What the query is doing:**  
"This script loads our Kaggle food searches CSV into DuckDB. We use the `read_csv_auto` function which reads the data and infers the column types automatically. The query wraps this in a `CREATE TABLE IF NOT EXISTS`—so if the 'food' table doesn't exist, it makes one from the CSV."

**Why it’s written this way:**  
"We want a repeatable, error-resistant way to ingest data. Using `IF NOT EXISTS` keeps it safe for re-runs, and `read_csv_auto` simplifies handling varied CSV formats."

**How DuckDB executes this:**  
"When this query runs, DuckDB reads 'data/food_search_google.csv' and copies its contents into a new table called 'food.' If the table already exists, nothing changes."

**What to point out in the UI:**  
"After running this, check the 'food' table appears in the schema browser. You can run `DESC food` to view the inferred columns and their types."

**Common pitfalls or checks:**  
"Make sure the CSV file path is correct relative to where you're executing this. If you get a 'file not found' or no 'food' table appears, double-check your working directory and the file's existence."

**Clear read-aloud phrasing:**  
> "Let's start by bringing our dataset into DuckDB. This script creates our main 'food' table directly from the CSV. After running it, I like to check that the table and its columns show up in the UI—no errors means we're ready to go!"

---

## 2. `eda_food.sql`  
**What the query is doing:**  
"This file is for Exploratory Data Analysis—just getting familiar with what’s inside the 'food' table. The queries get the schema, view all data, look for distinct food item IDs, check how many unique foods and total records there are, and filter the data for specific date ranges."

**Why it’s written this way:**  
"EDA queries give confidence in the dataset’s shape and integrity. Knowing the column names, data counts, and unique values helps guide later cleaning or transformation steps."

**How DuckDB executes this:**  
"Each query here either displays table structure or computes counts and filtered lists. `DESC food` returns metadata; `SELECT` queries return rows from the data."

**What to point out in the UI:**  
"Show the schema result: This tells you column names like 'id', 'week_id', and 'value.'  
Show the count results: Number of unique foods, total row count—should match dataset expectations.  
Use a filtered select to verify that the subset by week range actually works, returning only rows from the chosen date window."

**Common pitfalls or checks:**  
"If DISTINCT or COUNT queries return zero, the data may not have loaded correctly. With big tables, be careful running a naked `SELECT * FROM food`—you could flood your UI."

**Clear read-aloud phrasing:**  
> "Before doing anything fancy, it’s vital to know what’s inside our data. I run these EDA scripts to check the schema, unique food items, and total rows, making sure they match the CSV’s summary. Filtering by date lets me peek at just a slice—another good sanity test!"

---

## 3. `transformations.sql`  
**What the query is doing:**  
"This script cleans and transforms the raw data for analysis. It renames columns for clarity, removes an irrelevant one, extracts the year from the week string, and finally, creates a cleaned version of the table called 'cleaned_food.'"

**Why it’s written this way:**  
"Good column names make queries far easier to read and maintain. Extracting the year as its own field makes time-based analysis much easier. Creating a new table means we preserve the original and can experiment without risk."

**How DuckDB executes this:**  
"The SELECT statement produces new column names and a calculated year. The subsequent `CREATE TABLE` runs this transformation as a batch, storing results in 'cleaned_food.'"

**What to point out in the UI:**  
"Show the result of `FROM cleaned_food`—it should display columns like 'food', 'week', 'year', and 'number_of_searches' with plausible values.  
Confirm that 'cleaned_food' is now listed alongside 'food' in your tables view."

**Common pitfalls or checks:**  
"Watch for typos in column aliases—misnaming one will error or just silently give you unexpected output. Make sure your substring indices match your real data—wrong settings will produce bad year values."

**Clear read-aloud phrasing:**  
> "Data cleaning is crucial in every project. Here I rename for clarity, pull out the year, and standardize naming for easier aggregation later. I always check the new table to make sure all the columns and sample values make sense."

---

## 4. `group_by.sql`  
**What the query is doing:**  
"This script unlocks the power of aggregation. Here, we use SQL’s `GROUP BY` clause with aggregate functions like `SUM()` to condense many rows into summary rows by category, year, or both. We also use filtering, ordering, and limiting for focused analysis."

**Why it’s written this way:**  
"In searches data, each food (e.g., 'FROZEN YOGURT') appears in many rows—one per week. To answer questions like: 'Total searches for each food?' or 'Which food is most popular?', we group by category and sum the total searches."

**How DuckDB executes this:**  
"`GROUP BY` collects all rows with the same grouping key together; aggregate functions (like `SUM(number_of_searches)`) compute a value over all grouped rows. Adding `ORDER BY` shows the most-searched foods first. `LIMIT` keeps output manageable."

**What to point out in the UI:**  
"Show that, after grouping, each food category appears only once—no more repeats like in the raw data. Point out that the sorted summary helps spot which foods are most searched. Show the other groupings (by year; by year and food), and how the output shrinks or changes in focus."

**Common pitfalls or checks:**  
"Not including the right columns in GROUP BY causes errors. Always use aggregate functions on columns not listed in the GROUP BY. With big result sets, always add an ORDER BY and LIMIT to avoid overwhelming your screen."

**Clear read-aloud phrasing:**  
> "Here’s the heart of today’s lesson—aggregation. By grouping by food and summing search counts, we go from thousands of repetitive rows to just one per food, sorted by popularity. Notice how the UI output shrinks and makes trends visible at a glance. Trying multiple groupings—by year or by (year, food)—lets us answer even more questions, like: 'How does interest change over time?'"

---

# Summary for Fast Recall

- **Start** by ingesting raw data safely and reproducibly.
- **Explore** the data structure and check contents.
- **Transform** with clear, analytical column names and helpful derived fields.
- **Aggregate** using GROUP BY and SUM to collapse and summarize, always validating output and understanding the structure of results.

**Tips:**  
- Run a SELECT after every table creation or change to confirm structure and sample data.  
- Use ORDER BY and LIMIT in GROUP BY queries for manageable, readable results.  
- Always check for typos and correct file paths!

---