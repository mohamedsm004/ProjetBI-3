SELECT DISTINCT

    transaction_type AS type_id,

FROM {{ ref('stg_banking_data') }}