-- one row per order: how many items, how much, and how much of it was Tech
with items as (

    select * from {{ ref('stg_northvale__order_items') }}

),

categories as (

    select * from {{ ref('product_categories') }}

),

joined as (

    select
        items.order_id,
        items.quantity,
        items.line_amount,
        categories.department
    from items
    left join categories
        on items.category_code = categories.category_code

)

select
    order_id,
    sum(quantity)                                                       as item_quantity,
    sum(line_amount)                                                    as items_amount,
    sum(case when department = 'Tech' then line_amount else 0 end)      as tech_amount
from joined
group by order_id