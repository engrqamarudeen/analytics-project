with bronze_categories AS (
    select CREATED_AT, CATEGORY_ID, CATEGORY_NAME, PARENT_CATEGORY_ID, UPDATED_AT
    from {{source('data_source_snowflake', 'CATEGORIES') }}
)
select * from bronze_categories