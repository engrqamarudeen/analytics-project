with silver_transaction_base AS (
    select CREATED_AT, INVOICE_DATE, INVOICE_NO, ORDER_ID, PAYMENT_METHOD, TOTAL_AMOUNT, UPDATED_AT
    from {{ref('bronze_transactions') }} -- filename, where your data is coming from
)
select row_number() over (order by INVOICE_NO) as transaction_sk, *
 from 
silver_transaction_base