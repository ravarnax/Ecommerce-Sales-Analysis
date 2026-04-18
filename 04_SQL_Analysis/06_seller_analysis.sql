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



-- Query 2 — Seller Performance Scorecard
-- Business question: Can we classify sellers into performance tiers?
-- Why it matters: This is how real marketplace operations teams decide who gets promoted in search results, who gets coaching, and who gets removed. You're building the exact framework used at Amazon, Shopify, and Mercado Livre.
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



-- Query 3 — Seller Tier Summary
-- Business question: What % of revenue comes from Platinum vs Bronze sellers?
-- 3. SELLER TIER REVENUE SUMMARY
WITH seller_metrics AS (
    SELECT
        seller_id,
        seller_state,
        COUNT(DISTINCT order_id)                        AS total_orders,
        ROUND(SUM(item_price), 2)                       AS total_gmv,
        ROUND(AVG(actual_delivery_days), 1)             AS avg_delivery_days,
        ROUND(AVG(review_score), 2)                     AS avg_review_score,
        ROUND(
            COUNT(*) FILTER (WHERE is_late_delivery = 1)
            * 100.0 / NULLIF(COUNT(*), 0)
        , 1)                                            AS late_delivery_pct
    FROM delivered_orders
    WHERE actual_delivery_days IS NOT NULL
      AND review_score IS NOT NULL
    GROUP BY seller_id, seller_state
    HAVING COUNT(DISTINCT order_id) >= 20
),
seller_tiers AS (
    SELECT
        seller_id,
        total_orders,
        total_gmv,
        avg_delivery_days,
        avg_review_score,
        late_delivery_pct,
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
        END AS seller_tier
    FROM seller_metrics
)
SELECT
    seller_tier,
    COUNT(seller_id)                                    AS seller_count,
    ROUND(
        COUNT(seller_id) * 100.0
        / SUM(COUNT(seller_id)) OVER ()
    , 1)                                                AS pct_of_sellers,
    SUM(total_orders)                                   AS total_orders,
    ROUND(SUM(total_gmv), 2)                            AS total_gmv,
    ROUND(
        SUM(total_gmv) * 100.0
        / SUM(SUM(total_gmv)) OVER ()
    , 1)                                                AS pct_of_revenue,
    ROUND(AVG(avg_delivery_days), 1)                    AS avg_delivery_days,
    ROUND(AVG(avg_review_score), 2)                     AS avg_review_score,
    ROUND(AVG(late_delivery_pct), 1)                    AS avg_late_pct
FROM seller_tiers
GROUP BY seller_tier
ORDER BY 
    CASE seller_tier
        WHEN 'Platinum — Elite seller'  THEN 1
        WHEN 'Gold — Strong seller'     THEN 2
        WHEN 'Silver — Average seller'  THEN 3
        WHEN 'Bronze — At-risk seller'  THEN 4
    END;

-- Based on the Seller Tier Revenue Summary output, 4.8% of the total platform GMV comes from Bronze sellers





