with base as (
select 
maryam1.column,
maryam2.column
peju1.column,
peju2.column

from dim_customer maryam1
join dim_categories maryam2
on marya1.id = maryam2.cat_id
join dim_date  peju1
on peju1.id = maryam1.column
join dim_suppliers peju2
on peju2.id = peju1.id

)

select * from base