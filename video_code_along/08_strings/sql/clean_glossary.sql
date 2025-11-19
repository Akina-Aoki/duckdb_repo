-- transformations to clean glossary data
/* explanation pattern:
- UPPER(TRIM(sql_word)) : sql_word is converted to uppercase and leading/trailing spaces are removed
- AS sql_word : renames the resulting column to sql_word
*/
CREATE SCHEMA IF NOT EXISTS refined;

CREATE TABLE IF NOT EXISTS refined.sql_glossary AS (
    SELECT
    UPPER(TRIM(sql_word)) AS sql_word,
    description,
    example
    FROM staging.sql_glossary
);