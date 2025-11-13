/* This SQL script creates a table named 'bike_data' by reading data from CSV files located in the '../data' directory. 
   The 'read_csv_auto' function automatically infers the schema of the CSV files. */
CREATE TABLE
    IF NOT EXISTS bike_data AS (
        SELECT
            *
        FROM
            read_csv_auto ('../data')
    );
    
