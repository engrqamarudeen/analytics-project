{{
    config(
        materialized='incremental',
        unique_key='SUPPLIER_ID',
        incremental_strategy='merge',
        merge_update_columns=['CREATED_AT', 'CITY', 'EMAIL', 'SUPPLIER_NAME', 'PHONE', 'RATING', 'ADDRESS', 'COUNTRY', 'CONTACT_PERSON', 'UPDATED_AT']
    )
}}

with bronze_suppliers AS (
    select CREATED_AT, CITY, EMAIL, SUPPLIER_ID, SUPPLIER_NAME, PHONE, RATING, ADDRESS, COUNTRY, CONTACT_PERSON, UPDATED_AT
    from {{source('data_source_snowflake', 'SUPPLIERS') }}
    
    {% if is_incremental() %}
        where UPDATED_AT > (select max(UPDATED_AT) from {{ this }})
    {% endif %}
)
select * from bronze_suppliers


