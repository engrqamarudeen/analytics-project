{{
    config(
        materialized='incremental',
        unique_key='transaction_sk',
        incremental_strategy='merge',
        merge_update_columns=['transaction_sk', 'created_at', 'invoice_date', 'order_id', 'payment_method', 'total_amount', 'updated_at']
    )
}}

with dim_transactions as (
    select
    transaction_sk,
     created_at,
    invoice_date,
    order_id,
    payment_method,
    total_amount,
    updated_at
    from {{ref ('silver_transactions')}}
    
    {% if is_incremental() %}
        where updated_at > (select max(updated_at) from {{ this }})
    {% endif %}
)
select * from dim_transactions