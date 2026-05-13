{{ config(
    materialized='table'
) }}

SELECT DISTINCT
    transaction_date AS date_id,
    transaction_date,
    EXTRACT(YEAR FROM transaction_date) AS year_trans,
    EXTRACT(MONTH FROM transaction_date) AS month_trans,
    EXTRACT(QUARTER FROM transaction_date) AS quarter_trans,
    TO_CHAR(transaction_date, 'Month') AS month_name,
    TO_CHAR(transaction_date, 'Day') AS day_name
FROM {{ ref('stg_banking_data') }}