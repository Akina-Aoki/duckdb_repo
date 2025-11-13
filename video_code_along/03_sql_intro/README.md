# Filtering and Exploring Data in SQL (DuckDB)

This reference provides essential SQL filtering techniques using a basic jokes dataset in DuckDB. Key SQL commands are applied for data exploration, analysis, and manipulation with a focus on clarity and best practices for beginners.

---

## Project Structure

```
03_sql_intro/
   ├─ sql/
   │    ├─ create_table.sql      # Table definition for `funny_jokes`
   │    ├─ insert_jokes.sql      # Sample data for `funny_jokes`
   │    ├─ queries.sql           # Filtering and ordering queries
   │    ├─ update_joke.sql       # Example data updates
   │    ├─ delete.sql            # Filtering and deleting records
   ├─ .gitignore                 # Ignore DuckDB files
   └─ README.md                  # This overview
```

---

## Dataset: `funny_jokes`

The dataset consists of the `funny_jokes` table, designed for concise practice and demonstration.

**Columns:**
- `id`: INTEGER – Unique identifier for each entry (Primary Key)
- `joke_text`: VARCHAR – Joke content
- `rating`: INTEGER – Numerical rating of humor quality (higher indicates more humorous)

Table schema and sample data are available in [`create_table.sql`](sql/create_table.sql) and [`insert_jokes.sql`](sql/insert_jokes.sql).

---

## Key SQL Filtering and Analysis Concepts

### 1. Basic Filtering with `WHERE`

The `WHERE` clause restricts returned rows based on specified boolean conditions.

**Example:**  
Return all jokes with a rating of 8 or higher:
```sql
SELECT * FROM funny_jokes WHERE rating >= 8;
```

### 2. Multiple Conditions

Combine logic conditions using `AND` and `OR`.

**Example:**  
Display jokes with ratings between 7 and 9:
```sql
SELECT * FROM funny_jokes WHERE rating >= 7 AND rating <= 9;
```

### 3. Sorting Results using `ORDER BY`

Order query outputs numerically or alphabetically for better pattern recognition.

**Ascending order:**
```sql
SELECT * FROM funny_jokes ORDER BY rating;
```
**Descending order:**
```sql
SELECT * FROM funny_jokes ORDER BY rating DESC;
```

### 4. Filtering for Specific Records

Target individual records using column equality.

**Example:**  
Isolate the row for `id = 7`:
```sql
SELECT * FROM funny_jokes WHERE id = 7;
```

### 5. Preview Before Deleting (Safe Delete Patterns)

Execute a `SELECT` statement with the desired `WHERE` condition before performing a `DELETE` for validation.

**Preview rows to be deleted:**
```sql
SELECT * FROM funny_jokes WHERE rating < 5;
```
**Delete those rows:**
```sql
DELETE FROM funny_jokes WHERE rating < 5;
```

---

## Updating Data

Values in table entries can be modified using `UPDATE` statements.

**Example:**  
Increase the rating for the row with `id = 7` to 10:
```sql
UPDATE funny_jokes
SET rating = 10
WHERE id = 7;
```

---

## Best Practices

- Always preview affected rows using `SELECT` before running `UPDATE` or `DELETE`.
- Use `ORDER BY` to clarify data structure and reveal value distribution.
- Ensure unique `id` assignment as primary key in each row.
- Utilize aggregate functions to summarize data.  
    **Example:**  
    ```sql
    SELECT COUNT(*) AS total_jokes FROM funny_jokes;
    ```
- Apply simple pattern searches for text content.  
    **Example:**  
    ```sql
    SELECT * FROM funny_jokes WHERE joke_text LIKE '%penguin%';
    ```

---

## Code Reference

- Table creation: `sql/create_table.sql`
- Sample inserts: `sql/insert_jokes.sql`
- Filtering, ordering, lookup queries: `sql/queries.sql`
- Record updates: `sql/update_joke.sql`
- Row preview and deletion: `sql/delete.sql`

---

## References

- [DuckDB SQL Reference – WHERE](https://duckdb.org/docs/sql/statements/select.html#where-clause)
- [DuckDB SQL Reference – UPDATE](https://duckdb.org/docs/sql/statements/update.html)
- [DuckDB SQL Reference – DELETE](https://duckdb.org/docs/sql/statements/delete.html)
- [Beginner SQL Tutorial](https://www.sqlcourse.com/)

---