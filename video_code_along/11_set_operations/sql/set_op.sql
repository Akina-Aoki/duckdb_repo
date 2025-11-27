-- Combine sales data from January and February, removing duplicates
SELECT * FROM synthetic.sales_jan
UNION
SELECT * FROM synthetic.sales_feb;

-- Combine sales data from January and February, removing duplicates, selecting specific columns
SELECT product_name, amount FROM synthetic.sales_jan
UNION
SELECT product_name, amount FROM synthetic.sales_feb;


-- Combine sales data from January and February, including duplicates
SELECT product_name, amount FROM synthetic.sales_jan
UNION ALL
SELECT product_name, amount FROM synthetic.sales_feb;


-- nothing is returned since there are no common rows between the two tables
SELECT * FROM synthetic.sales_jan
INTERSECT 
SELECT * FROM synthetic.sales_feb;

-- returns their common row
SELECT product_name, amount FROM synthetic.sales_jan
INTERSECT 
SELECT product_name, amount FROM synthetic.sales_feb;


-- take everything from A table (jan) and remove anything from B table (feb)
SELECT product_name, amount FROM synthetic.sales_jan
EXCEPT 
SELECT product_name, amount FROM synthetic.sales_feb;