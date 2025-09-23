{{
    config(
        materialized='incremental',
        unique_key='CUSTOMER_ID',
        incremental_strategy='merge',
        merge_update_columns=['CREATED_AT', 'EMAIL', 'COUNTRY', 'LAST_NAME', 'FIRST_NAME', 'UPDATED_AT']
    )
}}

with bronze_customers AS (
    select CREATED_AT, CUSTOMER_ID, EMAIL, COUNTRY, LAST_NAME, FIRST_NAME, UPDATED_AT
    from {{source('data_source_snowflake', 'CUSTOMERS') }}
    
    {% if is_incremental() %}
        where UPDATED_AT > (select max(UPDATED_AT) from {{ this }})
    {% endif %}
)
select * from bronze_customers