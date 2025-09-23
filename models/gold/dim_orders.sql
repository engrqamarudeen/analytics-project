{{
    config(
        materialized='incremental',
        unique_key='order_sk',
        incremental_strategy='merge',
        merge_update_columns=['order_id', 'order_date', 'order_status', 'billing_address', 'state_name', 'shipping_address', 'shipping_method', 'created_at', 'updated_at']
    )
}}

with dim_orders as (
    select
    order_sk,
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
    
    {% if is_incremental() %}
        where updated_at > (select max(updated_at) from {{ this }})
    {% endif %}
)
select * from dim_orders