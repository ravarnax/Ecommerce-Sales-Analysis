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

-- Business question: Which categories consistently disappoint customers?
-- Why it matters: Low review scores in a category signal a systemic problem — bad sellers, product quality issues, mismatched expectations, or delivery damage. These categories are quietly destroying your NPS.

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

-- Business question: Which categories are growing and which are declining?
-- Why it matters: A category that was your top performer in 2017 but is shrinking in 2018 is a warning sign. A small category that doubled in 6 months is a signal to invest now before competitors notice.

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


-- 5. FREIGHT COST ANALYSIS BY CATEGORY

-- Business question: Which product categories are the most expensive to ship relative to their value?
-- Why it matters: High freight-to-GMV ratio means either the products are heavy and bulky, the sellers are far from customers, or Olist is subsidizing shipping. Any of these is a profitability problem.

SELECT
    product_category,
    COUNT(DISTINCT order_id)                     AS total_orders,
    ROUND(AVG(item_price), 2)                    AS avg_item_price,
    ROUND(AVG(freight_value), 2)                 AS avg_freight_value,
    ROUND(
        AVG(freight_value)
        / NULLIF(AVG(item_price), 0) * 100
    , 1)                                         AS freight_to_price_ratio_pct,
    ROUND(AVG(actual_delivery_days), 1)          AS avg_delivery_days,
    ROUND(AVG(review_score), 2)                  AS avg_review_score
FROM delivered_orders
GROUP BY product_category
HAVING COUNT(DISTINCT order_id) >= 50
ORDER BY freight_to_price_ratio_pct DESC
LIMIT 20;

-- 6. TOP CATEGORY PER STATE

-- Business question: Do customers in different states buy different categories?
-- Why it matters: Regional preference data is gold for marketing teams. It tells you which products to promote in which regions and helps sellers know where to focus their inventory.

WITH state_category_rank AS (
    SELECT
        customer_state,
        product_category,
        COUNT(DISTINCT order_id)          AS total_orders,
        ROUND(SUM(item_price), 2)         AS gmv,
        RANK() OVER (
            PARTITION BY customer_state
            ORDER BY COUNT(DISTINCT order_id) DESC
        )                                 AS rank_in_state
    FROM delivered_orders
    GROUP BY customer_state, product_category
)
SELECT
    customer_state,
    product_category                      AS top_category,
    total_orders,
    gmv
FROM state_category_rank
WHERE rank_in_state = 1
ORDER BY total_orders DESC;




-- 7. CATEGORY SEASONALITY
-- Business question: Do certain categories spike at specific times of year?

WITH top_5 AS (
    SELECT product_category
    FROM delivered_orders
    GROUP BY product_category
    ORDER BY SUM(item_price) DESC
    LIMIT 5
)
SELECT
    d.product_category,
    d.order_month_num,
    TO_CHAR(DATE_TRUNC('month',
        MIN(d.order_purchase_timestamp))
    , 'Mon')                              AS month_short,
    COUNT(DISTINCT d.order_id)            AS total_orders,
    ROUND(SUM(d.item_price), 2)           AS gmv
FROM delivered_orders d
INNER JOIN top_5 t
    ON d.product_category = t.product_category
GROUP BY d.product_category, d.order_month_num
ORDER BY d.product_category, d.order_month_num;

