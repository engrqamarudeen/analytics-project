with
    source as (select * from {{ ref("bronze_order_items") }}),
    cleaned as (
        select
        row_number() over(order by order_item_id) as order_item_sk,
            -- Clean and validate UUID
            lower(trim(order_item_id)) as order_item_id,
            lower(trim(order_id)) as order_id,
            lower(trim(product_id)) as product_id,

             -- Safe numeric conversions: only cast if it’s actually numeric
        CASE 
            WHEN TRY_TO_NUMBER(TO_VARCHAR(quantity)) IS NOT NULL
            THEN CAST(TRY_TO_NUMBER(TO_VARCHAR(quantity)) AS NUMBER(18,0))
            ELSE NULL
        END AS quantity,

        CASE 
            WHEN TRY_TO_NUMBER(TO_VARCHAR(unit_price)) IS NOT NULL
            THEN CAST(TRY_TO_NUMBER(TO_VARCHAR(unit_price)) AS NUMBER(18,2))
            ELSE NULL
        END AS unit_price,

        CASE 
            WHEN TRY_TO_NUMBER(TO_VARCHAR(line_total)) IS NOT NULL
            THEN CAST(TRY_TO_NUMBER(TO_VARCHAR(line_total)) AS NUMBER(18,2))
            ELSE NULL
        END AS line_total,

        -- normalize discount into boolean
        CASE
            WHEN discount_applied IN (1, '1', 'true', 'TRUE', TRUE) THEN TRUE
            ELSE FALSE
        END AS discount_applied
    FROM source
    WHERE order_item_id IS NOT NULL
        and ORDER_ID is not null
        and product_ID is not null
        and TRY_TO_NUMBER(TO_VARCHAR(quantity)) > 0
)

select
    order_item_sk,
    order_item_id,
    order_id,
    product_id,
    COALESCE(quantity, 0) AS quantity,
    unit_price,
    COALESCE(line_total, quantity * unit_price) AS line_total,
    discount_applied

from cleaned