import duckdb
from constants import DB_PATH

username = input("Enter your username: ")
password = input("Enter your password: ")

with duckdb.connect(str(DB_PATH)) as conn:
    result = conn.execute(""" 
    SELECT * 
    FROM users
    WHERE 
        username = '{username}' AND
        password = '{password}'            
""")
    if result.fetchon