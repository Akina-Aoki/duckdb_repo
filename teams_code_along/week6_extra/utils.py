import pandas as pd
import duckdb

def query_database(query: str, db_path: str = "data/lecture_13to15.duckdb") -> pd.DataFrame:
    """Conveniece function to open a DuckDB connection, run queries, and return a DataFrame."""
    with duckdb.connect(db_path) as conn:
        return conn.execute(query=query).df()
