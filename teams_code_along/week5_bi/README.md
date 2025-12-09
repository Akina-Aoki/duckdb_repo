# Data Pipeline Code Along - Week 5: BI Dashboard
![Figure 1](./data_pipeline_example.png)

# Worklflow Summary (Guide to VG)
**NOTE:** The final dashboard from the lecture is available in this repo folder called `20_dashboard_lecture`.
```bash
week5_bi/
│
├── .vscode/                     # VS Code settings for this project
│
├── dashboard/
│   └── .evidence/               # Evidence’s internal files (auto-generated)
│
├── pages/                       # Dashboard pages you see in the browser
│   ├── index.md                 # Main homepage of the dashboard
│   └── sakila.md                # Page showing Sakila analysis and charts
│
├── sources/                     # Where Evidence reads data from
│   ├── needful_things/          # Example data source used for testing
│   │   ├── connection.yaml      # How Evidence connects to this data
│   │   ├── needful_things.duckdb # Small DuckDB file for testing
│   │   └── orders.sql           # SQL query used as a model
│   │
│   └── sakila/                  # Your main Sakila data source
│       ├── connection.yaml      # How Evidence connects to sakila.duckdb
│       ├── film.sql             # SQL model for film data
│       ├── film_actor.sql       # SQL model joining film + actor
│       └── sakila.duckdb        # DuckDB database created by your DLT pipeline
│
├── data/
│   └── data_pipeline_example.png # Image showing your data pipeline
│
├── dlt_load_sakila.py           # Python script that loads SQLite → DuckDB
│
├── evidence.config.yaml         # Main settings file for Evidence
├── package.json                 # Node.js config for running Evidence
├── package-lock.json            # Locked versions of dependencies
├── degit.json                   # Template settings from Evidence
└── .gitignore                   # Files Git should ignore
```

## 1. Create a dashboard folder in the folder (choice)
CTRL + SHIFT + P
Create Evidence project, choose the DASHBOARD  folder.
Default files will be produced.


## 2. In the connection.yaml file, change to this
```
#### This file was automatically generated
name: sakila
type: duckdb
options:
  filename: sakila.duckdb
```

## 3. In the .gitignore, add `.evidence`
Save the file.


4. Install different packages
Go to the path you want to install in. 
This case, it's in my week5_bi/dashboard(main)
`npm install`


## 5. Add data sources
There are 2 subfolder (pages, sources)
Create a `sakila` folder under sources.
Copy the available connection.yaml under the sakila folder.
Double check if I have edited the connection.yaml.

Connection.yaml and sakila should always be in the same folder.

## 6. Create the sql files that I will use to show in the evidence dashboard.
In this case, its the `film_actor.sql` and `actor.sql`


## 7. try running `npm run dev` to see if everything is working fine.
If there are errors, try running `npm run sources`

If there are errors, open duckdb in the terminal and check if the database is not empty. `duckdb sources/sakila/sakila.duckdb`

If everything is fine, I can see the dashboard running at `localhost:3000` and
see the different pages I have created under the pages folder.


## 8. Here I can create different pages to show different analysis.

[![YouTube Tutorial Video](https://img.youtube.com/vi/8jMIRtGwReY/0.jpg)](https://www.youtube.com/watch?v=8jMIRtGwReY)
**Video by AIgeneer**

This is part of the VG requirement and need to figure this out myself.

## 9. Working with Evidence Dashboard.

Under then pages folder in the sakila.md, I can create different markdown files to show different visualizations.
```
```sql film_ratings
 SELECT
    rating,
    COUNT(*) AS number_film
FROM sakila.film
GROUP BY rating
```

<BarChart
    data = {film_ratings}
    title="Number of Films by Rating"
    x = rating
    y = number_film
/>  
```

_____________________________________________________________________________________________________

## Different Data Sources
- Using an API for the data source (Arbetsförmedlingen in this lecture).
- Using a URL, we can find data about different job listings in Sweden.
```
jobsearch.api.jobtechdev.se/search
```
### Cleaning the Data
- This is a messy data source, so we will use dbt to clean it up (transformations and cleaning).
- The tools for that are example, DBT, and DuckDB. (see figure 1)

### Data Ingestion (DLT HUB)
- Data Ingestion is the process of collecting data from various sources and bringing it into a centralized location for storage and analysis.

- Put them in the staging area (raw data) in the warehouse (DuckDB).

### Data Warehouse (DuckDB)
- After getting the data from the API, we will load it into our data warehouse (DuckDB).
- Only data engineers can collect the data from the sources and Data Scientists can use it for analysis.

### Data Transformation (DBT)
- After loading the data into the warehouse, we will use DBT to transform and clean the data.

- DBT allows us to write SQL queries to transform the data and create new tables/views in the warehouse.

- Its like picking something from the Data warehouse, transgforming it, and putting it back into the warehouse WITH A NEW SCHEMA NAME. Example is "transformed" schema.

### AI MODELS (Optional)
- Data Scientists can use AI models to analyze the data and get insights from it.

- We can use AI models to predict trends, classify data, and more.


### Dashboarding (Evidence, Streamlit, etc)
- Finally, we will use Evidence to create a dashboard to visualize the data.

- Evidence connects to the DuckDB warehouse and allows us to create interactive dashboards using SQL and Markdown.

- This is local, running in the laptop. 

- This is deployable to the Cloud so others can see it.

### Dockerization for cloud deployment of the Project
- A toll used is DOCKER to containerize the project for easy deployment to the cloud.

- Docker allows us to package the application and its dependencies into a single container that can run anywhere.

### Github for Collaboration
- Using Github for version control and collaboration.

- However, if a team is working on the same project, Github allows multiple people to work on the same codebase without conflicts.

### Orchestration (Python, Dagster, Airflow, etc)
- Without orchestration, we would have to manually run each step of the data pipeline (ingestion, transformation, loading, etc) every time we want to update the data.

- Finally, we can use orchestration tools to automate the data pipeline. We need to schedule the data pipeline to run at specific intervals (daily, weekly, etc) because the data is constantly changing and the whole process needs to be repeated to keep the data up-to-date.

- If I have multiple data pipelines, I can use orchestration tools like Dagster or Airflow to manage and schedule the pipelines.
git
- These tools allow us to define dependencies between pipelines and ensure that they run in the correct order.




