# Exploring Sakila Database
## Films in Sakila

- `(npm run dev)` to run in the terminal to open evidence app in the browser.

- Notice that in the sources/sakila folder, we have a connection.yaml file that connects to the sakila.duckdb database. The film.sql also connects with the sakila.duckdb database.

```sql films
from sakila.film;
---
