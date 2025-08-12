with bronze_transactions AS (
    select CREATED_AT, INVOICE_DATE, INVOICE_NO, ORDER_ID, PAYMENT_METHOD, TOTAL_AMOUNT, UPDATED_AT
    from {{source('data_source_snowflake', 'TRANSACTIONS') }}
)
select * from bronze_transactions
