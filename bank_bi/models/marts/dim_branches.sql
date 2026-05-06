select distinct
    branch_id,
    branch_name
from {{ref('stg_banking_data')}}