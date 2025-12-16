from constants import DB_PATH, SQL_PATH
import duckdb

with duckdb.connect(str(DB_PATH)) as conn, open(SQL_PATH / "create_users.sql") as sql_script:
    sql_code = sql_script.read()
    # print(sql_code)
    conn.execute(sql_code)
    # print("hej")