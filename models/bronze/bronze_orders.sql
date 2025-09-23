{{
    config(
        materialized='incremental',
        unique_key='ORDER_ID',
        incremental_strategy='merge',
        merge_update_columns=['CREATED_AT', 'ORDER_DATE', 'TAX_AMOUNT', 'CUSTOMER_ID', 'ORDER_STATUS', 'TOTAL_AMOUNT', 'SHIPPING_COST', 'BILLING_ADDRESS', 'DISCOUNT_AMOUNT', 'SHIPPING_METHOD', 'SHIPPING_ADDRESS', 'UPDATED_AT']
    )
}}

with bronze_orders AS (
    select CREATED_AT, ORDER_ID, ORDER_DATE, TAX_AMOUNT, CUSTOMER_ID, ORDER_STATUS, TOTAL_AMOUNT, SHIPPING_COST, BILLING_ADDRESS, DISCOUNT_AMOUNT, SHIPPING_METHOD, SHIPPING_ADDRESS, UPDATED_AT
    from {{source('data_source_snowflake', 'ORDERS') }}
    
    {% if is_incremental() %}
        where UPDATED_AT > (select max(UPDATED_AT) from {{ this }})
    {% endif %}
)
select * from bronze_orders