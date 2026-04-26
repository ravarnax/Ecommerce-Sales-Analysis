-- EDA QUERY 1 - CHECK ORDER STATUS DISTRIBUTION
SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- EDA QUERY 2 - CHECK DATE RANGE OF ORDERS
SELECT
	MIN(order_purchase_timestamp) AS first_order,
	MAX(order_purchase_timestamp) AS last_order
FROM orders;

-- EDA QUERY 3 - MISSING DELIVERY DATES
SELECT COUNT(*)
FROM orders
WHERE order_delivered_customer_date IS NULL;


-- EDA QUERY 4 - AVERAGE ORDER VALUE (AOV)
SELECT SUM(price) / COUNT(DISTINCT order_id) AS avg_order_value
FROM order_items;

-- EDA QUERY 5 - TOP PRODUCT CATEGORIES
SELECT 
	p.product_category_name,
	COUNT(*) AS items_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY items_sold DESC
LIMIT 10;

-- EDA QUERY 6 - PAYMENT METHOD DISTRIBUTION
SELECT
	payment_type,
	COUNT(*) AS total_payments
FROM payments
GROUP BY payment_type
ORDER BY total_payments DESC;

-- EDA QUERY 7 - AVERAGE REVIEW SCORE
SELECT AVG(review_score) AS avg_rating
FROM reviews;