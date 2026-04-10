-- =============================================
-- MASTER ANALYTICAL VIEW
-- File: 02_master_view.sql
-- Purpose: Single clean layer joining all 8 tables
--          Foundation for all business analysis
-- =============================================

CREATE OR REPLACE VIEW master_orders_view AS

WITH payment_summary AS (
    SELECT 
        order_id,
        MODE() WITHIN GROUP (ORDER BY payment_type)  AS primary_payment_type,
        MAX(payment_installments)                    AS max_payment_installments,
        SUM(payment_value)                           AS total_order_payment_value
    FROM payments 
    GROUP BY order_id
),

review_summary AS (
    SELECT DISTINCT ON (order_id)
        order_id,
        review_score
    FROM reviews 
    ORDER BY order_id, review_creation_date DESC
)

SELECT
    -- Identifiers
    o.order_id,
    o.customer_id,
    oi.order_item_id, -- Added back
    o.order_status,

    -- Time Dimensions
    o.order_purchase_timestamp,
    DATE_TRUNC('month', o.order_purchase_timestamp)         AS order_month,
    EXTRACT(YEAR  FROM o.order_purchase_timestamp)::INT     AS order_year,
    EXTRACT(MONTH FROM o.order_purchase_timestamp)::INT     AS order_month_num,
    TO_CHAR(o.order_purchase_timestamp, 'Mon YYYY')         AS order_month_name,
    TO_CHAR(o.order_purchase_timestamp, 'TMDay')            AS order_day_of_week,

    -- Delivery Raw Timestamps
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    -- Delivery Metrics (Days)
    ROUND(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400.0, 1) AS actual_delivery_days,
    ROUND(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_estimated_delivery_date)) / 86400.0, 1) AS delivery_delay_days,
    CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 1 ELSE 0 END AS is_late_delivery,

    -- Dimensions
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    
    oi.product_id, -- Added back
    COALESCE(p.product_category_name, 'others')             AS product_category,
    
    oi.seller_id, -- Added back
    s.seller_city,
    s.seller_state,

    -- Financials (Item Level)
    ROUND(oi.price::NUMERIC, 2)                             AS item_price,
    ROUND(oi.freight_value::NUMERIC, 2)                     AS freight_value,
    ROUND((oi.price + oi.freight_value)::NUMERIC, 2)        AS total_item_revenue,

    -- Aggregate Metrics from CTEs
    pay.primary_payment_type,
    pay.max_payment_installments,
    rev.review_score

FROM orders o
LEFT JOIN customers c       ON o.customer_id = c.customer_id
LEFT JOIN order_items oi    ON o.order_id = oi.order_id
LEFT JOIN products p        ON oi.product_id = p.product_id
LEFT JOIN sellers s         ON oi.seller_id = s.seller_id
LEFT JOIN payment_summary pay ON o.order_id = pay.order_id
LEFT JOIN review_summary rev  ON o.order_id = rev.order_id;




-- VERIFICATION 1: Row count check
-- Should be close to your order_items row count (~112,650)
SELECT COUNT(*) AS total_rows FROM master_orders_view;



-- VERIFICATION 2: Preview the structure
SELECT *
FROM master_orders_view
LIMIT 5;


-- VERIFICATION 3: Delivered orders only (our core analysis set)
-- Note this number — it becomes your headline KPI denominator
SELECT
    order_status,
    COUNT(DISTINCT order_id)   AS orders,
    COUNT(*)                   AS line_items,
    ROUND(SUM(item_price), 2)  AS total_gmv
FROM master_orders_view
GROUP BY order_status
ORDER BY orders DESC;


-- =============================================
-- DELIVERED ORDERS VIEW (Clean Analysis Set)
-- =============================================

CREATE OR REPLACE VIEW delivered_orders AS
SELECT *
FROM master_orders_view
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;


-- =============================================
-- Financial Double-Counting (The Fan-Out Trap).
-- =============================================
CREATE OR REPLACE VIEW payment_summary_view AS
SELECT
    order_id,
    MODE() WITHIN GROUP (ORDER BY payment_type) AS payment_type,
    MAX(payment_installments) AS payment_installments,
    ROUND(SUM(payment_value)::NUMERIC, 2) AS payment_value
FROM payments
GROUP BY order_id;


-- Quick sanity check
SELECT
    COUNT(DISTINCT order_id)        AS delivered_orders,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,
    COUNT(DISTINCT seller_id)       AS active_sellers,
    COUNT(DISTINCT product_category) AS product_categories,
    ROUND(SUM(item_price), 2)       AS total_gmv_brl,
    ROUND(AVG(item_price), 2)       AS avg_order_value,
    MIN(order_purchase_timestamp)   AS data_start,
    MAX(order_purchase_timestamp)   AS data_end
FROM delivered_orders;


Output:
    "delivered_orders"	"unique_customers"	"active_sellers"	"product_categories"	"total_gmv_brl"	"avg_order_value"	"data_start"	        "data_end"
    96470	                93350	                2970	                74	           13220248.93	    119.98	         "2016-09-15 12:16:38"	"2018-08-29 15:00:37"