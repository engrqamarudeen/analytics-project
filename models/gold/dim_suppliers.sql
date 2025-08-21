with dim_suppliers as (
    select
    supplier_sk,
    supplier_id,
    supplier_name,
    city,
    email,
    phone,
    rating,
    address,
    country,
    contact_person,
    updated_at,
    created_at
    from {{ ref('silver_suppliers') }}
)
select * from dim_suppliers