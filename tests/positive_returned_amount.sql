SELECT *
FROM {{ ref('fct_sales') }}
WHERE returned_amount < 0