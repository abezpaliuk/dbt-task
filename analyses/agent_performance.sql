WITH agent_sales AS (
  SELECT
    sales_agent_name,
    COUNT(distinct reference_id) AS num_sales,
    AVG(total_amount) AS avg_revenue,
    AVG(discount_amount) AS avg_discount,
    SUM(total_amount) AS total_revenue
  FROM {{ref("fact_sales")}}
  GROUP BY sales_agent_name
)
SELECT
  sales_agent_name,
  num_sales,
  ROUND(avg_revenue, 2) AS avg_revenue,
  ROUND(avg_discount, 2) AS avg_discount,
  total_revenue,
  RANK() OVER (ORDER BY total_revenue DESC) AS rank
FROM agent_sales
ORDER BY rank;
