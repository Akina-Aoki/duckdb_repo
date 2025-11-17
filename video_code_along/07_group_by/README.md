# 07 – Aggregation & GROUP BY in DuckDB

A walkthrough of data aggregation techniques using SQL’s `GROUP BY`, on a real dataset of Google food searches.  
This readme summarizes the project structure, key aggregation concepts, and practical SQL examples to support fast learning and review.

---

## Project Structure

```
07_group_by/
    ├─ data/
    │   └─ food_search_google.csv      # Main dataset (food searches from Google)
    ├─ sql/
    │   ├─ ingest_food.sql             # Loads CSV data into DuckDB (as table `food`)
    │   ├─ eda_food.sql                # Exploratory Data Analysis (get a feel for the table)
    │   ├─ transformations.sql         # Renames, cleans, and adds year column → `cleaned_food`
    │   └─ group_by.sql                # GROUP BY queries and aggregation demos
    └─ README.md
```

---

## Dataset Summary

**`data/food_search_google.csv`**  
A weekly time series of Google search interest for food items.  
Sample columns:

- `id` — Food item (e.g. frozen-yogurt)
- `googleTopic` — Topic code from Google
- `week_id` — Weekly time window (format: `YYYY-WW`)
- `value` — Number of searches (search interest index value)

---

## Key Concepts: Aggregation & GROUP BY

#### 1. Data Ingestion
Bring the data into DuckDB using `read_csv_auto`:

#### 2. Exploratory Data Analysis (EDA)
Check out the shape and content of the data:

#### 3. Data Transformation
Clean up names, extract year, and provide analysis-ready columns

### 4. Aggregation with `GROUP BY`
```
Raw data (many rows):
-------------------------------------
| food         | number_of_searches |
|--------------|-------------------|
| FROZEN YOGURT| 20                |
| FROZEN YOGURT| 15                |
| FROZEN YOGURT| 12                |
| PIZZA        | 40                |
| PIZZA        | 23                |
| SUSHI        | 17                |
| SUSHI        | 8                 |

After GROUP BY food, SUM(number_of_searches):
-------------------------------------
| food         | total_searches     |
|--------------|-------------------|
| FROZEN YOGURT| 47                |   <-- 20+15+12
| PIZZA        | 63                |   <-- 40+23
| SUSHI        | 25                |   <-- 17+8
```
  
- Raw data has many repeated food rows.
- GROUP BY food collapses all such rows into ONE per food, summing their searches.
- Table becomes smaller and easier to analyze.

---

## Tips & Patterns

- **GROUP BY** combines all rows sharing a value (e.g., all "frozen-yogurt" rows) into one.
- Use **aggregate functions** (`SUM`, `COUNT`, `AVG`, etc.) to summarize grouped data.
- **ORDER BY** helps you find the most or least searched foods quickly.
- **HAVING** filters groups after aggregation (e.g., only foods/years above a certain total).

---

## Further Reading

- [DuckDB: GROUP BY](https://duckdb.org/docs/sql/select.html#group-by)
- [DuckDB: Aggregate Functions](https://duckdb.org/docs/sql/aggregates.html)
- [Modern SQL Aggregation Patterns](https://modern-sql.com/feature/group-by)
