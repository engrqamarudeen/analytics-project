{{
    config(
        materialized='incremental',
        unique_key='ORDER_ITEM_ID',
        incremental_strategy='merge',
        merge_update_columns=['ORDER_ID', 'PRODUCT_ID', 'QUANTITY', 'LINE_TOTAL', 'UNIT_PRICE', 'DISCOUNT_APPLIED']
    )
}}

with bronze_order_items AS (
    select ORDER_ITEM_ID, ORDER_ID, PRODUCT_ID, QUANTITY, LINE_TOTAL, UNIT_PRICE, DISCOUNT_APPLIED 
    from {{source('data_source_snowflake', 'ORDER_ITEMS') }}
    
    {% if is_incremental() %}
        where ORDER_ITEM_ID > (select max(ORDER_ITEM_ID) from {{ this }})
    {% endif %}
)
select * from bronze_order_items