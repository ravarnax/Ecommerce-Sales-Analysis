-- =============================================
-- DELIVERY & LOGISTICS PERFORMANCE ANALYSIS
-- File: 07_delivery_logistics_analysis.sql
-- =============================================


-- Query 1 — Overall Delivery Performance Summary
-- Business question: What does Olist's delivery performance look like at a platform level?
-- Why it matters: This is the single scorecard metric that every logistics team reports weekly. It's the first slide in every operations review.


-- 1. OVERALL DELIVERY PERFORMANCE SUMMARY
-- 1. OVERALL DELIVERY PERFORMANCE SUMMARY (Fixed for PostgreSQL)
SELECT
    COUNT(DISTINCT order_id)                             AS total_orders,
    
    -- Delivery time metrics
    ROUND(AVG(actual_delivery_days)::numeric, 1)          AS avg_delivery_days,
    -- Fixed: Added ::numeric cast here
    ROUND(
        (PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY actual_delivery_days))::numeric
    , 1)                                                 AS median_delivery_days,
    ROUND(MIN(actual_delivery_days)::numeric, 1)          AS fastest_delivery,
    ROUND(MAX(actual_delivery_days)::numeric, 1)          AS slowest_delivery,
    
    -- On-time performance
    COUNT(*) FILTER (WHERE is_late_delivery = 0)         AS on_time_orders,
    COUNT(*) FILTER (WHERE is_late_delivery = 1)         AS late_orders,
    ROUND(
        COUNT(*) FILTER (WHERE is_late_delivery = 0) * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                                 AS on_time_pct,
    ROUND(
        COUNT(*) FILTER (WHERE is_late_delivery = 1) * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                                 AS late_pct,
    
    -- Early deliveries (delivered before estimated date)
    COUNT(*) FILTER (WHERE delivery_delay_days < 0)      AS early_orders,
    ROUND(
        COUNT(*) FILTER (WHERE delivery_delay_days < 0) * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                                 AS early_pct,
    
    -- Average delay (for late orders only)
    ROUND(AVG(delivery_delay_days) FILTER (WHERE is_late_delivery = 1)::numeric, 1) AS avg_delay_when_late,
    
    -- Freight cost
    ROUND(AVG(freight_value)::numeric, 2)                AS avg_freight_cost,
    ROUND(
        (AVG(freight_value) / NULLIF(AVG(item_price), 0) * 100)::numeric
    , 1)                                                 AS avg_freight_pct_of_price
    
FROM delivered_orders
WHERE actual_delivery_days IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL;



-- Query 2 — Delivery Performance Trend Over Time
-- Business question: Is delivery performance improving or degrading as Olist scales?
-- Why it matters: If delivery times are getting worse as order volume grows, it means the logistics infrastructure isn't scaling with the business. This is a major red flag.


-- 2. DELIVERY PERFORMANCE TREND (MONTHLY)
SELECT
    order_month,
    order_month_name,
    COUNT(DISTINCT order_id)                             AS total_orders,
    ROUND(AVG(actual_delivery_days)::numeric, 1)          AS avg_delivery_days,
    ROUND(
        (PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY actual_delivery_days))::numeric
    , 1)                                                 AS median_delivery_days,
    ROUND(
        COUNT(*) FILTER (WHERE is_late_delivery = 1)
        * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                                 AS late_delivery_pct,
    ROUND(AVG(freight_value)::numeric, 2)                AS avg_freight_cost,
    ROUND(AVG(review_score)::numeric, 2)                 AS avg_review_score
FROM delivered_orders
WHERE actual_delivery_days IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
GROUP BY order_month, order_month_name
ORDER BY order_month;



-- Query 3 — Delivery Performance by Customer State
-- Business question: Which Brazilian states get the worst delivery service?   
-- Why it matters: If Northern and Northeastern states consistently deliver 5-10 days slower than São Paulo, you've proven geographic inequality in service quality. This connects directly to the customer concentration finding from Step 5.

-- 3. DELIVERY PERFORMANCE BY CUSTOMER STATE (PostgreSQL Optimized)
SELECT
    customer_state,
    COUNT(DISTINCT order_id)                             AS total_orders,
    -- Added ::numeric cast for rounding
    ROUND(AVG(actual_delivery_days)::numeric, 1)          AS avg_delivery_days,
    -- Fixed Median: Added ::numeric cast here
    ROUND(
        (PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY actual_delivery_days))::numeric
    , 1)                                                 AS median_delivery_days,
    ROUND(
        COUNT(*) FILTER (WHERE is_late_delivery = 1)
        * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                                 AS late_delivery_pct,
    ROUND(AVG(freight_value)::numeric, 2)                AS avg_freight_cost,
    ROUND(
        (AVG(freight_value) / NULLIF(AVG(item_price), 0) * 100)::numeric
    , 1)                                                 AS freight_pct_of_price,
    ROUND(AVG(review_score)::numeric, 2)                 AS avg_review_score
FROM delivered_orders
WHERE actual_delivery_days IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
GROUP BY customer_state
HAVING COUNT(DISTINCT order_id) >= 100
ORDER BY avg_delivery_days DESC;




-- Query 4 — Delivery Performance by Seller State
-- Business question: Do sellers from certain states deliver faster than others?


-- 4. DELIVERY PERFORMANCE BY SELLER STATE
SELECT
    seller_state,
    COUNT(DISTINCT seller_id)                           AS unique_sellers,
    COUNT(DISTINCT order_id)                            AS total_orders,
    ROUND(AVG(actual_delivery_days), 1)                 AS avg_delivery_days,
    ROUND(
        COUNT(*) FILTER (WHERE is_late_delivery = 1)
        * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                                AS late_delivery_pct,
    ROUND(AVG(freight_value), 2)                        AS avg_freight_cost,
    ROUND(AVG(review_score), 2)                         AS avg_review_score
FROM delivered_orders
WHERE actual_delivery_days IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
GROUP BY seller_state
HAVING COUNT(DISTINCT order_id) >= 100
ORDER BY avg_delivery_days ASC;


-- 5. SLOWEST DELIVERY ROUTES (TOP 20)
SELECT
    seller_state                                        AS from_state,
    customer_state                                      AS to_state,
    COUNT(DISTINCT order_id)                            AS total_orders,
    ROUND(AVG(actual_delivery_days), 1)                 AS avg_delivery_days,
    ROUND(
        COUNT(*) FILTER (WHERE is_late_delivery = 1)
        * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                                AS late_delivery_pct,
    ROUND(AVG(freight_value), 2)                        AS avg_freight_cost,
    ROUND(AVG(review_score), 2)                         AS avg_review_score
FROM delivered_orders
WHERE actual_delivery_days IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
GROUP BY seller_state, customer_state
HAVING COUNT(DISTINCT order_id) >= 50
ORDER BY avg_delivery_days DESC
LIMIT 20;




-- Query 6 — Delivery Delay Impact on Review Score
-- Business question: Exactly how much does delivery delay hurt review scores?
-- Why it matters: This quantifies the business cost of late delivery in customer satisfaction terms. It's the causal proof you need to justify logistics investment.


-- 6. DELIVERY DELAY IMPACT ON REVIEW SCORE

-- 6. DELIVERY DELAY IMPACT ON REVIEW SCORE (Fixed)
WITH delay_analysis AS (
    SELECT
        order_id,
        review_score,
        CASE
            WHEN delivery_delay_days <= -5  THEN '5+ days early'
            WHEN delivery_delay_days <= -1  THEN '1-4 days early'
            WHEN delivery_delay_days = 0   THEN 'Exactly on time'
            WHEN delivery_delay_days <= 3   THEN '1-3 days late'
            WHEN delivery_delay_days <= 7   THEN '4-7 days late'
            WHEN delivery_delay_days <= 14  THEN '8-14 days late'
            ELSE '15+ days late'
        END AS delay_bucket
    FROM delivered_orders
    WHERE delivery_delay_days IS NOT NULL
      AND review_score IS NOT NULL
)
SELECT
    delay_bucket,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT order_id) * 100.0 / SUM(COUNT(DISTINCT order_id)) OVER ()
    , 1) AS pct_of_orders,
    ROUND(AVG(review_score)::numeric, 2) AS avg_review_score,
    ROUND(
        COUNT(*) FILTER (WHERE review_score <= 2) * 100.0 / NULLIF(COUNT(*), 0)
    , 1) AS negative_review_pct,
    ROUND(
        COUNT(*) FILTER (WHERE review_score >= 4) * 100.0 / NULLIF(COUNT(*), 0)
    , 1) AS positive_review_pct
FROM delay_analysis
GROUP BY delay_bucket
ORDER BY
    CASE
        WHEN delay_bucket = '5+ days early'   THEN 1
        WHEN delay_bucket = '1-4 days early'  THEN 2
        WHEN delay_bucket = 'Exactly on time' THEN 3
        WHEN delay_bucket = '1-3 days late'   THEN 4
        WHEN delay_bucket = '4-7 days late'   THEN 5
        WHEN delay_bucket = '8-14 days late'  THEN 6
        WHEN delay_bucket = '15+ days late'   THEN 7
    END;





-- Query 7 — Delivery Performance by Product Category
-- Business question: Are certain product categories consistently slower to deliver?
-- Why it matters: If furniture and mattresses always deliver late, it's either because they're bulky (freight issue) or sellers in those categories are worse performers (seller quality issue). Either way, it's actionable.


-- 7. DELIVERY PERFORMANCE BY PRODUCT CATEGORY (PostgreSQL Optimized)
WITH top_categories AS (
    SELECT product_category
    FROM delivered_orders
    GROUP BY product_category
    ORDER BY SUM(item_price) DESC
    LIMIT 15
)
SELECT
    d.product_category,
    COUNT(DISTINCT d.order_id)                             AS total_orders,
    -- Fixed: Cast AVG to ::numeric for ROUND function
    ROUND(AVG(d.actual_delivery_days)::numeric, 1)          AS avg_delivery_days,
    ROUND(
        COUNT(*) FILTER (WHERE d.is_late_delivery = 1)
        * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                                   AS late_delivery_pct,
    ROUND(AVG(d.freight_value)::numeric, 2)                AS avg_freight_cost,
    ROUND(
        (AVG(d.freight_value) / NULLIF(AVG(d.item_price), 0) * 100)::numeric
    , 1)                                                   AS freight_pct_of_price,
    ROUND(AVG(d.review_score)::numeric, 2)                 AS avg_review_score
    -- Note: avg_weight_grams removed as product_weight_g is not in delivered_orders
FROM delivered_orders d
INNER JOIN top_categories tc
    ON d.product_category = tc.product_category
WHERE d.actual_delivery_days IS NOT NULL
  AND d.order_delivered_customer_date IS NOT NULL
GROUP BY d.product_category
ORDER BY avg_delivery_days DESC;

