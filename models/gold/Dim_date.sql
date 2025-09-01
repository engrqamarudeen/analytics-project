with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2025-07-27' as date)",
        end_date="dateadd(year, 5, current_date)"
       )
    }}
)
select
    cast(TO_VARCHAR(date_day, 'YYYYMMDD') as int) as date_sk,
    date_day as date,
    extract(year from date_day) as year,
    extract(month from date_day) as month,
    extract(day from date_day) as day,
    extract(quarter from date_day) as quarter,
    extract(week from date_day) as week_of_year,
    extract(dayofweek from date_day) as day_of_week,
    case when extract(dayofweek from date_day) in (1, 7) then true else false end as is_weekend
from date_spine



