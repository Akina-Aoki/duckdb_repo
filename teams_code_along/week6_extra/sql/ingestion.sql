CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.students AS (
    SELECT * FROM read_csv_auto('data/students.csv')
);

CREATE TABLE IF NOT EXISTS staging.teachers AS (
    SELECT * FROM read_csv_auto('data/teachers.csv')
);

CREATE TABLE IF NOT EXISTS staging.housing_sales AS (
    SELECT * FROM read_csv_auto('data/housing_sales.csv')
);

CREATE TABLE IF NOT EXISTS staging.neighborhoods AS (
    SELECT * FROM read_csv_auto('data/neighborhoods.csv')
);

CREATE TABLE IF NOT EXISTS staging.categories AS (
    SELECT * FROM read_csv_auto('data/categories.csv')
);

CREATE TABLE IF NOT EXISTS staging.sales AS (
    SELECT * FROM read_csv_auto('data/sales.csv')
);