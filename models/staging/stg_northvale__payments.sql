with source as (

    select * from {{ source('northvale', 'raw_payments') }}

),

renamed as (

    select
        id                                              as payment_id,
        order_id,
        lower(trim(payment_method))                     as payment_method,
        {{ cents_to_dollars('amount_cents') }}          as amount,
        lower(trim(status))                             as payment_status,
        cast(created_at as timestamp)                   as paid_at
    from source

)

select * from renamed