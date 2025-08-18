with dim_orders as (
    select
    order_id,
    order_date,
    order_status,
    billing_address,
    state_name,
    shipping_address,
    shipping_method,
    created_at,
    updated_at
    from {{ref ('orders')}}
)
select * from dim_orders