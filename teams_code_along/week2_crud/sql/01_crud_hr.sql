-- SETUP:
-- Create an empty database (duckdb -ui hr.duckdb)
-- adelo@Aira MINGW64 ~/de25/aira_sql/teams_code_along/week2_crud (main)
-- $ duckdb -ui hr.duckdb

/* **********************************************************************
 Task 1.              DDL: Create Schema and Table         
 *********************************************************************** */
-- Create schema
CREATE SCHEMA IF NOT EXISTS staging;

-- Create sequence to generate value for employee_id column later
-- id_sequence will start from 1 because the first employee employed should have employee_id = 1
CREATE SEQUENCE IF NOT EXISTS id_sequence START 1; 

-- Create table
CREATE TABLE IF NOT EXISTS staging.employees ( --- Table name
    employee_id INTEGER DEFAULT nextval('id_sequence'), -- Column 1
    department VARCHAR, -- Column 2
    employment_year INTEGER -- Column 3
);

/*
***********************************************************************
            Code Explanation
Explanation: employee_id INTEGER DEFAULT nextval('id_sequence')
- employee_id is of type INTEGER
- DEFAULT nextval('id_sequence') means that if no value is provided for employee_id during insertion, the next value from the sequence 'id_sequence' will be used automatically.
This ensures that each employee gets a unique identifier without manual input.
    ***********************************************************************
*/  

/* **********************************************************************
    Task 2.    CRUD: Create         
 *********************************************************************** */
-- Insert 3 rows manually
INSERT INTO staging.employees(department, employment_year) -- explanation: employee_id will be auto-generated
VALUES -- insert values in department and employment_year columns
    ('Sales', 2001), -- first row
    ('Logistics', 2002), -- second row  
    ('IT', 2002);    -- third row


-- check the record of employees
SELECT * FROM staging.employees;

-- Ingest from CSV file
-- https://duckdb.org/docs/stable/data/overview
INSERT INTO staging.employees (department, employment_year)
SELECT * FROM read_csv('data/employees.csv');

-- check the record of employees
SELECT * FROM staging.employees;

-- check the record of employees after ingesting from csv
SELECT * FROM staging.employees;



/* **********************************************************************
 Task 3.              CRUD READ; Update Records         
 *********************************************************************** */ 
-- Update employment_year for employee_id 98 and 99
UPDATE staging.employees -- specify the table to update

-- set new value for employment_year column
SET employment_year = 2023 -- set the new employment_year

-- specify the condition to update only employee_id 98 and 99, could include multiple values using IN clause
WHERE employee_id IN (98, 99); 

-- check the record of employees after update
SELECT * FROM staging.employees;

/* **********************************************************************
    Task 4      CRUD ALTER      
 *********************************************************************** */ 
ALTER TABLE staging.employees
ADD COLUMN pension_plan VARCHAR DEFAULT 'plan 1'; -- add new column salary of type INTEGER

/* **********************************************************************
                  CRUD UPDATE      
 *********************************************************************** */ 
-- After 2015, update pension_plan from 1 -> 2
UPDATE staging.employees
SET pension_plan = 'plan 2'
WHERE employment_year > 2015;


/* **********************************************************************
    Task 5.      CRUD DELETE      
 *********************************************************************** */ 
 -- Always check the rows you want to delete first
SELECT * FROM staging.employees
WHERE employee_id = 1; 

-- once green light from the employer to delete, proceed to delete
DELETE FROM staging.employees
WHERE employee_id = 1;


/* **********************************************************************
    Task 6.      CRUD     
 *********************************************************************** */ 
