-- query 01 : revenue by product category
-- business question : which product categories generate the most revenue?
-- why it matters : this is the most important product metric for any marketplace. It directly measures platform loyalty.
                    -- Category revenue concentration tells you where your business actually lives vs. where you think it lives. Most marketplace leaders are surprised by this answer

-- 1. REVENUE BY PRODUCT CATEGORY
SELECT
	product_category,
	COUNT(DISTINCT order_id) AS total_orders,
	COUNT(DISTINCT customer_unique_id) AS unique_customers,
	ROUND(SUM(item_price), 2) AS total_gmv,
	ROUND(AVG(item_price), 2) AS avg_order_value,
	ROUND(SUM(freight_value), 2) AS total_freight,
	ROUND(SUM(freight_value) / NULLIF(SUM(item_price), 0) * 100, 1) AS freight_pct_of_gmv,
	ROUND(AVG(review_score), 2) AS avg_review_score,
	ROUND(SUM(item_price) * 100.0 / SUM(SUM(item_price)) OVER (), 2) AS pct_of_total_gmv
	FROM delivered_orders
	GROUP BY product_category
	ORDER BY total_gmv DESC;


-- Query 2 — Category Performance Matrix
-- Business question: Which categories are high volume AND high value vs. high volume but low value?
-- Why it matters: This is the classic 2x2 matrix analysis. High volume + high value = invest more. High volume + low value = fix the economics or deprioritize. Low volume + high value = hidden gem worth growing.

-- 2. CATEGORY PERFORMANCE MATRIX
WITH category_stats AS (
    SELECT
        product_category,
        COUNT(DISTINCT order_id)           AS total_orders,
        ROUND(SUM(item_price), 2)          AS total_gmv,
        ROUND(AVG(item_price), 2)          AS avg_order_value,
        ROUND(AVG(review_score), 2)        AS avg_review_score,
        ROUND(
            SUM(freight_value)
            / NULLIF(SUM(item_price), 0) * 100
        , 1)                               AS freight_pct
    FROM delivered_orders
    GROUP BY product_category
),
averages AS (
    SELECT
        AVG(total_orders)       AS avg_orders,
        AVG(avg_order_value)    AS avg_aov
    FROM category_stats
)
SELECT
    cs.product_category,
    cs.total_orders,
    cs.total_gmv,
    cs.avg_order_value,
    cs.avg_review_score,
    cs.freight_pct,
    CASE
        WHEN cs.total_orders > a.avg_orders
         AND cs.avg_order_value > a.avg_aov
        THEN 'Star — high volume, high value'
        WHEN cs.total_orders > a.avg_orders
         AND cs.avg_order_value <= a.avg_aov
        THEN 'Workhorse — high volume, low value'
        WHEN cs.total_orders <= a.avg_orders
         AND cs.avg_order_value > a.avg_aov
        THEN 'Hidden gem — low volume, high value'
        ELSE 'Underperformer — low volume, low value'
    END                                    AS category_quadrant
FROM category_stats cs
CROSS JOIN averages a
ORDER BY cs.total_gmv DESC;


-- 3. CATEGORY SATISFACTION RANKING
-- Minimum 100 orders to be statistically meaningful
WITH category_reviews AS (
    SELECT
        product_category,
        COUNT(DISTINCT order_id)        AS total_orders,
        ROUND(AVG(review_score), 2)     AS avg_review_score,
        COUNT(*) FILTER (
            WHERE review_score >= 4
        )                               AS positive_reviews,
        COUNT(*) FILTER (
            WHERE review_score <= 2
        )                               AS negative_reviews,
        ROUND(
            COUNT(*) FILTER (WHERE review_score >= 4)
            * 100.0 / NULLIF(COUNT(*), 0)
        , 1)                            AS positive_review_pct,
        ROUND(
            COUNT(*) FILTER (WHERE review_score <= 2)
            * 100.0 / NULLIF(COUNT(*), 0)
        , 1)                            AS negative_review_pct
    FROM delivered_orders
    WHERE review_score IS NOT NULL
    GROUP BY product_category
    HAVING COUNT(DISTINCT order_id) >= 100
)
SELECT
    product_category,
    total_orders,
    avg_review_score,
    positive_review_pct,
    negative_review_pct,
    RANK() OVER (ORDER BY avg_review_score DESC)  AS satisfaction_rank
FROM category_reviews
ORDER BY avg_review_score DESC;


-- BOTTOM 10 CATEGORIES BY SATISFACTION
WITH category_reviews AS (
    SELECT
        product_category,
        COUNT(DISTINCT order_id)          AS total_orders,
        ROUND(AVG(review_score), 2)       AS avg_review_score,
        ROUND(
            COUNT(*) FILTER (WHERE review_score <= 2)
            * 100.0 / NULLIF(COUNT(*), 0)
        , 1)                              AS negative_review_pct,
        ROUND(AVG(actual_delivery_days), 1) AS avg_delivery_days,
        ROUND(
            SUM(freight_value)
            / NULLIF(SUM(item_price), 0) * 100
        , 1)                              AS freight_pct
    FROM delivered_orders
    WHERE review_score IS NOT NULL
    GROUP BY product_category
    HAVING COUNT(DISTINCT order_id) >= 100
)
SELECT *
FROM category_reviews
ORDER BY avg_review_score ASC
LIMIT 10;


-- 4. CATEGORY REVENUE TREND (TOP 10 CATEGORIES)
WITH top_categories AS (
    SELECT product_category
    FROM delivered_orders
    GROUP BY product_category
    ORDER BY SUM(item_price) DESC
    LIMIT 10
)
SELECT
    d.product_category,
    d.order_year,
    d.order_month_num,
    d.order_month_name,
    d.order_month,
    COUNT(DISTINCT d.order_id)      AS total_orders,
    ROUND(SUM(d.item_price), 2)     AS gmv
FROM delivered_orders d
INNER JOIN top_categories tc
    ON d.product_category = tc.product_category
GROUP BY
    d.product_category,
    d.order_year,
    d.order_month_num,
    d.order_month_name,
    d.order_month
ORDER BY
    d.product_category,
    d.order_month;



