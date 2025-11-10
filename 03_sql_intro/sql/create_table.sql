/* 
Create a DATA DEFINITION LANGUAGE - defines what we want to create in the jokes_text table.
- if the table doesn't exist, create that table
- id primary key means it is unique
- VARCHAR means string
- INTEGER means inetger
 */
CREATE TABLE
    IF NOT EXISTS funny_jokes (
        id INTEGER PRIMARY KEY,
        joke_text VARCHAR,
        rating INTEGER
    );