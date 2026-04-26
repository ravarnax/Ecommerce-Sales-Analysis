-- create database tables
-- schema

CREATE TABLE customers (
    customer_id TEXT PRIMARY KEY,
    customer_unique_id TEXT,
    customer_zip_code_prefix INT,
    customer_city TEXT,
    customer_state TEXT
);

-- ORDERS
CREATE TABLE orders (
    order_id TEXT PRIMARY KEY,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

-- ORDER ITEMS
CREATE TABLE order_items (
	order_id TEXT,
	order_item_id INT,
	product_id TEXT,
	seller_id TEXT,
	shipping_limit_date TIMESTAMP,
	price NUMERIC,
	freight_value NUMERIC
);
-- PRODUCTS
CREATE TABLE products (
    product_id TEXT PRIMARY KEY,
    product_category_name TEXT,
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- SELLERS
CREATE TABLE sellers (
    seller_id TEXT PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city TEXT,
    seller_state TEXT
);

-- GEOLOCATION
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_city TEXT,
    geolocation_state TEXT,
    geolocation_lat NUMERIC,
    geolocation_lng NUMERIC
);

-- REVIEWS
CREATE TABLE reviews (
    review_id TEXT,
    order_id TEXT,
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);


-- VERIFY LOADED DATA
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM sellers;
SELECT COUNT(*) FROM payments;
SELECT COUNT(*) FROM reviews;