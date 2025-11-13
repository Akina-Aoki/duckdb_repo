# DuckDB Setup and Data Ingestion Guide 
This document walks you through installing DuckDB, setting up your environment, and creating your first database with CSV ingestion. It includes notes for both Windows (Git Bash) and macOS/Linux users.
  **Note**
  This repository is part of my SQL course at Stockholms Tekniska Institut, guided by AIgineer.
  It serves as my learning log, documenting my step-by-step setup, troubleshooting, and practical use of DuckDB for data engineering exercises.
  
## Summary
1. Install DuckDB and verified setup
2. Creat a persistent database file
3. Ingest a CSV into a DuckDB table
4. Use CLI and UI to query data
5. Learn essential bash and meta commands
6. Configure `.gitignore` for clean versioning


## 1. Installation and Setup
Follow the [official DuckDB installation guide](https://duckdb.org/install/?platform=macos&environment=cli) to download the correct version for your operating system.

**For macOS**
You can install DuckDB via Homebrew:
``` bash
brew install duckdb
```

**For Windows**
Download the Windows binary from DuckDB’s official site and add it to your PATH.
To verify it’s accessible, open Git Bash and run:

``` bash
duckdb --version
```
If the command shows a version number, DuckDB is correctly installed.

## 2. Setting Up Your Terminal
**On Windows**
Use Git Bash, not Command Prompt or PowerShell.
You can open a terminal directly in **VS Code** and set Git Bash as the default shell:

- `Press Ctrl + Shift + P`
- Search for **“Select Default Profile”**
- Choose Git Bash

**On macOS or Linux**
Use your built-in terminal app.

## 3. Essential Bash Commands
When navigating your local project, these are the core commands you’ll use:

| Command | Description                                                     |
| ------- | --------------------------------------------------------------- |
| `cd`    | Change the current working directory                            |
| `cd ..` | Move one level up in the folder hierarchy                       |
| `ls`    | List visible files and folders in the directory                 |
| `ls -a` | List *all* files including hidden ones (like `.venv` or `.git`) |
| `pwd`   | Print the full path of your current directory                   |
| `<`     | Input redirection — used to pass an SQL file into DuckDB        |

**Note:**
Bash is case-sensitive and spacing matters. If you ever see “No such file or directory,” check your path carefully.

## 4. Running DuckDB in the CLI
Once installed, you can start a DuckDB session right from the terminal.
Navigate into your project folder and run:
``` bash
duckdb test_yt.duckdb
```
This creates a persistent database file `(test_yt.duckdb)` that will automatically save changes to disk when you execute commands.
Now, try a few commands:
``` sql
-- View structures of database objects
DESC;

-- Explore database metadata
SELECT * FROM information_schema.schemata;
SELECT * FROM information_schema.tables;
```
To exit:
macOS: `Ctrl + D`
Windows: `Ctrl + C`

## 5. Ingesting Data from CSV
Now, let’s load a dataset into DuckDB.
We’ll use a simple folder structure like this:

```pgsql
├── data
│   └── aigineer_yt_2024_2025.csv
└── sql
    └── ingest_data.sql
```
### Step 1: Write the ingestion script

Create a new file in the sql folder called ingest_data.sql and paste the following code:
``` sql
CREATE TABLE IF NOT EXISTS videos AS (
  SELECT * FROM read_csv_auto('data/aigineer_yt_2024_2025.csv')
);
```
This script:
- Creates a table called `videos` (only if it doesn’t already exist).
- Automatically detects column types using `read_csv_auto.`
- Loads data from your CSV file located in the `data` folder.

### Step 2: Run the script using input redirection
From the root of your project (not inside `data/` or `sql/`), run:
``` bash
duckdb yt_videos.duckdb < sql/ingest_data.sql
```
This tells DuckDB:
- Create or open a database called `yt_videos.duckdb`
- Execute all SQL statements in `ingest_data.sql`

  **Tip:**
  If you get an error saying the CSV path doesn’t exist, double-check your working directory with `pwd`. You must run this command from one level above the `data` and `sql` folders.

## 6. Verifying the Data
Once the ingestion runs successfully, open DuckDB again:
```
duckdb yt_videos.duckdb
```

Then run:
```
SELECT * FROM videos;
```
If you see rows, the data was successfully imported.
You can also run DESC videos; to inspect the table’s schema.

Try closing and reopening DuckDB Your data should persist across sessions

## 7. DuckDB Local UI
As of June 2024, DuckDB provides a local browser-based UI for running queries interactively.
To launch it:
```
duckdb -ui yt_videos.duckdb
```

This will open `http://localhost:4213/` in your browser.
You can write SQL commands directly and see immediate results, similar to Jupyter Notebook but much faster.

  **Note:**
  Queries run in the Local UI are automatically saved in your .duckdb_history folder.
  However, that history is only stored locally on your computer, not in your GitHub repo.

Best Practice:
Always copy your SQL queries from the UI into `.sql` files under your `sql/` folder. This keeps your version history clean and makes collaboration easier.

## 8. Using Meta Commands

Inside the DuckDB CLI, you can also execute **meta commands** (prefixed with a dot `.`).
These are shortcuts for managing databases and inspecting metadata.

| Meta Command | Description                                        |
| ------------ | -------------------------------------------------- |
| `.open`      | Opens an existing DuckDB database file             |
| `.read`      | Runs SQL statements from a specified file          |
| `.schema`    | Displays schema information for all tables         |
| `.tables`    | Lists all available tables in the current database |
| `.quit`      | Exits the DuckDB session                           |
| `.help`      | Lists all available meta commands                  |

Examaple:
``` bash
.read sql/ingest_data.sql
```

## 9. .gitignore Setup
Add these to your .gitignore file so Git doesn’t track your database files:
``` markdown
*.duckdb
*.wal
```
These files store database state and transaction logs — they don’t belong in version control.
If you’re on macOS, also add:
```*.DS_Store```
This hides system metadata files created by Finder.
