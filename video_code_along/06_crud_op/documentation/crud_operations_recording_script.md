# CRUD Operations in DuckDB – Narration Script & File Guide

> **File Guide for Video Recording**  
>  
> Follow this order for your VS Code and DuckDB UI walkthrough.  
> You can refer to this as a checklist while recording:
>
> 1. `create_statement.sql`
> 2. `1_crud_create.sql`
> 3. `2_crud_read.sql`
> 4. `alter.sql`
> 5. `3_crud_update.sql`
> 6. `4_crud_delete.sql`
> 7. `drop.sql`

---
Folder setup
adelo@Aira MSYS ~/de25/aira_sql/video_code_along/06_crud_op/sql (main)

$ touch create_statement.sql alter.sql drop.sq
l 1_crud_create.sql 2_crud_read.sql 3_crud_upd
ate.sql 4_crud_delete.sql

Create code in vscode and copy the query in the ui cells and run to see the results.

See in the ui that its now connected to glossary
RUn in the terminal: duckdb -ui glossary.duckdb
---

## 1. `create_statement.sql`  
**What/Why:**  
"This step sets up the entire database structure. We're creating schemas—think of these as folders for our tables—and the tables themselves, which store our data. We also create sequences so that IDs auto-increment for each new record."

**How It Executes:**  
"Running these commands tells DuckDB to check if the schemas and tables already exist, and only create them if not. Sequences ensure every record has a unique ID—no manual counting!"

**What to Point Out in UI:**  
"After running this, check your output: when you do `DESC database.sql` or any table, you should see columns for id, word, and description.  
Querying `information_schema.schemata` will list the schemas—confirm both `database` and `programming` appear."

**Pitfalls/Checks:**  
"Be sure to use `IF NOT EXISTS` in CREATE statements—otherwise, you could get errors if you rerun the scripts. Always check if columns and tables were created as expected."

**Read-Aloud:**  
> "Let's create our schemas called 'database' and 'programming', and the tables for our SQL, DuckDB, and Python glossaries. The sequences here make sure each new row gets a unique, auto-incremented ID. When you run these, the tables should appear, ready for storing data."

---

## 2. `1_crud_create.sql`  
**What/Why:**  
"Now we're doing the C in CRUD—Create. These queries insert real data into our new tables."

**How It Executes:**  
"Each `INSERT INTO ... VALUES ...` puts a new row into the table. Notice for `database.sql` and `programming.python`, we insert several rows at once, which saves time and keeps the script tidy."

**What to Point Out in UI:**  
"After each insert, run a `SELECT * FROM ...` and show the resulting table.  
You should see each glossary term and description appear with a unique ID."

**Pitfalls/Checks:**  
"Watch for typing errors in values and column order—DuckDB matches by order, so make sure the values match the columns you specify.  
If an insert fails, check that the table structure matches your columns."

**Read-Aloud:**  
> "Time to populate our tables! Here, I'm adding entries like 'query', 'CRUD', and Python terms like 'class'. Always double-check your insert values; the columns and data types must match up exactly. After inserting, I select all rows to make sure everything looks right."

---

## 3. `2_crud_read.sql`  
**What/Why:**  
"Here is the R in CRUD—Read. I'm querying each table to display its contents, and also demo how to filter data."

**How It Executes:**  
"`SELECT *` returns every row and every column from the table. The extra query `WHERE id > 7` focuses on a subset of the data—only the rows with IDs greater than 7."

**What to Point Out in UI:**  
"Show the entire table after a plain `SELECT *`.  
Then run the filtered query and show how fewer rows are displayed, based on your condition. Point out the change in results."

**Pitfalls/Checks:**  
"Make sure the table isn't empty (check your inserts first!). When using `WHERE`, remember to use correct column names and check for typos, or you might get zero results."

**Read-Aloud:**  
> "Let's see what's in our tables. First, I select all records, then filter by an ID greater than 7. This is a simple way to inspect and check our data at each stage."

---

## 4. `alter.sql`  
**What/Why:**  
"Sometimes you need to update your table structure. This alters the schema by adding a new column, `learnt`, to mark which terms you've studied."

**How It Executes:**  
"ALTER TABLE makes a live change in DuckDB. The new boolean column 'learnt' now exists for every row, with a default value of FALSE."

**What to Point Out in UI:**  
"Run `DESC database.duckdb`—you'll see an extra column for 'learnt'.  
When you select data, all the 'learnt' fields are FALSE by default until we update them."

**Pitfalls/Checks:**  
"You can't add a column with a name that already exists, so check column names before running the alter. Use `DEFAULT` for initial values; otherwise, you’ll get NULLs."

**Read-Aloud:**  
> "Imagine I've just realized I want to keep track of which glossary entries I've mastered. With one statement, I add a 'learnt' column and set it to FALSE everywhere."

---

## 5. `3_crud_update.sql`  
**What/Why:**  
"This file is about the U in CRUD—Update. We're modifying data. Specifically, we want to mark certain glossary entries as learnt."

**How It Executes:**  
"The `UPDATE` statement finds the rows by ID (using `WHERE id IN (3, 6, 7)`) and sets 'learnt' to TRUE just for them."

**What to Point Out in UI:**  
"Use a select to show which rows had 'learnt' as FALSE, then do the update, then select again to see the change to TRUE only for those IDs."

**Pitfalls/Checks:**  
"Always double-check your WHERE clause—if you forget it, every row could be updated. Try querying before and after to verify exactly what changed."

**Read-Aloud:**  
> "I'm updating just a few entries, not everything. Before updating, I select the rows to show their status is FALSE. After updating, I check again and only those rows now have 'learnt' set to TRUE. That's the power of the WHERE filter!"

---

## 6. `4_crud_delete.sql` – D for Delete: Removing Data

**Script:**
> Finally, let's see how deletions work.
>
> First, I find the record in `programming.python` where `id = 2`:
> ```sql
> SELECT * FROM programming.python WHERE id = 2;
> ```
> Then, the following deletes it:
> ```sql
> DELETE FROM programming.python WHERE id = 2;
> ```
> I follow with a select (`SELECT * FROM programming.python;`) to confirm it’s been removed.
>
> At the end of the file, I repeat mass-inserts (like in the create step), then selectively delete all rows in `database.duckdb` where `id > 10`. This demonstrates bulk deletion when you want to reset state or clean up data after experimentation.

**UI Result Explanation:**
> After deleting, the previously found `id = 2` row is gone from the select output.
>
> After deleting `id > 10`, those rows disappear from the result set, leaving only IDs 1–10, confirming that deletions worked as expected.

---

## 7. `drop.sql` – Dropping Tables and Schemas

**Script:**
> To wrap up, here's how you clean up your database entirely.
>
> This script shows how to drop tables and schemas – essentially deleting everything you created.
> ```sql
> DROP TABLE database.sql;
> DROP SCHEMA programming CASCADE;
> ```
> Finally, I run a `DESC;` and a `SELECT * FROM information_schema.schemata;` to confirm what’s left (just the database schema or none).

**UI Result Explanation:**
> After running `DROP`, when I describe objects or list schemas, I should see that the dropped table and schema are gone.
>
> Cleaning up ensures you can start fresh for future experiments!

---

# Final Review Notes

- **Always confirm changes by running SELECT statements after each operation.**
- **Look for errors or warning messages in the UI; if you see one, check your SQL for typos or constraints.**
- **Modify, test, and observe – the pattern is create → insert → read → update → delete → drop.**
- **These files provide building blocks for learning not just DuckDB, but relational databases and SQL workflows in general.**

