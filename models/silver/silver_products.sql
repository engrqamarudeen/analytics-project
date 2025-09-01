with base as (
    select 
    cast(product_id as varchar) as product_id,
    trim(stock_code)as stock_code,
    cast(unit_price as float) as unit_price,
    category_id,
    initcap(description) as description,
    supplier_id,
    cast(stock_quantity as int) as stock_quantity,
    cast(created_at as timestamp) as created_at,
    cast(updated_at as timestamp) as updated_at
    from {{ ref('bronze_products') }}
),
deduped as (
    select *
    from base
    qualify row_number() over (partition by product_id order by updated_at desc) = 1
),
final as (
    select
    row_number() over (order by product_id) as product_sk,
    *
    from deduped
)
select * from final