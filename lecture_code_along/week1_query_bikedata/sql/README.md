# Bike.duckdb join concept illustration and figure
## Concept of o and oi
**“Match each order with its related order items, using the order_id as the link.”**
```sql
SELECT *
FROM staging.orders o -- base on this table, "o" means alias, no need to provide alias when using "o"
LEFT JOIN staging.order_items oi ON o.order_id = oi.order_id
```

- `o` is just a short nickname (alias) for the table "staging.order"
- `oi` is a nickname for the table "staging.order_items"
- `o.order_id = oi.order_id` tells SQL how the two tables are connected
- `LEFT JOIN` means “keep all rows from o (order) even if no matching items exist in oi (order_items)
- In human terms:
Keep every order, and attach the items that belong to each order. If an order has no items, still show the order, the item fields will just be empty.
 
   ┌──────────────────────────┐       ┌──────────────────────────┐
   │        o (orders)        │ LEFT  │      oi (order_items)    │
   └──────────────────────────┘  JOIN └──────────────────────────┘
        order_id | customer            order_id | item_name
        ----------+---------            ----------+-----------
           1      |  A                     1      |  Shirt
           2      |  B                     1      |  Shoes
           3      |  C                     2      |  Hat
           4      |  D                     5      |  Keyboard
<br>
## Result:
┌───────────┬───────────┬──────────┐
│ order_id  │ customer  │ item     │
├───────────┼───────────┼──────────┤
│     1     │    A      │ Shirt    │
│     1     │    A      │ Shoes    │
│     2     │    B      │ Hat      │
│     3     │    C      │ NULL     │   ← no matching item
│     4     │    D      │ NULL     │   ← no matching item


## Summary:
**The unique key is order_id from the orders table (o).**

That’s the stable, one-row-per-order identifier.

The relationship looks like this:

`orders` (o) → one row per order

`order_items` (oi) → many rows per order_id (because an order can have multiple items)

So the “unique table” is the `orders` table.

It’s the left table.
**It’s the parent.**
It’s the one that must keep all its rows.

**`order_items` is the child table.`**

It repeats the same order_id for multiple items.