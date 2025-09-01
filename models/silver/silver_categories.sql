with silver_categories as (
    select
    category_id,
    category_name,
    parent_category_id
  from {{ref('bronze_categories') }}
)
select 
row_number() over (order by category_id) as category_sk,
*
from silver_categories