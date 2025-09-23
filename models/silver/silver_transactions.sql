{{
    config(
        materialized='incremental',
        unique_key='invoice_no',
        incremental_strategy='merge',
        merge_update_columns=['transaction_sk', 'created_at', 'invoice_date', 'order_id', 'payment_method', 'total_amount', 'updated_at']
    )
}}

with silver_transaction_base AS (
    select CREATED_AT, INVOICE_DATE, INVOICE_NO, ORDER_ID, PAYMENT_METHOD, TOTAL_AMOUNT, UPDATED_AT
    from {{ref('bronze_transactions') }} -- filename, where your data is coming from
    
    {% if is_incremental() %}
        where updated_at > (select max(updated_at) from {{ this }})
    {% endif %}
)
select row_number() over (order by INVOICE_NO) as transaction_sk, *
 from 
silver_transaction_base