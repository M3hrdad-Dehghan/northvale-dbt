with source as (

    select * from {{ source('northvale', 'raw_customers') }}

),

renamed as (

    select
        id                                      as customer_id,
        first_name,
        last_name,
        lower(trim(email))                      as email,
        upper(trim(province))                   as province_code,
        cast(signup_at as timestamp)            as signup_at,
        cast(signup_at as date)                 as signup_date,
        upper(trim(marketing_opt_in)) = 'Y'     as is_marketing_opt_in
    from source

)

select * from renamed