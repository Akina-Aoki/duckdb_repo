## Text Functions and Operators in SQL

| Function/Operator | What it Does                                | Example Usage                                 | Result / Description                         |
|-------------------|---------------------------------------------|-----------------------------------------------|----------------------------------------------|
| `||` (Concatenate)| Joins two strings together                   | `'Hello' || ' World'`                         | `Hello World`                                |
| `CONCAT(str1, str2, ...)` | Joins two or more strings            | `CONCAT('SQL', ' is', ' fun')`                | `SQL is fun`                                 |
| `LENGTH(str)`     | Gives the number of characters in a string   | `LENGTH('hello')`                             | `5`                                          |
| `LOWER(str)`      | Converts all letters to lowercase            | `LOWER('SQL Fun')`                            | `sql fun`                                    |
| `UPPER(str)`      | Converts all letters to uppercase            | `UPPER('Sql fun')`                            | `SQL FUN`                                    |
| `TRIM(str)`       | Removes spaces at the beginning and end      | `TRIM(' hello ')`                             | `hello`                                      |
| `LTRIM(str)`      | Removes spaces at the beginning only         | `LTRIM('   hi!  ')`                           | `hi!  `                                      |
| `RTRIM(str)`      | Removes spaces at the end only               | `RTRIM('  hi!   ')`                           | `  hi!`                                      |
| `SUBSTRING(str, start, length)` | Gets part of a string          | `SUBSTRING('abcdef', 2, 3)`                   | `bcd`                                        |
| `LEFT(str, n)`    | Gets the first n characters                  | `LEFT('banana', 3)`                           | `ban`                                        |
| `RIGHT(str, n)`   | Gets the last n characters                   | `RIGHT('banana', 2)`                          | `na`                                         |
| `REPLACE(str, find, replace_with)` | Replaces part of a string   | `REPLACE('cat', 'c', 'b')`                    | `bat`                                        |
| `POSITION(substr IN str)` | Finds where substring starts         | `POSITION('a' IN 'carrot')`                   | `2`                                          |
| `INSTR(str, substr)` | Finds position of substring (some DBs)    | `INSTR('carrot', 'rr')`                       | `3`                                          |
| `REVERSE(str)`    | Reverses the string                         | `REVERSE('hello')`                            | `olleh`                                      |
| `LIKE`            | Simple pattern search with wildcards         | `name LIKE 'A%'`                              | Finds values starting with A                  |
| `ILIKE`           | Case-insensitive LIKE (some DBs)             | `name ILIKE '%duck%'`                         | Finds values containing `duck` (any case)     |
| `REGEXP` / `~`    | Match regular expressions (advanced search)  | `col ~ '^A.*'`                                | Finds text starting with 'A'                  |

### Key
- Use `||` or `CONCAT` to join strings.
- Use `LOWER` and `UPPER` to standardize letter case.
- Use `LIKE` with `%` to search for patterns (`%` means any number of characters).
- Use `SUBSTRING`/`LEFT`/`RIGHT` to extract part of a string.
- Use `REPLACE` to swap out parts of text.


## String Concepts
When working with databases, it's often needed to store and manage text - names, addresses, comments, etc. Databases use different "data types" for storing strings (text). Here’s a simple guide to the most common ones:

- CHAR(n):
Stores strings of a fixed length (n characters). If your text is shorter, the database pads it with spaces.
Example: If you store 'hi' in CHAR(5), it becomes 'hi '.

- VARCHAR(n):
Stores strings up to a maximum of n characters. Doesn’t pad with spaces—just uses what’s needed.
Example: 'hello' in VARCHAR(20) is just 'hello'.

- TEXT / STRING:
Stores text, usually with a big or unlimited length. Good for long pieces of text, like descriptions or comments.

- NVARCHAR(n):
Like VARCHAR(n), but supports more characters from many different languages ("Unicode characters").

- NCHAR(n):
Like CHAR(n), but also supports Unicode.

- BLOB:
Stores binary data (like images or files). Not usually for regular text.

- Wildcards
When searching for text, you can use wildcards (like % for any number of characters) to find similar matches.
Example: LIKE 'A%on' finds names like 'Aaron' or 'Alon'.

## Regex (Regular Expressions):
More powerful way to search for patterns in text. Useful for checking formats, like emails or phone numbers.

