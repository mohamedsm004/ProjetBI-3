SELECT

    customer_id,
    first_name,
    last_name,
    age,
    gender,
    "address",
    city,
    contact_number,
    email_address,
    account_type,
    account_balance,
    date_of_account_opening,
    last_transaction_date

FROM {{ ref('stg_banking_data') }}