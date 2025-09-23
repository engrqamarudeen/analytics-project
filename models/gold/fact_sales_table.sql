with base as (
select 
customer_id,
customer_sk,
first_name,
last_name,
country,
email,
created_at,
updated_at
from {{ ref('dim_customers') }} 
),
dim_categories as (
    select 
    category_id,
    category_name,
    category_sk,
    parent_category_id
from {{ ref('dim_categories') }}  
) 
-- from base dim_customers
select
customer_id,
customer_sk,
first_name,
last_name,
country,
email,
created_at,
updated_at
-- from dim_categories
select
category_id,
    category_name,
    category_sk,
    parent_category_id
left join base as dim_customers
on dim_categories.category_sk = dim_customers.customer_sk
)
select * from base