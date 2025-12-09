# Sakila

## Films in Sakila

```sql films
select
    title,
    description,
    rating,
    length,
    release_year
from sakila.film;
```

## Actors in Sakila
```sql actors
select
    actor_name
from sakila.film_actor;
```

## Top Customers by Rental 
Pick out the top customers

```sql rental
select 
    customer,
    sum(amount) as total_amount,
    count(*) as number_of_rentals
from sakila.rental_customer
group by customer_id, customer
order by total_amount desc, number_of_rentals desc
limit 10;
```
## Dashboard Demonstration
<BarChart
    data = {rental}
    title = "Top Customers by Rental Amount"
    x = customer
    y = total_amount
    swapXY = True
/> 

## All Rentals
```sql rent
from sakila.rental_customer;
```

## Analyzing payments
Choose your store
<Dropdown data = {rent} name = store value = store_id>
title = "Select Store" defaultValue = "1"
</Dropdown>

You have picked stor {inputs.store.value}

```sql customer
select
    date_trunc('day', payment_date) as pay_date,
    sum(amount) as total_payment
from sakila.rental_customer
where store_id = ${inputs.store.value} and payment_date between '2005-05-01' and '2005-09-01' 
group by pay_date
```

<LineChart
    data = {customer}
    title = "Total Payments Over Time for Store {inputs.store.value}"
    x = pay_date
    y = total_payment
    xAxisTitle = "Total Amount"
    yAxisTitle = "Payment Date"
/>  
