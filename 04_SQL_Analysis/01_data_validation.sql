-- =============================================
-- OLIST DATA VALIDATION
-- File: 01_data_validation.sql
-- Author: SHIVAM KOTHIYAL
-- Date: 10-04-2026
-- =============================================

-- 1. ROW COUNT AUDIT
-- Business question: Did all our data load correctly?
-- Expected counts based on Kaggle dataset documentation

SELECT 'customers'       AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'orders',                         COUNT(*)             FROM orders
UNION ALL
SELECT 'order_items',                    COUNT(*)             FROM order_items
UNION ALL
SELECT 'order_payments',                 COUNT(*)             FROM order_payments
UNION ALL
SELECT 'order_reviews',                  COUNT(*)             FROM order_reviews
UNION ALL
SELECT 'products',                       COUNT(*)             FROM products
UNION ALL
SELECT 'sellers',                        COUNT(*)             FROM sellers
UNION ALL
SELECT 'geolocation',                    COUNT(*)             FROM geolocation
ORDER BY row_count DESC;

Output:
        "table_name"	  "row_count"
        "geolocation"	    1000163
        "order_items"	    112650
        "order_payments"	103886
        "customers"	        99441
        "orders"	        99441
        "order_reviews" 	99224
        "products"	        32951
        "sellers"	        3095


-- Query 2 — Date Range Check
-- Business question: What time period does our data actually cover?

SELECT 
    MIN(order_purchase_timestamp) AS earliest_order,
    MAX(order_purchase_timestamp) AS latest_order,
    MAX(order_purchase_timestamp) :: DATE 
        - MIN(order_purchase_timestamp) :: DATE AS total_days_span,
    COUNT(DISTINCT DATE_TRUNC('month', order_purchase_timestamp)) AS months_of_data
    COUNT(DISTINCT DATE_TRUNC('year', order_purchase_timestamp)) AS year_of_data
FROM orders;


Output: 
"earliest_order"	    "latest_order"	        "total_days_span"	"months_of_data"	"year_of_data"
"2016-09-04 21:15:19"	"2018-10-17 17:30:18"	    773	                25	                3


-- Query 3 — Order Status Distribution
-- Business question: What share of orders actually completed? This affects every revenue metric.

SELECT 
    order_status AS order_count,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

Output:
        "order_count"	"total_orders"	"pct_of_total"
        "unavailable"	    609	            0.61
        "shipped"	        1107	        1.11
        "processing"	    301	            0.30
        "invoiced"	        314	            0.32
        "delivered"	        96478	        97.02
        "created"	        5	            0.01
        "canceled"	        625	            0.63
        "approved"	        2	            0.00



-- Query 4 — Null Value Audit on Critical Columns
-- Business question: Which columns have missing data that could break our analysis?

-- check null values in orders table
SELECT 
    t.table_name,
    jsonb_object_agg(c.column_name, (
        SELECT count(*) 
        FROM orders
        WHERE c.column_name IS NULL
    )) as null_counts
FROM information_schema.columns c
JOIN information_schema.tables t ON c.table_name = t.table_name
WHERE t.table_name = 'orders'
GROUP BY t.table_name;

Output:
    "null_counts"
    "{""order_id"": 0, ""customer_id"": 0, ""order_status"": 0, ""order_approved_at"": 0, ""order_purchase_timestamp"": 0, ""order_delivered_carrier_date"": 0, ""order_delivered_customer_date"": 0, ""order_estimated_delivery_date"": 0}"


-- QUERY 4.1 -- Missing Delivery Info
-- Business question: Are there orders that show as delivered but lack delivery dates?

SELECT 
    MIN(order_purchase_timestamp) as earliest_date,
    COUNT(*) FILTER (WHERE order_status = 'delivered' AND order_delivered_customer_date IS NULL) as missing_delivery_info
FROM orders;

Output:
"earliest_date"	"missing_delivery_info"
"2016-09-04 21:15:19"	8


