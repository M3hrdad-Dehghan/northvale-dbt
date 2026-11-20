with source as (

    select * from {{ source('northvale', 'raw_orders') }}

),

renamed as (

    select
        id                                              as order_id,
        customer_id,
        cast(ordered_at as timestamp)                   as ordered_at,
        cast(ordered_at as date)                        as order_date,
        lower(trim(status))                             as order_status,
        {{ cents_to_dollars('shipping_cents') }}        as shipping_amount
    from source

)

select * from renamed