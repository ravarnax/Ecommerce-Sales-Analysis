# Dataset Description
## Olist Brazilian E-Commerce Public Dataset

---

## 1. Overview

This project is built on the **Olist Brazilian E-Commerce Public Dataset**, originally published on [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) under a **CC BY-NC-SA 4.0** license. The dataset was donated by Olist — the largest department store in Brazilian marketplaces — and covers **~100,000 real, anonymized orders** placed between **September 2016 and October 2018** across multiple Brazilian marketplace channels.

The data spans the **full order lifecycle**: from the moment a customer places an order through payment processing, shipping, delivery, and post-purchase review. It includes supplementary tables covering customers, sellers, products, geolocation, and category name translations, making it a rich, relational dataset suitable for end-to-end business intelligence analysis.

| Property              | Details                                      |
|-----------------------|----------------------------------------------|
| **Source**            | Olist / Kaggle                               |
| **License**           | CC BY-NC-SA 4.0 (Non-Commercial)             |
| **Time Period**       | September 2016 – October 2018                |
| **Geography**         | Brazil (all 26 states + Federal District)    |
| **Total Tables**      | 9 CSV files                                  |
| **Core Order Volume** | ~99,441 orders                               |
| **Total Row Count**   | ~1,455,761 rows across all tables            |
| **Primary Language**  | Portuguese (category names translated to EN) |

---

## 2. Dataset Schema Overview (Entity-Relationship Summary)

```
olist_customers_dataset  ──────────────────────────────────┐
                                                            │
olist_geolocation_dataset ── (zip code prefix)             │
                                                            ▼
olist_sellers_dataset ──────────────── olist_orders_dataset
                           ▲                    │
olist_products_dataset ────┤                    ▼
        │                  │      olist_order_items_dataset
        │           seller_id              │
        ▼                                  ▼
product_category_name_translation   olist_order_payments_dataset
                                    olist_order_reviews_dataset
```

The **`olist_orders_dataset`** is the central fact table. All other tables join to it either directly (via `order_id`) or indirectly (via `customer_id`, `seller_id`, or `product_id`).

---

## 3. Individual Dataset Descriptions

---

### 3.1 `olist_orders_dataset.csv` — Core Orders Fact Table

| Property       | Value                          |
|----------------|--------------------------------|
| **Rows**       | 99,441                         |
| **Columns**    | 8                              |
| **Primary Key**| `order_id`                     |
| **Role**       | Central fact table; backbone of all analysis |

**Description:**
The master orders table containing one row per unique order. It tracks the full temporal lifecycle of each order — from the customer's purchase timestamp through approval, carrier handoff, customer delivery, and the platform's estimated delivery date. Every other dataset in this project joins to this table via `order_id` or `customer_id`.

**Schema:**

| Column | Data Type | Description |
|---|---|---|
| `order_id` | `VARCHAR` | Unique identifier for each order (UUID-format hash). Primary key. |
| `customer_id` | `VARCHAR` | Foreign key referencing `olist_customers_dataset`. Note: this is a **per-order** customer ID, not a persistent customer identifier. |
| `order_status` | `VARCHAR` | Current status of the order. Values: `delivered`, `shipped`, `canceled`, `unavailable`, `invoiced`, `processing`, `created`, `approved`. |
| `order_purchase_timestamp` | `TIMESTAMP` | Date and time the customer placed the order. |
| `order_approved_at` | `TIMESTAMP` | Date and time the payment was approved. May be NULL for canceled or unavailable orders. |
| `order_delivered_carrier_date` | `TIMESTAMP` | Date and time the seller handed the order to the logistics carrier. May be NULL for undelivered orders. |
| `order_delivered_customer_date` | `TIMESTAMP` | Actual date and time the customer received the order. NULL for non-delivered orders. |
| `order_estimated_delivery_date` | `TIMESTAMP` | Estimated delivery date communicated to the customer at time of purchase. |

**Key Notes:**
- The vast majority of orders (96,478) have status `delivered`; a small fraction are `canceled` (625), `shipped` (1,107), or in other states.
- Delivery performance KPIs (on-time rate, delay days) are derived by comparing `order_delivered_customer_date` vs. `order_estimated_delivery_date`.
- `order_approved_at` has ~160 NULL values corresponding to non-approved orders.

