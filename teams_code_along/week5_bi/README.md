# Data Pipeline Code Along - Week 5: BI Dashboard
![Figure 1](./data_pipeline_example.png)


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

- These tools allow us to define dependencies between pipelines and ensure that they run in the correct order.