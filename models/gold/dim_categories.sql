
with dim_categories AS (

SELECT
    *
       
from {{ ref('silver_categories') }}

)

select * from dim_categories
