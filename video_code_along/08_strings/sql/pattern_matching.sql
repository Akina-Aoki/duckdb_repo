/* ===========================
   Pattern matching with 
   LIKE operator and wildcards
   =========================== */

-- use LIKE operator in WHERE clause to filter rows
-- LIKE operator is often used with wildcards to search for a pattern
-- wildcard % matches 0 or more characters  

/*
Explanation of the pattern:
- 'select%' means the string starts with 'select' followed by any number of characters (
*/
SELECT
  	example,
  	lower(trim(example)) as cleaned_example
FROM
	staging.sql_glossary
WHERE
	cleaned_example LIKE 'select%';



/*wildcard _ represents one character
explanation of the pattern:
- 'S_LECT%' means the string starts with 'S', followed by any single character
*/
SELECT
  	example,
  	trim(example) as cleaned_example
FROM
	staging.sql_glossary
WHERE
	cleaned_example LIKE 'S_LECT%'; -- matches SELECT, SLECT, S1LECT, etc.


/* ===========================
   Pattern matching with 
   regular expression
   =========================== */

/* use regexp_matches function with WHERE clause to filter rows starting with c
pattern explanation:
- ^c means the string starts with character 'c'
*/
SELECT
  	lower(trim(description)) as cleaned_description
FROM
	staging.sql_glossary
WHERE 
	regexp_matches(cleaned_description, '^c');


/* to filter rows starting with C or S
pattern explanation:
- ^[CS] means the string starts with either 'C' or 'S'
*/
SELECT
  	trim(description) as cleaned_description
FROM
	staging.sql_glossary
WHERE 
	regexp_matches(cleaned_description, '^[CS]');


/*makes it match exactly select word (for example, not selects)
pattern explanation:
- \b is a word boundary anchor meaning the position between a word character (like a letter or digit) and a non-word character (like a space or punctuation)
*/
SELECT
	lower(description)
FROM
	staging.sql_glossary
WHERE
	regexp_matches (lower(description), 'select\b')



/* [a-f] matches a range of characters
^[a-f] means starting with characters a to f
pattern explanation:
- ^ indicates the start of the string, meaning the first character should be in the range a to f
*/
SELECT
	lower(trim(description)) as cleaned_description
FROM
	staging.sql_glossary
WHERE 
  	regexp_matches (cleaned_description, '^[a-f]')



/*[^a-f] matches any character NOT in the range of a-f
^[^a-f] means starting with characters NOT in the range of a-f
pattern explanation:
- ^ inside the square brackets negates the character class, meaning it matches any character that is not in the specified range
*/
SELECT
	lower(trim(description)) as cleaned_description
FROM
	staging.sql_glossary
WHERE 
  	regexp_matches (cleaned_description, '^[^a-f]')


/*-- use regexp_replace function to replace a pattern with a string
' +' matches 1 or more spaces
'g' is the global flag to replace all occurences of the pattern
pattern explanation:
' +' matches one or more spaces, so it will find sequences of multiple spaces and replace them with a single space
*/
SELECT
	description,
	regexp_replace (description, ' +', ' ', 'g') AS cleaned_description,
FROM
	staging.sql_glossary;







