# Data Dictionary
## Olist Brazilian E-Commerce Public Dataset

**Format:** Column-level reference for all 9 CSV files.
**Notation:** `PK` = Primary Key · `FK` = Foreign Key · `NN` = Not Null · `NULL` = Nullable

---

## Table Index

| # | Table | Rows | Columns |
|---|-------|-----:|--------:|
| 1 | [olist_orders_dataset](#1-olist_orders_dataset) | 99,441 | 8 |
| 2 | [olist_customers_dataset](#2-olist_customers_dataset) | 99,441 | 5 |
| 3 | [olist_order_items_dataset](#3-olist_order_items_dataset) | 112,650 | 7 |
| 4 | [olist_order_payments_dataset](#4-olist_order_payments_dataset) | 103,886 | 5 |
| 5 | [olist_order_reviews_dataset](#5-olist_order_reviews_dataset) | 104,164 | 7 |
| 6 | [olist_products_dataset](#6-olist_products_dataset) | 32,951 | 9 |
| 7 | [olist_sellers_dataset](#7-olist_sellers_dataset) | 3,095 | 4 |
| 8 | [olist_geolocation_dataset](#8-olist_geolocation_dataset) | 1,000,163 | 5 |
| 9 | [product_category_name_translation](#9-product_category_name_translation) | 71 | 2 |

---

## 1. `olist_orders_dataset`

Central fact table. One row per order.

| Column | SQL Type | Constraint | Nullable | Sample Value | Description |
|--------|----------|-----------|----------|--------------|-------------|
| `order_id` | `VARCHAR(32)` | **PK** | NN | `e481f51cbdc54678b7...` | Unique order identifier (MD5 hash). |
| `customer_id` | `VARCHAR(32)` | **FK** → customers | NN | `9ef432eb625129730...` | Per-order customer ID. Links to `olist_customers_dataset`. Not a persistent customer key — use `customer_unique_id` for repeat analysis. |
| `order_status` | `VARCHAR(20)` | — | NN | `delivered` | Current lifecycle stage of the order. See valid values below. |
| `order_purchase_timestamp` | `TIMESTAMP` | — | NN | `2017-10-02 10:56:33` | When the customer submitted the order. |
| `order_approved_at` | `TIMESTAMP` | — | **NULL** | `2017-10-02 11:07:15` | When payment was approved by the platform. NULL for unapproved orders (~160 NULLs). |
| `order_delivered_carrier_date` | `TIMESTAMP` | — | **NULL** | `2017-10-04 19:55:00` | When the seller handed the package to the carrier. NULL for unshipped orders (~1,783 NULLs). |
| `order_delivered_customer_date` | `TIMESTAMP` | — | **NULL** | `2017-10-10 21:25:13` | When the customer received the package. NULL for non-delivered orders (~2,965 NULLs). |
| `order_estimated_delivery_date` | `TIMESTAMP` | — | NN | `2017-10-18 00:00:00` | Estimated delivery date shown to customer at checkout. Used to compute on-time vs. late delivery. |

**`order_status` Valid Values:**

| Value | Count | Meaning |
|-------|------:|---------|
| `delivered` | 96,478 | Order successfully delivered to customer |
| `shipped` | 1,107 | In transit with carrier |
| `canceled` | 625 | Order canceled |
| `unavailable` | 609 | Product unavailable at time of order |
| `invoiced` | 314 | Invoice generated, awaiting shipment |
| `processing` | 301 | Being processed by seller |
| `created` | 5 | Order placed, not yet approved |
| `approved` | 2 | Payment approved, not yet shipped |

**Business Rules:**
- Delivery performance = `order_delivered_customer_date` vs. `order_estimated_delivery_date`
- Filter to `order_status = 'delivered'` for all GMV and revenue analysis
- Time-to-approval = `order_approved_at - order_purchase_timestamp`

---

## 2. `olist_customers_dataset`

Customer dimension. One row per `customer_id` (order-level).

| Column | SQL Type | Constraint | Nullable | Sample Value | Description |
|--------|----------|-----------|----------|--------------|-------------|
| `customer_id` | `VARCHAR(32)` | **PK** | NN | `06b8999e2fba1a1fb...` | Per-order customer identifier. Matches `customer_id` in `olist_orders_dataset`. **Not a stable customer key.** |
| `customer_unique_id` | `VARCHAR(32)` | — | NN | `861eff4711a542e4b...` | Persistent customer identifier. A returning customer will have the same `customer_unique_id` across different `customer_id` values. **Always group by this field for customer-level analysis.** |
| `customer_zip_code_prefix` | `CHAR(5)` | **FK** → geolocation | NN | `14409` | First 5 digits of the customer's CEP (postal code). Join key to `olist_geolocation_dataset`. |
| `customer_city` | `VARCHAR(60)` | — | NN | `franca` | City name in **lowercase, unaccented** Portuguese. |
| `customer_state` | `CHAR(2)` | — | NN | `SP` | Brazilian state abbreviation. 27 distinct values (26 states + DF). |

**`customer_state` Coverage:** 27 distinct states. Top 3: `SP` (~41%), `RJ` (~13%), `MG` (~12%).

**Business Rules:**
- `customer_id` is recycled per order — one physical customer shopping twice has 2 different `customer_id` values but 1 `customer_unique_id`
- Repeat purchase rate must be computed on `customer_unique_id`, not `customer_id`
- City names require title-casing and accent restoration for display

---

## 3. `olist_order_items_dataset`

Order line-item fact table. One row per product per order.

| Column | SQL Type | Constraint | Nullable | Sample Value | Description |
|--------|----------|-----------|----------|--------------|-------------|
| `order_id` | `VARCHAR(32)` | **FK** → orders | NN | `00010242fe8c5a6d1...` | Links to `olist_orders_dataset`. |
| `order_item_id` | `INTEGER` | PK (composite) | NN | `1` | Sequential item number within an order. Starts at 1. Multi-item orders have rows with `order_item_id` = 1, 2, 3, … |
| `product_id` | `VARCHAR(32)` | **FK** → products | NN | `4244733e06e7ecb49...` | Links to `olist_products_dataset`. |
| `seller_id` | `VARCHAR(32)` | **FK** → sellers | NN | `48436dade18ac8b2b...` | Links to `olist_sellers_dataset`. |
| `shipping_limit_date` | `TIMESTAMP` | — | NN | `2017-09-19 09:45:35` | Deadline for seller to hand package to carrier. 0 NULLs. |
| `price` | `DECIMAL(10,2)` | — | NN | `58.90` | Item sale price in BRL, **excluding freight**. Range: R$0.85 – R$6,735. Avg: R$120.65. |
| `freight_value` | `DECIMAL(10,2)` | — | NN | `13.29` | Freight cost for this line item in BRL. Range: R$0 – R$409.68. Avg: R$19.99. Split proportionally for multi-item orders. |

**Composite PK:** (`order_id`, `order_item_id`)

**Business Rules:**
- `GMV = SUM(price)` on delivered orders ≈ R$13.6M total
- `Freight Ratio = SUM(freight_value) / SUM(price)` — platform average ~16.6%
- `freight_value = 0` is valid (free shipping promotions)
- An order's total cost = `SUM(price + freight_value)` grouped by `order_id`

---

## 4. `olist_order_payments_dataset`

Payment transaction fact table. One row per payment method per order.

| Column | SQL Type | Constraint | Nullable | Sample Value | Description |
|--------|----------|-----------|----------|--------------|-------------|
| `order_id` | `VARCHAR(32)` | **FK** → orders | NN | `b81ef226f3fe1789b...` | Links to `olist_orders_dataset`. |
| `payment_sequential` | `INTEGER` | PK (composite) | NN | `1` | Sequence number when multiple payment methods are used. `1` = primary method. |
| `payment_type` | `VARCHAR(20)` | — | NN | `credit_card` | Payment method used. See valid values below. |
| `payment_installments` | `INTEGER` | — | NN | `8` | Number of installments selected. Range: **1–24**. `1` = paid in full. Brazilian credit culture allows multi-month splits. |
| `payment_value` | `DECIMAL(10,2)` | — | NN | `99.33` | BRL value of this specific payment row. For split payments, sum all rows per `order_id` for the true order total. |

**Composite PK:** (`order_id`, `payment_sequential`)

**`payment_type` Valid Values:**

| Value | Count | % of Orders | Description |
|-------|------:|------------:|-------------|
| `credit_card` | 76,795 | 74.0% | Standard credit card |
| `boleto` | 19,784 | 19.1% | Brazilian bank slip (offline payment) |
| `voucher` | 5,775 | 5.6% | Platform discount voucher |
| `debit_card` | 1,529 | 1.5% | Debit card |
| `not_defined` | 3 | <0.1% | Undefined / system error |

**Business Rules:**
- Row count (103,886) > order count (99,441) due to split-payment orders
- To get total payment per order: `SUM(payment_value) GROUP BY order_id`
- Voucher rows represent discounts applied; their `payment_value` = the voucher amount, not the full order value
- High installment counts (`>6`) indicate price-sensitive purchases

---

## 5. `olist_order_reviews_dataset`

Post-purchase customer satisfaction surveys. One row per review record.

| Column | SQL Type | Constraint | Nullable | Sample Value | Description |
|--------|----------|-----------|----------|--------------|-------------|
| `review_id` | `VARCHAR(32)` | **PK** | NN | `7bc2406110b926393...` | Unique review record identifier. |
| `order_id` | `VARCHAR(32)` | **FK** → orders | NN | `73fc7af87114b3971...` | Links to `olist_orders_dataset`. One order may have multiple review rows (survey resends). |
| `review_score` | `INTEGER` | — | NN | `4` | Customer satisfaction rating. Scale: **1 (worst) to 5 (best)**. |
| `review_comment_title` | `VARCHAR(255)` | — | **NULL** | `"Ótimo produto"` | Short review title in Portuguese. Highly sparse — majority NULL. |
| `review_comment_message` | `TEXT` | — | **NULL** | `"Chegou antes do prazo..."` | Full review text in Portuguese. ~57% of records have no message. |
| `review_creation_date` | `TIMESTAMP` | — | NN | `2018-01-18 00:00:00` | Timestamp when the customer submitted the review. |
| `review_answer_timestamp` | `TIMESTAMP` | — | NN | `2018-01-18 21:46:59` | Timestamp when the platform recorded/processed the review. |

**`review_score` Distribution:**

| Score | Count | % of Reviews |
|------:|------:|-------------:|
| 5 ⭐⭐⭐⭐⭐ | 57,328 | 55.1% |
| 4 ⭐⭐⭐⭐ | 19,142 | 18.4% |
| 3 ⭐⭐⭐ | 8,179 | 7.9% |
| 2 ⭐⭐ | 3,151 | 3.0% |
| 1 ⭐ | 11,424 | 11.0% |
| **Avg** | **4.09** | — |

**Business Rules:**
- Row count (104,164) > order count (99,441) — some orders have multiple reviews (survey resends)
- To get one score per order, use `ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY review_creation_date DESC)`
- `review_comment_title` and `review_comment_message` are in **Brazilian Portuguese** — NLP requires PT-BR models
- Key analytical finding: orders delivered 15+ days late average **1.71** vs. **4.22** for on-time orders

---

## 6. `olist_products_dataset`

Product catalogue. One row per unique product SKU.

| Column | SQL Type | Constraint | Nullable | Sample Value | Description |
|--------|----------|-----------|----------|--------------|-------------|
| `product_id` | `VARCHAR(32)` | **PK** | NN | `1e9e8ef04dbcff454...` | Unique product identifier. Referenced by `olist_order_items_dataset`. |
| `product_category_name` | `VARCHAR(80)` | **FK** → translation | **NULL** | `perfumaria` | Product category in **Portuguese** (snake_case). ~610 NULL values. Join to `product_category_name_translation` for English. |
| `product_name_lenght` | `INTEGER` | — | **NULL** | `40` | Character count of the product listing title. ⚠️ **Typo in source column name** (`lenght` ≠ `length`). |
| `product_description_lenght` | `INTEGER` | — | **NULL** | `287` | Character count of the product description body. ⚠️ **Same typo as above.** |
| `product_photos_qty` | `INTEGER` | — | **NULL** | `1` | Number of product photos in the listing. Range: **1–20**. |
| `product_weight_g` | `INTEGER` | — | **NULL** | `225` | Product weight in **grams**. Range: **0–40,425 g**. Primary freight cost driver. |
| `product_length_cm` | `INTEGER` | — | **NULL** | `16` | Package length in centimeters. Used for volumetric weight calculation. |
| `product_height_cm` | `INTEGER` | — | **NULL** | `10` | Package height in centimeters. |
| `product_width_cm` | `INTEGER` | — | **NULL** | `14` | Package width in centimeters. |

**Known Data Issues:**

| Issue | Detail |
|-------|--------|
| Column name typo | `product_name_lenght` and `product_description_lenght` are misspelled in the source — preserved as-is |
| NULL `product_category_name` | ~610 products have no category — aliased as `'unknown'` during cleaning |
| `product_weight_g = 0` | Present in data; may indicate data entry errors for lightweight items |
| Dimension NULLs | ~2 records missing physical dimensions — excluded from freight modeling |

**Business Rules:**
- Volumetric weight (carrier formula) = `(length_cm × height_cm × width_cm) / 6000`
- Actual billed weight = `MAX(product_weight_g / 1000, volumetric_weight_kg)`
- 71 distinct product categories, all translatable via the companion lookup table

---

## 7. `olist_sellers_dataset`

Seller dimension. One row per registered seller.

| Column | SQL Type | Constraint | Nullable | Sample Value | Description |
|--------|----------|-----------|----------|--------------|-------------|
| `seller_id` | `VARCHAR(32)` | **PK** | NN | `3442f8959a84dea7e...` | Unique seller identifier. Referenced by `olist_order_items_dataset`. |
| `seller_zip_code_prefix` | `CHAR(5)` | **FK** → geolocation | NN | `13023` | First 5 digits of the seller's CEP. Join key to `olist_geolocation_dataset`. |
| `seller_city` | `VARCHAR(60)` | — | NN | `campinas` | Seller's city in **lowercase, unaccented** Portuguese. |
| `seller_state` | `CHAR(2)` | — | NN | `SP` | Brazilian state abbreviation. 23 distinct values — sellers do not cover all 27 states. |

**`seller_state` Coverage:** 23 of 27 states. Heavily concentrated — ~70% of sellers are in `SP`.

**Business Rules:**
- Seller performance tier (Platinum/Gold/Silver/Bronze) is a derived metric computed from review scores and on-time delivery rates — not a native column
- Same-state delivery (`seller_state = customer_state`) averages 9.2 days vs. 14.8 days cross-state — makes seller location a logistics variable
- Top 20% of sellers by GMV account for 80%+ of revenue (Pareto distribution)

---

## 8. `olist_geolocation_dataset`

ZIP code geolocation reference. Multiple rows per ZIP prefix.

| Column | SQL Type | Constraint | Nullable | Sample Value | Description |
|--------|----------|-----------|----------|--------------|-------------|
| `geolocation_zip_code_prefix` | `CHAR(5)` | **No PK** | NN | `01037` | First 5 digits of a Brazilian CEP. Join key to customers and sellers. **Not unique** — many lat/lng points exist per prefix. |
| `geolocation_lat` | `DOUBLE PRECISION` | — | NN | `-23.5456` | Latitude in decimal degrees. Negative = South. |
| `geolocation_lng` | `DOUBLE PRECISION` | — | NN | `-46.6392` | Longitude in decimal degrees. Negative = West. |
| `geolocation_city` | `VARCHAR(60)` | — | NN | `sao paulo` | City name (lowercase, unaccented). |
| `geolocation_state` | `CHAR(2)` | — | NN | `SP` | State abbreviation. |

**Business Rules:**
- **No primary key** — each ZIP prefix maps to multiple coordinate points
- Before joining to customers/sellers, create a deduplicated CTE:
  ```sql
  WITH geo_ref AS (
    SELECT zip_code_prefix, AVG(lat) AS lat, AVG(lng) AS lng
    FROM olist_geolocation_dataset
    GROUP BY zip_code_prefix
  )
  ```
- Brazil coordinates: Latitude range ≈ `–33` (south) to `+5` (north) · Longitude range ≈ `–74` to `–35`
- This table was **not included** in the core `master_orders_view` due to its size (1M rows) and fan-out risk

---

## 9. `product_category_name_translation`

Category name lookup table. Portuguese → English.

| Column | SQL Type | Constraint | Nullable | Sample Value | Description |
|--------|----------|-----------|----------|--------------|-------------|
| `product_category_name` | `VARCHAR(80)` | **PK** | NN | `beleza_saude` | Category name in Portuguese (snake_case). Join key to `olist_products_dataset.product_category_name`. |
| `product_category_name_english` | `VARCHAR(80)` | — | NN | `health_beauty` | English translation of the category name (snake_case). |

**Selected Category Translations:**

| Portuguese | English |
|-----------|---------|
| `cama_mesa_banho` | `bed_bath_table` |
| `beleza_saude` | `health_beauty` |
| `informatica_acessorios` | `computers_accessories` |
| `moveis_decoracao` | `furniture_decor` |
| `esporte_lazer` | `sports_leisure` |
| `utilidades_domesticas` | `housewares` |
| `relogios_presentes` | `watches_gifts` |
| `telefonia` | `telephony` |
| `automotivo` | `auto` |
| `pc_gamer` | `pc_gamer` *(untranslated)* |

**Business Rules:**
- Complete lookup: all 71 categories have an English translation — no missing rows
- Always join as `LEFT JOIN` (not `INNER JOIN`) because `product_category_name` can be NULL in the products table
- Use `product_category_name_english` as the display-facing label in all dashboards and reports

---

## Appendix A — Derived / Calculated Fields

These fields do not exist natively but are computed in the `master_orders_view` and analysis queries:

| Derived Field | Source Columns | Formula / Logic |
|---|---|---|
| `delivery_days` | `order_purchase_timestamp`, `order_delivered_customer_date` | `DATE_PART('day', delivered - purchase)` |
| `delay_days` | `order_delivered_customer_date`, `order_estimated_delivery_date` | `DATE_PART('day', actual - estimated)` · Negative = early |
| `is_late` | `delay_days` | `CASE WHEN delay_days > 0 THEN TRUE ELSE FALSE END` |
| `approval_time_hours` | `order_purchase_timestamp`, `order_approved_at` | `EXTRACT(EPOCH FROM (approved - purchase)) / 3600` |
| `total_order_value` | `price`, `freight_value` | `SUM(price + freight_value)` per `order_id` |
| `freight_ratio` | `freight_value`, `price` | `SUM(freight_value) / NULLIF(SUM(price), 0)` |
| `seller_tier` | `review_score`, `is_late` | `NTILE(4)` or threshold-based: Platinum / Gold / Silver / Bronze |
| `rfm_segment` | `order_count`, `total_spend`, `last_order_date` | Recency + Frequency + Monetary scoring |

---

## Appendix B — Foreign Key Map

```
olist_orders_dataset.customer_id
    └── olist_customers_dataset.customer_id

olist_orders_dataset.order_id
    ├── olist_order_items_dataset.order_id
    ├── olist_order_payments_dataset.order_id
    └── olist_order_reviews_dataset.order_id

olist_order_items_dataset.product_id
    └── olist_products_dataset.product_id

olist_order_items_dataset.seller_id
    └── olist_sellers_dataset.seller_id

olist_products_dataset.product_category_name
    └── product_category_name_translation.product_category_name

olist_customers_dataset.customer_zip_code_prefix
    └── olist_geolocation_dataset.geolocation_zip_code_prefix (*)

olist_sellers_dataset.seller_zip_code_prefix
    └── olist_geolocation_dataset.geolocation_zip_code_prefix (*)

(*) Many-to-many — aggregate geolocation before joining
```
