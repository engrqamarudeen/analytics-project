with base as (
select 
maryam1.column,
maryam2.column
with dim_date as (
    select
        cast(to_varchar(date_day, 'YYYYMMDD') as int) as date_sk,
        date_day as date,
        extract(year from date_day) as year,
        extract(month from date_day) as month,
        extract(day from date_day) as day,
        extract(quarter from date_day) as quarter,
        extract(week from date_day) as week_of_year,
        extract(dayofweek from date_day) as day_of_week,
        case when extract(dayofweek from date_day) in (1, 7) then true else false end as is_weekend
    from {{ ref('dim_date') }}
),

dim_orders as (
    select
        order_sk,
        order_id,
        order_date,
        order_status,
        billing_address,
        state_name,
        shipping_address,
        shipping_method,
        created_at,
        updated_at
    from {{ ref('silver_orders') }}
)

select
    -- from dim_date (peju1)
    peju1.date_sk,
    peju1.date,
    peju1.year,
    peju1.month,
    peju1.day,
    peju1.quarter,
    peju1.week_of_year,
    peju1.day_of_week,
    peju1.is_weekend,

    -- from dim_orders (peju2)
    peju2.order_sk,
    peju2.order_id,
    peju2.order_status,
    peju2.billing_address,
    peju2.state_name,
    peju2.shipping_address,
    peju2.shipping_method,
    peju2.created_at,
    peju2.updated_at

from dim_orders peju2
left join dim_date peju1
    on cast(to_varchar(peju2.order_date, 'YYYYMMDD') as int) = peju1.date_sk


from dim_customer maryam1
join dim_categories maryam2
on marya1.id = maryam2.cat_id
join dim_date  peju1
on peju1.id = maryam1.column
join dim_suppliers peju2
on peju2.id = peju1.id

)

select * from base