# 06_crud_op – CRUD Operations SQL Code Along
[![R in Crud Operations video learning log](https://img.youtube.com/vi/eggHjrB-dgU/0.jpg)](https://youtu.be/eggHjrB-dgU)




A walkthrough for basic SQL `CRUD` (Create, Read, Update, Delete) operations using DuckDB, covering workflow, terminology, and practical examples. This README summarizes essential patterns and references for both learning and quick review.

*For a workflow demonstration, see `workflow_documentation.ipynb`.*
---

## Project Structure

```
video_code_along/06_crud_op/
├─ sql/
│   ├─ create_statement.sql   # Creates schemas, sequences, and tables
│   ├─ 1_crud_create.sql      # Demonstrates INSERT (Create)
│   ├─ 2_crud_read.sql        # Demonstrates SELECT (Read)
│   ├─ 3_crud_update.sql      # Demonstrates UPDATE (Update)
│   ├─ 4_crud_delete.sql      # Demonstrates DELETE (Delete)
│   ├─ alter.sql              # Alters table structure (e.g., add columns)
│   ├─ drop.sql               # Drops tables/schemas to clean up
│   └─ workflow_documentation.ipynb # Notes and code-along documentation
```

---

## Dataset & Tables

**No external CSV:** All data is inserted via SQL scripts. The following schemas and tables are used:

- `database.sql`: SQL concepts glossary
- `database.duckdb`: DuckDB/SQL concepts glossary (with an alterable schema)
- `programming.python`: Python programming glossary

Each table defines the following columns:

| Column       | Meaning                                  |
|--------------|------------------------------------------|
| `id`         | Unique integer ID (auto-incremented)     |
| `word`       | Glossary term                            |
| `description`| Definition or description of the term    |

---

## CRUD Workflow & Concept Review

### 1. Create: Inserting Data

Use `INSERT INTO` to add new records.

```sql
INSERT INTO database.sql (word, description)
VALUES ('query', 'request made to a database to retrieve, modify or manipulate data');
```

**Bulk Insert Example:**

```sql
INSERT INTO programming.python (word, description)
VALUES
  ('class', 'code template for creating objects'),
  ('tuple', 'immutable, works similar to list...');
```

---

### 2. Read: Querying Data

Use `SELECT ... FROM ...` to retrieve data.

```sql
SELECT * FROM programming.python;
SELECT word, description FROM database.duckdb WHERE id > 7;
```

---

### 3. Update: Modifying Records

Change column values with `UPDATE`.

```sql
UPDATE database.duckdb
SET learnt = TRUE
WHERE id IN (3, 6, 7);
```

---

### 4. Delete: Removing Records

Use `DELETE ... WHERE` to remove matching rows.

```sql
DELETE FROM programming.python
WHERE id = 2;
```

---

### Table Alteration & Cleanup

- **Altering Structure:**  
  `ALTER TABLE database.duckdb ADD COLUMN learnt BOOLEAN DEFAULT FALSE;`

- **Dropping Tables/Schemas:**  
  `DROP TABLE database.sql;`  
  `DROP SCHEMA programming CASCADE;`

---

## Key SQL Patterns

- **Creating Tables & Sequences:**
  ```sql
  CREATE SEQUENCE IF NOT EXISTS id_sql_sequence START 1;
  CREATE TABLE IF NOT EXISTS database.sql (
      id INTEGER PRIMARY KEY DEFAULT nextval('id_sql_sequence'),
      word STRING,
      description STRING
  );
  ```

- **Viewing Table Structure:**  
  `desc database.sql;`

- **View/Check Results After Each Step:**  
  Use `SELECT * FROM ...` to verify changes (after INSERT, UPDATE, DELETE, etc.).

---

## Practical Examples

- **Insert multiple glossary terms into a table:**  
  See `1_crud_create.sql`

- **Alter a table by adding a new column:**  
  See `alter.sql`

- **Update selected rows based on a filter:**  
  See `3_crud_update.sql`

- **Delete rows and confirm removal:**  
  See `4_crud_delete.sql`

---

## Reference & Further Reading

- [DuckDB SQL: Data Types](https://duckdb.org/docs/sql/data_types/overview.html)
- [DuckDB SQL: CREATE TABLE](https://duckdb.org/docs/sql/statements/create_table.html)
- [DuckDB SQL: INSERT](https://duckdb.org/docs/sql/statements/insert.html)
- [DuckDB SQL: SELECT](https://duckdb.org/docs/sql/statements/select.html)
- [DuckDB SQL: UPDATE & DELETE](https://duckdb.org/docs/sql/statements/update.html)
- [DuckDB SQL: ALTER TABLE](https://duckdb.org/docs/sql/statements/alter_table.html)
- [DuckDB SQL: DROP](https://duckdb.org/docs/sql/statements/drop.html)

---

