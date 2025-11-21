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

## Task 4
Create a new column which is the first answer of the AI model. Do not use pattern matching in your query.

## Task 5
Create a new column which is the first answer of the AI model. Use pattern matching in your query.


# Cleaning the squaddata
- Using regular expression, indexing, slicing