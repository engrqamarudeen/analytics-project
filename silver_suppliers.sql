WITH base AS (
    SELECT
        phone,
        REGEXP_REPLACE(phone, '[^0-9]', '') AS digits
    FROM {{ ref('bronze_supliers') }}
)

SELECT
    phone,
    digits,
    CASE 
        WHEN LENGTH(digits) > 10 
            THEN LEFT(digits, LENGTH(digits) - 10)
        ELSE '1'  -- fallback default country code
    END AS country_code,
    RIGHT(digits, 10) AS subscriber_10
FROM base;
