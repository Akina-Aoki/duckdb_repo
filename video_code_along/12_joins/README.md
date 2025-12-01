# plant and sakila query explanations
This document walks through the two SQL files in this folder:
- `sql/01_generate_data.sql` - creates the plants dataset and inserts sample rows
- `sql/02_joins.sql` - demonstrates different JOIN types using the sample data

## plant data
### Ingestion
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
#### Identify the Anchor (FROM)
Start with main.plants because this is the primary dataset.
Rule: The table you want to keep complete goes first.

#### Identify the Enrichment (JOIN)
Select main.plant_care as the secondary table.
Purpose: To fetch additional attributes (water/sunlight) corresponding to the anchor.

#### Determine Direction (LEFT)
Use LEFT JOIN to prioritize the Anchor table.
Logic: "If a plant has no care instruction, keep the plant and show NULL for care. Do not delete the plant."

#### Establish the Link (ON)
Map the relationship using the shared Primary Key (plant_id).
Mechanism: p.plant_id = pc.plant_id ensures data from the right table attaches to the correct row in the left table.


### 2) RIGHT JOIN (plants RIGHT JOIN plant_care)

```sql
SELECT p.plant_id, p.plant_name, p.type, pc.water_schedule, pc.sunlight
FROM main.plants p
RIGHT JOIN main.plant_care pc ON p.plant_id = pc.plant_id;
```
#### Identify the Anchor (The Right Side)
Treat main.plant_care (the table after JOIN) as the primary dataset.
Rule: In a Right Join, the table listed second is the one you keep complete.

#### Identify the Lookup (The Left Side)
Use main.plants (the table after FROM) merely to look up names.
Purpose: To see if you can find a name for the care instructions in your list.

#### Determine Direction (RIGHT)
Use RIGHT JOIN to prioritize the plant_care table.
Logic: "I want to see every single care schedule I have on file. If a schedule exists for a Plant ID that isn't in my plants table (an 'orphan' record), keep the schedule and just show NULL for the plant name."

#### Establish the Link (ON)
Map the relationship using the shared Primary Key (plant_id).

Mechanism: p.plant_id = pc.plant_id connects the two, but the "Right" table controls which rows stay.

### 3) INNER JOIN (only matched rows)

```sql
SELECT p.plant_id, p.plant_name, p.type, pc.water_schedule, pc.sunlight
FROM main.plants p
INNER JOIN main.plant_care pc ON p.plant_id = pc.plant_id;
```
#### Identify the Goal (The Intersection)
You only want data where both pieces of information exist.
Rule: "No unmatched data allowed."

#### Select the Tables
Start with main.plants (Anchor) and join main.plant_care (Secondary).

Note: In an Inner Join, the order of tables technically doesn't matter for the final result.

#### Determine Direction (INNER)
Use INNER JOIN to strictly filter the results.

Logic: "If a plant has no care instructions, hide it. If a care instruction has no matching plant, hide it. Only give me the rows that are perfect matches."

#### Establish the Link (ON)

Map the relationship using the shared Primary Key (plant_id).

Mechanism: p.plant_id = pc.plant_id acts as the filter. Rows are only kept if this condition is true.

### 4) FULL JOIN (all rows from both sides, matching where possible)

```sql
SELECT p.plant_id, p.plant_name, p.type, pc.water_schedule, pc.sunlight
FROM main.plants p
FULL JOIN main.plant_care pc ON p.plant_id = pc.plant_id;
```

#### Identify the Scope (The Whole Picture)
You want to retain all data from both tables, regardless of whether they match.
Rule: "Leave no row behind."

#### Treat Both Tables as Anchors
main.plants and main.plant_care are treated as equally important.

Note: The order implies column arrangement, but not data filtration.

#### Determine Direction (FULL)
Use FULL JOIN (or FULL OUTER JOIN) to combine the results of both a Left and Right join.

Logic: "Show me the perfect matches, PLUS the plants with no care info, PLUS the care info with no plants. I want to see everything, including the 'orphans' on both sides."

#### Establish the Link (ON)
Map the relationship using the shared Primary Key (plant_id).

Mechanism: If a match is found, join them. If a row in either table has no match, display it anyway and fill the missing side with NULL.


### 5) CROSS JOIN
```sql
-- FROM plants p CROSS JOIN plant_care pc;
SELECT p.plant_id, p.plant_name, pc.water_schedule, pc.sunlight
FROM main.plants p
CROSS JOIN main.plant_care pc;
```

#### Identify the Goal 
You want to create every possible combination of rows.Rule: "Pair every single plant with every single care instruction, regardless of whether they belong together."Select the Tablesmain.plants and main.plant_care.

#### Determine Direction (CROSS)
Use CROSS JOIN (Cartesian Product)
Logic: This is not a "match"; it is a "mix-and-match." It forces every row on the left to pair with every row on the right.

#### Drop the Link (NO ON Clause)Crucial Difference:
Unlike all other joins, you do not write ON p.plant_id = ....Mechanism: There is no condition. If you have 10 plants and 10 care instructions, you will get 100 rows ($10 \times 10$) in your result.

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