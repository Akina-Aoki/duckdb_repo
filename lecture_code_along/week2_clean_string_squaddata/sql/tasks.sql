/*
## Task 2
Find rows that do not contain the *title* column value in the *context* column value.
 */
-- My solution:
SELECT
    *
FROM
    staging.squad
WHERE
    POSITION NOT (title IN context) = 0;

-- Debbie's solution 1: using regexp_matches function
-- shows rows that have title inside context
SELECT
    title,
    context,
    INSTR (context, title)
FROM
    staging.squad
WHERE
    regexp_matches (context, title);

-- Debbie's solution 2: using regexp_matches function
-- position 0 does not exist because sql starts indexing from 1
-- shows rows that do not have title inside context
SELECT
    title,
    context,
    INSTR (context, title) -- no match if there is no match
FROM
    staging.squad
WHERE
    NOT regexp_matches (context, title);

-- two arguments are string and substring


/*
## Task 3
Find rows that start with *title* column value in the *context* column value.
*/


-- Debbies solution 1: using LIKE with CONCAT
/* query explanation in WHERE by line: */
-- CONCAT (title, '%')  --> creates a pattern that matches any string that starts with
SELECT
    title,
    context
FROM
    staging.squad
WHERE
    context LIKE CONCAT (title, '%')
    -- check the results for 'Southern_California'
    -- the results ae not ok due to the wildcard '_'


-- Debbies solution 2: using LIKE with CONCAT, ^ carrot
/* explanation: 
*/
SELECT
    *
FROM
    staging.squad
WHERE
    regexp_matches (
        context, -- from which column
        CONCAT ('^', title)); -- ^ starts with title



-- The query above is the same as the query below, just a sample here:
SELECT
    *
FROM
    staging.squad
WHERE
    regexp_matches(context, '^Normans')


-- My solution 1 using SUBSTR
SELECT
    *
FROM
    staging.squad
WHERE
    SUBSTR (context, 1, LENGTH (title)) = title;


-- My solution 2 using LIKE
SELECT title, context
FROM staging.squad
WHERE context LIKE title || '%';


/*
Task 4
NO PATTERN MATCHING
- Create a new column which is the first answer of the AI model. Do not use pattern matching in your query.
- Show a new column which is the first answer from the AI model.
*/

SELECT
  answers [18:], -- pick up from 19 using index SLICING
  answers[19],   -- pick up from 19 using INDEXING
  answers
FROM
  staging.squad


-- Clean up the characters in the front before the first answer
SELECT
  answers [18:], -- pick up from 19 using index SLICING
  answers[18],   -- pick up from 19 using INDEXING
  CASE 
    WHEN answers[18] = ',' THEN NULL 
    ELSE answers[18:]
  END AS striped_answers,  
-- CASE WHEN produces a new column called striped answers, cleaning the patterns in the front
  answers
FROM
  staging.squad


-- show a new column which is the first answer from the Ai model.
-- without pattern matching
SELECT 
 answers[18:], -- slicing
 answers[18], -- indexing
 CASE 
  WHEN answers[18] = ',' THEN NULL
  ELSE answers[18:]
 END AS striped_answers,
 INSTR(striped_answers, '''') AS first_quotation_index, -- a single quoation needs to be typed as '',
 striped_answers[:first_quotation_index-1] AS first_answers,
 answers
FROM staging.squad;



/* Task 5
PATTERN MATCHING
Create a new column which is the first answer of the AI model. Use pattern matching in your query.
*/
SELECT
    answers,
    -- capture the outer pattern first, and stop when detecting a character not specified in the pattern
    -- extract the first group in (), not everything in ''
    -- the pattern: ' multiple characters not ' up to ' or ', 
    regexp_extract(answers, '''([^'']+)''') AS first_answer,
    regexp_extract(answers, '''([^'']+)'',') AS first_answer,
    regexp_extract(answers, '''([A-Za-z0-9 ,]+)'',') AS first_answer, -- uppercase, lowercase, digits, space, comma
    regexp_extract(answers, '''([^'']+)''', 1) AS first_answer,
    regexp_extract(answers, '''([^'']+)'',', 1) AS first_answer,
FROM staging.squad;