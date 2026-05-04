SELECT
    customer_id,  
    branch_id,    
    transaction_date,
    sum(transaction_amount) as turnover,
    avg(transaction_amount) as avg_trans,
    AVG(account_balance) AS solde_moyen,
    count(transaction_id) as volume
FROM {{ ref('stg_banking_data') }}