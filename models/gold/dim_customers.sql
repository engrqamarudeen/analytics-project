
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

)

select * from dim_customers


