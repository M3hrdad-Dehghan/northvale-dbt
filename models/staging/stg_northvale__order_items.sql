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
        {{ cents_to_dollars('unit_price_cents') }}                  as unit_price,
        {{ cents_to_dollars('quantity * unit_price_cents') }}       as line_amount

    from source

)

select * from renamed