SELECT *
FROM {{ ref('fct_sales') }}
WHERE number_of_rebills < 0 OR number_of_rebills != FLOOR(number_of_rebills)