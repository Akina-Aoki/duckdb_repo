# Exercise 2 - querying multiple tables
**Actual sql queries in their corresponding folder.

#### TASK 0: Cleaning malformed text data 
Find the sql files in video_code_along/09_temporal_data

#### TASK 1: More extensive EDA on the sakila database
Find the sql files in video_code_along/11_set_operations


## Theory questions

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

| terminology        | explanation                                                                                                                                                                                                                                                              |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **temporal**       | Refers to *time-based data*, such as dates, timestamps, intervals, durations. Temporal queries answer questions like “What trains departed last Monday?” or “What is the delay difference between scheduled and actual time?”                                            |
| **interval**       | A *time duration* (e.g., “2 hours”, “3 days”). Often used for calculations.<br><br>Example:<br>`sql\nSELECT NOW() + INTERVAL '2 hours';`                                                                                                                                 |
| **synthetic**      | Data that is *artificially generated* instead of collected from the real world. Used for testing, training, teaching.                                                                                                                                                    |
| **VALUES**         | A SQL constructor used to create *inline rows* without a table.<br><br>Example:<br>`sql\nSELECT * FROM (VALUES (1, 'A'), (2, 'B')) AS t(id, label);`                                                                                                                     |
| **subquery**       | A query *inside* another query. It acts like a temporary table.<br><br>Example:<br>`sql\nSELECT * FROM (SELECT * FROM trains WHERE delay_minutes > 10);`                                                                                                                 |
| **compound query** | A query made by *combining multiple SELECTs* using set operations such as `UNION`, `INTERSECT`, or `EXCEPT`.                                                                                                                                                             |
| **set operations** | Operations that treat results like mathematical sets. They compare *whole rows* between SELECT statements.<br><br>**Includes:**<br>- `UNION`<br>- `UNION ALL`<br>- `INTERSECT`<br>- `EXCEPT`<br><br>Visual:<br>`\nA ∪ B  (UNION)\nA ∩ B  (INTERSECT)\nA - B  (EXCEPT)\n` |
| **EXCEPT**         | Returns rows that exist in **A** but not in **B**.<br><br>Venn diagram style:<br>`\n A: ●●●●●\n B:   ●●\n A EXCEPT B = only the left circle\n`                                                                                                                           |
| **result set**     | The output table that a SQL query returns.                                                                                                                                                                                                                               |
| **UNION**          | Combines two result sets and **removes duplicates**.<br><br>`\n A = {1,2,3}\n B = {3,4}\n A UNION B = {1,2,3,4}\n`                                                                                                                                                       |
| **UNION ALL**      | Combines two result sets and **keeps duplicates**.<br><br>`\n A = {1,2,3}\n B = {3,4}\n A UNION ALL B = {1,2,3,3,4}\n`                                                                                                                                                   |
| **operator**       | A symbol/keyword that performs an action, such as `+`, `=` , `LIKE`, `UNION`.                                                                                                                                                                                            |
| **INTERSECT**      | Returns only rows that exist *in both sets*. <br><br>Diagram:<br>`\n A ∩ B  (overlapping part)\n`                                                                                                                                                                        |
| **venn diagram**   | A visual tool to show relationships between sets (like A ∪ B, A ∩ B). Often used to explain set operations.                                                                                                                                                              |
| **LEFT JOIN**      | Returns **all rows from the left table**, and matching rows from the right. Missing matches become NULL.<br><br>Diagram:<br>`\nLEFT: ●●●●●\nRIGHT:   ●●\nResult: keep all from LEFT\n`                                                                                   |
| **INNER JOIN**     | Returns only rows that match in *both* tables.<br><br>Diagram:<br>`\nA ●●●\nB   ●●●\noverlap = INNER JOIN\n`                                                                                                                                                             |
| **RIGHT JOIN**     | Opposite of LEFT JOIN: keep all rows from the right table and matching rows from the left.                                                                                                                                                                               |
| **LIKE**           | A simple pattern-matching operator.<br><br>Examples:<br>`sql\nWHERE city LIKE 'Stock%'\nWHERE name LIKE '%son'\n`                                                                                                                                                        |
| **ILIKE**          | Case-insensitive version of LIKE.<br><br>`sql\nWHERE city ILIKE 'stock%'\n`                                                                                                                                                                                              |
| **regexp**         | Pattern matching using *regular expressions*, more powerful than LIKE.<br><br>`sql\nWHERE email ~ '^[a-z]+@[a-z]+\\.com$'\n`                                                                                                                                             |

## JOINS
```sql
INNER JOIN     → overlap only
LEFT JOIN      → everything from LEFT + matches
RIGHT JOIN     → everything from RIGHT + matches
FULL JOIN      → all rows from both sides (DuckDB supports it)
```

## Set Operations
```sql
UNION          → combine sets, remove duplicates
UNION ALL      → combine sets, keep duplicates
INTERSECT      → intersection (overlap)
EXCEPT         → rows in A but not in B
```

```css
A ∪ B   → UNION
A ∩ B   → INTERSECT
A - B   → EXCEPT
```

## JOINS
![alt text](image-2.png)

## String Matching
```sql
LIKE           → basic patterns
ILIKE          → case-insensitive
regexp (~)     → advanced patterns
```

## Interval
```sql
SELECT NOW() + INTERVAL '3 days';
```

## Synthetic
![alt text](image-1.png)
[What is Synthetic Data Generation? (K2View)](https://www.k2view.com/what-is-synthetic-data-generation/)

## Values
A SQL constructor for creating inline rows.
```sql
SELECT * FROM (VALUES (1, 'A'), (2, 'B')) AS t(id, label);
```

## Subquery
A query inside another query.
Used like a temporary table.
```sql
Main Query
└── Subquery
    └── Data
```

## Compound Query
A query built using set operators like:
UNION, UNION ALL, INTERSECT, EXCEPT
They allow combining whole result sets.

## LIKE
Basic pattern matching.
```sql
WHERE name LIKE 'Stock%'
```

## ILIKE
Case-insensitive LIKE.
```sql
WHERE name LIKE 'Stock%'
```

## regex
Regular expression matching for extremely flexible patterns.
```sql
WHERE email ~ '^[a-z]+@[a-z]+\\.com$'
```