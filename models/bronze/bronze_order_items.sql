with bronze_order_items AS (
    select ORDER_ITEM_ID, ORDER_ID, PRODUCT_ID, QUANTITY, LINE_TOTAL, UNIT_PRICE, DISCOUNT_APPLIED 
    from {{source('data_source_snowflake', 'ORDER_ITEMS') }}
)
select * from bronze_order_items