-- a completed order must be fully paid: returns the orders where it is not
select
    order_id,
    order_total,
    total_paid
from {{ ref('fct_orders') }}
where is_completed
  and abs(order_total - total_paid) > 0.01