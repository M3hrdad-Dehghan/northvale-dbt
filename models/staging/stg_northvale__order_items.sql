with source as (

    select * from {{ source('northvale', 'raw_order_items') }}

),

renamed as (

    select
        id                                                          as order_item_id,
        order_id,
        sku                                                         as product_sku,
        upper(trim(category_code))                                  as category_code,
        quantity,
        cast(unit_price_cents / 100.0 as decimal(16, 2))            as unit_price,
        cast(quantity * unit_price_cents / 100.0 as decimal(16, 2)) as line_amount
    from source

)

select * from renamed