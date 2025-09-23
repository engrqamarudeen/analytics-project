
{{
    config(
        materialized='incremental',
        unique_key='customer_sk',
        incremental_strategy='merge',
        merge_update_columns=['customer_id', 'first_name', 'last_name', 'country', 'email', 'created_at', 'updated_at']
    )
}}

with dim_customers AS (

SELECT
    customer_sk,
    customer_id,
    first_name,
    last_name,
    country,
    email,
    created_at,
    updated_at
       
from {{ ref('silver_customers') }}

{% if is_incremental() %}
    where updated_at > (select max(updated_at) from {{ this }})
{% endif %}

)

select * from dim_customers