-- Query 4.2 — Geolocation Data Quality
-- Business question: Is our location data complete and valid?

SELECT 
    COUNT(*) as total_rows,
    COUNT(DISTINCT geolocation_zip_code_prefix) as unique_zips,
    COUNT(*) - COUNT(geolocation_lat) as null_lats,
    COUNT(*) - COUNT(geolocation_lng) as null_lngs,
    COUNT(*) FILTER (WHERE geolocation_lat = 0 OR geolocation_lng = 0) as zero_coordinates
FROM geolocation;

Output:
    "total_rows"	"unique_zips"	"null_lats"	"null_lngs"	"zero_coordinates"
    1000163	        19015	        0	            0	            0


-- Null audit on products (category name matters for analysis)
SELECT
    'products' AS table_name,
    COUNT(*)                                                       AS total_rows,
    COUNT(*) FILTER (WHERE product_id IS NULL)                    AS null_product_id,
    COUNT(*) FILTER (WHERE product_category_name IS NULL)         AS null_category,
    COUNT(*) FILTER (WHERE product_weight_g IS NULL)              AS null_weight,
    COUNT(*) FILTER (WHERE product_length_cm IS NULL)             AS null_dimensions
FROM products;


Output:
    "table_name"	        "total_rows"	"null_product_id"	"null_category"	   "null_weight"	"null_dimnsions"
    "products"	            32951	            0	                610	                2	                2


    /* insights :
          1. 610 products are currently 'invisible' to any category-based analysis
                ie ~ 1.85% of product catalog is uncategorized.

                Risk : if 610 products are from high-value categories, our revenue and category-level insights will be skewed.

                Action : 
                    1. don't delete them. 
                    2. label them as 'uncategorized' in the product table.

          2. only 2 products are missing weights and dimensions.
                ie. 0.006% of products --> "Fat finger error" data entry mistake.

                Note : Fat finger error is when a typo or human error occurs during data entry.

                Action : 
                    1. since it's only 2 rows out of 32,951 products, we can ignore them.
                    2. fill them with the median weight and dimensions of the category.
                    
    */

-- Null audit on order_items
SELECT
    'order_items' AS table_name,
    COUNT(*)                                            AS total_rows,
    COUNT(*) FILTER (WHERE order_id IS NULL)            AS null_order_id,
    COUNT(*) FILTER (WHERE product_id IS NULL)          AS null_product_id,
    COUNT(*) FILTER (WHERE seller_id IS NULL)           AS null_seller_id,
    COUNT(*) FILTER (WHERE price IS NULL)               AS null_price,
    COUNT(*) FILTER (WHERE freight_value IS NULL)       AS null_freight
FROM order_items;

-- Output:
    "table_name"    "total_rows"    "null_order_id"    "null_product_id"    "null_seller_id"    "null_price"    "null_freight"
    "order_items"   112650          0                   0                   0                   0               0

    /* insights :
        1. order_items table has no null values.
            ie. 100% data integrity.
            Financial Integrity:
             This audit verifies the "source of truth" for revenue. Any NULLs in price or freight_value would fundamentally break your Total Sales and Net Profit calculations.

        2. Join Reliability: 
            Ensuring order_id and product_id have zero NULLs confirms that every transaction can be successfully linked to a specific customer and a specific product category.

        3. Operational Visibility: 
            Auditing seller_id ensures we can attribute sales to specific vendors. NULLs here would create "Ghost Sales" where we know money was spent but don't know who fulfilled the order.

        4. The "Profit Leak" Detection: 
            NULLs in freight_value are a major red flag; if shipping costs are missing, our profitability analysis will be "hallucinated" (it will look like we made more money than we actually did).

        5. AOV Protection: 
            By identifying NULLs (and eventually $0.00 values) early, we prevent your Average Order Value (AOV) from being skewed by incomplete records.

        6. Decision Readiness: 
            A "0 NULL" result across these columns gives us the green light to move from Data Engineering to Business Intelligence 
    */  
    