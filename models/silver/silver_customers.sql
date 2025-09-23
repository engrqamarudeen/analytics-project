{{
    config(
        materialized='incremental',
        unique_key='customer_id',
        incremental_strategy='merge',
        merge_update_columns=['customer_sk', 'first_name', 'last_name', 'email', 'country', 'created_at', 'updated_at']
    )
}}

with
    source as (select * from {{ ref("bronze_customers") }}
    
    {% if is_incremental() %}
        where updated_at > (select max(updated_at) from {{ this }})
    {% endif %}
    
    ),
    cleaned as (
        select
        row_number() over(order by customer_id) as customer_sk,
            -- Clean and validate UUID
            lower(trim(customer_id)) as customer_id,

            -- Standardize and clean names
            initcap(trim(first_name)) as first_name,
            initcap(trim(last_name)) as last_name,

            -- Email to lowercase and trim
            lower(trim(email)) as email,

            -- standardize and clean country
            initcap(trim(country)) as country,
            created_at,
            updated_at

        from source

        -- Filter out invalid UUIDs and null essential fields
        where
            customer_id rlike '^[a-f0-9\\-]{36}


            and email is not null
            and first_name is not null
            and last_name is not null

    )
select customer_sk, customer_id, first_name, last_name, email, country, created_at, updated_at

from cleaned
