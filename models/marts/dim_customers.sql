with customers as (

    select * from {{ ref('stg_northvale__customers') }}

),

provinces as (

    select * from {{ ref('provinces') }}

),

completed_orders as (

    select
        customer_id,
        min(order_date)     as first_order_date,
        max(order_date)     as most_recent_order_date,
        count(*)            as number_of_orders,
        sum(order_total)    as lifetime_value
    from {{ ref('fct_orders') }}
    where is_completed
    group by customer_id

)

select
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customers.email,
    customers.signup_date,
    customers.is_marketing_opt_in,
    customers.province_code,
    provinces.province_name,
    provinces.region,
    completed_orders.first_order_date,
    completed_orders.most_recent_order_date,
    coalesce(completed_orders.number_of_orders, 0)  as number_of_orders,
    coalesce(completed_orders.lifetime_value, 0)    as lifetime_value,
    case
        when completed_orders.number_of_orders >= 2 then 'repeat'
        when completed_orders.number_of_orders = 1 then 'one-time'
        else 'no orders'
    end                                             as customer_type
from customers
left join provinces on customers.province_code = provinces.province_code
left join completed_orders on customers.customer_id = completed_orders.customer_id