/* duckdb specific, many other SQL dialects don't have these */

/* index - explnation
   SQL strings are 0 indexed
   negative index counts from the end
   slicing is [start:end] - end is exclusive
*/
SELECT
	sql_word,
	sql_word[0],  -- count from 1
	sql_word[1], 
	sql_word[-1], 
FROM
	staging.sql_glossary;

/* slicing: explanation
   SQL strings are 0 indexed
   negative index counts from the end
   slicing is [start:end] - end is exclusive
*/
SELECT
	sql_word,
	sql_word[:2],
	sql_word[2:5]
FROM
	staging.sql_glossary;
