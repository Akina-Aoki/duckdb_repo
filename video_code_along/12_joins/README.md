# plant and sakila query explanations

## plant data
This document walks through the two SQL files in this folder:
- `sql/01_generate_data.sql` - creates the plants dataset and inserts sample rows
- `sql/02_joins.sql` - demonstrates different JOIN types using the sample data

### Ingestion
1. Create a DuckDB file and run the generator SQL:
```bash
duckdb data/plants.duckdb < sql/01_generate_data.sql
duckdb -ui data/plants.duckdb
```

### 1) LEFT JOIN (plants LEFT JOIN plant_care)

```sql
SELECT p.plant_id, p.plant_name, p.type, pc.water_schedule, pc.sunlight
FROM main.plants p
LEFT JOIN main.plant_care pc ON p.plant_id = pc.plant_id;
```
- Return all rows from `plants`. If there is a matching `plant_care` row, include its columns; otherwise return NULL for care columns.

Expected result rows:
```text
plant_id | plant_name | type      | water_schedule | sunlight
1        | Rose       | Flower    | Daily          | Full Sun
2        | Oak        | Tree      | NULL           | NULL
3        | Tulip      | Flower    | Weekly         | Partial Sun
4        | Cactus     | Succulent | Biweekly       | Full Sun
5        | Sunflower  | Flower    | NULL           | NULL
```


--------------------------------------------------------------------------------------------------------------------
# Study Guide
## JOINS vs SET OPERATIONS
```sql
INNER JOIN  → overlap only  
LEFT JOIN   → all from LEFT + matches  
RIGHT JOIN  → all from RIGHT + matches  
FULL JOIN   → all rows from both sides  
```

## INNER JOIN vs INTERSECT
INNER JOIN = horizontal merge
Aligns tables by a shared key → outputs wider rows.
```sql
A(id, name) INNER JOIN B(id, salary)
→ (id, name, salary)
```
## INTERSECT = vertical filtering
Compares two result sets → returns only rows that appear in both.
Requires identical column structure.
```sql
[1,2,3,4] INTERSECT [3,4,5,6] → [3,4]
```

## Set Operations
| Feature      | Joins                                | Set Operations                        |
| ------------ | ------------------------------------ | ------------------------------------- |
| Direction    | Horizontal (add columns)             | Vertical (stack / filter rows)        |
| Use Case     | Relate entities (Customers ↔ Orders) | Combine comparable datasets (EU ↔ US) |
| Column Rules | Any columns you select               | Must match count + data types         |

## Joins vs Set Operations
| Feature      | Joins                                | Set Operations                        |
| ------------ | ------------------------------------ | ------------------------------------- |
| Direction    | Horizontal (add columns)             | Vertical (stack / filter rows)        |
| Use Case     | Relate entities (Customers ↔ Orders) | Combine comparable datasets (EU ↔ US) |
| Column Rules | Any columns you select               | Must match count + data types         |

## Logical Operators vs Set Operators
### Logical Operators (AND, OR)
Used inside one query to filter rows.
```sql
WHERE country = 'Sweden' AND age > 30
```
### Set Operators (UNION, INTERSECT, EXCEPT)
Used to combine two complete queries.
```sql
SELECT name FROM A
UNION
SELECT name FROM B;
```

### Key Set-Operation Patterns
A − B
```sql
SELECT * FROM A
EXCEPT
SELECT * FROM B;
```
### Overlap (A ∩ B)
```sql
SELECT * FROM A
INTERSECT
SELECT * FROM B;
```

### A-only + B-only 
```sql
SELECT * FROM A EXCEPT SELECT * FROM B
UNION ALL
SELECT * FROM B EXCEPT SELECT * FROM A;
```