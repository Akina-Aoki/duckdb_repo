# Exercise 2 - querying multiple tables

In this exercise, you get to make more complex querying with SQL. For the practical exercises, you can open up your local repository as a project and make new connections to each databse file that you will work with.

> [!NOTE]
> To ingest data to the database, you should use CLI in combination with SQL script, as the relative path from dbeaver is not from the repository. Also absolute path is not recommended as this won't work for another computer.

> [!NOTE]
> Try not to skip those tasks which are more free, where you need to think what else that could be explored, transformed etc. These are very important as in industry it's common that you need to explore data and participate in stakeholders and team discussions.

## 0. Cleaning malformed text data

Continue working on the data from lecture 09_strings. In this lecture you created a schema called staging and ingested the raw data into the staging schema.

```sql
-- duckdb temporal_data.duckdb < sql/ingest_data.sql
-- uckdb -ui temporal_data.duckdb
```

### a) Create a schema called refined. This is the schema where you'll put the transformed data.
        - Workflow before creating the refined schema
        - I opened the temporal_data lecture in the duckdb ui and created refined schema there.
        - The following below are the following queries for exercise 0 for refined schema creation.


### b) Now transform and clean the data and place the cleaned table inside the refined schema.
### TIP: The strategic model: Staging → Refined

    In any modern data architecture—whether running DuckDB locally or Snowflake in production—the golden rule is:

    - Always ingest into staging first.
    - Do all cleaning, parsing, and quality checks in staging.
    - Push only clean, modeled, high-quality tables into refined.
    - That means choice #1 is the correct and industry-aligned flow.

    ```sql
    CREATE TABLE IF NOT EXISTS refined.trains_schedules AS
    SELECT ...
    FROM staging.trains_schedules
    WHERE ...
    ```

### What not to do

    - Do NOT ingest raw CSVs directly into the refined schema.
    - Do NOT transform inside refined.
    - Do NOT move raw data around.
    - That breaks lineage, makes debugging painful, and kills data governance.

### Check the staging.trains_schedule to see what needs to be transformed

```sql
-- check staging.trains_schedule again
SELECT * 
FROM staging.train_schedules;
```

**Data set is already clean**
- `scheduled_arrival`, `actual_arrival`, `departure_time` are already valid TIMESTAMP strings

- `delay_minutes` and `passengers` are clean integers (no quotes)

- No nulls
- No weird whitespace
- No broken rows
- This means transformation layer can be incredibly lightweight.

### transformation strategy
Leave staging untouched
– staging is your raw landing zone
– no cleaning, no casting, no modifying, no deleting rows

Create `refined.trains_schedules`
– cleaned version
– timestamp-typed version
– trimmed text
– same row count
– fully analytics-ready

### c) Practice filtering and searching for different keywords in different columns. Discuss with a friend why this could be useful in this case.

## 1. More extensive EDA on the sakila database

You will be using the same database as in 11_joins. Take some time to really understand this database, as we'll come back to this database later in this course and in data modeling course.

### a) Describe all tables.

### b) Select all data on all tables.

### c) Find out how many rows there are in each table.

The questions here might come from a business stakeholder which is not familiar with the table structure. Hence it's your job to find out which table(s) to look at.

### d) Calculate descriptive statistics on film length.

### e) What are the peak rental times?

### f) What is the distribution of film ratings?

### g) Who are the top 10 customers by number of rentals?

### h) Retrieve a list of all customers and what films they have rented.

### i) Make a more extensive EDA of your choice on the Sakila database.

## 2. Sets and joins on sakila

&nbsp; a) Retrieve a list of all customers and actors which last name starts with G.

&nbsp; b) How many customers and actors starts have the the letters 'ann' in there first names?

&nbsp; c) In which cities and countries do the customers live in?

&nbsp; d) In which cities and countries do the customers with initials JD live in?

&nbsp; e) Retrieve a list of all customers and what films they have rented.

&nbsp; f) What else cool information can you find out with this database using what you know about SQL.

## 3. Theory questions

These study questions are good to get an overview of how SQL and relational databases work.

&nbsp; a) What is the difference between INNER JOIN and INTERSECT?

&nbsp; b) When are the purposes of set operations?

&nbsp; c) What are the main difference between joins and set operations?

&nbsp; d) When is set operators used contra logical operators?

&nbsp; e) How to achieve this using set operations in SQL, where A and B are result sets.

<img src ="https://github.com/kokchun/assets/blob/main/sql/set_question_1.png?raw=true" width = 200>

&nbsp; f) How to achieve this using set operations in SQL, where A and B are result sets.

<img src ="https://github.com/kokchun/assets/blob/main/sql/set_question_2.png?raw=true" width = 200>

&nbsp; g) Does joining order matter for three or more tables?

## Glossary

Fill in this table either by copying this into your own markdown file or copy it into a spreadsheet if you feel that is easier to work with.

| terminology    | explanation |
| -------------- | ----------- |
| temporal       |             |
| interval       |             |
| synthetic      |             |
| VALUES         |             |
| subquery       |             |
| compound query |             |
| set operations |             |
| EXCEPT         |             |
| result set     |             |
| UNION          |             |
| UNION ALL      |             |
| operator       |             |
| INTERSECT      |             |
| venn diagram   |             |
| LEFT JOIN      |             |
| INNER JOIN     |             |
| RIGHT JOIN     |             |
| LIKE           |             |
| ILIKE          |             |
| regexp         |             |