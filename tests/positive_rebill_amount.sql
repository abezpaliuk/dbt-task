SELECT *
FROM {{ ref('fct_sales') }}
WHERE total_rebill_amount < 0