-- Query 4 — Seller Geographic Distribution
-- Business question: Where are sellers concentrated geographically?
-- Why it matters: If sellers are all in São Paulo but customers are spread across Brazil, you have a structural delivery time problem. Geography is destiny in logistics.
-- 4. SELLER GEOGRAPHIC DISTRIBUTION
SELECT
    seller_state,
    COUNT(DISTINCT seller_id)                   AS unique_sellers,
    COUNT(DISTINCT order_id)                    AS total_orders,
    ROUND(SUM(item_price), 2)                   AS total_gmv,
    ROUND(AVG(actual_delivery_days), 1)         AS avg_delivery_days,
    ROUND(AVG(review_score), 2)                 AS avg_review_score,
    ROUND(
        COUNT(*) FILTER (WHERE is_late_delivery = 1)
        * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                        AS late_delivery_pct,
    ROUND(
        COUNT(DISTINCT seller_id) * 100.0
        / SUM(COUNT(DISTINCT seller_id)) OVER ()
    , 2)                                        AS pct_of_sellers
FROM delivered_orders
WHERE actual_delivery_days IS NOT NULL
GROUP BY seller_state
ORDER BY unique_sellers DESC;


-- Query 5 — Worst Performing Sellers (The Danger List)
-- Business question: Which specific sellers are actively hurting the platform?
-- Why it matters: These are the sellers that should be flagged for immediate review. In a real business, this query output goes directly to the seller operations team every Monday morning.
-- 5. AT-RISK SELLERS (THE DANGER LIST)
-- Sellers with >30 orders who consistently underperform
SELECT
    seller_id,
    seller_city,
    seller_state,
    COUNT(DISTINCT order_id)                            AS total_orders,
    ROUND(SUM(item_price), 2)                           AS total_gmv,
    ROUND(AVG(actual_delivery_days), 1)                 AS avg_delivery_days,
    ROUND(AVG(review_score), 2)                         AS avg_review_score,
    ROUND(
        COUNT(*) FILTER (WHERE review_score <= 2)
        * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                                AS negative_review_pct,
    ROUND(
        COUNT(*) FILTER (WHERE is_late_delivery = 1)
        * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                                AS late_delivery_pct,
    COUNT(DISTINCT product_category)                    AS categories_sold,
    CASE
        WHEN AVG(review_score) < 3.0
        THEN 'Critical — review crisis'
        WHEN COUNT(*) FILTER (WHERE is_late_delivery = 1)
             * 100.0 / NULLIF(COUNT(*), 0) > 50
        THEN 'Critical — delivery crisis'
        WHEN AVG(actual_delivery_days) > 25
        THEN 'High risk — consistently slow'
        ELSE 'Moderate risk'
    END                                                 AS risk_category
FROM delivered_orders
WHERE actual_delivery_days IS NOT NULL
  AND review_score IS NOT NULL
GROUP BY seller_id, seller_city, seller_state
HAVING COUNT(DISTINCT order_id) >= 30
   AND (
       AVG(review_score) < 3.5
       OR COUNT(*) FILTER (WHERE is_late_delivery = 1)
          * 100.0 / NULLIF(COUNT(*), 0) > 40
       OR AVG(actual_delivery_days) > 20
   )
ORDER BY avg_review_score ASC, late_delivery_pct DESC;


-- Query 6 — Seller Delivery Performance vs Customer Distance
-- Business question: Do sellers far from customers deliver slower?
-- Why it matters: This tests the hypothesis that geographic mismatch causes delivery delays. If true, the solution is recruiting sellers closer to underserved customer regions.
-- 6. DELIVERY PERFORMANCE BY SELLER-CUSTOMER DISTANCE
-- Proxy: same state vs different state delivery
SELECT
    CASE
        WHEN seller_state = customer_state
        THEN 'Same state — local delivery'
        ELSE 'Different state — long distance'
    END                                                 AS delivery_type,
    COUNT(DISTINCT order_id)                            AS total_orders,
    ROUND(AVG(actual_delivery_days), 1)                 AS avg_delivery_days,
    ROUND(AVG(review_score), 2)                         AS avg_review_score,
    ROUND(
        COUNT(*) FILTER (WHERE is_late_delivery = 1)
        * 100.0 / NULLIF(COUNT(*), 0)
    , 1)                                                AS late_delivery_pct,
    ROUND(AVG(freight_value), 2)                        AS avg_freight_cost,
    ROUND(
        AVG(freight_value) / NULLIF(AVG(item_price), 0) * 100
    , 1)                                                AS freight_pct_of_price
FROM delivered_orders
WHERE actual_delivery_days IS NOT NULL
  AND review_score IS NOT NULL
GROUP BY
    CASE
        WHEN seller_state = customer_state
        THEN 'Same state — local delivery'
        ELSE 'Different state — long distance'
    END;


-- Query 7 — Seller Concentration (Pareto Analysis)
-- Business question: What % of sellers generate what % of revenue?
--  SELLER REVENUE CONCENTRATION (PARETO)
WITH seller_revenue AS (
    SELECT
        seller_id,
        ROUND(SUM(item_price)::numeric, 2) AS total_gmv
    FROM delivered_orders
    GROUP BY seller_id
),
ranked_sellers AS (
    SELECT
        seller_id,
        total_gmv,
        ROW_NUMBER() OVER (ORDER BY total_gmv DESC) AS revenue_rank,
        COUNT(*) OVER ()                            AS total_sellers,
        SUM(total_gmv) OVER ()                      AS total_platform_gmv
    FROM seller_revenue
),
cumulative AS (
    SELECT
        seller_id,
        total_gmv,
        revenue_rank,
        total_sellers,
        total_platform_gmv,
        CASE
            WHEN revenue_rank <= CEIL(total_sellers * 0.01) THEN 'Top 1%'
            WHEN revenue_rank <= CEIL(total_sellers * 0.05) THEN 'Top 5%'
            WHEN revenue_rank <= CEIL(total_sellers * 0.10) THEN 'Top 10%'
            WHEN revenue_rank <= CEIL(total_sellers * 0.20) THEN 'Top 20%'
            ELSE 'Bottom 80%'
        END AS seller_segment
    FROM ranked_sellers
)
SELECT
    seller_segment,
    COUNT(seller_id)                                 AS seller_count,
    ROUND(SUM(total_gmv)::numeric, 2)                AS total_gmv,
    ROUND(
        (SUM(total_gmv) * 100.0 / MAX(total_platform_gmv))::numeric
    , 1)                                             AS pct_of_revenue
FROM cumulative
GROUP BY seller_segment, total_platform_gmv -- grouping by platform gmv allows us to use it in the PCT calc
ORDER BY 
    CASE 
        WHEN seller_segment = 'Top 1%'    THEN 1
        WHEN seller_segment = 'Top 5%'    THEN 2
        WHEN seller_segment = 'Top 10%'   THEN 3
        WHEN seller_segment = 'Top 20%'   THEN 4
        ELSE 5
    END;