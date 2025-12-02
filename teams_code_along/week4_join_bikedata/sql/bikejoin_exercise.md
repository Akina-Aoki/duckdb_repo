# In-class exercise, week 4
This exercise covers knowledge in chapter 12 and previous chapters. We will focus on understanding different types of joins using the bike data we used in week 1. 

Glance through the below before you start: 
- the documentation of the data in [kaggle](https://www.kaggle.com/datasets/dillonmyrick/bike-store-sample-database?select=order_items.csv).
- duckdb documentation on OUTER JOIN (LEFT, RIGHT, FULL) and INNER JOIN [HERE](https://duckdb.org/docs/stable/sql/query_syntax/from)


## Task 1
We will work on the *order_items.csv* and *products.csv* from kaggle. 

Create a database called *bikejoin* with a *staging* schema. Then, create two tables under the *staging* schema to store the data of the two csv files. Use the csv file names for table names. 

## Task 2
The *products* table stores all distinct prodcuts available in the bike store, while the *order_items* table stores order history from customers. 

Check the number of distinct *product_id* in each of these tables. Is the number different between the tables? And why? 

## Task 3
We can perform different join operations on these two tables. It's important to understand if they lead to the same of different results, and why.

Compare queries by groups. Are they doing the same thing and generate the same results, for instance, the same no. of rows? 

Group 1:
```sql
SELECT oi.product_id
FROM staging.products p
JOIN staging.orders_items oi
ON oi.product_id = p.product_id;

SELECT oi.product_id
FROM staging.products p
INNER JOIN staging.orders_items oi
ON oi.product_id = p.product_id;

SELECT oi.product_id
FROM staging.products p
LEFT JOIN staging.orders_items oi
ON oi.product_id = p.product_id;
```

Group 2:
```sql
SELECT oi.product_id
FROM staging.orders_items oi
INNER JOIN staging.products p
ON oi.product_id = p.product_id;

SELECT oi.product_id
FROM staging.orders_items oi
LEFT JOIN staging.products p
ON oi.product_id = p.product_id;

SELECT oi.product_id
FROM staging.orders_items oi
RIGHT JOIN staging.products p
ON oi.product_id = p.product_id;
```

Group 3:
```sql
SELECT *
FROM staging.orders_items oi
INNER JOIN staging.products p
ON oi.product_id = p.product_id
WHERE oi.product_id IS NULL;

SELECT *
FROM staging.orders_items oi
RIGHT JOIN staging.products p
ON oi.product_id = p.product_id
WHERE oi.product_id IS NULL;
```