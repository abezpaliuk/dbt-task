SELECT *
FROM {{ ref('fct_sales') }}
WHERE discount_amount > total_amount