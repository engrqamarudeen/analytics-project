with dim_orders as (
    select
    order_sk
    order_id,
    order_date,
    order_status,
    billing_address,
    state_name,
    shipping_address,
    shipping_method,
    created_at,
    updated_at
    from {{ref ('silver_orders')}}
)
select * from dim_orders