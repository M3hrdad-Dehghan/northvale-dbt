with source as (

    select * from {{ source('northvale', 'raw_payments') }}

),

renamed as (

    select
        id                                              as payment_id,
        order_id,
        lower(trim(payment_method))                     as payment_method,
        cast(amount_cents / 100.0 as decimal(16, 2))    as amount,
        lower(trim(status))                             as payment_status,
        cast(created_at as timestamp)                   as paid_at
    from source

)

select * from renamed