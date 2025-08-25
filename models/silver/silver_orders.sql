with base as (

    -- i have to reference the bronze table
    select *
    from {{ ref('bronze_orders') }}

),

state_extracted as (  
    --it takes base and adds a state_name column extracted from billing_address.

    select
        *,
        -- Extract the 2-letter state abbreviation before the ZIP code
        regexp_substr(billing_address, ',\\s([A-Z]{2})\\s\\d{5}', 1, 1, 'e', 1) as state_name
    from base

),

final as (

    select
     --row_number() over (order by order_id) as order_sk,
        order_id,
        customer_id,
        order_date,
        order_status,
        billing_address,

        -- Derived state_name based on state_code
        case state_name
            when 'AL' then 'Alabama'
            when 'AK' then 'Alaska'
            when 'AZ' then 'Arizona'
            when 'AR' then 'Arkansas'
            when 'CA' then 'California'
            when 'CO' then 'Colorado'
            when 'CT' then 'Connecticut'
            when 'DE' then 'Delaware'
            when 'FL' then 'Florida'
            when 'GA' then 'Georgia'
            when 'HI' then 'Hawaii'
            when 'ID' then 'Idaho'
            when 'IL' then 'Illinois'
            when 'IN' then 'Indiana'
            when 'IA' then 'Iowa'
            when 'KS' then 'Kansas'
            when 'KY' then 'Kentucky'
            when 'LA' then 'Louisiana'
            when 'ME' then 'Maine'
            when 'MD' then 'Maryland'
            when 'MA' then 'Massachusetts'
            when 'MI' then 'Michigan'
            when 'MN' then 'Minnesota'
            when 'MS' then 'Mississippi'
            when 'MO' then 'Missouri'
            when 'MT' then 'Montana'
            when 'NE' then 'Nebraska'
            when 'NV' then 'Nevada'
            when 'NH' then 'New Hampshire'
            when 'NJ' then 'New Jersey'
            when 'NM' then 'New Mexico'
            when 'NY' then 'New York'
            when 'NC' then 'North Carolina'
            when 'ND' then 'North Dakota'
            when 'OH' then 'Ohio'
            when 'OK' then 'Oklahoma'
            when 'OR' then 'Oregon'
            when 'PA' then 'Pennsylvania'
            when 'RI' then 'Rhode Island'
            when 'SC' then 'South Carolina'
            when 'SD' then 'South Dakota'
            when 'TN' then 'Tennessee'
            when 'TX' then 'Texas'
            when 'UT' then 'Utah'
            when 'VT' then 'Vermont'
            when 'VA' then 'Virginia'
            when 'WA' then 'Washington'
            when 'WV' then 'West Virginia'
            when 'WI' then 'Wisconsin'
            when 'WY' then 'Wyoming'
            else null
        end as state_name,

        shipping_address,
        shipping_cost,
        shipping_method,
        discount_amount,
        tax_amount,
        total_amount,
        created_at,
        updated_at

    from state_extracted
)
---insert into analytic_dwh.silver.orders
select * from final