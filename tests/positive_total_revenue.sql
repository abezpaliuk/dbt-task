SELECT *
FROM {{ ref('fct_sales') }}
WHERE (total_amount + total_rebill_amount - returned_amount) < 0
