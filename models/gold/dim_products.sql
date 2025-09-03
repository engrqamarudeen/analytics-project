with products as (
    select
        product_sk,
        product_id,
        stock_code,
        description as product_description,
        unit_price,
        stock_quantity,
        category_id,
        supplier_id,
        created_at,
        updated_at
    from {{ ref('silver_products') }}
),

categories as (
    select
        category_sk,
        category_id,
        initcap(trim(category_name)) as category_name,
        parent_category_id
    from {{ ref('silver_categories') }}
),

suppliers as (
    select
        supplier_sk,
        supplier_id,
        initcap(trim(supplier_name)) as supplier_name,
        trim(city) as supplier_city,
        trim(country) as supplier_country,
        contact_person,
        email,
        phone,
        rating,
        address,
        created_at as supplier_created_at,
        updated_at as supplier_updated_at
    from {{ ref('silver_suppliers') }}
)
select
    p.product_sk,               -- Reuse surrogate key from silver_products
    p.product_id,               -- Natural key
    p.stock_code,
    p.product_description,
    p.unit_price,
    p.stock_quantity,
    p.created_at,
    p.updated_at,

    c.category_sk,              -- Reuse surrogate key from silver_categories
    c.category_id,              -- Natural key
    c.category_name,
    c.parent_category_id,

    s.supplier_sk,              -- Reuse surrogate key from silver_suppliers
    s.supplier_id,              -- Natural key
    s.supplier_name,
    s.supplier_city,
    s.supplier_country,
    s.contact_person,
    s.email,
    s.phone,
    s.rating,
    s.address

from products p
left join categories c 
    on p.category_id = c.category_id
left join suppliers s 
    on p.supplier_id = s.supplier_id