---

### 3.2 `olist_customers_dataset.csv` — Customer Dimension Table

| Property       | Value                          |
|----------------|--------------------------------|
| **Rows**       | 99,441                         |
| **Columns**    | 5                              |
| **Primary Key**| `customer_id`                  |
| **Role**       | Customer dimension; links orders to geography and identity |

**Description:**
Maps each `customer_id` (order-level) to a persistent unique customer identity (`customer_unique_id`) and geographic location. The distinction between `customer_id` and `customer_unique_id` is critical: a single real customer may appear under multiple `customer_id` values across separate orders, but will share a single `customer_unique_id`. This design makes repeat purchase analysis dependent on grouping by `customer_unique_id`.

**Schema:**

| Column | Data Type | Description |
|---|---|---|
| `customer_id` | `VARCHAR` | Per-order customer identifier. Foreign key to `olist_orders_dataset`. |
| `customer_unique_id` | `VARCHAR` | True persistent customer identifier. Use this for customer-level aggregations and repeat purchase analysis. |
| `customer_zip_code_prefix` | `VARCHAR(5)` | First 5 digits of the customer's postal code. Joins to `olist_geolocation_dataset`. |
| `customer_city` | `VARCHAR` | Customer's city name (lowercase, unaccented). |
| `customer_state` | `CHAR(2)` | Brazilian state abbreviation (e.g., `SP`, `RJ`, `MG`). |

**Key Notes:**
- 96.7% of customers placed only one order during the analysis period — a critical retention metric.
- State distribution is highly skewed: SP (São Paulo) alone accounts for ~41% of all customers.
- City names are stored in lowercase without diacritics (accent marks), which may require normalization for display purposes.

---

### 3.3 `olist_order_items_dataset.csv` — Order Line Items

| Property       | Value                              |
|----------------|------------------------------------|
| **Rows**       | 112,650                            |
| **Columns**    | 7                                  |
| **Primary Key**| (`order_id`, `order_item_id`)      |
| **Role**       | Order line-item bridge; links orders to products, sellers, and pricing |

**Description:**
A transactional fact table where each row represents one line item within an order. Orders containing multiple products will have multiple rows in this table. This table is the primary source for **GMV (Gross Merchandise Value)**, freight costs, and seller-product-order relationships.

**Schema:**

| Column | Data Type | Description |
|---|---|---|
| `order_id` | `VARCHAR` | Foreign key to `olist_orders_dataset`. |
| `order_item_id` | `INTEGER` | Sequential item number within an order (1 = first item, 2 = second item, etc.). |
| `product_id` | `VARCHAR` | Foreign key to `olist_products_dataset`. |
| `seller_id` | `VARCHAR` | Foreign key to `olist_sellers_dataset`. |
| `shipping_limit_date` | `TIMESTAMP` | Deadline by which the seller must hand the item to the carrier. |
| `price` | `DECIMAL` | Item price in Brazilian Real (BRL), excluding freight. |
| `freight_value` | `DECIMAL` | Freight cost for this item in BRL. If an order has multiple items, freight is split proportionally. |

**Key Notes:**
- GMV = `SUM(price)` across all delivered order items. Total project GMV is ~R$13.6M.
- Freight ratio = `SUM(freight_value) / SUM(price)`, a key profitability indicator.
- The 112,650 rows vs. 99,441 orders confirms some orders contain multiple items (avg ~1.13 items/order).
- `shipping_limit_date` is set by the platform based on seller SLA and product category.

---

### 3.4 `olist_order_payments_dataset.csv` — Payment Transactions

| Property       | Value                              |
|----------------|------------------------------------|
| **Rows**       | 103,886                            |
| **Columns**    | 5                                  |
| **Primary Key**| (`order_id`, `payment_sequential`) |
| **Role**       | Payment fact table; captures payment method, installments, and value |

**Description:**
Records all payment transactions associated with each order. A single order may have multiple payment rows if the customer used multiple payment methods (e.g., a voucher plus a credit card). The `payment_sequential` field orders these rows when splitting payments across methods.

**Schema:**

