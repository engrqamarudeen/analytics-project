with test AS (
    select * from {{source('data_source_snowflake', 'CUSTOMERS') }}
)
select count(*) from test