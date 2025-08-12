with categories AS (
    select category_id, category_name, parent_category_id from {{source('data_source_snowflake', 'CATEGORIES') }}
)
insert into ANALYTIC_DWH.BRONZE.CATEGORIES
select * from categories