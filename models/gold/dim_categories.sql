
{{
    config(
        materialized='incremental',
        unique_key='category_sk',
        incremental_strategy='merge',
        merge_update_columns=['category_id', 'category_name', 'parent_category_id']
    )
}}

with dim_categories AS (

SELECT
    *
       
from {{ ref('silver_categories') }}

{% if is_incremental() %}
    where category_id > (select max(category_id) from {{ this }})
{% endif %}

)

select * from dim_categories
