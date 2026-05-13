{{ config(
    materialized='table'
) }}

SELECT distinct
    customer_id,
    first_name,
    last_name,
    age,
    gender,
    "address",
    city,
    contact_number,
    email,
    account_type,
    account_balance,
    date_of_account_opening,
    last_transaction_date,
    loan_id,
    loan_amount,
    loan_type,
    interest_rate,
    loan_term,
    approval_rejection_date,
    loan_status,
    card_id,
    card_type,
    credit_limit,
    credit_card_balance,
    minimum_payment_due,
    payment_due_date,
    last_credit_card_payment_date,
    rewards_points
FROM {{ ref('stg_banking_data') }}