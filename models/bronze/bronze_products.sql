{{
    config(
        materialized='incremental',
        unique_key='PRODUCT_ID',
        incremental_strategy='merge',
        merge_update_columns=['CREATED_AT', 'STOCK_CODE', 'UNIT_PRICE', 'CATEGORY_ID', 'DESCRIPTION', 'SUPPLIER_ID', 'STOCK_QUANTITY', 'UPDATED_AT']
    )
}}

with bronze_products AS (
    select CREATED_AT, PRODUCT_ID, STOCK_CODE, UNIT_PRICE, CATEGORY_ID, DESCRIPTION, SUPPLIER_ID, STOCK_QUANTITY, UPDATED_AT
    from {{source('data_source_snowflake', 'PRODUCTS') }}
    
    {% if is_incremental() %}
        where UPDATED_AT > (select max(UPDATED_AT) from {{ this }})
    {% endif %}
)
select * from bronze_products