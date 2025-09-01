-- Step 1: Get raw data from bronze_orders
with base as (

    select *
    from {{ ref('bronze_orders') }}

),

-- Step 2: Apply cleaning and transformations
cleaned_order as (

    select
        order_id,
        customer_id,
        cast(order_date as date) as order_date,
        cast(created_at as timestamp) as created_at,
        cast(updated_at as timestamp) as updated_at,

        billing_address,
        shipping_address,

        cast(discount_amount as numeric(10,2)) as discount_amount,
        cast(shipping_cost as numeric(10,2)) as shipping_cost,
        cast(tax_amount as numeric(10,2)) as tax_amount,
        cast(total_amount as numeric(10,2)) as total_amount,

        order_status,

        -- 🛠 Replace NULL with 'Outsourced'
        coalesce(shipping_method, 'Outsourced') as shipping_method

    from base
    where order_id is not null

)

-- Step 3: Final output
select * from cleaned_order