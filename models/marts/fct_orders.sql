{{
    config(
        materialized = 'incremental',
        unique_key = 'order_id'
    )
}}

with orders as (

    select * from {{ ref('stg_northvale__orders') }}

    {% if is_incremental() %}
    -- only new orders, plus the last 7 days again (their status may have changed)
    where ordered_at >= {{ dbt.dateadd('day', -7, '(select max(ordered_at) from ' ~ this ~ ')') }}
    {% endif %}

),

items as (

    select * from {{ ref('int_order_items_summarized') }}

),

payments as (

    select * from {{ ref('int_order_payments_pivoted') }}

)

select
    orders.order_id,
    orders.customer_id,
    orders.ordered_at,
    orders.order_date,
    orders.order_status,
    orders.order_status = 'completed'                           as is_completed,
    coalesce(items.item_quantity, 0)                            as item_quantity,
    coalesce(items.items_amount, 0)                             as items_amount,
    coalesce(items.tech_amount, 0)                              as tech_amount,
    orders.shipping_amount,
    coalesce(items.items_amount, 0) + orders.shipping_amount    as order_total,
    coalesce(payments.credit_card_amount, 0)                    as credit_card_amount,
    coalesce(payments.paypal_amount, 0)                         as paypal_amount,
    coalesce(payments.apple_pay_amount, 0)                      as apple_pay_amount,
    coalesce(payments.gift_card_amount, 0)                      as gift_card_amount,
    coalesce(payments.total_paid, 0)                            as total_paid
from orders
left join items on orders.order_id = items.order_id
left join payments on orders.order_id = payments.order_id