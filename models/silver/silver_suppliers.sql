WITH base AS (
    SELECT
        created_at,
        city,
        email,
        supplier_id,
        supplier_name,
        rating,
        address,
        country,
        contact_person,
        updated_at,
        REGEXP_REPLACE(phone, '[^0-9]', '') AS digits
    FROM {{ ref('bronze_suppliers') }}
),

Transformed_layer as (
SELECT
    row_number() over (order by supplier_id) as supplier_sk,
    created_at,
    city,
    email,
    supplier_id,
    supplier_name,
    rating,
    address,
    country,
    contact_person,
    updated_at,
    CASE 
        WHEN LENGTH(digits) BETWEEN 11 AND 13
             AND LENGTH(RIGHT(digits,10)) = 10
        THEN CONCAT(
            '+', LEFT(digits, LENGTH(digits)-10), '-',
            SUBSTRING(RIGHT(digits,10),1,3), '-',
            SUBSTRING(RIGHT(digits,10),4,3), '-',
            SUBSTRING(RIGHT(digits,10),7,4)
        )
        ELSE NULL
    END AS phone,
    CASE 
        WHEN LENGTH(digits) BETWEEN 11 AND 13
             AND LENGTH(RIGHT(digits,10)) = 10
        THEN TRUE
        ELSE FALSE
    END AS is_valid_phone
FROM base )
select * from Transformed_layer