| Column | Data Type | Description |
|---|---|---|
| `order_id` | `VARCHAR` | Foreign key to `olist_orders_dataset`. |
| `payment_sequential` | `INTEGER` | Sequence number for orders with multiple payment methods (1 = primary payment). |
| `payment_type` | `VARCHAR` | Payment method used. Values: `credit_card`, `boleto` (bank slip), `voucher`, `debit_card`, `not_defined`. |
| `payment_installments` | `INTEGER` | Number of installments chosen by the customer (1 = paid in full). Range: 1–24. |
| `payment_value` | `DECIMAL` | Value of this payment transaction in BRL. |

**Key Notes:**
- `credit_card` is the dominant payment method (~73% of orders).
- `boleto` (Brazilian bank slip) accounts for ~19% of payments — a payment method unique to Brazil.
- Installment purchasing is common: many customers split payments over 2–12 months.
- For orders with vouchers, `payment_value` on the voucher row represents the discount applied.
- Rows exceed order count (103,886 vs. 99,441) due to split-payment orders.

---

### 3.5 `olist_order_reviews_dataset.csv` — Customer Reviews

| Property       | Value                          |
|----------------|--------------------------------|
| **Rows**       | 104,164                        |
| **Columns**    | 7                              |
| **Primary Key**| `review_id`                    |
| **Role**       | Customer satisfaction dimension; post-purchase feedback |

**Description:**
Contains customer satisfaction survey responses collected after order delivery. Olist proactively sends a satisfaction survey via email at two points: shortly after the estimated delivery date and after the actual delivery. A small number of orders may have more than one review row due to survey resends.

**Schema:**

| Column | Data Type | Description |
|---|---|---|
| `review_id` | `VARCHAR` | Unique identifier for each review record. |
| `order_id` | `VARCHAR` | Foreign key to `olist_orders_dataset`. |
| `review_score` | `INTEGER` | Customer satisfaction score. Scale: 1 (worst) to 5 (best). |
| `review_comment_title` | `VARCHAR` | Optional short title for the review (in Portuguese). Frequently NULL. |
| `review_comment_message` | `VARCHAR` | Optional free-text review body (in Portuguese). Frequently NULL. |
| `review_creation_date` | `TIMESTAMP` | Date the customer submitted the review. |
| `review_answer_timestamp` | `TIMESTAMP` | Date and time the platform recorded/answered the review. |

**Key Notes:**
- ~57% of reviews have no written comment (only a numeric score was provided).
- Platform average review score: **4.09 / 5.0**.
- Strong negative correlation between delivery delay and review score: orders delivered 15+ days late average **1.71** vs. **4.22** for on-time deliveries — a 2.5-point gap that is the project's central causal finding.
- Review text is in Brazilian Portuguese; NLP/sentiment analysis would require Portuguese-language models.

---

### 3.6 `olist_products_dataset.csv` — Product Catalogue

| Property       | Value                          |
|----------------|--------------------------------|
| **Rows**       | 32,951                         |
| **Columns**    | 9                              |
| **Primary Key**| `product_id`                   |
| **Role**       | Product dimension; physical attributes and category classification |

**Description:**
The product catalogue table containing one row per unique product SKU listed on the Olist platform. It provides category classification and physical dimension/weight data — the latter being crucial inputs for understanding freight cost drivers.

**Schema:**

| Column | Data Type | Description |
|---|---|---|
| `product_id` | `VARCHAR` | Unique product identifier. Foreign key referenced from `olist_order_items_dataset`. |
| `product_category_name` | `VARCHAR` | Product category name in **Portuguese** (e.g., `cama_mesa_banho`). May be NULL (~610 records). Joins to `product_category_name_translation` for English names. |
| `product_name_lenght` | `INTEGER` | Character length of the product name (note: column name has a typo — `lenght` instead of `length`). |
| `product_description_lenght` | `INTEGER` | Character length of the product description text. |
| `product_photos_qty` | `INTEGER` | Number of product photos in the listing. |
| `product_weight_g` | `INTEGER` | Product weight in grams. Key freight cost driver. |
| `product_length_cm` | `INTEGER` | Product length in centimeters (packaging dimension). |
| `product_height_cm` | `INTEGER` | Product height in centimeters (packaging dimension). |
| `product_width_cm` | `INTEGER` | Product width in centimeters (packaging dimension). |

