-- Ce modèle prépare les données pour l'entrepôt et le graphe
WITH raw_data AS (
    SELECT * FROM {{ source('internal_data', 'raw_transactions') }}
)

SELECT

    -- Conversion des types
    CAST(customer_id AS INTEGER) AS customer_id,
    first_name,
    last_name,
    CAST(age AS INTEGER) AS age,
    gender,
    "address",
    city,
    CAST(contact_number AS INTEGER) AS contact_number,
    email,
    account_type,
    CAST(account_balance AS DECIMAL(12, 2)) AS account_balance,
    CAST(date_of_account_opening AS DATE) AS date_of_account_opening,
    CAST(last_transaction_date AS DATE) AS last_transaction_date,
    CAST(transaction_id AS INTEGER) AS transaction_id,
    CAST(transaction_date AS DATE) AS transaction_date,
    transaction_type,
    CAST(transaction_amount AS DECIMAL(12, 2)) AS transaction_amount,
    CAST(account_balance_after_transaction AS DECIMAL(12, 2)) AS account_balance_after_transaction,
    CAST(branch_id AS INTEGER) AS branch_id,
    CAST(loan_id AS INTEGER) AS loan_id,
    CAST(loan_amount AS DECIMAL(12, 2)) AS loan_amount,
    loan_type,
    CAST(interest_rate AS DECIMAL(12, 2)) AS interest_rate,
    CAST(loan_term AS INTEGER) AS loan_term,
    CAST(approval_rejection_date AS DATE) AS approval_rejection_date,
    loan_status,
    CAST(card_id AS INTEGER) AS card_id,
    card_type,
    CAST(credit_limit AS decimal(12, 2)) as credit_limit,
    cast(credit_card_balance as decimal(12,2)) as credit_card_balance,
    cast(minimum_payment_due as decimal(12,2)) as minimum_payment_due,
    cast(payment_due_date as date) as payment_due_date,
    cast(last_credit_card_payment_date as date) as last_credit_card_payment_date,
    cast(rewards_points as integer) as rewards_points,
    cast(feedback_id as integer) as feedback_id,
    cast(feedback_date as date) as feedback_date,
    feedback_type,
    resolution_status,
    cast(resolution_date as date) as resolution_date,
    cast(anomaly as integer) as anomaly,
    'Branch_' || CAST(branch_id AS TEXT) AS branch_name
    
FROM raw_data