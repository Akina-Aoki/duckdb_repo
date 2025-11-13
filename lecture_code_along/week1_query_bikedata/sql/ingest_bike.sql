/*Create a schema and table to ingest bike data from csv files in one command line
*/

-- First create a schema. Common practice is to name schema as staging
CREATE SCHEMA IF NOT EXISTS staging; 


CREATE TABLE
    IF NOT EXISTS staging.orders AS ( -- create a table named orders in staging schema
        SELECT
            *
        FROM
            read_csv_auto ('data/orders.csv')  -- specify the path to the csv file
    );


CREATE TABLE
    IF NOT EXISTS staging.customers AS ( -- create a table named customers in staging schema
        SELECT
            *
        FROM
            read_csv_auto ('data/customers.csv')  -- specify the path to the csv file
    );