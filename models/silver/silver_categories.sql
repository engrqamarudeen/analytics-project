{{
    config(
        materialized='incremental',
        unique_key='category_id',
        incremental_strategy='merge',
        merge_update_columns=['category_sk', 'category_name', 'parent_category_id']
    )
}}

with silver_categories as (
    select
    category_id,
    category_name,
    parent_category_id
  from {{ref('bronze_categories') }}
  
  {% if is_incremental() %}
        where category_id > (select max(category_id) from {{ this }})
  {% endif %}
)
select 
row_number() over (order by category_id) as category_sk,
*
from silver_categories