# sakila query explanation

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