**Key Notes:**
- The column names `product_name_lenght` and `product_description_lenght` contain a **typo** (missing 'h') — preserved as-is from the source data.
- ~610 products have a NULL `product_category_name`. These were handled during data cleaning by assigning a `'unknown'` placeholder category.
- Physical dimensions (`weight_g`, `length_cm`, `height_cm`, `product_width_cm`) are used by carriers to calculate volumetric freight costs.
- There are **71 distinct product categories** in Portuguese, all translatable via the companion translation table.

---

### 3.7 `olist_sellers_dataset.csv` — Seller Dimension Table

| Property       | Value                          |
|----------------|--------------------------------|
| **Rows**       | 3,095                          |
| **Columns**    | 4                              |
| **Primary Key**| `seller_id`                    |
| **Role**       | Seller dimension; geographic profile of marketplace vendors |

**Description:**
A compact dimension table profiling each active seller on the Olist marketplace. It provides location data for sellers, enabling geographic supply-demand analysis and logistics insights (same-state vs. cross-state delivery patterns).

**Schema:**

| Column | Data Type | Description |
|---|---|---|
| `seller_id` | `VARCHAR` | Unique seller identifier. Foreign key referenced from `olist_order_items_dataset`. |
| `seller_zip_code_prefix` | `VARCHAR(5)` | First 5 digits of the seller's postal code. Joins to `olist_geolocation_dataset`. |
| `seller_city` | `VARCHAR` | Seller's city (lowercase, unaccented). |
| `seller_state` | `CHAR(2)` | Brazilian state abbreviation (e.g., `SP`, `PR`, `MG`). |

**Key Notes:**
- Seller geography is heavily concentrated in São Paulo state (~70% of sellers), mirroring the customer concentration.
- The North and Northeast regions are severely underserved by sellers — a key finding driving the strategic recommendation to recruit regional sellers.
- Pareto analysis confirms the **top 20% of sellers generate 80%+ of total GMV** (classic 80/20 distribution).

---

### 3.8 `olist_geolocation_dataset.csv` — ZIP Code Geolocation Reference

| Property       | Value                              |
|----------------|------------------------------------|
| **Rows**       | 1,000,163                          |
| **Columns**    | 5                                  |
| **Primary Key**| None (multiple coordinates per ZIP prefix) |
| **Role**       | Geographic reference; maps ZIP prefixes to lat/lng coordinates |

**Description:**
A geographic reference table mapping Brazilian postal code prefixes (first 5 digits) to latitude/longitude coordinates, city, and state. This is the largest table in the dataset by row count. Each ZIP prefix may have **multiple coordinate rows** (representing different points within the same postal area), so aggregation (e.g., `AVG(lat)`, `AVG(lng)`) is typically required before joining to customer or seller tables.

**Schema:**

| Column | Data Type | Description |
|---|---|---|
| `geolocation_zip_code_prefix` | `VARCHAR(5)` | First 5 digits of a Brazilian postal code (CEP). Join key to customers and sellers. |
| `geolocation_lat` | `FLOAT` | Latitude coordinate (decimal degrees). |
| `geolocation_lng` | `FLOAT` | Longitude coordinate (decimal degrees). |
| `geolocation_city` | `VARCHAR` | City name corresponding to this coordinate (lowercase). |
| `geolocation_state` | `CHAR(2)` | State abbreviation. |

**Key Notes:**
- **This table has no primary key** — each ZIP prefix maps to multiple lat/lng points. Always aggregate before joining.
- Used in geographic distribution analysis and potential map visualizations.
- Coverage: all 27 Brazilian states and the Federal District (Brasília).
- Recommended join pattern: create a deduplicated `geolocation_ref` view using `AVG(lat)` and `AVG(lng)` grouped by `zip_code_prefix`.
- This table was used primarily for geographic context in this project and is **not** part of the core `master_orders_view`.

---

### 3.9 `product_category_name_translation.csv` — Category Name Translation

