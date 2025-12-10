from pathlib import Path        # to be able to open files in a cross-platform way


SQL_PATH = Path(__file__).parent / "sql"
DB_PATH = Path(__file__).parent / "glassiker.duckdb"

# print("---"*20)
# print(DB_PATH)
# print("--"*20)

# with open("sql/create_users.sql") as file:
#   print(file.read())

