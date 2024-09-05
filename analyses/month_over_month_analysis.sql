WITH monthly_revenue AS (
  SELECT
    month(order_date_kyiv_timestamp) AS month,
    SUM(total_amount) AS total_revenue
  FROM {{ref("fact_sales")}}
  GROUP BY month(order_date_kyiv_timestamp)
),

revenue_growth AS (
  SELECT
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month) AS previous_month_revenue
  FROM monthly_revenue
)
-- select * from revenue_growth

SELECT
  CASE 
    WHEN month = 1 THEN 'January'
    WHEN month = 2 THEN 'February'
    WHEN month = 3 THEN 'March'
    WHEN month = 4 THEN 'April'
    WHEN month = 5 THEN 'May'
    WHEN month = 6 THEN 'June'
    WHEN month = 7 THEN 'July'
    WHEN month = 8 THEN 'August'
    WHEN month = 9 THEN 'September'
    WHEN month = 10 THEN 'October'
    WHEN month = 11 THEN 'November'
    WHEN month = 12 THEN 'December'
    ELSE 'Unknown'
  END AS month_name,
  total_revenue,
  previous_month_revenue,
  CASE 
    WHEN previous_month_revenue IS NOT NULL 
    THEN ROUND(((total_revenue - previous_month_revenue) / previous_month_revenue) * 100, 2)
    ELSE NULL
  END AS percentage_growth
FROM revenue_growth
ORDER BY month;
