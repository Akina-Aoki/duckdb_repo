/*Remove leading and trailing spaces from a string explanation of each part:
- TRIM: This function is used to remove specified characters from the beginning and end of a string.
- sql_word: This is the column from which we want to remove the characters.
- ' ': This specifies that we want to remove spaces.
- AS trimmed_string: This renames the output column to 'trimmed_string' for better readability.
- FROM staging.sql_glossary: This specifies the table from which we are selecting the data.*/

SELECT 
    TRIM(sql_word, ' ') AS trimmed_string,
    trimmed_string[1] AS first_character, -- Get the first character of the trimmed string
    trimmed_string[-1] AS last_character  -- Get the last character of the trimmed string
FROM 
    staging.sql_glossary; 


-- Transform character to uppercase
SELECT 
    UPPER(TRIM(sql_word, ' ')) AS upper_string,
    trimmed_string[1] AS first_character, -- Get the first character of the trimmed string
    trimmed_string[-1] AS last_character  -- Get the last character of the trimmed string
FROM 
    staging.sql_glossary; 


-- replace 2 or more spaces with 1 space
SELECT
    description,
    REPLACE(description, '  ', ' ') AS clean_description -- replace double spaces with single space
FROM 
    staging.sql_glossary;


/*concatenate strings
Explanation of each part:
- CONCAT: This function is used to combine two or more strings into one.
- UPPER: This function converts all characters in a string to uppercase.
- TRIM: This function removes leading and trailing spaces from a string.
- sql_word: This is the column from which we want to create the new string.*/
SELECT
    CONCAT(upper(trim(sql_word, ' ')), ' command') AS sql_command,
FROM
    staging.sql_glossary;

-- concatenate strings using ||
SELECT
    upper(trim(sql_word, ' ')) || ' command' AS sql_command,
FROM
    staging.sql_glossary;



/* remove leading and trailing spaces
explanation: TRIM function removes spaces from both ends of the string.
- Substring function extracts a portion of the string starting from position 1 to 5.
- The result is a new column showing the first five characters of the trimmed string.*/
SELECT
    TRIM(sql_word) AS trimmed_string,
    substring(TRIM(sql_word),1, 5) AS first_five_chars,
    trimmed_string[1:5] AS sliced_five_chars
FROM
    staging.sql_glossary;

/* reverse characters
- explanation: The REVERSE function takes a string and returns it with the characters in reverse order.
- Here, we first trim the sql_word to remove any leading or trailing spaces, then extract the first five characters using SUBSTRING, and finally reverse those characters.
- The result is a new column showing the first five characters of the trimmed string in reverse order.
- Note: Adjust the number of characters in the SUBSTRING function as needed.*/

SELECT 
	reverse(substring(trim(sql_word), 1, 5)) as reversed_word
FROM staging.sql_glossary


/* find the position of the first occurence of a substring
return zero if the substring is not found.

Explanation of each part:
- INSTR: This function returns the position of the first occurrence of a substring within a string.
- description: This is the column in which we are searching for the substring.
- 'select': This is the substring we are looking for within the description.
- AS select_position: This renames the output column to 'select_position' for better readability
- FROM staging.sql_glossary: This specifies the table from which we are selecting the data.*/
SELECT 
	description, 
	instr(description, 'select') as select_position,
	select_position != 0 as about_select
FROM staging.sql_glossary

-- concatenation
SELECT 'fun' || ' joke'