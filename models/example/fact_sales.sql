{{ config(materialized='table') }}

WITH fact_sales AS (
  SELECT distinct
    COALESCE(ReferenceID, 'N/A') AS Reference_ID,
    COALESCE(ProductCode, 'N/A') AS Product_Code,
    COALESCE(ProductName, 'N/A') AS Product_Name,
    COALESCE(SalesAgentName, 'N/A') AS Sales_Agent_Name,
    COALESCE(Country, 'N/A') AS Country,
    COALESCE(CampaignName, 'N/A') AS Campaign_Name,
    COALESCE(Source, 'N/A') AS Source,
    COALESCE(TotalAmount, 0) + COALESCE(TotalRebillAmount, 0) - COALESCE(ReturnedAmount, 0) AS Total_Amount_Including_Rebills_Refunds,
    TotalRebillAmount AS Total_Rebill_Amount,
    NumberOfRebills AS Number_Of_Rebills,
    DiscountAmount AS Discount_Amount,
    ReturnedAmount AS Returned_Amount,
    TotalAmount AS Total_Amount,
    to_timestamp(OrderDateKyiv, 'MMMM d, yyyy, h:mm a') AS Order_Date_Kyiv_Timestamp,
    to_timestamp(ReturnDateKyiv, 'MMMM d, yyyy, h:mm a') AS Return_Date_Kyiv_Timestamp,
      DATEDIFF(
      to_timestamp(ReturnDateKyiv, 'MMMM d, yyyy, h:mm a'),
      to_timestamp(OrderDateKyiv, 'MMMM d, yyyy, h:mm a')
    ) AS Days_Difference
  FROM `hive_metastore`.`sales`.`sales_data`
)
SELECT
  Reference_ID,
  Product_Code,
  Product_Name,
  Sales_Agent_Name,
  Country,
  Campaign_Name,
  Source,
  Total_Amount_Including_Rebills_Refunds,
  Total_Rebill_Amount,
  Number_Of_Rebills,
  Discount_Amount,
  Returned_Amount,
  Total_Amount,
  Order_Date_Kyiv_Timestamp,
  to_utc_timestamp(
      Order_Date_Kyiv_Timestamp, 
      'Europe/Kiev'
      ) AS Order_Date_UTC,
    from_utc_timestamp(
        to_utc_timestamp(
          Order_Date_Kyiv_Timestamp, 
          'Europe/Kiev'
        ), 
        'America/New_York'
      ) AS Order_Date_New_York,
  Return_Date_Kyiv_Timestamp,
  to_utc_timestamp(
      Return_Date_Kyiv_Timestamp, 
      'Europe/Kiev'
      ) AS Return_Date_UTC,
    from_utc_timestamp(
        to_utc_timestamp(
          Return_Date_Kyiv_Timestamp, 
          'Europe/Kiev'
        ), 
        'America/New_York'
      ) AS Return_Date_New_York,
  Days_Difference
FROM fact_sales