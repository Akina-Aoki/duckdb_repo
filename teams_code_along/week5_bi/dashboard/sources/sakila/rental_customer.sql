select
    p.amount,
    p.payment_date,
    r.rental_date,
    r.return_date,
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer,
    s.store_id

from staging.payment p
    left join staging.rental r on p.rental_id = r.rental_id
    left join staging.customer c on c.customer_id = p.customer_id
    left join staging.store s on s.store_id = c.store_id;