SELECT
    transaction_id,
    customer_id,  
    branch_id,
    transaction_date as date_id,
    transaction_type,
    transaction_amount,
    anomaly
FROM {{ ref('stg_banking_data') }}