| Property       | Value                          |
|----------------|--------------------------------|
| **Rows**       | 71                             |
| **Columns**    | 2                              |
| **Primary Key**| `product_category_name`        |
| **Role**       | Lookup/translation table; Portuguese → English category names |

**Description:**
A simple, small lookup table mapping all 71 Portuguese product category names to their English equivalents. Essential for making product category analysis accessible to non-Portuguese-speaking audiences and for standardized reporting.

**Schema:**

| Column | Data Type | Description |
|---|---|---|
| `product_category_name` | `VARCHAR` | Category name in Portuguese (e.g., `cama_mesa_banho`). Join key to `olist_products_dataset`. |
| `product_category_name_english` | `VARCHAR` | English translation of the category name (e.g., `bed_bath_table`). |

**Key Notes:**
- Only 71 categories exist, meaning this is a complete, exhaustive lookup with no missing translations.
- The Portuguese name `pc_gamer` has a humorous direct translation: `pc_gamer` (untranslated) — indicating a culturally specific category.
- This table is joined in the analytical layer (`master_orders_view`) to always present English category names in output queries.

---

## 4. Data Relationships & Join Logic

The tables form a **star schema** with `olist_orders_dataset` as the central fact table:

| Relationship | Join Key | Type |
|---|---|---|
| `orders` → `customers` | `customer_id` | Many-to-One |
| `orders` → `order_items` | `order_id` | One-to-Many |
| `orders` → `order_payments` | `order_id` | One-to-Many |
| `orders` → `order_reviews` | `order_id` | One-to-Many |
| `order_items` → `products` | `product_id` | Many-to-One |
| `order_items` → `sellers` | `seller_id` | Many-to-One |
| `products` → `category_translation` | `product_category_name` | Many-to-One |
| `customers` → `geolocation` | `customer_zip_code_prefix` | Many-to-Many* |
| `sellers` → `geolocation` | `seller_zip_code_prefix` | Many-to-Many* |

> \* Geolocation joins are Many-to-Many due to multiple coordinates per ZIP prefix. Use an aggregated CTE first.

---

## 5. Data Quality Notes

| Issue | Affected Table | Impact | Resolution |
|---|---|---|---|
| ~610 NULL `product_category_name` | `olist_products_dataset` | Category analysis completeness | Assigned `'unknown'` placeholder during cleaning |
| Duplicate coordinate rows per ZIP prefix | `olist_geolocation_dataset` | Incorrect fan-out on joins | Aggregate (`AVG`) before joining |
| Typo in column names (`lenght`) | `olist_products_dataset` | Minor cosmetic issue | Preserved as-is; aliased in queries |
| Multiple `review` rows per `order_id` | `olist_order_reviews_dataset` | Duplicate rows in joins | Use `DISTINCT ON (order_id)` or `ROW_NUMBER()` |
| Split payments (multiple rows per order) | `olist_order_payments_dataset` | Inflated row counts | Aggregate `SUM(payment_value)` by `order_id` |
| `customer_id` ≠ persistent customer ID | `olist_customers_dataset` | Breaks naïve repeat-purchase analysis | Always group by `customer_unique_id` |

---

## 6. Analytical Scope & Usage in This Project

This dataset supports the following analytical domains in this project:

| Analysis Domain | Primary Tables Used |
|---|---|
| Revenue & GMV Trends | `orders`, `order_items` |
| Customer Retention & RFM Segmentation | `orders`, `customers`, `order_items` |
| Product Category Performance | `order_items`, `products`, `category_translation` |
| Seller Quality & Pareto Analysis | `order_items`, `sellers`, `orders`, `order_reviews` |
| Delivery & Logistics Performance | `orders`, `order_items`, `sellers`, `customers` |
| Payment Behaviour | `order_payments` |
| Geographic Distribution | `customers`, `sellers`, `geolocation` |

---

## 7. Data Licensing & Citation

**License:** [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

**Original Source:** [Olist Brazilian E-Commerce Public Dataset — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

**Citation:**
> Olist. (2018). *Brazilian E-Commerce Public Dataset by Olist*. Kaggle.
> Retrieved from https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

This dataset is used exclusively for **non-commercial, educational, and portfolio purposes** in accordance with the license terms.
