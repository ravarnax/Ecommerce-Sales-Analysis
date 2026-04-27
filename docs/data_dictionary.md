## Data Quality Findings

### Row Counts (actual)
- customers: 99441
- orders: 99441
- order_items: 112650
- order_payments: 103886
- order_reviews: 99224
- products: 32951
- sellers: 3095
- geolocation: 1000163

### Key Issues Found
1. products.product_category_name — ~610 nulls → will label as 'uncategorized'
2. orders.order_delivered_customer_date — nulls exist for non-delivered orders → expected

### Analysis Decisions Made
- Revenue analysis will use ONLY orders with status = 'delivered'
- Null categories will be relabeled 'uncategorized' in our queries
- Geolocation table has duplicates by zip code — will use DISTINCT or aggregate

## Analytical Assumptions & Cleaning Decisions

1. REVENUE SCOPE
   - Only orders with status = 'delivered' are included in revenue metrics
   - Revenue = price + freight_value (total paid by customer)
   - GMV = price only (what went to the seller, excluding logistics)

2. NULL HANDLING
   - product_category_name NULL → replaced with 'uncategorized'
   - delivery_time NULL → excluded from delivery time calculations
   - review_score NULL → excluded from satisfaction calculations

3. DELIVERY TIME
   - Calculated as: order_delivered_customer_date - order_purchase_timestamp
   - Expressed in days (decimal)
   - Late = delivered after order_estimated_delivery_date

4. TIME DIMENSIONS
   - All analysis uses order_purchase_timestamp as the event date
   - Extracted: year, month, month_name, quarter, day_of_week

5. GEOLOCATION
   - Using customer state/city from customers table
   - Using seller state/city from sellers table






## Master View Summary

### Views Created
1. master_orders_view — all orders, all statuses, all joins
2. delivered_orders   — filtered to delivered + non-null delivery date

### Key Numbers (from verification query)
- Total delivered orders:     96478
- Unique customers:           93358
- Active sellers:             2970
- Product categories:         74
- Total GMV (BRL):            13221498.11
- Average order value (BRL):  119.98
- Data range:                 2016-09-15 12:16:38 to 2018-08-29 15:00:37

### Payment Aggregation Note
Payments were pre-aggregated per order_id before joining to avoid
row multiplication. Used MODE() for payment type, SUM() for value.

### Review Deduplication Note  
Used DISTINCT ON (order_id) to take the most recent review per order,
preventing duplicate rows where multiple reviews exist.





