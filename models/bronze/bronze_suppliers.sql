with bronze_suppliers AS (
    select CREATED_AT, CITY, EMAIL, SUPPLIER_ID, SUPPLIER_NAME, PHONE, RATING, ADDRESS, COUNTRY, CONTACT_PERSON, UPDATED_AT
    from {{source('data_source_snowflake', 'SUPPLIERS') }}
)
select * from bronze_suppliers