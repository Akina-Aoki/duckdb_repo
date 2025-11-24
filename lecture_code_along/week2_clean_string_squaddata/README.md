# In-class exercise, week 2
This exercise covers knowledge in chapter 8. The background is that you are a data engineer responsible for the AI team and analyze the response data from an AI model doing reading comprehension. 

Follow the tasks below: 

## Task 1
You are asked to create a database with:
- a schema called *staging*
- a table under the schema, called *squad*

Use the file *validation.csv* from [kaggle](https://www.kaggle.com/datasets/thedevastator/squad2-0-a-challenge-for-question-answering-syst) to ingest rows into table. [Here](https://rajpurkar.github.io/SQuAD-explorer/) you can learn more about the background of this dataset. 

## Task 2
Find rows that do not contain the *title* column value in the *context* column value.

## Task 3
Find rows that start with *title* column value in the *context* column value.

Breakdown:

context

This is the long text field where the reading passage lives.

title

This is the shorter text that describes or summarizes the passage.

LENGTH(title)

This calculates how many characters are in the title.

Example:

If title = 'School Life' → LENGTH(title) = 11 characters (including the space).

SUBSTR(context, 1, LENGTH(title))

SUBSTR = “substring”, meaning “take part of the text.”

The arguments are:

context → which text to cut from.

1 → start position. Here it means start at the first character of context.

LENGTH(title) → how many characters to take.

So this means:
“Take the first N characters of context, where N is the length of title.”

Example:

title = 'School Life'

context = 'School Life is very different in Japan...'

LENGTH(title) = 11

SUBSTR(context, 1, 11) = 'School Life'

SUBSTR(context, 1, LENGTH(title)) = title

Now we compare:
“Are the first N characters of context exactly equal to title?”

If yes → the row matches and is returned.

If not → the row is filtered out.

So the full WHERE line means:

“Keep only the rows where the context text starts with the exact same characters as the title value.”

## Task 4
Create a new column which is the first answer of the AI model. Do not use pattern matching in your query.

## Task 5
Create a new column which is the first answer of the AI model. Use pattern matching in your query.


# Cleaning the squaddata
- Using regular expression, indexing, slicing