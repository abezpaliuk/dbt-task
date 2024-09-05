WITH agent_discounts AS (
  SELECT
    sales_agent_name,
    AVG(discount_amount) AS avg_discount_per_agent
  FROM {{ref("fact_sales")}}
  GROUP BY sales_agent_name
),
overall_avg_discount AS (
  SELECT AVG(discount_amount) AS overall_avg_discount
  FROM {{ref("fact_sales")}}
)
SELECT
  a.sales_agent_name,
  a.avg_discount_per_agent,
  o.overall_avg_discount
FROM agent_discounts a, overall_avg_discount o
WHERE a.avg_discount_per_agent > o.overall_avg_discount
ORDER BY a.avg_discount_per_agent DESC;