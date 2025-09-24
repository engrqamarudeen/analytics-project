
with
order_items as (
    select
        order_item_sk,
        order_item_id,
        order_id,
        product_id,
        discount_applied
    from {{ ref('silver_order_items') }}
),

-- Orders dimension (for surrogate FK)
orders as (
    select
        order_sk,
        order_id
    from {{ ref('dim_orders') }}
),

-- Products dimension (for surrogate FK)
products as (
    select
        product_sk,
        product_id
    from {{ ref('dim_products') }}
),

dim_order_items as (
    select
    -- Dimension surrogate key
        row_number() over(order by oi.order_item_id) as dim_order_item_sk,

    -- Natural keys
        oi.order_item_id,
        oi.order_id,
        oi.product_id,

        -- Foreign keys
        o.order_sk,
        p.product_sk,

        -- Attributes
        oi.discount_applied

    from order_items oi
    
    left join orders o
        on oi.order_id = o.order_id
    left join products p
        on oi.product_id = p.product_id
)
select * from dim_order_items
