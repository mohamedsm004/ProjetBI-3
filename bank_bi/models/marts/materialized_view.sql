WITH raw_data_1 AS (
    SELECT * FROM {{ source('internal_data', 'stg_communities') }}
)

{{ config(
    materialized='materialized_view'
) }}

SELECT 
    c.customer_id,
    com.community_id
FROM {{ ref('dim_customers') }} as c
LEFT JOIN raw_data_1 as com ON c.customer_id = com.customer_id

