# 10 — Constraints
This short folder shows how to enforce rules on table columns using constraints in DuckDB.
[![YouTube Video](https://img.youtube.com/vi/8bQT2R7nE6s/0.jpg)](https://youtu.be/8bQT2R7nE6s)
<br>
**Enforce Constraints**


## What are constraints?
- Constraints are simple rules you add to table columns.
- They stop bad or unexpected data from being inserted.
- Use them to keep data clean and predictable.

## Common types (short and simple)
#### NOT NULL  
  - The column must have a value. It cannot be NULL.
  - Example: name VARCHAR NOT NULL

#### UNIQUE  
  - All values in the column must be different.
  - Example: email VARCHAR UNIQUE

#### CHECK  
  - The value must meet a condition you write.
  - Example: age INTEGER CHECK (age >= 0)

 #### DEFAULT  
  - If no value is given, use this default value.
  - Example: created_at TIMESTAMP DEFAULT current_timestamp

#### PRIMARY KEY  
  - A column (or set) that uniquely identifies each row.
  - Often implies UNIQUE and NOT NULL.
  - Example: id INTEGER PRIMARY KEY

#### FOREIGN KEY  
  - Links a column to a primary key in another table.
  - Helps keep relationships correct (e.g., orders.user_id -> users.id).

#### Notes about DuckDB and ALTER TABLE
- You can add or drop DEFAULT with ALTER TABLE (see constraints.sql).
- Not all constraint changes can be added with ALTER TABLE in every case.
- Check the example file sql/constraints.sql to see how each rule behaves.
- If an INSERT breaks a constraint, the whole INSERT fails.
- Use CHECK for simple business rules (e.g., salary >= 0).
- Use DEFAULT for convenient, consistent values.

References  
[constraints]: https://duckdb.org/docs/stable/sql/constraints <br>
[constraints]: https://www.geeksforgeeks.org/sql/sql-constraints/ <br>
[constraints]: https://www.w3schools.com/sql/sql_constraints.asp <br>
[alter]: https://duckdb.org/docs/stable/sql/statements/alter_table <br>

