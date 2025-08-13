with bronze_customers AS (
    select CREATED_AT, CUSTOMER_ID, EMAIL, COUNTRY, LAST_NAME, FIRST_NAME, UPDATED_AT
    from {{source('data_source_snowflake', 'CUSTOMERS') }}
)
select * from bronze_customers