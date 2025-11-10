# Setting up the DuckDB database file

Let’s switch to the terminal and initialize a new DuckDB database named `jokes.duckdb`:
```python
duckdb -ui jokes.duckdb
```
Once you’re in the DuckDB shell, run a simple command (for example, DESC;) so that the database is saved to disk. 
After this step, you’ll see a file called `jokes.duckdb` created in your directory.

```python
CREATE TABLE funny_jokes (
    id INTEGER PRIMARY KEY,
    joke_text VARCHAR,
    rating INTEGER
);
```
This statement is part of SQL’s Data Definition Language (DDL). It creates a table named funny_jokes with three columns:

`id` — an integer that acts as the primary key

`joke_text` — the actual joke stored as text

`rating` — a numeric value indicating how funny the joke is

## Inserting Data
Now let’s add some jokes into the table:
```python
INSERT INTO funny_jokes (id, joke_text, rating) VALUES
(1, 'Why don’t scientists trust atoms? Because they make up everything!', 8),
(2, 'Why did the scarecrow win an award? Because he was outstanding in his field!', 7),
(3, 'I told my wife she was drawing her eyebrows too high. She looked surprised.', 9),
(4, 'Why don’t skeletons fight each other? They don’t have the guts.', 6);

```
You can verify the insert worked by checking the contents of the table:
```
SELECT * FROM funny_jokes;
```
The table is stored in the default schema called main. Schemas in DuckDB are like folders — they organize tables and related database objects under a common namespace.

## Describing Database Objects
To inspect what’s inside the database, use the `DESC` command:
```
DESC;
```
This displays available schemas and confirms that main is the default one.
You can also describe a specific table:
```
DESC funny_jokes;
DESC main.funny_jokes;
```
Both commands return the same details about your table’s structure.

## Adding more jokes
Let’s expand the table with more entries:
```
INSERT INTO funny_jokes (id, joke_text, rating) VALUES
(5, 'Why don’t some couples go to the gym? Because some relationships don’t work out.', 8),
(6, 'I would avoid the sushi if I were you. It’s a little fishy.', 7),
(7, 'Want to hear a joke about construction? I’m still working on it.', 6),
(8, 'Why don’t programmers like nature? It has too many bugs.', 9),
(9, 'How does a penguin build its house? Igloos it together.', 1),
(10, 'A Gothenburg person queues for Star Wars tickets. When someone cuts in line, he says "Ge daj!"', 2);

```
