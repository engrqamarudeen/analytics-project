{{
    config(
        materialized='incremental',
        unique_key='INVOICE_NO',
        incremental_strategy='merge',
        merge_update_columns=['CREATED_AT', 'INVOICE_DATE', 'ORDER_ID', 'PAYMENT_METHOD', 'TOTAL_AMOUNT', 'UPDATED_AT']
    )
}}

with bronze_transactions AS (
    select CREATED_AT, INVOICE_DATE, INVOICE_NO, ORDER_ID, PAYMENT_METHOD, TOTAL_AMOUNT, UPDATED_AT
    from {{source('data_source_snowflake', 'TRANSACTIONS') }}
    
    {% if is_incremental() %}
        where UPDATED_AT > (select max(UPDATED_AT) from {{ this }})
    {% endif %}
)
select * from bronze_transactions
