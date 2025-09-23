{{
    config(
        materialized='incremental',
        unique_key='CATEGORY_ID',
        incremental_strategy='merge',
        merge_update_columns=['CREATED_AT', 'CATEGORY_NAME', 'PARENT_CATEGORY_ID', 'UPDATED_AT']
    )
}}

with bronze_categories AS (
    select CREATED_AT, CATEGORY_ID, CATEGORY_NAME, PARENT_CATEGORY_ID, UPDATED_AT
    from {{source('data_source_snowflake', 'CATEGORIES') }}
    
    {% if is_incremental() %}
        where UPDATED_AT > (select max(UPDATED_AT) from {{ this }})
    {% endif %}
)
select * from bronze_categories