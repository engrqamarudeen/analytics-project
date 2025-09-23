{{
    config(
        materialized='incremental',
        unique_key='supplier_sk',
        incremental_strategy='merge',
        merge_update_columns=['supplier_id', 'supplier_name', 'city', 'email', 'phone', 'rating', 'address', 'country', 'contact_person', 'updated_at', 'created_at']
    )
}}

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
    
    {% if is_incremental() %}
        where updated_at > (select max(updated_at) from {{ this }})
    {% endif %}
)
select * from dim_suppliers