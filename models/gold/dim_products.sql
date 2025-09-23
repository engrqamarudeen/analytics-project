{{
    config(
        materialized='incremental',
        unique_key='product_sk',
        incremental_strategy='merge',
        merge_update_columns=['product_id', 'stock_code', 'product_description', 'unit_price', 'stock_quantity', 'category_sk', 'category_name', 'parent_category_id', 'supplier_sk', 'supplier_name', 'supplier_city', 'supplier_country', 'supplier_rating', 'supplier_contact_person', 'created_at', 'updated_at']
    )
}}

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
    
    {% if is_incremental() %}
        where updated_at > (select max(updated_at) from {{ this }})
    {% endif %}
),

categories as (
    select
        category_sk,
        category_id,
        category_name,
        parent_category_id
    from {{ ref('dim_categories') }}
),

suppliers as (
    select
        supplier_sk,
        supplier_id,
        supplier_name,
        city,
        rating,
        country,
        contact_person,
        
    from {{ ref('dim_suppliers') }}
),

dim_products as (
    select
        p.product_sk,
        p.product_id,
        p.stock_code,
        p.product_description,
        p.unit_price,
        p.stock_quantity,

        c.category_sk,
        c.category_name,
        c.parent_category_id,

        s.supplier_sk,
        s.supplier_name,
        s.city as supplier_city,
        s.country as supplier_country,
        s.rating as supplier_rating,
        s.contact_person as supplier_contact_person,

        p.created_at,
        p.updated_at

    from products p
    left join categories c
        on p.category_id = c.category_id
    left join suppliers s
        on p.supplier_id = s.supplier_id
)

select * from dim_products

