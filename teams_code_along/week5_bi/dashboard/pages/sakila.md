# Sakila
## Dashboard Demonstration

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