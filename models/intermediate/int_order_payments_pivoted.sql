-- one row per order, one column per payment method (successful payments only)
{% set payment_methods = ['credit_card', 'paypal', 'apple_pay', 'gift_card'] %}

with payments as (

    select * from {{ ref('stg_northvale__payments') }}
    where payment_status = 'success'

)

select
    order_id,

    {% for method in payment_methods %}
    sum(case when payment_method = '{{ method }}' then amount else 0 end) as {{ method }}_amount,
    {% endfor %}

    sum(amount) as total_paid
from payments
group by order_id