-- =============================================
-- SELLER PERFORMANCE ANALYSIS
-- File: 06_seller_analysis.sql
-- =============================================

-- 1. SELLER REVENUE LEADERBOARD (TOP 50)
SELECT
    seller_id,
    seller_city,
    seller_state,
    COUNT(DISTINCT order_id)                    AS total_orders,
    COUNT(DISTINCT customer_unique_id)          AS unique_customers,
    COUNT(DISTINCT product_category)            AS categories_sold,
    ROUND(SUM(item_price), 2)                   AS total_gmv,
    ROUND(AVG(item_price), 2)                   AS avg_order_value,
    ROUND(SUM(freight_value), 2)                AS total_freight,
    ROUND(
        SUM(freight_value) / NULLIF(SUM(item_price), 0) * 100
    , 1)                                        AS freight_pct_of_gmv,
    ROUND(AVG(actual_delivery_days), 1)         AS avg_delivery_days,
    ROUND(AVG(review_score), 2)                 AS avg_review_score,
    ROUND(
        COUNT(*) FILTER (WHERE is_late_delivery = 1)
        * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                        AS late_delivery_pct
FROM delivered_orders
WHERE actual_delivery_days IS NOT NULL
  AND review_score IS NOT NULL
GROUP BY seller_id, seller_city, seller_state
HAVING COUNT(DISTINCT order_id) >= 10
ORDER BY total_gmv DESC
LIMIT 50;




-- 2. SELLER PERFORMANCE SCORECARD
-- Minimum 20 orders for statistical significance
WITH seller_metrics AS (
    SELECT
        seller_id,
        seller_state,
        COUNT(DISTINCT order_id)                        AS total_orders,
        ROUND(SUM(item_price), 2)                       AS total_gmv,
        ROUND(AVG(item_price), 2)                       AS avg_order_value,
        ROUND(AVG(actual_delivery_days), 1)             AS avg_delivery_days,
        ROUND(AVG(review_score), 2)                     AS avg_review_score,
        ROUND(
            COUNT(*) FILTER (WHERE is_late_delivery = 1)
            * 100.0 / NULLIF(COUNT(*), 0)
        , 1)                                            AS late_delivery_pct,
        ROUND(
            SUM(freight_value) / NULLIF(SUM(item_price), 0) * 100
        , 1)                                            AS freight_pct
    FROM delivered_orders
    WHERE actual_delivery_days IS NOT NULL
      AND review_score IS NOT NULL
    GROUP BY seller_id, seller_state
    HAVING COUNT(DISTINCT order_id) >= 20
)
SELECT
    seller_id,
    seller_state,
    total_orders,
    total_gmv,
    avg_delivery_days,
    avg_review_score,
    late_delivery_pct,
    freight_pct,
    CASE
        WHEN avg_review_score >= 4.2
         AND late_delivery_pct <= 10
         AND avg_delivery_days <= 12
        THEN 'Platinum — Elite seller'
        WHEN avg_review_score >= 4.0
         AND late_delivery_pct <= 20
         AND avg_delivery_days <= 15
        THEN 'Gold — Strong seller'
        WHEN avg_review_score >= 3.5
         AND late_delivery_pct <= 30
        THEN 'Silver — Average seller'
        WHEN avg_review_score < 3.5
         OR late_delivery_pct > 40
         OR avg_delivery_days > 20
        THEN 'Bronze — At-risk seller'
        ELSE 'Silver — Average seller'
    END                                                 AS seller_tier
FROM seller_metrics
ORDER BY total_gmv DESC;