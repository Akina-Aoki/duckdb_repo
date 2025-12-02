# plant and sakila query explanations
This document walks through the two SQL files in this folder:
- `sql/01_generate_data.sql` - creates the plants dataset and inserts sample rows
- `sql/02_joins.sql` - demonstrates different JOIN types using the sample data

# plant data
## Ingestion
1. Create a DuckDB file and run the generator SQL:
```bash
duckdb data/plants.duckdb < sql/01_generate_data.sql
duckdb -ui data/plants.duckdb
```

plants:
```text
plant_id | plant_name | type
1        | Rose       | Flower
2        | Oak        | Tree
3        | Tulip      | Flower
4        | Cactus     | Succulent
5        | Sunflower  | Flower
```

plant_care:
```text
id | plant_id | water_schedule | sunlight
1  | 1        | Daily          | Full Sun
2  | 3        | Weekly         | Partial Sun
3  | 4        | Biweekly       | Full Sun
4  | 6        | Daily          | Shade
```

### 1) LEFT JOIN (plants LEFT JOIN plant_care)
- Return all rows from `plants`. If there is a matching `plant_care` row, include its columns; otherwise return NULL for care columns.

```sql
SELECT p.plant_id, p.plant_name, p.type, pc.water_schedule, pc.sunlight
FROM main.plants p
LEFT JOIN main.plant_care pc ON p.plant_id = pc.plant_id;
```
| Step                                   | Concept                    | Operational Intent                                                                      | Key Insight                                               |
| -------------------------------------- | -------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| **1. Identify the Anchor (FROM)**      | `main.plants`              | Position as the primary dataset in the pipeline.                                        | The “keep-everything” table always sits left.             |
| **2. Identify the Enrichment (JOIN)**  | `main.plant_care`          | Supplement the anchor with value-adding attributes such as watering and sunlight needs. | Enrichment tables *extend*, they don’t replace.           |
| **3. Determine Direction (LEFT JOIN)** | `LEFT JOIN`                | Preserve all rows from the anchor; append matches from the enrichment layer.            | Missing care info surfaces as `NULL`, not missing plants. |
| **4. Establish the Link (ON)**         | `p.plant_id = pc.plant_id` | Bind rows using a shared primary key.                                                   | Ensures accurate, row-level alignment across entities.    |



### 2) RIGHT JOIN (plants RIGHT JOIN plant_care)

```sql
SELECT p.plant_id, p.plant_name, p.type, pc.water_schedule, pc.sunlight
FROM main.plants p
RIGHT JOIN main.plant_care pc ON p.plant_id = pc.plant_id;
```
| Step                                    | Concept                    | Operational Intent                                            | Key Insight                                          |
| --------------------------------------- | -------------------------- | ------------------------------------------------------------- | ---------------------------------------------------- |
| **1. Identify the Anchor (Right Side)** | `main.plant_care`          | Treat the JOIN-second table as the "must-keep-all" dataset.   | In RIGHT JOINs, completeness flows from the right.   |
| **2. Identify the Lookup (Left Side)**  | `main.plants`              | Use only to fetch matching names for existing care schedules. | Acts as a reference table, not a preserved one.      |
| **3. Determine Direction (RIGHT JOIN)** | `RIGHT JOIN`               | Keep all care schedules—even those without matching plants.   | Orphan care entries surface with `NULL` plant names. |
| **4. Establish the Link (ON)**          | `p.plant_id = pc.plant_id` | Bind rows through the shared primary k                        |                                                      |

### 3) INNER JOIN (only matched rows)

```sql
SELECT p.plant_id, p.plant_name, p.type, pc.water_schedule, pc.sunlight
FROM main.plants p
INNER JOIN main.plant_care pc ON p.plant_id = pc.plant_id;
```
| Step                                    | Concept                           | Operational Intent                                                  | Strategic Insight                                                        |
| --------------------------------------- | --------------------------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| **1. Identify the Goal (Intersection)** | High-integrity dataset            | Deliver only rows where both entities have validated relationships. | Zero tolerance for incomplete or orphaned records.                       |
| **2. Select the Tables**                | `main.plants` + `main.plant_care` | Combine anchor + enrichment, with order not impacting result.       | INNER JOIN is direction-agnostic.                                        |
| **3. Determine Direction (INNER)**      | `INNER JOIN`                      | Enforce strict match-filtering across both domains.                 | Non-matching rows are automatically excluded from downstream visibility. |
| **4. Establish the Link (ON)**          | `p.plant_id = pc.plant_id`        | Apply the primary-key match constraint.                             | Only rows satisfying the join condition move forward in the pipeline.    |


### 4) FULL JOIN (all rows from both sides, matching where possible)

```sql
SELECT p.plant_id, p.plant_name, p.type, pc.water_schedule, pc.sunlight
FROM main.plants p
FULL JOIN main.plant_care pc ON p.plant_id = pc.plant_id;
```

| Step                                      | Concept                              | Operational Intent                      | Strategic Insight                                        |
| ----------------------------------------- | ------------------------------------ | --------------------------------------- | -------------------------------------------------------- |
| **1. Identify the Scope (Whole Picture)** | Complete dataset across both domains | Retain every row—matched or unmatched.  | Full visibility → zero data loss.                        |
| **2. Treat Both Tables as Anchors**       | `main.plants` + `main.plant_care`    | Elevate both tables to equal priority.  | Order impacts layout, not filtering behavior.            |
| **3. Determine Direction (FULL JOIN)**    | `FULL JOIN` / `FULL OUTER JOIN`      | Merge all matches plus all non-matches. | Functionally a union of LEFT + RIGHT join outputs.       |
| **4. Establish the Link (ON)**            | `p.plant_id = pc.plant_id`           | Align rows on shared primary key.       | Missing matches surface as `NULL` values on either side. |


### 5) CROSS JOIN
```sql
-- FROM plants p CROSS JOIN plant_care pc;
SELECT p.plant_id, p.plant_name, pc.water_schedule, pc.sunlight
FROM main.plants p
CROSS JOIN main.plant_care pc;
```

| Step                                | Concept                           | Operational Intent                                          | Strategic Insight                                   |
| ----------------------------------- | --------------------------------- | ----------------------------------------------------------- | --------------------------------------------------- |
| **1. Identify the Goal**            | Exhaustive combination generation | Produce every possible pairing of plant × care instruction. | This is a brute-force matrix expansion.             |
| **2. Select the Tables**            | `main.plants` + `main.plant_care` | Feed both datasets into the combinatorial engine.           | Content is not validated for relevance—only volume. |
| **3. Determine Direction (CROSS)**  | `CROSS JOIN`                      | Generate a Cartesian product across both sides.             | Maximizes coverage, not precision.                  |
| **4. Drop the Link (No ON Clause)** | No join condition                 | Skip relational logic entirely; no key alignment.           | Row count becomes `rows_left × rows_right`.         |


--------------------------------------------------------------------------------------------------------------------

# sakila data
## Ingestion

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