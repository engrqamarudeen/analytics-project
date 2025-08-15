
with dim_customers AS (

SELECT
    customer_id,
    first_name,
    last_name,
    country,
    email

FROM {{ ref('silver_customers') }}

)

select * from dim_customers
