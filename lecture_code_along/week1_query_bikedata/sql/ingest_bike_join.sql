/*Create a schema and table to ingest bike data from csv files in one command line
*/

-- First create a schema. Common practice is to name schema as staging
CREATE SCHEMA IF NOT EXISTS staging; 



CREATE TABLE
    IF NOT EXISTS staging.joined_table AS ( -- create a table named joined_table in staging schema
        SELECT
            *
        FROM
            read_csv_auto ('data/joined_table.csv')  -- specify the path to the csv file
    );