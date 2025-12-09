# Sakila
## Dashboard Demonstration

```sql film_ratings
 SELECT
    rating,
    COUNT(*) AS number_film
FROM sakila.film
GROUP BY rating
```