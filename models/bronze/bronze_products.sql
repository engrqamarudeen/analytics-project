with bronze_products AS (
    select CREATED_AT, PRODUCT_ID, STOCK_CODE, UNIT_PRICE, CATEGORY_ID, DESCRIPTION, SUPPLIER_ID, STOCK_QUANTITY, UPDATED_AT
    from {{source('data_source_snowflake', 'PRODUCTS') }}
)
select * from bronze_products