| Type/Concept    | What is it?                           | Simple Example                         | Notes                                  |
|-----------------|---------------------------------------|----------------------------------------|----------------------------------------|
| `CHAR(n)`       | Fixed-length text                     | `CHAR(5)` stores 'hi' as 'hi   '      | Always uses `n` characters             |
| `VARCHAR(n)`    | Variable-length text                  | `VARCHAR(10)` stores 'hi' as 'hi'     | Uses only as much space as needed      |
| `TEXT` / `STRING` | Long text, no max length usually    | `TEXT` stores a whole paragraph        | Great for comments or descriptions     |
| `NVARCHAR(n)`   | Variable-length, supports all languages| `NVARCHAR(20)` stores 'こんにちは'     | Stores international (Unicode) text    |
| `NCHAR(n)`      | Fixed-length Unicode text             | `NCHAR(4)` stores 'AB' as 'AB  '      | Supports international characters      |
| `BLOB`          | Not for text! Stores files/images     | `BLOB` for a picture, not 'hello'      | Use only if storing non-text data      |
| `LIKE`          | Search with wildcards                 | `LIKE 'A%son'` matches 'Alison'       | `%` = any characters; `_` = any one    |
| `REGEXP`        | Pattern search with regex             | `REGEXP '^[A-Z][a-z]+'`               | Super-flexible text searching          |


## Regex Glossary
| Pattern    | What it means                                   | Beginner explanation                                                                                                                   |
| ---------- | ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `\bword\b` | Match the whole word only.                      | `\b` marks word boundaries (the edges of words). This ensures you match **only “word” as a complete word**, not part of a longer word. |
| `\d`       | Any digit 0–9.                                  | Works like saying “find any single number character”. Useful for detecting dates, prices, phone numbers, etc.                          |
| `\D`       | Anything that is **not** a digit.               | The opposite of `\d`. Helps when you want to ignore numbers and pick up letters or symbols instead.                                    |
| `\s`       | Any whitespace.                                 | This includes spaces, tabs, and line breaks. Good for splitting text or detecting gaps between words.                                  |
| `\S`       | Any non-whitespace.                             | Useful when you want to catch characters that aren’t spaces (letters, numbers, symbols).                                               |
| `\w`       | Letters, numbers, or underscore.                | Think of this as “word characters”. Good for variable names, usernames, etc.                                                           |
| `\W`       | Any character that is **not** a word character. | Captures punctuation or symbols like `!`, `#`, `?`. Opposite of `\w`.                                                                  |
| `^`        | Start of the line.                              | Makes sure the pattern only matches if it appears **at the beginning** of the text.                                                    |
| `$`        | End of the line.                                | Ensures the pattern is found **at the end** of the text.                                                                               |
| `.`        | Any single character.                           | Matches everything except newlines. Good for saying “I don’t care what character is here”.                                             |
| `*`        | Zero or more repeats.                           | The character before `*` can appear many times, or not at all. Example: `a*` can match nothing, or “aaaaa”.                            |
| `+`        | One or more repeats.                            | Similar to `*` but **requires at least one** occurrence: `a+` needs at least one “a”.                                                  |
| `?`        | Optional (0 or 1 time).                         | Means “this character may appear, but doesn’t have to.” Example: `colou?r` matches “color” and “colour”.                               |
| `{n}`      | Exactly n repeats.                              | `a{3}` means exactly “aaa”. Good for validating specific formats.                                                                      |
| `{n,}`     | At least n repeats.                             | `a{2,}` means “aa”, or many more. Useful for enforcing minimum lengths.                                                                |
| `{n,m}`    | Between n and m repeats.                        | A controlled range. `a{2,4}` matches “aa”, “aaa”, or “aaaa”.                                                                           |
| `[abc]`    | One character from the list.                    | Acts like a menu: match “a”, “b”, or “c”.                                                                                              |
| `[^abc]`   | One character *not* in the list.                | The `^` inside brackets flips the logic. Matches anything except “a”, “b”, “c”.                                                        |
| `(abc)`    | A group of characters.                          | Treated as one unit. Useful for capturing or grouping patterns like `(hello)+`.                                                        |
| `a\|b`     |                                                 |                                                                                                                                        |


### Read more

#### From DuckDB Documentation

- **[Text functions specific for DuckDB](https://duckdb.org/docs/sql/functions/strings.html)**
- **[Regular expression specific for DuckDB](https://duckdb.org/docs/sql/functions/regexp.html)**

#### Other Sources

- **[String functions (PostgreSQL)](https://www.postgresql.org/docs/current/functions-string.html)**
- **[String functions (SQLite)](https://www.sqlite.org/lang_corefunc.html#corefunc_string)**
- **[String functions (MySQL)](https://dev.mysql.com/doc/refman/8.0/en/string-functions.html)**
- **[Wildcards (W3Schools)](https://www.w3schools.com/sql/sql_wildcards.asp)**
- **[Regex (MDN)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions)**
- **[Regex Tutorial (W3Schools)](https://www.w3schools.com/js/js_regexp.asp)**
- **[Regex Cheat Sheet (Regex101)](https://regex101.com/cheat-sheet)**
- **[Regex Cheat Sheet (MDN)](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_expressions/Cheatsheet)**