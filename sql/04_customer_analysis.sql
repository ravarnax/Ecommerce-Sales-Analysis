-- Query 1 — Customer Purchase Frequency Distribution
-- Business question: How many customers bought once vs. multiple times?
-- Why it matters: This is the single most important customer health metric for any marketplace. It directly measures platform loyalty.


-- =============================================
-- CUSTOMER BEHAVIOR ANALYSIS
-- File: 04_customer_analysis.sql
-- =============================================

-- 1. PURCHASE FREQUENCY DISTRIBUTION
WITH customer_order_counts AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id)          AS total_orders,
        ROUND(SUM(item_price), 2)         AS lifetime_value,
        MIN(order_purchase_timestamp)     AS first_order_date,
        MAX(order_purchase_timestamp)     AS last_order_date
    FROM delivered_orders
    GROUP BY customer_unique_id
)
SELECT
    total_orders                              AS orders_placed,
    COUNT(customer_unique_id)                 AS customer_count,
    ROUND(
        COUNT(customer_unique_id) * 100.0
        / SUM(COUNT(customer_unique_id)) OVER ()
    , 2)                                      AS pct_of_customers,
    ROUND(AVG(lifetime_value), 2)             AS avg_ltv,
    ROUND(SUM(lifetime_value), 2)             AS total_revenue_segment
FROM customer_order_counts
GROUP BY total_orders
ORDER BY total_orders;


-- "orders_placed"	"customer_count"	"pct_of_customers"	"avg_ltv"	"total_revenue_segment"
--      1	            90549	            97.00	          137.96	    12491840.18
--      2	            2573	            2.76	          245.35	    631274.90
--      3	            181	                0.19	          364.50	    65974.42
--      4	            28	                0.03	          676.67	    18946.73
--      5	            9	                0.01	          624.06	    5616.54
--      6	            5	                0.01	          520.13	    2600.66
--      7	            3	                0.00	          760.01	    2280.02
--      9	            1	                0.00	          1000.85       1000.85
--      15          	1	                0.00	          714.63	    714.63




-- Query 2 — New vs Returning Customers Monthly
-- Business question: Month by month, how many orders came from new customers vs. returning ones?
-- Why it matters: A healthy marketplace shows a growing returning customer base over time. A declining or flat returning customer line alongside growing new customers means you have a leaky bucket — you are filling it faster than it drains, but only just.



-- 2. NEW VS RETURNING CUSTOMERS BY MONTH
WITH customer_first_order AS (
    SELECT
        customer_unique_id,
        MIN(order_month) AS first_order_month
    FROM delivered_orders
    GROUP BY customer_unique_id
),
tagged_orders AS (
    SELECT
        d.order_month,
        d.order_month_name,
        d.customer_unique_id,
        d.order_id,
        d.item_price,
        CASE
            WHEN d.order_month = cfo.first_order_month
            THEN 'New Customer'
            ELSE 'Returning Customer'
        END AS customer_type
    FROM delivered_orders d
    LEFT JOIN customer_first_order cfo
        ON d.customer_unique_id = cfo.customer_unique_id
)
SELECT
    order_month,
    order_month_name,
    customer_type,
    COUNT(DISTINCT customer_unique_id)   AS unique_customers,
    COUNT(DISTINCT order_id)             AS total_orders,
    ROUND(SUM(item_price), 2)            AS gmv
FROM tagged_orders
GROUP BY order_month, order_month_name, customer_type
ORDER BY order_month, customer_type;


-- "order_month"	        "order_month_name"	    "customer_type"     "unique_customers"   "total_orders"        "gmv"
-- "2016-09-01 00:00:00"	    "Sep 2016"	        "New Customer"	         1                   1                   134.97
-- "2016-10-01 00:00:00"	    "Oct 2016"	        "New Customer"	         262                 265                 40325.11
-- "2016-12-01 00:00:00"	    "Dec 2016"	        "New Customer"	         1                   1                   10.90
-- "2017-01-01 00:00:00"	    "Jan 2017"	        "New Customer"	         717                 749                 111787.46
-- "2017-01-01 00:00:00"	    "Jan 2017"	        "Returning Customer"	 1                   1                   10.90
-- "2017-02-01 00:00:00"	    "Feb 2017"	        "New Customer"	        1628                1651                234147.28
-- "2017-02-01 00:00:00"	    "Feb 2017"      	"Returning Customer"	 2	                2	                76.12
-- "2017-03-01 00:00:00"	    "Mar 2017"      	"New Customer"	        2503	            2541	            358681.06
-- "2017-03-01 00:00:00"	    "Mar 2017"      	"Returning Customer"	 5	                5	                517.79
-- "2017-04-01 00:00:00"	    "Apr 2017"      	"New Customer"	        2256	            2284	            338637.93
-- "2017-04-01 00:00:00"	    "Apr 2017"      	"Returning Customer"	 18	                19	                2031.75
-- "2017-05-01 00:00:00"	    "May 2017"      	"New Customer"	        3450	            3516            	484779.53
-- "2017-05-01 00:00:00"	    "May 2017"      	"Returning Customer"	 28	                29	                4379.72
-- "2017-06-01 00:00:00"	    "Jun 2017"      	"New Customer"	        3037	            3092	            416935.13
-- "2017-06-01 00:00:00"	    "Jun 2017"      	"Returning Customer"	39	                43	                4988.24
-- "2017-07-01 00:00:00"	    "Jul 2017"      	"New Customer"	        3752	            3820            	475042.39
-- "2017-07-01 00:00:00"	    "Jul 2017"      	"Returning Customer"	50	                52	                6562.13
-- "2017-08-01 00:00:00"	    "Aug 2017"      	"New Customer"	        4057	            4133	            546021.77
-- "2017-08-01 00:00:00"	    "Aug 2017"      	"Returning Customer"	57	                60	                8677.93
-- "2017-09-01 00:00:00"	    "Sep 2017"      	"New Customer"	        4004	            4070	            597783.07
-- "2017-09-01 00:00:00"	    "Sep 2017"      	"Returning Customer"	79	                80	                9616.60
-- "2017-10-01 00:00:00"	    "Oct 2017"      	"New Customer"	        4328	            4384	            636772.38
-- "2017-10-01 00:00:00"	    "Oct 2017"      	"Returning Customer"	89	                94	                11475.27
-- "2017-11-01 00:00:00"	    "Nov 2017"      	"New Customer"	        7059	            7159	            972496.76
-- "2017-11-01 00:00:00"	    "Nov 2017"      	"Returning Customer"	123	                129	                15151.31
-- "2017-12-01 00:00:00"	    "Dec 2017"      	"New Customer"	        5338	            5395	            709843.58
-- "2017-12-01 00:00:00"	    "Dec 2017"      	"Returning Customer"	112	                118	                16189.61
-- "2018-01-01 00:00:00"	    "Jan 2018"      	"New Customer"	        6842	            6934	            906733.35
-- "2018-01-01 00:00:00"	    "Jan 2018"      	"Returning Customer"	132	                135	                17911.65
-- "2018-02-01 00:00:00"	    "Feb 2018"      	"New Customer"	        6288	            6435	            813053.18
-- "2018-02-01 00:00:00"	    "Feb 2018"      	"Returning Customer"	112	                120	                13383.95
-- "2018-03-01 00:00:00"	    "Mar 2018"      	"New Customer"	        6774	            6860	            937192.39
-- "2018-03-01 00:00:00"	    "Mar 2018"      	"Returning Customer"	140	                143	                16163.86
-- "2018-04-01 00:00:00"	    "Apr 2018"      	"New Customer"	        6582	            6633	            952665.48
-- "2018-04-01 00:00:00"	    "Apr 2018"      	"Returning Customer"	162	                165	                20868.61
-- "2018-05-01 00:00:00"	    "May 2018"      	"New Customer"	        6506	            6556	            953140.05
-- "2018-05-01 00:00:00"	    "May 2018"      	"Returning Customer"	187	                193	                24404.64
-- "2018-06-01 00:00:00"	    "Jun 2018"      	"New Customer"	        5875	            5908	            830213.86
-- "2018-06-01 00:00:00"	    "Jun 2018"      	"Returning Customer"	183	                188	                25378.11
-- "2018-07-01 00:00:00"	    "Jul 2018"      	"New Customer"	        5946	            6004	            847477.57
-- "2018-07-01 00:00:00"	    "Jul 2018"      	"Returning Customer"	151	                152	                20008.90
-- "2018-08-01 00:00:00"	    "Aug 2018"      	"New Customer"	        6144	            6180	            820059.08
-- "2018-08-01 00:00:00"	    "Aug 2018"      	"Returning Customer"	166	                171	                18517.56


-- Query 03 - Customer Lifetime Value Segments 
Business question : Can we segment customers by how much they spend?
Why it matters : Not all customers are equal.Top 10%  of customers generate
                50% of revenue. We need to identify and retain those customers.


-- 3. CUSTOMER LTV SEGMENTATION
WITH customer_ltv AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id)           AS total_orders,
        ROUND(SUM(item_price), 2)          AS lifetime_value,
        ROUND(AVG(item_price), 2)          AS avg_order_value,
        MIN(order_purchase_timestamp)      AS first_order_date,
        MAX(order_purchase_timestamp)      AS last_order_date,
        COUNT(DISTINCT product_category)   AS categories_purchased
    FROM delivered_orders
    GROUP BY customer_unique_id
),
ltv_percentiles AS (
    SELECT
        customer_unique_id,
        total_orders,
        lifetime_value,
        avg_order_value,
        categories_purchased,
        first_order_date,
        last_order_date,
        NTILE(4) OVER (ORDER BY lifetime_value) AS ltv_quartile
    FROM customer_ltv
)
SELECT
    CASE ltv_quartile
        WHEN 4 THEN 'Platinum — Top 25%'
        WHEN 3 THEN 'Gold — Upper Mid 25%'
        WHEN 2 THEN 'Silver — Lower Mid 25%'
        WHEN 1 THEN 'Bronze — Bottom 25%'
    END                                     AS customer_segment,
    COUNT(customer_unique_id)               AS customer_count,
    ROUND(MIN(lifetime_value), 2)           AS min_ltv,
    ROUND(MAX(lifetime_value), 2)           AS max_ltv,
    ROUND(AVG(lifetime_value), 2)           AS avg_ltv,
    ROUND(SUM(lifetime_value), 2)           AS total_revenue,
    ROUND(
        SUM(lifetime_value) * 100.0
        / SUM(SUM(lifetime_value)) OVER ()
    , 1)                                    AS pct_of_total_revenue,
    ROUND(AVG(total_orders), 2)             AS avg_orders_per_customer,
    ROUND(AVG(avg_order_value), 2)          AS avg_order_value
FROM ltv_percentiles
GROUP BY ltv_quartile
ORDER BY ltv_quartile DESC;


OUTPUT:

-- "customer_segment"          "customer_count"    "min_ltv"   "max_ltv"   "avg_ltv"   "total_revenue"   "pct_of_total_revenue"  "avg_orders_per_customer"   "avg_order_value"
-- "Platinum — Top 25%"        23337                154.75      13440.00    354.23        8266720.25              62.5                     1.08                      303.54
-- "Gold — Upper Mid 25%"      23337                89.70       154.70      117.73        2747490.43              20.8                     1.03                      109.15
-- "Silver — Lower Mid 25%"    23338                47.65       89.70       65.43         1526931.34              11.5                     1.02                      62.29
-- "Bronze — Bottom 25%"       23338                0.85        47.65       29.10         679106.91                5.1                     1.00                      28.34


-- Query 04. REPEAT CUSTOMER PROFILE
-- 4. REPEAT CUSTOMER PROFILE
WITH customer_profile AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id)              AS total_orders,
        ROUND(SUM(item_price), 2)             AS lifetime_value,
        ROUND(AVG(item_price), 2)             AS avg_order_value,
        ROUND(AVG(review_score), 2)           AS avg_review_score,
        COUNT(DISTINCT product_category)      AS categories_explored,
        COUNT(DISTINCT seller_id)             AS unique_sellers_used,
        customer_state,
        MIN(order_purchase_timestamp)         AS first_order_date,
        MAX(order_purchase_timestamp)         AS last_order_date,
        ROUND(
            EXTRACT(EPOCH FROM (
                MAX(order_purchase_timestamp)
                - MIN(order_purchase_timestamp)
            )) / 86400.0
        , 0)                                  AS days_as_customer
    FROM delivered_orders
    GROUP BY customer_unique_id, customer_state
)
SELECT
    CASE
        WHEN total_orders = 1  THEN '1 — One-time buyer'
        WHEN total_orders = 2  THEN '2 — Returning buyer'
        WHEN total_orders = 3  THEN '3 — Loyal buyer'
        WHEN total_orders >= 4 THEN '4+ — Champion buyer'
    END                                       AS buyer_segment,
    COUNT(customer_unique_id)                 AS customers,
    ROUND(AVG(lifetime_value), 2)             AS avg_ltv,
    ROUND(AVG(avg_order_value), 2)            AS avg_order_value,
    ROUND(AVG(avg_review_score), 2)           AS avg_satisfaction_score,
    ROUND(AVG(categories_explored), 1)        AS avg_categories_explored,
    ROUND(AVG(days_as_customer), 0)           AS avg_days_as_customer
FROM customer_profile
GROUP BY
    CASE
        WHEN total_orders = 1  THEN '1 — One-time buyer'
        WHEN total_orders = 2  THEN '2 — Returning buyer'
        WHEN total_orders = 3  THEN '3 — Loyal buyer'
        WHEN total_orders >= 4 THEN '4+ — Champion buyer'
    END
ORDER BY buyer_segment;


-- OUTPUT:
-- "buyer_segment"			"customers"		"avg_ltv"   "avg_order_value"	"avg_satisfaction_score"	"avg_categories_explored"	"avg_days_as_customer"
-- "1 — One-time buyer"		90621		137.94	    	126.44		            4.15		                1.0		                0
-- "2 — Returning buyer"		2542		245.69	    	106.35		            4.18		                1.6		                81
-- "3 — Loyal buyer"			179		    362.68	    	94.83		            4.37		                2.0		                144
-- "4+ — Champion buyer"		46		    664.38	    	107.21		            4.37		                2.8		                205


-- QUERY 5 - CUSTOMER ACQUISITION TREND
-- BUSINESS QUESTION : How fast is our customer base growing month over month?

WITH first_orders AS (
    SELECT
        customer_unique_id,
        MIN(order_month) AS acquisition_month,
        MIN(order_month_name) AS acquisition_month_name
    FROM delivered_orders
    GROUP BY customer_unique_id
)
SELECT
    acquisition_month,
    acquisition_month_name,
    COUNT(customer_unique_id) AS new_customers_acquired,
    SUM(COUNT(customer_unique_id))
        OVER (ORDER BY acquisition_month) AS cumulative_customers
FROM first_orders
GROUP BY acquisition_month, acquisition_month_name
ORDER BY acquisition_month;


OUTPUT:
-- "acquisition_month"	    "acquisition_month_name"	"new_customers_acquired"	"cumulative_customers"
-- "2016-09-01 00:00:00"	    "Sep 2016"	                    1	                        1
-- "2016-10-01 00:00:00"	    "Apr 2017"	                    1	                        263
-- "2016-10-01 00:00:00"	    "Jun 2018"	                    2	                        263
-- "2016-10-01 00:00:00"	    "Jan 2018"	                    1	                        263
-- "2016-10-01 00:00:00"	    "Nov 2017"	                    1	                        263
-- "2016-10-01 00:00:00"	    "Jul 2017"	                    1	                        263
-- "2016-10-01 00:00:00"	    "Mar 2018"	                    1	                        263
-- "2016-10-01 00:00:00"	    "Oct 2016"	                    253	                        263
-- "2016-10-01 00:00:00"	    "May 2018"	                    2	                        263
-- "2016-12-01 00:00:00"	    "Dec 2016"	                    1	                        264
-- "2017-01-01 00:00:00"	    "Feb 2017"	                    2	                        981
-- "2017-01-01 00:00:00"	    "Dec 2017"	                    1	                        981
-- "2017-01-01 00:00:00"	    "Feb 2018"	                    3	                        981
-- "2017-01-01 00:00:00"	    "Apr 2018"	                    1	                        981
-- "2017-01-01 00:00:00"	    "Aug 2018"	                    1	                        981
-- "2017-01-01 00:00:00"	    "Jan 2017"	                    707	                        981
-- "2017-01-01 00:00:00"	    "Apr 2017"	                    1	                        981
-- "2017-01-01 00:00:00"	    "Aug 2017"	                    1	                        981
-- "2017-02-01 00:00:00"	    "Dec 2017"	                    2	                        2609
-- "2017-02-01 00:00:00"	    "Apr 2017"	                    5	                        2609
-- "2017-02-01 00:00:00"	    "Apr 2018"	                    2	                        2609
-- "2017-02-01 00:00:00"	    "Feb 2017"	                    1615	                        2609
-- "2017-02-01 00:00:00"	    "Aug 2017"	                    4	                        2609
-- "2017-03-01 00:00:00"	    "Feb 2018"	                    2	                        5112
-- "2017-03-01 00:00:00"	    "Jun 2017"	                    8	                        5112
-- "2017-03-01 00:00:00"	    "Jul 2018"	                    2	                        5112
-- "2017-03-01 00:00:00"	    "Jan 2018"	                    8	                        5112
-- "2017-03-01 00:00:00"	    "Jun 2018"	                    5	                        5112
-- "2017-03-01 00:00:00"	    "Mar 2017"	                    2446                    	5112
-- "2017-03-01 00:00:00"	    "Jul 2017"	                    9	                        5112
-- "2017-03-01 00:00:00"	    "Aug 2017"	                    4	                        5112
-- "2017-03-01 00:00:00"	    "Apr 2017"	                    11	                        5112
-- "2017-03-01 00:00:00"	    "Dec 2017"	                    2	                        5112
-- "2017-03-01 00:00:00"	    "Apr 2018"	                    3	                        5112
-- "2017-03-01 00:00:00"	    "Aug 2018"	                    3	                        5112
-- "2017-04-01 00:00:00"	    "Apr 2017"	                    2256	                    7368
-- "2017-05-01 00:00:00"	    "Jul 2017"	                    13	                        10818
-- "2017-05-01 00:00:00"	    "Dec 2017"	                    5	                        10818
-- "2017-05-01 00:00:00"	    "Jan 2018"	                    7	                        10818
-- "2017-05-01 00:00:00"	    "Aug 2018"	                    7	                        10818
-- "2017-05-01 00:00:00"	    "Mar 2018"	                    8	                        10818
-- "2017-05-01 00:00:00"	    "Apr 2018"	                    12	                        10818
-- "2017-05-01 00:00:00"	    "Aug 2017"	                    8	                        10818
-- "2017-05-01 00:00:00"	    "Jun 2017"	                    15	                        10818
-- "2017-05-01 00:00:00"	    "May 2017"	                    3362                    	10818
-- "2017-05-01 00:00:00"	    "Feb 2018"	                    8	                        10818
-- "2017-05-01 00:00:00"	    "Jul 2018"	                    5	                        10818
-- "2017-06-01 00:00:00"	    "Apr 2018"	                    9	                        13855
-- "2017-06-01 00:00:00"	    "Aug 2018"	                    6	                        13855
-- "2017-06-01 00:00:00"	    "Aug 2017"	                    12	                        13855
-- "2017-06-01 00:00:00"	    "Jun 2017"	                    2973                    	13855
-- "2017-06-01 00:00:00"	    "Jul 2017"	                    13	                        13855
-- "2017-06-01 00:00:00"	    "Jul 2018"	                    3	                        13855
-- "2017-06-01 00:00:00"	    "Jan 2018"	                    6	                        13855
-- "2017-06-01 00:00:00"	    "Feb 2018"	                    4	                        13855
-- "2017-06-01 00:00:00"	    "Dec 2017"	                    11	                        13855
-- "2017-07-01 00:00:00"	    "Jan 2018"	                    12	                        17607
-- "2017-07-01 00:00:00"	    "Jul 2017"	                    3690	                    17607
-- "2017-07-01 00:00:00"	    "Dec 2017"	                    8	                        17607
-- "2017-07-01 00:00:00"	    "Feb 2018"	                    4	                        17607
-- "2017-07-01 00:00:00"	    "Aug 2018"	                    8	                        17607
-- "2017-07-01 00:00:00"	    "Aug 2017"	                    20	                        17607
-- "2017-07-01 00:00:00"	    "Apr 2018"	                    10	                        17607
-- "2017-08-01 00:00:00"	    "Apr 2018"	                    6	                        21664
-- "2017-08-01 00:00:00"	    "Aug 2017"	                    4051	                    21664
-- "2017-09-01 00:00:00"	    "Sep 2017"	                    3884	                    25668
-- "2017-09-01 00:00:00"	    "Nov 2017"	                    18	                        25668
-- "2017-09-01 00:00:00"	    "Dec 2017"	                    11	                        25668
-- "2017-09-01 00:00:00"	    "Feb 2018"	                    8	                        25668
-- "2017-09-01 00:00:00"	    "May 2018"	                    9	                        25668
-- "2017-09-01 00:00:00"	    "Oct 2017"	                    23	                        25668
-- "2017-09-01 00:00:00"	    "Jan 2018"	                    15	                        25668
-- "2017-09-01 00:00:00"	    "Jul 2018"	                    9	                        25668
-- "2017-09-01 00:00:00"	    "Apr 2018"	                    10	                        25668
-- "2017-09-01 00:00:00"	    "Mar 2018"	                    8	                        25668
-- "2017-09-01 00:00:00"	    "Aug 2018"	                    3	                        25668
-- "2017-09-01 00:00:00"	    "Jun 2018"	                    6	                        25668
-- "2017-10-01 00:00:00"	    "Jan 2018"	                    3	                        29996
-- "2017-10-01 00:00:00"	    "Oct 2017"	                    4220	                        29996
-- "2017-10-01 00:00:00"	    "Jul 2018"	                    8	                        29996
-- "2017-10-01 00:00:00"	    "Apr 2018"	                    9	                        29996
-- "2017-10-01 00:00:00"	    "May 2018"	                    14	                        29996
-- "2017-10-01 00:00:00"	    "Jun 2018"	                    10	                        29996
-- "2017-10-01 00:00:00"	    "Dec 2017"	                    11	                        29996
-- "2017-10-01 00:00:00"	    "Feb 2018"	                    9	                        29996
-- "2017-10-01 00:00:00"	    "Mar 2018"	                    9	                        29996
-- "2017-10-01 00:00:00"	    "Aug 2018"	                    8	29996
-- "2017-10-01 00:00:00"	    "Nov 2017"	                    27	29996
-- "2017-11-01 00:00:00"	    "Jan 2018"	                    25	37055
-- "2017-11-01 00:00:00"	    "Nov 2017"	                    6926	37055
-- "2017-11-01 00:00:00"	    "Dec 2017"	                    40	                        37055
-- "2017-11-01 00:00:00"	    "Feb 2018"	                    11	                        37055
-- "2017-11-01 00:00:00"	    "Apr 2018"	                    13	                        37055
-- "2017-11-01 00:00:00"	    "Jul 2018"	                    9	                        37055
-- "2017-11-01 00:00:00"	    "May 2018"	                    8	                        37055
-- "2017-11-01 00:00:00"	    "Aug 2018"	                    4	                        37055
-- "2017-11-01 00:00:00"	    "Mar 2018"	                    11	                        37055
-- "2017-11-01 00:00:00"	    "Jun 2018"	                    12	                        37055
-- "2017-12-01 00:00:00"	    "Aug 2018"	                    10	                        42393
-- "2017-12-01 00:00:00"	    "Dec 2017"	                    5314	                    42393
-- "2017-12-01 00:00:00"	    "Apr 2018"	                    14	                        42393
-- "2018-01-01 00:00:00"	    "Aug 2018"	                    15	                        49235
-- "2018-01-01 00:00:00"	    "Apr 2018"	                    20	                        49235
-- "2018-01-01 00:00:00"	    "Feb 2018"	                    23	                        49235
-- "2018-01-01 00:00:00"	    "Jan 2018"	                    6784	                    49235
-- "2018-02-01 00:00:00"	    "Feb 2018"	                    6250	                    55523
-- "2018-02-01 00:00:00"	    "Aug 2018"	                    13	                        55523
-- "2018-02-01 00:00:00"	    "Apr 2018"	                    25	                        55523
-- "2018-03-01 00:00:00"	    "Aug 2018"	                    8	                        62297
-- "2018-03-01 00:00:00"	    "Jul 2018"	                    8	                        62297
-- "2018-03-01 00:00:00"	    "Mar 2018"	                    6712	                    62297
-- "2018-03-01 00:00:00"	    "Jun 2018"	                    19	                        62297
-- "2018-03-01 00:00:00"	    "Apr 2018"	                    27	                        62297
-- "2018-04-01 00:00:00"	    "Apr 2018"	                    6582	                    68879
-- "2018-05-01 00:00:00"	    "May 2018"	                    6444	                    75385
-- "2018-05-01 00:00:00"	    "Jul 2018"	                    17	                        75385
-- "2018-05-01 00:00:00"	    "Aug 2018"	                    12	                        75385
-- "2018-05-01 00:00:00"	    "Jun 2018"	                    33	                        75385
-- "2018-06-01 00:00:00"	    "Aug 2018"	                    16	                        81260
-- "2018-06-01 00:00:00"	    "Jun 2018"	                    5835	                    81260
-- "2018-06-01 00:00:00"	    "Jul 2018"	                    24	                        81260
-- "2018-07-01 00:00:00"	    "Aug 2018"	                    31	                        87206
-- "2018-07-01 00:00:00"	    "Jul 2018"	                    5915	                    87206
-- "2018-08-01 00:00:00"	    "Aug 2018"	                    6144	                    93350




-- Query 6 — Customer Geographic Distribution
-- Business question: Where do our customers actually live?
-- Why it matters: Geographic concentration means logistics risk, marketing opportunity, and potential for regional pricing strategy.


-- 6. CUSTOMER GEOGRAPHIC DISTRIBUTION
SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id)     AS unique_customers,
    COUNT(DISTINCT order_id)              AS total_orders,
    ROUND(SUM(item_price), 2)             AS gmv,
    ROUND(AVG(item_price), 2)             AS avg_order_value,
    ROUND(AVG(actual_delivery_days), 1)   AS avg_delivery_days,
    ROUND(AVG(review_score), 2)           AS avg_review_score,
    ROUND(
        COUNT(DISTINCT customer_unique_id) * 100.0
        / SUM(COUNT(DISTINCT customer_unique_id)) OVER ()
    , 2)                                  AS pct_of_customers
FROM delivered_orders
GROUP BY customer_state
ORDER BY unique_customers DESC;



-- OUTPUT:
-- "customer_state"	"unique_customers"	"total_orders"	"gmv"	"avg_order_value"	"avg_delivery_days"	"avg_review_score"	"pct_of_customers"
-- "SP"	39149	40494	5066562.98	109.10	8.7	4.18	41.92
-- "RJ"	11917	12350	1759651.13	124.42	15.1	3.87	12.76
-- "MG"	11001	11354	1552481.83	120.20	12.0	4.12	11.78
-- "RS"	5167	5344	728718.47	118.82	15.2	4.09	5.53
-- "PR"	4769	4923	666063.51	117.91	11.9	4.15	5.11
-- "SC"	3449	3546	507012.13	123.75	15.0	4.05	3.69
-- "BA"	3158	3256	493584.14	134.02	19.2	3.86	3.38
-- "DF"	2019	2080	296498.41	125.90	13.0	4.06	2.16
-- "ES"	1928	1995	268643.45	120.74	15.6	4.01	2.06
-- "GO"	1895	1957	282836.70	124.21	15.4	4.04	2.03
-- "PE"	1551	1593	251889.49	144.27	18.3	4.02	1.66
-- "CE"	1258	1279	219757.38	154.11	21.0	3.88	1.35
-- "PA"	922	946	174470.59	165.53	23.8	3.84	0.99
-- "MT"	856	886	152191.62	146.76	18.0	4.01	0.92
-- "MA"	700	717	117009.38	146.26	21.6	3.76	0.75
-- "MS"	681	701	115429.97	142.33	15.5	4.06	0.73
-- "PB"	504	517	112586.82	192.13	20.6	4.04	0.54
-- "PI"	464	476	84721.00	161.99	19.4	3.96	0.50
-- "RN"	464	474	82105.66	157.59	19.3	4.11	0.50
-- "AL"	387	397	78855.72	184.67	24.5	3.82	0.41
-- "SE"	329	335	56574.19	150.86	21.5	3.90	0.35
-- "TO"	267	274	48402.51	156.14	17.4	4.16	0.29
-- "RO"	231	243	45682.76	167.34	19.7	4.07	0.25
-- "AM"	140	145	22155.84	135.93	26.4	4.11	0.15
-- "AC"	76	80	15930.97	175.07	20.7	4.13	0.08
-- "AP"	66	67	13374.81	165.12	28.2	4.26	0.07
-- "RR"	40	41	7057.47	153.42	28.2	3.89	0.04



-- 7. RFM SEGMENTATION
WITH rfm_base AS (
    SELECT
        customer_unique_id,
        -- Simple subtraction returns integer days in Postgres
        (DATE '2018-08-31' - MAX(order_purchase_timestamp)::date) AS recency_days,
        -- Frequency: number of orders
        COUNT(DISTINCT order_id)           AS frequency,
        -- Monetary: total spend
        ROUND(SUM(item_price)::numeric, 2)  AS monetary
    FROM delivered_orders
    GROUP BY customer_unique_id
),
rfm_scored AS (
    SELECT
        customer_unique_id,
        recency_days,
        frequency,
        monetary,
        -- Score each dimension 1-4 (4 = best)
        -- Note: For Recency, a SMALLER day count is BETTER, so we order by recency_days DESC
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency ASC)    AS f_score,
        NTILE(4) OVER (ORDER BY monetary ASC)     AS m_score
    FROM rfm_base
)
SELECT
    customer_unique_id,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score)          AS rfm_total_score,
    CASE
        WHEN (r_score + f_score + m_score) >= 10 THEN 'Champions'
        WHEN (r_score + f_score + m_score) >= 8  THEN 'Loyal Customers'
        WHEN (r_score + f_score + m_score) >= 6 AND r_score >= 3 THEN 'Potential Loyalists'
        WHEN r_score = 4 AND (f_score + m_score) <= 4 THEN 'New Customers'
        WHEN r_score <= 2 AND (f_score + m_score) >= 6 THEN 'At Risk'
        WHEN r_score = 1 AND f_score = 1 THEN 'Lost Customers'
        ELSE 'Needs Attention'
    END                                    AS rfm_segment
FROM rfm_scored
ORDER BY rfm_total_score DESC;

-- OUTPUT:

-- "customer_unique_id"	"recency_days"	"frequency"	"monetary"	"r_score"	"f_score"	"m_score"	"rfm_total_score"	"rfm_segment"
-- "afbcfd0b9c5233e7ccc73428526fbb52"	2	1	457.75	4	4	4	12	"Champions"
-- "67b70801e21ff8c93e7ad2e6a063b9a0"	116	1	179.00	4	4	4	12	"Champions"
-- "333bf43dc858229ead909c1264473418"	116	1	179.00	4	4	4	12	"Champions"
-- "d042efa47e8e695602ac675d4ab9d43f"	116	1	187.00	4	4	4	12	"Champions"
-- "250ff4b596100260ab4631ee13fa63b8"	116	1	199.00	4	4	4	12	"Champions"
-- "e0c138a2613d7822d9ddeff3909a9c5c"	116	1	199.00	4	4	4	12	"Champions"
-- "20268c28f10a856e5dc90bf8810a5c31"	116	1	186.00	4	4	4	12	"Champions"
-- "5f9e57e6275e77379564f6b45b6c9565"	116	1	159.99	4	4	4	12	"Champions"
-- "ccdc2cd25c64913a68fe4d44e43c7402"	116	1	159.00	4	4	4	12	"Champions"
-- "c3818f2a1aa9b856afa2cc5adf8e97b7"	116	1	189.90	4	4	4	12	"Champions"
-- "5b4022860c7de252d3cc645fa65090f9"	116	1	185.90	4	4	4	12	"Champions"
-- "3b927d7e51ae0a57e0f7e7efd12faf17"	116	1	179.49	4	4	4	12	"Champions"
-- "f4bfa7d75a394df13adaa6b672dc0407"	116	1	1099.99	4	4	4	12	"Champions"
-- "43e153a2e8f22e54e3c59a6555bce16d"	116	1	169.90	4	4	4	12	"Champions"
-- "e5a197b88d04fe99fe96b95f41a686f4"	116	1	164.90	4	4	4	12	"Champions"
-- "e3b3b57caa0974d93ed5218dde2ff4b3"	116	1	990.00	4	4	4	12	"Champions"
-- "bfabd561837fc8ae17420e8d97818ea6"	116	1	159.49	4	4	4	12	"Champions"
-- "94134db974fa93782c3d210c22388f41"	116	1	193.00	4	4	4	12	"Champions"
-- "5874919973f2990196b3a832ac6e4274"	116	1	157.90	4	4	4	12	"Champions"
-- "cdc69d19bd629d9087f32d67e15a39a4"	116	1	179.90	4	4	4	12	"Champions"
-- "8fca845b8523f20659773d02df788da3"	116	1	199.00	4	4	4	12	"Champions"
-- "46513dd0e33c3dbf950e202aed83f796"	116	1	195.00	4	4	4	12	"Champions"
-- "e00a116db9bafed27efa96cb571aa7ec"	116	1	899.00	4	4	4	12	"Champions"
-- "08ba51d0133a2a5d8a95e0f094fed34c"	116	1	179.90	4	4	4	12	"Champions"
-- "ba09cdff04586794fc557641afb2bd1a"	116	1	169.99	4	4	4	12	"Champions"
-- "88da21ad308ca9bff370909f980da689"	116	1	169.00	4	4	4	12	"Champions"
-- "7e7cb315f1552e0c390b5879c25bbc55"	116	1	199.00	4	4	4	12	"Champions"
-- "7bb289562c6224e0d4d34f513d0aae89"	116	1	199.00	4	4	4	12	"Champions"
-- "4c302f6bb8c2bf278a813d5a29315335"	116	1	189.00	4	4	4	12	"Champions"
-- "7fe53ce6ebcc4a93719884627ab3f66b"	116	1	179.00	4	4	4	12	"Champions"
-- "8fcb8ae164a5d1c7c4534595e9bb898a"	116	1	179.00	4	4	4	12	"Champions"
-- "e177f3ef38e3b40f5c08c7a5a1cfb249"	116	1	189.00	4	4	4	12	"Champions"
-- "cefc7ca7e5539436c9c83eb0368e3131"	116	1	159.00	4	4	4	12	"Champions"
-- "2ff881fd08323303966e4e983a6607ab"	115	1	169.99	4	4	4	12	"Champions"
-- "2570d167ddea00454cd45ced0222d6b1"	115	1	215.90	4	4	4	12	"Champions"
-- "045647db3d89047f1163e8135bc2336c"	115	1	188.00	4	4	4	12	"Champions"
-- "c7f2cf5728abafd66680709316b3ecc8"	115	1	180.00	4	4	4	12	"Champions"
-- "e1708ec558c8c1d8bd5e24d022cd13ce"	115	1	215.50	4	4	4	12	"Champions"
-- "105e4e021d64daefffa74f4630107f3d"	115	1	157.90	4	4	4	12	"Champions"
-- "70fc429b7bf128070c74d50e27d0c6a2"	115	1	197.25	4	4	4	12	"Champions"
-- "38d6c7a1968ce4bcd8fff3175bb60430"	115	1	165.00	4	4	4	12	"Champions"
-- "9a16d6330d336fd7e5a9d6ec3f14d7aa"	115	1	215.00	4	4	4	12	"Champions"
-- "ef3210ff1b594a76939d1b3686e7fd02"	115	1	979.00	4	4	4	12	"Champions"
-- "65381bda7816e13672e17c9b9fb66f1f"	115	1	199.70	4	4	4	12	"Champions"
-- "32fd2eb152c94d2db5fdbbb78d6e0c50"	115	1	199.00	4	4	4	12	"Champions"
-- "15fa1715ed2fd2ac6a67e6234d4d5128"	115	1	164.90	4	4	4	12	"Champions"
-- "9f3421bef3e901d5e45f6f1e54662442"	115	1	990.00	4	4	4	12	"Champions"
-- "87e43907cc6fc5aef92da72c71225813"	115	1	190.00	4	4	4	12	"Champions"
-- "94e8e9f7feacb6478fa2b9c6b3293749"	115	1	190.00	4	4	4	12	"Champions"
-- "04f466d6234a805ba36301c1d054b343"	115	1	173.00	4	4	4	12	"Champions"
-- "f4876c612a0aae8ca7fd40f061df9796"	115	1	173.25	4	4	4	12	"Champions"
-- "684da9ec00ee25877fe21ce197403d04"	115	1	2550.00	4	4	4	12	"Champions"
-- "89df862586ea3722ee42623686b395b4"	115	1	178.99	4	4	4	12	"Champions"
-- "c981912fbdd26b666387abe56034bf34"	115	1	179.00	4	4	4	12	"Champions"
-- "0673f745328ddafefaecec22ad5d4c84"	115	1	159.90	4	4	4	12	"Champions"
-- "bbe7f810c9d21b7e59061ce463685b20"	115	1	179.00	4	4	4	12	"Champions"
-- "8e323c75fdec6658ed2933b3f2ecc33a"	115	1	1069.00	4	4	4	12	"Champions"
-- "591dd8be55859ec4becafa8b849d5ead"	115	1	189.99	4	4	4	12	"Champions"
-- "41b4b0d7d2b9c08e9379801336b0020c"	115	1	179.49	4	4	4	12	"Champions"
-- "9d30f7b1f1ec3287b26252ffabc07ec1"	115	1	179.00	4	4	4	12	"Champions"
-- "259c7722126a66185f7c54abd5a2df56"	115	1	161.25	4	4	4	12	"Champions"
-- "26728fb51596755c923c21f756fcd11c"	115	1	189.00	4	4	4	12	"Champions"
-- "e1c4a382b39243db7149e72b91498015"	115	1	160.90	4	4	4	12	"Champions"
-- "c43b2b3018f41c39380df5b1e77769f8"	115	1	179.99	4	4	4	12	"Champions"
-- "3eea189062c7ab7ee8fa8f339befdcbd"	115	1	160.00	4	4	4	12	"Champions"
-- "1734eaee5f45a8f811841efba80b1a6e"	115	1	175.92	4	4	4	12	"Champions"
-- "63693d83793f8b8f4626822da8a6084e"	115	1	179.00	4	4	4	12	"Champions"
-- "5e9a8e3a9ba163c16e5ff0f1781c0943"	115	1	159.99	4	4	4	12	"Champions"
-- "46462920b4896ede7c6810eebbc29f08"	115	1	189.90	4	4	4	12	"Champions"
-- "48d600767669bc5c6db104c1c6d9690b"	115	1	199.89	4	4	4	12	"Champions"
-- "f3c6f7452df051a1f10450ad5e7ec930"	115	1	195.00	4	4	4	12	"Champions"
-- "9d43fce1eff4ec570753b91e60042d18"	115	1	169.99	4	4	4	12	"Champions"
-- "9aaeac4d7597ef5e2c9dca24968afec9"	115	1	195.00	4	4	4	12	"Champions"
-- "121037d818f2d8cc570a32546c7801fe"	115	1	199.00	4	4	4	12	"Champions"
-- "ea566669e9c38192fb24134377f68ac9"	115	1	169.00	4	4	4	12	"Champions"
-- "713de21fd33b1ed45f482d7ba22d51e2"	115	1	278.00	4	4	4	12	"Champions"
-- "8f931493b31df1a02dfaaf7a79be647b"	115	1	255.00	4	4	4	12	"Champions"
-- "6741fe058b7a7605920b9060b234294e"	115	1	260.00	4	4	4	12	"Champions"
-- "56a92d4ae6da383232787ec2b840a711"	115	1	549.90	4	4	4	12	"Champions"
-- "d60a2f23557ba7c63bd1be0c3a9df384"	115	1	299.70	4	4	4	12	"Champions"
-- "0205ecc1296100f97f4ae03e22643b8e"	115	1	410.00	4	4	4	12	"Champions"
-- "cddac5b56ee65e6ece087d94b26ee6c8"	115	1	599.99	4	4	4	12	"Champions"
-- "231d36f5c4b238c26f449ffd98c79180"	115	2	1373.89	4	4	4	12	"Champions"
-- "db28fc41c6aae0d92e04d0e0c127f6f5"	115	1	220.64	4	4	4	12	"Champions"
-- "0807baeeeaa1309effbd9a9dee41ab17"	115	2	305.00	4	4	4	12	"Champions"
-- "4d769103760f32a58c919aa3c3f9d5b1"	115	1	750.00	4	4	4	12	"Champions"
-- "c324beae17c071a7d94b993a12cf39c5"	115	1	270.00	4	4	4	12	"Champions"
-- "7cf08f01ab6a6a1365e1613989a65158"	115	2	156.90	4	4	4	12	"Champions"
-- "d0401aa66d5c33ae752ece32f8474d3c"	115	2	184.89	4	4	4	12	"Champions"
-- "91f15ef4db3006a762bc7e46aa544393"	115	1	370.00	4	4	4	12	"Champions"
-- "bb80ab8ffb7d3b9f9a11b3f06eef10c3"	115	1	220.00	4	4	4	12	"Champions"
-- "cfc782fd443ac9ad698d64a51f0ebad6"	115	1	427.90	4	4	4	12	"Champions"
-- "3c166bd80203dfb723ba32f64bedd87b"	115	2	280.25	4	4	4	12	"Champions"
-- "cd207eb5b4d7a9b5f4ad684eb5461c47"	115	1	630.00	4	4	4	12	"Champions"
-- "9d95d5b59bb358271f0999a86f02c074"	115	1	319.20	4	4	4	12	"Champions"
-- "f38b63854efc52fa742823a70b6bb616"	115	1	220.00	4	4	4	12	"Champions"
-- "9ab71138a8522cc94a49857735854ed3"	115	1	230.00	4	4	4	12	"Champions"
-- "7e1013f7423cda110d3ccf6d6d544b8d"	115	1	219.90	4	4	4	12	"Champions"
-- "622be3abf5853ebb483f789b34b08d1b"	115	1	249.00	4	4	4	12	"Champions"
-- "d9392eb14d3887d001ba8b3c4343f2cc"	115	1	399.00	4	4	4	12	"Champions"
-- "ad2ae8efeb838a2257713600b0f74827"	115	1	349.90	4	4	4	12	"Champions"
-- "7fb3376b7bcbfa9bb632247c4b434512"	115	1	219.99	4	4	4	12	"Champions"
-- "e6b5460e0fc18c6738442222204b49dc"	115	1	330.00	4	4	4	12	"Champions"
-- "bc81913cb080c668a64efab50515273a"	115	1	279.00	4	4	4	12	"Champions"
-- "6b5b8b2ddfb5c697069f7f2c2f5e0283"	115	1	299.00	4	4	4	12	"Champions"
-- "889d22055f87a5ee884ea207622044b4"	115	1	399.00	4	4	4	12	"Champions"
-- "e226254ce0c6d5b7a7ef7218c9b5b518"	115	3	584.60	4	4	4	12	"Champions"
-- "1e15fe81c685c1580edae27baee70608"	115	1	760.00	4	4	4	12	"Champions"
-- "3771603dd4c501660a60a33415653aa0"	115	1	239.90	4	4	4	12	"Champions"
-- "9eaee1fe94e2155bde44087d299c0b9d"	115	2	173.80	4	4	4	12	"Champions"
-- "7db92cbb797de39eebe3bc986be820f8"	115	2	719.00	4	4	4	12	"Champions"
-- "d6a4a2054c2afbf6ccd3e80f960b2dba"	115	1	797.00	4	4	4	12	"Champions"
-- "324ce23e08a1768007118a11836ea7d3"	115	1	739.80	4	4	4	12	"Champions"
-- "a4b72a65f75ef2ba60e6781626cdef40"	115	1	231.54	4	4	4	12	"Champions"
-- "ac65db53732705db8bd3cbb5806c2dca"	115	1	320.00	4	4	4	12	"Champions"
-- "77e223f4a031fdeb1650e797bf4c692a"	115	2	209.80	4	4	4	12	"Champions"
-- "0bd9702b6faa88ff1d9eb5e763cb84d5"	115	1	539.00	4	4	4	12	"Champions"
-- "5255f21b04601b69f1f975987a90fc1a"	115	1	379.99	4	4	4	12	"Champions"
-- "3c5cc98c5d66e9df468a1149cea5db2f"	115	1	659.70	4	4	4	12	"Champions"
-- "38a4edb49c1c376a9bf78db1e6f031fe"	115	1	278.00	4	4	4	12	"Champions"
-- "0a4e93797d441e3a488a029b13ab40d1"	114	1	269.99	4	4	4	12	"Champions"
-- "1cbda36ee89944baa7a738ddbdc4679a"	114	2	501.00	4	4	4	12	"Champions"
-- "7fab37144066f5ffca152c8bf9d0f856"	114	1	379.90	4	4	4	12	"Champions"
-- "da2168560d23ebcf1414078f7a5a5997"	114	1	278.00	4	4	4	12	"Champions"
-- "f71f711f287055ea2c1311e4cee9310c"	114	1	299.00	4	4	4	12	"Champions"
-- "b9683d6a646f9b6f7b0a1889d00e3154"	114	1	349.90	4	4	4	12	"Champions"
-- "07b1b60bca2b6326fa2adb259ea4a55f"	114	3	190.40	4	4	4	12	"Champions"
-- "d547f6aa046bc09da16d46062617d8bb"	114	1	330.00	4	4	4	12	"Champions"
-- "1f9127ae1fce2f368bfc3837ab3b1f69"	114	1	540.00	4	4	4	12	"Champions"
-- "835cd65a1ff89e0be89851e41cab8c3d"	114	1	225.80	4	4	4	12	"Champions"
-- "7ed8f3109744ca6d5bed7460dd78aeea"	114	1	385.61	4	4	4	12	"Champions"
-- "8a23128cf31e6dbb8c88fa635ad01b5d"	114	1	299.90	4	4	4	12	"Champions"
-- "27667934aa9901bcaad1fe937155095e"	114	1	230.00	4	4	4	12	"Champions"
-- "128879fb7a67cfdb05d5e1fe5a37e989"	114	1	559.00	4	4	4	12	"Champions"
-- "43a1d7fce4fffa3adb9d81586f5f3ecd"	114	1	241.89	4	4	4	12	"Champions"
-- "3ada8f80a7e773f741b3abc3bb7d9a55"	114	1	229.99	4	4	4	12	"Champions"
-- "29b0e029cfa4d858a9c22d9f3b701921"	114	1	499.00	4	4	4	12	"Champions"
-- "78761d0c2d365eb550a618345df5f9c7"	114	1	369.00	4	4	4	12	"Champions"
-- "f68ec6805b80a4aa7416a2bf1e84ab44"	114	1	330.00	4	4	4	12	"Champions"
-- "0623f038035c3a191a8c19d01965611e"	114	1	240.00	4	4	4	12	"Champions"
-- "ae11ab40faeb1f8b85f6308e052bd710"	114	2	229.80	4	4	4	12	"Champions"
-- "dc6502a8fc5ef5239994a36192e7a0ca"	114	2	319.39	4	4	4	12	"Champions"
-- "e6293a4e5afac2650800b0483634e321"	114	1	379.90	4	4	4	12	"Champions"
-- "e271fa40aa8fea4e0f304b3768b65d6a"	114	2	1199.98	4	4	4	12	"Champions"
-- "296abfdab73db3e8b962ba5c4389475f"	114	1	319.98	4	4	4	12	"Champions"
-- "67f4a0e45fb1bbdfebc5001cd8a68208"	114	1	889.20	4	4	4	12	"Champions"
-- "8fbed3a01c5bb83fc9bbdf640988246c"	114	1	559.00	4	4	4	12	"Champions"
-- "a08baa27a7207c2b21620abbb8847ffd"	114	1	330.00	4	4	4	12	"Champions"
-- "ed64cf9aa7a7028f4a7ba14dbc08de41"	114	2	173.89	4	4	4	12	"Champions"
-- "33416ee3d4fa56400ec814d7b24bde02"	114	2	203.99	4	4	4	12	"Champions"
-- "e72db37a1bc35d8c18f8418932602f32"	114	1	279.00	4	4	4	12	"Champions"
-- "dd69f24efd472cdcae01b58709c81fed"	114	1	231.54	4	4	4	12	"Champions"
-- "1ce670f2342ab0961580191511d642d4"	114	1	249.99	4	4	4	12	"Champions"
-- "7cbf84875196ee1d04dc880ebbfaa7ef"	114	2	317.79	4	4	4	12	"Champions"
-- "ee3575d8ee7cd3251e3efd6f9cf23fea"	114	1	249.22	4	4	4	12	"Champions"
-- "e6a842f26a52b4012fa34ab9048e2fb5"	114	1	229.99	4	4	4	12	"Champions"
-- "9e4b2156054649b5c139134859b596dc"	114	1	241.90	4	4	4	12	"Champions"
-- "1ef654897cb6d035dabcf0d8063dffc9"	114	1	320.99	4	4	4	12	"Champions"
-- "4104f7e8028204149d92a527d010f207"	114	1	220.64	4	4	4	12	"Champions"
-- "7a78c6e53163e36c68d2f22f5909b0eb"	114	1	839.99	4	4	4	12	"Champions"
-- "3eb2432c10c27f0444e15779fb248c88"	114	1	220.64	4	4	4	12	"Champions"
-- "360e5466682fd1c155990ebea3d3af5c"	114	1	186.79	4	4	4	12	"Champions"
-- "0d1e3b5d7d8a9adbbc15d4d64904e2c7"	114	1	183.00	4	4	4	12	"Champions"
-- "ff85a253905887f4e7bb9123cf1ef4f8"	114	1	179.00	4	4	4	12	"Champions"
-- "33047a883dab6ab720ed2269d31891a1"	114	1	189.90	4	4	4	12	"Champions"
-- "f739d2a8c552550b20a781313a2785d8"	114	1	176.94	4	4	4	12	"Champions"
-- "b218733357b8317b5738bf9fe3c77b07"	114	1	189.90	4	4	4	12	"Champions"
-- "8039b3eb4692041e3e7a17a18dffdf84"	114	1	190.99	4	4	4	12	"Champions"
-- "9f5b78334246addf67c6b0545bc7dd2b"	114	1	170.90	4	4	4	12	"Champions"
-- "2ac352a6f5f4ca13ac93fdedf7d6dbd7"	114	1	169.99	4	4	4	12	"Champions"
-- "e3bc0ff1259d5701f8a76ba915135d85"	114	1	196.80	4	4	4	12	"Champions"
-- "3e544080d5c6dddc9c12925be95c1164"	114	1	197.90	4	4	4	12	"Champions"
-- "7493d2ba4d74df409dd16aefe4f1221e"	114	1	199.00	4	4	4	12	"Champions"
-- "6cd4f9f619a196f16b771eaf368838ec"	114	1	199.00	4	4	4	12	"Champions"
-- "59251607f121873632793ae7192b960a"	114	1	199.00	4	4	4	12	"Champions"
-- "66003712fd22ba49d0e695d80d054de1"	114	1	199.00	4	4	4	12	"Champions"
-- "5bbc03d010ac4dbcfdfa2018349c8f6e"	114	1	199.00	4	4	4	12	"Champions"
-- "7927a4735bdf77ccba27cd077c93603a"	114	1	199.00	4	4	4	12	"Champions"
-- "97a9c6ce2f5a124d22fe6be767bcbb07"	114	1	199.00	4	4	4	12	"Champions"
-- "d18125b8c0fcffd0da676d56fb581bee"	114	1	199.80	4	4	4	12	"Champions"
-- "9271b12d584732342f9ab94f9f08dddb"	114	1	899.40	4	4	4	12	"Champions"
-- "2214477bc746c01d7e790dba816a9a2c"	114	1	899.50	4	4	4	12	"Champions"
-- "81a79f384f8602573644b70698bab3b1"	114	1	979.00	4	4	4	12	"Champions"
-- "49666298f9301ecc7d9706acfb707672"	114	1	160.00	4	4	4	12	"Champions"
-- "73685133e38f5b824324971c0274855a"	114	1	1399.00	4	4	4	12	"Champions"
-- "e5887c53081fedb7b6795f1ba14e08ff"	114	1	155.00	4	4	4	12	"Champions"
-- "5941e69ecce17afb03f8f03c9568a759"	114	1	159.90	4	4	4	12	"Champions"
-- "79cd4aa52496125d2b3af331e6639a4e"	114	1	213.90	4	4	4	12	"Champions"
-- "40cb3346ecab62241f99b0201ac2141f"	114	1	159.49	4	4	4	12	"Champions"
-- "bebb64a635507dabf47f076252103200"	114	1	159.49	4	4	4	12	"Champions"
-- "b608532e04a3070b4b31178948f5c43b"	113	2	322.79	4	4	4	12	"Champions"
-- "22ad9e811b0fc0e074a40ebafeb144b7"	113	1	349.90	4	4	4	12	"Champions"
-- "5e8a37a9db66531212450e6bd9a3c9ad"	113	1	799.90	4	4	4	12	"Champions"
-- "52fe912a8900e2dd1da709098ddcffcd"	113	1	264.50	4	4	4	12	"Champions"
-- "3af90f255e824d1d53b3584a4e89ad58"	113	2	165.00	4	4	4	12	"Champions"
-- "6c08a1ff8d15b8956488744617afc154"	113	1	299.00	4	4	4	12	"Champions"
-- "2627b721fd62cdea6685bd8da7502ff0"	113	1	220.64	4	4	4	12	"Champions"
-- "cd98b14c6c6679cbd5794f54e9ea94a2"	113	1	249.00	4	4	4	12	"Champions"
-- "e37991ff62f5883ef35c90dbb97b422f"	113	1	234.00	4	4	4	12	"Champions"
-- "b12519eb0679eb9713199f830686bf2b"	113	1	219.90	4	4	4	12	"Champions"
-- "0074a1d3f1995ff0538dc7197500973c"	113	1	599.00	4	4	4	12	"Champions"
-- "ebbcd2a9e626bb63de5ae9bb3357d2b1"	113	1	230.00	4	4	4	12	"Champions"
-- "ed80b0317e45a38ac41e4c25583829af"	113	1	412.00	4	4	4	12	"Champions"
-- "68497ce04e9b12cb402671a29acdf6a2"	113	2	1004.99	4	4	4	12	"Champions"
-- "2508fb31ee30c1940a23ccb4edb59b7c"	113	1	255.00	4	4	4	12	"Champions"
-- "78a4bafc5da008bdc6f65b2e9780e167"	113	1	320.00	4	4	4	12	"Champions"
-- "ce5e2053eded1a7e6e1469a4903c90ca"	113	1	330.00	4	4	4	12	"Champions"
-- "09cd73b13f103e47ce13675b4a4b36f3"	113	2	159.00	4	4	4	12	"Champions"
-- "fb482506a95394b3430b97dd4d5188fe"	113	1	529.90	4	4	4	12	"Champions"
-- "28e30481fd8d4fadf17626fcddc607db"	113	1	347.45	4	4	4	12	"Champions"
-- "2004ba7732339d9be65f2236d8887ae4"	113	3	249.95	4	4	4	12	"Champions"
-- "7ff147dcdbedd33f8508f93823a7deae"	113	1	529.99	4	4	4	12	"Champions"
-- "491bca87133a71aae594774a0176417c"	113	1	265.00	4	4	4	12	"Champions"
-- "64df076fb557552498049bb07ed1cd5f"	113	3	404.92	4	4	4	12	"Champions"
-- "8387e34a28c264e9d2ece1aae019fe21"	113	1	499.00	4	4	4	12	"Champions"
-- "e100fdb6bc0036c11bd18c9ef0ffcb80"	113	1	498.00	4	4	4	12	"Champions"
-- "7cdeefc6dd2959cb9202287174ca09ad"	113	1	598.00	4	4	4	12	"Champions"
-- "e7a0b95fe6d4836d124b1566642ffbec"	113	1	649.51	4	4	4	12	"Champions"
-- "62971915b214249061acaadcb26b3571"	113	1	626.00	4	4	4	12	"Champions"
-- "cfa2652966bbc756e9ea2beacfbf61cf"	113	1	275.50	4	4	4	12	"Champions"
-- "661808f26509f17d405df2234610c991"	113	1	320.99	4	4	4	12	"Champions"
-- "86be9ff5cb6382e8c1e92bfc17e0cb85"	113	1	235.00	4	4	4	12	"Champions"
-- "d3616f69d07e63763ec633baf604ee50"	113	1	289.00	4	4	4	12	"Champions"
-- "1818cf65cd53edcf0851d46901b64686"	113	1	320.99	4	4	4	12	"Champions"
-- "4d191f12310d9d4636bac0640e408d44"	113	1	265.00	4	4	4	12	"Champions"
-- "fc4449ffeedd204019f6d058ba914a9f"	113	1	220.64	4	4	4	12	"Champions"
-- "a17d93496a8da3cae2733efe89acb26f"	113	1	245.80	4	4	4	12	"Champions"
-- "c78b6a5c911f6ee40906272207fe1775"	113	1	319.90	4	4	4	12	"Champions"
-- "08e5b38d7948d37fbb2a59fc5e175ab1"	113	4	866.79	4	4	4	12	"Champions"
-- "34868842117c40b30209d16d4d41da71"	113	1	189.00	4	4	4	12	"Champions"
-- "064fb6f70338688d1372235d95d92ff7"	113	1	960.00	4	4	4	12	"Champions"
-- "8e9dddf8ef649a61f67a74c066089cf1"	113	1	180.00	4	4	4	12	"Champions"
-- "8d3c3ccb7dec72e59f272836dd23ba82"	113	1	179.00	4	4	4	12	"Champions"
-- "12caadb5a521dab786cd45e51272dddc"	113	1	159.99	4	4	4	12	"Champions"
-- "7f056701681de7475f34ab534321396c"	113	1	159.98	4	4	4	12	"Champions"
-- "00ae50eb5e1d2514f694dee1dcbbd5ae"	113	1	213.50	4	4	4	12	"Champions"
-- "329123e2077790e16cdd89587d0e75b6"	113	1	169.00	4	4	4	12	"Champions"
-- "3ba10e143a6da2aadfcfe7b112cfa290"	113	1	179.90	4	4	4	12	"Champions"
-- "1cbac5082a2dbeba7f6fa37e5622be52"	113	1	158.99	4	4	4	12	"Champions"
-- "91bfa4d9b218b0ba5f4bca20ab8eb63b"	113	1	189.99	4	4	4	12	"Champions"
-- "79d8f35342ecea70787117a8861368e5"	113	1	159.90	4	4	4	12	"Champions"
-- "1003a1d72627f1a71f255e239aaa4bfd"	113	1	1129.99	4	4	4	12	"Champions"
-- "be74c431147c32ab2d7c7cef5e4a995f"	113	1	1360.02	4	4	4	12	"Champions"
-- "cd7842747d0a08345adb407d006b21da"	113	1	159.99	4	4	4	12	"Champions"
-- "3d81d4e0977945889ce7eee309a884c5"	113	1	1899.00	4	4	4	12	"Champions"
-- "05eb062756e6d4358e72b1caf0ec22b1"	113	1	1399.00	4	4	4	12	"Champions"
-- "976e8c9f67686f03d836dd50a9662f29"	113	1	199.00	4	4	4	12	"Champions"
-- "bdee14a4f9d04d3b78a69f7ba1e82425"	113	1	179.00	4	4	4	12	"Champions"
-- "acc38a550c42d17125cd25c32a464d26"	113	1	2689.00	4	4	4	12	"Champions"
-- "ebdcff38570e8f463f6d0d6d48f0c3ef"	113	1	169.90	4	4	4	12	"Champions"
-- "7ce9430381c6ca969742479727f2be50"	113	1	174.00	4	4	4	12	"Champions"
-- "9150e9fa2fae240e2ba7ae76179d221b"	113	1	188.00	4	4	4	12	"Champions"
-- "7ad6ce39a91cdab266d18f6beac1b0a3"	113	1	178.98	4	4	4	12	"Champions"
-- "829eb0feec6f6c9951cba042e10c6960"	113	1	174.99	4	4	4	12	"Champions"
-- "cbe421944bc758b58a14097e2289cde6"	113	1	179.97	4	4	4	12	"Champions"
-- "4ad7e8137a8f2299cceb563ab66e0317"	113	1	1260.00	4	4	4	12	"Champions"
-- "f9530f49c87c33af8b3ac5300b550d95"	113	1	1180.00	4	4	4	12	"Champions"
-- "62de6068da9506dca753598fcfbdcd16"	113	1	159.99	4	4	4	12	"Champions"
-- "a7acd7f8aefc1d48f618e3f15c5e327b"	113	1	1859.97	4	4	4	12	"Champions"
-- "9433a8f8dc53df230460bbde1f7cc734"	113	1	1054.00	4	4	4	12	"Champions"
-- "9bd3091ad5fac62f6389eacf9af4c571"	113	1	1239.98	4	4	4	12	"Champions"
-- "2abd0f22de522dbcc7adc9ba8982e406"	112	1	159.99	4	4	4	12	"Champions"
-- "9a6e43453bf93c75cd740563c2872697"	112	1	179.00	4	4	4	12	"Champions"
-- "4064f4c4e548c2cbd2209e08b8cc3c84"	112	1	166.00	4	4	4	12	"Champions"
-- "e09002a1d37ff722ce6c9b44878434d5"	112	1	179.00	4	4	4	12	"Champions"
-- "738ee47ca7799ec680527c31c73b7ef5"	112	1	169.00	4	4	4	12	"Champions"
-- "8d105f250341cd9538f795c71d94adfd"	112	1	199.00	4	4	4	12	"Champions"
-- "2fe6abfe94e2959973382789b28a48f7"	112	1	218.20	4	4	4	12	"Champions"
-- "cd020f72b3994d3dda2f464efe9aa99b"	112	1	1890.00	4	4	4	12	"Champions"
-- "ff76aafa376f62ec87f99df89482afb8"	112	1	179.00	4	4	4	12	"Champions"
-- "4d7844325933f09d851e6d786331df03"	112	1	169.90	4	4	4	12	"Champions"
-- "aff36bada602c50fb8964855548648d8"	112	1	189.90	4	4	4	12	"Champions"
-- "b25c74b16e09b4a3390a6db984004c44"	112	1	1859.97	4	4	4	12	"Champions"
-- "6ed2eeda8a410794ac60b3bdbb663800"	112	1	159.90	4	4	4	12	"Champions"
-- "b26283ba08b726d3f3d95afdecfcd0df"	112	1	179.00	4	4	4	12	"Champions"
-- "1eb6f015c37dc8e3f5b531fbca809a49"	112	1	1799.00	4	4	4	12	"Champions"
-- "0da440f6d55daf040bd0d9a222bb0b30"	112	1	159.00	4	4	4	12	"Champions"
-- "a35a5dd77ca1643b8f45340f5cd94606"	112	1	1049.70	4	4	4	12	"Champions"
-- "f67653b0aa459ad0d7d97c2ce305f764"	112	1	213.00	4	4	4	12	"Champions"
-- "658a4b1bf3d0efc7773d6e7f996104c6"	112	1	199.00	4	4	4	12	"Champions"
-- "2ee02b9757d3a43c5d6e802282cc3903"	112	1	169.99	4	4	4	12	"Champions"
-- "3af11c83a23dd9fd6c62fb44f971a564"	112	1	178.50	4	4	4	12	"Champions"
-- "f8f4320123760e8cd9e3c99c68f38a42"	112	1	1039.97	4	4	4	12	"Champions"
-- "ff53fe20cbecc9fe366dbd7096f747ef"	112	1	217.98	4	4	4	12	"Champions"
-- "6d010016ac86b19d9b3a6829cd9e7f03"	112	1	179.00	4	4	4	12	"Champions"
-- "f44ffa618df5f8a65899275c93b14ae2"	112	1	2520.00	4	4	4	12	"Champions"
-- "ad0ad7c74270b0993dd91f1b9aa0e320"	112	1	599.00	4	4	4	12	"Champions"
-- "a62033e1eac3f078e0bbd44b09e3153a"	112	1	254.90	4	4	4	12	"Champions"
-- "facdaacbcd099d5aea3c066c5be1ea45"	112	1	318.98	4	4	4	12	"Champions"
-- "f2d6766e60c4da6664a2426139b83403"	112	1	224.00	4	4	4	12	"Champions"
-- "5fe7677db087a1f3a4078a4fa15c7a56"	112	1	390.00	4	4	4	12	"Champions"
-- "d9764886f02a2884590e05bc3c4391b2"	112	1	388.90	4	4	4	12	"Champions"
-- "54e0a7cc9c09c591bd186e4569c7bf30"	112	2	294.70	4	4	4	12	"Champions"
-- "696b3507aebf0dfe9179dba5b6d130c7"	112	1	229.99	4	4	4	12	"Champions"
-- "80f9b06ba6c2a5251a889fc90e0c5339"	112	1	220.00	4	4	4	12	"Champions"
-- "0c62da95f3d081e39b77e596cea54deb"	112	1	249.00	4	4	4	12	"Champions"
-- "6b254fe768396fef4ba7adfb41befc71"	112	1	330.00	4	4	4	12	"Champions"
-- "4db1ef0722c0e2c670108b4e6fb3c3dc"	112	1	220.00	4	4	4	12	"Champions"
-- "c516ab5d3734828829370782add9a630"	112	1	489.00	4	4	4	12	"Champions"
-- "9a78cfbcc474aa54511c4159dfc099cf"	112	1	219.90	4	4	4	12	"Champions"
-- "db1029b1f63308c837eabdbf054e9dd4"	112	1	299.80	4	4	4	12	"Champions"
-- "e784adf58bfebc64345aa6b16186de95"	112	1	435.19	4	4	4	12	"Champions"
-- "88a05273ec7607c9bdd318670effc818"	112	1	379.90	4	4	4	12	"Champions"
-- "3bfad1f3e44d5805f8ff67c558a155f8"	112	1	449.80	4	4	4	12	"Champions"
-- "e403e9b885c0a3d0af96d7ebddb091da"	112	1	245.00	4	4	4	12	"Champions"
-- "ae846348b4c9821d7754c3b4d7d813f2"	112	1	389.97	4	4	4	12	"Champions"
-- "df54a349b0edb7f8420cd864c0561770"	112	1	299.90	4	4	4	12	"Champions"
-- "3ff2cd81fc957790d81d52be091615c3"	112	1	264.00	4	4	4	12	"Champions"
-- "eaba6c1c62884cc102920d3cd01bb8d8"	112	1	220.64	4	4	4	12	"Champions"
-- "08a9098f7871cd4e9377535ea1a817c4"	112	1	299.99	4	4	4	12	"Champions"
-- "ff763f6fccce840a04aea139ec04c86c"	112	1	359.80	4	4	4	12	"Champions"
-- "bce006e903be688f122a39f45b210090"	112	2	244.80	4	4	4	12	"Champions"
-- "831a032a3327e2b8325faf9d37953870"	112	1	270.00	4	4	4	12	"Champions"
-- "6df09d94fdc9778210ca001e53325cff"	112	1	229.90	4	4	4	12	"Champions"
-- "c031ab1e08405306c145495528df30d8"	112	1	265.96	4	4	4	12	"Champions"
-- "efe8f87089ec28b1a681c20afa307784"	112	1	223.00	4	4	4	12	"Champions"
-- "1f9de30d7f394a1c24403cda4ce319cb"	112	1	499.99	4	4	4	12	"Champions"
-- "203c37755ceffec3ec8618c4057b0334"	112	1	235.98	4	4	4	12	"Champions"
-- "fea3fe25fcf1d736dc7b2cc72a0749e4"	112	1	220.00	4	4	4	12	"Champions"
-- "c881326ad04368c68b98522e700fd543"	111	1	279.94	4	4	4	12	"Champions"
-- "5a8fb123a20a0c9940c8914dcd6a8f67"	111	1	652.00	4	4	4	12	"Champions"
-- "c413f93fca4a6ad084044ebda9d87100"	111	1	265.00	4	4	4	12	"Champions"
-- "ec2ddda7d56bc6dcf0e5e5f4b9f67fef"	111	2	716.00	4	4	4	12	"Champions"
-- "9672859b65a3863580b284469dec2ada"	111	1	559.00	4	4	4	12	"Champions"
-- "077c6658adbb60fcf8437e255c00e906"	111	1	334.99	4	4	4	12	"Champions"
-- "58d10d80f3f3dc2d549e0c1f9c63b2c2"	111	1	230.00	4	4	4	12	"Champions"
-- "b56b1a9a4dda863e4a6eac9a578ce5cd"	111	1	299.98	4	4	4	12	"Champions"
-- "35f9efdd4f1e14908b390b19f6342930"	111	1	299.00	4	4	4	12	"Champions"
-- "297ec5afd18366f5ba27520cc4954151"	111	3	1392.44	4	4	4	12	"Champions"
-- "44da2e9248b8ddd38d664afaab8f1655"	111	1	249.00	4	4	4	12	"Champions"
-- "68fffb8a01663d5b45f58783f80528af"	111	1	305.00	4	4	4	12	"Champions"
-- "fe74c562689512f17b7eefffc41421c8"	111	1	220.00	4	4	4	12	"Champions"
-- "0035029989e6fc5cf030918a5f9f2037"	111	1	438.00	4	4	4	12	"Champions"
-- "c9f6a5d979d6abcd5e03dde326586a35"	111	1	219.99	4	4	4	12	"Champions"
-- "595e38fad1949e25468ad1c7c06924d0"	111	1	563.00	4	4	4	12	"Champions"
-- "29682242915a222580f388e3515672a4"	111	1	320.00	4	4	4	12	"Champions"
-- "8b1f294d23244901dae99e29bca2ebc1"	111	1	599.90	4	4	4	12	"Champions"
-- "e74efa7a06c5b068cc808f5baba88e83"	111	1	260.00	4	4	4	12	"Champions"
-- "0699c67bf57338fea4c2c1a6df0ab295"	111	1	299.99	4	4	4	12	"Champions"
-- "0805efe58062ce26f6f02ff0e4eae23c"	111	1	219.22	4	4	4	12	"Champions"
-- "cc433adb81dd4d1623900ca79f68a2a8"	111	1	299.00	4	4	4	12	"Champions"
-- "56d6d1ae03e95325991e4c77bf3cbe53"	111	2	220.64	4	4	4	12	"Champions"
-- "46f2e955a2102e6c4fc5423b1fb76ad6"	111	1	535.00	4	4	4	12	"Champions"
-- "d4b264d125b3de7f339899ddb8d7f7a0"	111	1	569.00	4	4	4	12	"Champions"
-- "87566fe4966777f59b86e1313f177587"	111	1	1990.00	4	4	4	12	"Champions"
-- "46d83174629858a4bd3c9e0927e1a802"	111	1	189.99	4	4	4	12	"Champions"
-- "d1aaf203473057f01f2270049ecbb5e9"	111	1	175.00	4	4	4	12	"Champions"
-- "311787523e8a6ac3c3edc54c301c3a52"	111	1	1199.00	4	4	4	12	"Champions"
-- "4b14353d85bb41da9adf35e07d4dd1a4"	111	1	199.00	4	4	4	12	"Champions"
-- "142ed0dad12a73d4e9eac64b4918fe2a"	111	1	179.90	4	4	4	12	"Champions"
-- "bdaae7d0dda6bb655f833ebdceaf178e"	111	1	199.00	4	4	4	12	"Champions"
-- "168de8fed35ccd79fade5fbb39a1ab1e"	111	1	179.90	4	4	4	12	"Champions"
-- "b3dfaa749149d9ac2eec071d793c45fc"	111	1	184.10	4	4	4	12	"Champions"
-- "f437fb14cbec4f465f565fef77463f52"	111	1	215.00	4	4	4	12	"Champions"
-- "7e8ace5e83e019d284a1cf0108b57f94"	111	1	159.49	4	4	4	12	"Champions"
-- "ce9c5dc9f654c9f6515b809de75252bc"	111	1	185.00	4	4	4	12	"Champions"
-- "a738981ccf873509c2efdcbaf1de28ac"	111	1	185.00	4	4	4	12	"Champions"
-- "ee0536b95071fa4ce9bb94a187fec75b"	111	1	169.99	4	4	4	12	"Champions"
-- "ffcb3eb07f2a033d45949fcecd160d98"	111	1	185.81	4	4	4	12	"Champions"
-- "7ac75eb1e4064d687eb1826aa8b9d2ec"	111	1	156.99	4	4	4	12	"Champions"
-- "28a4a9aa9bd3640e1f9a9cf542cb25fd"	111	1	899.90	4	4	4	12	"Champions"
-- "9a371e2e79f2b84ab837c96b91e8f079"	111	1	188.00	4	4	4	12	"Champions"
-- "b7b149999ce874c7fddfc6361addeddc"	111	1	179.00	4	4	4	12	"Champions"
-- "9a27ad21d3df090fd9c8bc50f9899390"	111	1	933.98	4	4	4	12	"Champions"
-- "7bc209195f4356a7a1bea27a2a80265e"	111	1	178.90	4	4	4	12	"Champions"
-- "1fa31edbc81c4b2b6e557c01360ae377"	111	1	189.90	4	4	4	12	"Champions"
-- "cae9c7893c1e2bb271e9052dbd3c1ffa"	111	1	189.90	4	4	4	12	"Champions"
-- "61ce0c821dcbe4af94bb523ee77f72ff"	111	1	173.90	4	4	4	12	"Champions"
-- "da406778a6247bee94838343fcafabab"	110	1	265.00	4	4	4	12	"Champions"
-- "325212fbe9d8025f529a43b69fcd3faa"	110	1	388.90	4	4	4	12	"Champions"
-- "7cd747a15b6eb374e2706259c27e96a8"	110	1	285.00	4	4	4	12	"Champions"
-- "621a8f64eb2b310fb4c518fbeef9774b"	110	1	219.80	4	4	4	12	"Champions"
-- "be60631fa17dfa30baba647071f5fd89"	110	1	367.90	4	4	4	12	"Champions"
-- "cfb9250ad7da3bac88843a57f83e93bc"	110	1	799.90	4	4	4	12	"Champions"
-- "ae209c7adfba6f3da2cf3a53bac0d544"	110	1	269.90	4	4	4	12	"Champions"
-- "7d8728a536552b955c9a2844e64f6824"	110	1	299.00	4	4	4	12	"Champions"
-- "44adda057b51a700d1e287783b02516e"	110	2	633.99	4	4	4	12	"Champions"
-- "5926b04bda3a482730b443f283a9ed24"	110	1	299.00	4	4	4	12	"Champions"
-- "be2f9e6ba2ea6b4cf1ffe993ba2e6078"	110	1	599.98	4	4	4	12	"Champions"
-- "684fdd89d877968793cfb9c8f7ef7874"	110	2	315.79	4	4	4	12	"Champions"
-- "39669467dedbe4a650046a0ec8859aae"	110	1	500.00	4	4	4	12	"Champions"
-- "b22b660b766eee055f792b62d1f38cbc"	110	1	574.20	4	4	4	12	"Champions"
-- "936f03703700e6bdab6252000f6f6e91"	110	1	260.00	4	4	4	12	"Champions"
-- "ff954519e2c82aa365ccf6f30fb0c259"	110	1	229.00	4	4	4	12	"Champions"
-- "3c555d15cca5369965d1759ad9530a66"	110	2	499.99	4	4	4	12	"Champions"
-- "bd7287fdad74d4d53c8d2b6e1cfd644d"	110	1	626.00	4	4	4	12	"Champions"
-- "97fc8d4ffceb37b85a1286dce44c6a7b"	110	1	299.99	4	4	4	12	"Champions"
-- "fc2261ae2c583aa2e68241456a6467c8"	110	2	519.90	4	4	4	12	"Champions"
-- "d318d1e80634c32132b65b347403c7ce"	110	1	379.99	4	4	4	12	"Champions"
-- "b99d2069aaa120f7914b8d66182acb63"	110	1	220.00	4	4	4	12	"Champions"
-- "15830e3bb000855aa09f415315a6f37d"	110	1	400.00	4	4	4	12	"Champions"
-- "09f13869ddd0dc89780cbac9eaabe347"	110	1	219.99	4	4	4	12	"Champions"
-- "9d73d8f25f88429a758525f465ca627d"	110	1	330.99	4	4	4	12	"Champions"
-- "b4a54ad19149ba21e0ac72f81a84865d"	110	1	469.80	4	4	4	12	"Champions"
-- "cdb8c10793ea950ad2bdc1918fdcc608"	110	1	858.90	4	4	4	12	"Champions"
-- "e061bbbdee5b4d539d3272c718faf836"	110	1	858.90	4	4	4	12	"Champions"
-- "a3273cc5b69f034bf090c924b75c725d"	110	1	458.28	4	4	4	12	"Champions"
-- "e4e44c4115815a76259cf73c08a874c4"	110	1	607.95	4	4	4	12	"Champions"
-- "6d0d423516a68d7b751cdab41deb0539"	110	1	271.99	4	4	4	12	"Champions"
-- "87c9e7ba960e4c2e6bd786b162adc639"	110	2	1597.80	4	4	4	12	"Champions"
-- "549038e2c41350e6ac5a9d601a93ceed"	110	1	159.00	4	4	4	12	"Champions"
-- "b338b43d7ded0affdb146ea0089b824e"	110	1	159.90	4	4	4	12	"Champions"
-- "915a2b219a25b88ccf9a4a9849d447a1"	110	1	189.90	4	4	4	12	"Champions"
-- "da2026f844d8833800d5ab729cf212b2"	110	1	180.00	4	4	4	12	"Champions"
-- "72035503761f6d18eae77d5bd1a411bd"	110	1	991.90	4	4	4	12	"Champions"
-- "9197958ddf1ab954bff3ab12647d7e16"	110	1	179.98	4	4	4	12	"Champions"
-- "d3383e8df3cd44cd351aecff92e34627"	110	1	213.84	4	4	4	12	"Champions"
-- "ed0aed881a7d2b46bf72c6ae4a0da02b"	110	1	169.99	4	4	4	12	"Champions"
-- "8950b8fdce3e6f6c68c682b7e6dba602"	110	1	214.60	4	4	4	12	"Champions"
-- "3ebf117d81533e8953be18ffa704877a"	110	1	157.89	4	4	4	12	"Champions"
-- "f053e082c3563fa331d4cd0c5d8ec177"	110	1	157.89	4	4	4	12	"Champions"
-- "baad4c06e7feffd0e2849ab8bbb6286c"	110	1	199.88	4	4	4	12	"Champions"
-- "b7a035bbaa15467c17b1a94adc820913"	110	1	1000.00	4	4	4	12	"Champions"
-- "bb6ba09d3fc6d4cbb5158e9ea7d26afe"	110	1	189.90	4	4	4	12	"Champions"
-- "d3f79d417a876b2f5a088818f555f662"	110	1	169.90	4	4	4	12	"Champions"
-- "a7642c8471382f961b102650dd020294"	110	1	179.90	4	4	4	12	"Champions"
-- "39cf8faf26661df0e27872cb60f9bb50"	110	1	179.90	4	4	4	12	"Champions"
-- "02c82b1b79ccf9f38fef2fa51cbc8791"	110	1	173.90	4	4	4	12	"Champions"
-- "57c95688d616e48cdbb0136608cdfc42"	110	1	199.00	4	4	4	12	"Champions"
-- "ba48b0b5bd1a6456a074b95c873cf952"	110	1	160.00	4	4	4	12	"Champions"
-- "b54ed372f1aa8fd434c6ab8cff76ba58"	110	1	180.00	4	4	4	12	"Champions"
-- "ffeddf8aa7cdecf403e77b2e9a99e2ea"	110	1	165.00	4	4	4	12	"Champions"
-- "abed9862c4d074ff11ca43acb962ebf9"	110	1	179.00	4	4	4	12	"Champions"
-- "bc70a522844989a1758d7afa37a4d613"	110	1	179.00	4	4	4	12	"Champions"
-- "af93c8e23e4df2d72f78fd43cb6ae215"	110	1	218.00	4	4	4	12	"Champions"
-- "213489684133d855d27b9ae5661b468d"	110	1	189.00	4	4	4	12	"Champions"
-- "da86766444b32f9b8cf1eb2ff2db07a9"	110	1	155.90	4	4	4	12	"Champions"
-- "1458e8048a02a286abe93ab981f5be0a"	109	1	199.00	4	4	4	12	"Champions"
-- "c6ba690689624400c05e4502dd69616c"	109	1	198.90	4	4	4	12	"Champions"
-- "1cf23763ac9e9e8d66727be259813df6"	109	1	180.00	4	4	4	12	"Champions"
-- "ee43ae31d889d5f180ec0118b5145580"	109	1	199.00	4	4	4	12	"Champions"
-- "1d78c3d8eb2539550b8b4d03487fdb50"	109	1	168.00	4	4	4	12	"Champions"
-- "ac0651cf284cc653d37a4d2178ccbca2"	109	1	219.00	4	4	4	12	"Champions"
-- "2b82b0425a030d4dfbb222cbdf5ea631"	109	1	169.99	4	4	4	12	"Champions"
-- "88281640bf024a756c9b3ad44844d557"	109	1	193.65	4	4	4	12	"Champions"
-- "dc17e671c24856019535cfca38659329"	109	1	170.00	4	4	4	12	"Champions"
-- "9db0703d6dd2cc17ddfa3b1d509a9464"	109	1	166.00	4	4	4	12	"Champions"
-- "62dfd7fb99b98c3ff0bcd6776a261549"	109	1	949.90	4	4	4	12	"Champions"
-- "9fe87d7149e3558d9f0673e049eb8d2e"	109	1	190.00	4	4	4	12	"Champions"
-- "56e615697258bdade82ec5d0bf6996a4"	109	1	190.00	4	4	4	12	"Champions"
-- "ae85516c85361785d9151930418af0cb"	109	1	162.40	4	4	4	12	"Champions"
-- "2d0d003e67fb56299e829ad77cb69c65"	109	1	189.99	4	4	4	12	"Champions"
-- "8e4e4ceda64e14b101cab139610ec8c4"	109	1	189.90	4	4	4	12	"Champions"
-- "bc7fad0e4189527e86792ba981941140"	109	1	189.90	4	4	4	12	"Champions"
-- "58e51c87c3ec742b03d5cee5e49dd664"	109	1	178.00	4	4	4	12	"Champions"
-- "4acc588accb6e7b5b57fc8814dbfb76c"	109	1	189.90	4	4	4	12	"Champions"
-- "3f1577ae405a1a1aad963e093b05ac6d"	109	1	159.96	4	4	4	12	"Champions"
-- "ee337c55ba083dcf3a922739b2e63428"	109	1	179.00	4	4	4	12	"Champions"
-- "9654d6df6a63f5a9b61dd5ba0e0d8286"	109	1	1790.00	4	4	4	12	"Champions"
-- "98db3c67c1a371adf2798a5eb366584e"	109	1	189.00	4	4	4	12	"Champions"
-- "28f6c5e53f39cd45ccd6b22fc82cd1d1"	109	1	1899.00	4	4	4	12	"Champions"
-- "1621e310494e1ed4f52cfd36da5fde30"	109	1	188.90	4	4	4	12	"Champions"
-- "c44a66200288da58d8a45411c1c870b8"	109	1	159.90	4	4	4	12	"Champions"
-- "80842b3998185370df3c0c9932ad17c5"	109	1	159.90	4	4	4	12	"Champions"
-- "e4a6746e29248bdf50b21b1e6584b01c"	109	1	159.90	4	4	4	12	"Champions"
-- "6bcc1cd0c7f8bffa6f67a6a1fbef5782"	109	1	156.00	4	4	4	12	"Champions"
-- "f0767ae738c3d90e7b737d7b8b8bb4d1"	109	1	3930.00	4	4	4	12	"Champions"
-- "32728a6d38195cb71a33f9221dbc3037"	109	1	159.80	4	4	4	12	"Champions"
-- "613414e80c8cc14aaad29edb20bae5e5"	109	1	156.99	4	4	4	12	"Champions"
-- "2fa6a78122d16adf2efec6789a63a0ea"	109	1	185.90	4	4	4	12	"Champions"
-- "acdcb3116121bde837f4edd1bf7f027e"	109	1	179.98	4	4	4	12	"Champions"
-- "d26420cca939f78a409db32872c4c8f5"	109	1	179.50	4	4	4	12	"Champions"
-- "1c02edc39fca262085eeee6c1e8dc88f"	109	1	185.00	4	4	4	12	"Champions"
-- "10bf5fb90ec309ac69a98f5245418fe3"	109	1	185.00	4	4	4	12	"Champions"
-- "84c48a189cfaacc111ba1fed41e5bb46"	109	1	184.00	4	4	4	12	"Champions"
-- "90088beec1a52588bd1a2991b633b3c6"	109	1	179.90	4	4	4	12	"Champions"
-- "47a9a95731329f6dfd6c8fa99d8cde75"	109	1	216.00	4	4	4	12	"Champions"
-- "1ff21b1a89701b32b3f44c63cbd52bb6"	109	1	179.90	4	4	4	12	"Champions"
-- "c96f5b413d24be67b098846784c2fc60"	109	1	199.00	4	4	4	12	"Champions"
-- "be33ce67f6c02b468b94afa895a955fe"	109	2	288.99	4	4	4	12	"Champions"
-- "810c70bb9085833beb866a42a6d6905f"	109	1	225.98	4	4	4	12	"Champions"
-- "dcd27efb93b723b301f8bac00e5d7e01"	109	2	292.80	4	4	4	12	"Champions"
-- "e27def83fca14e64279e3a053a0e0924"	109	1	433.69	4	4	4	12	"Champions"
-- "012452d40dafae4df401bced74cdb490"	109	2	427.90	4	4	4	12	"Champions"
-- "a2bba8861b692b875477c3825aad0629"	109	1	265.00	4	4	4	12	"Champions"
-- "24b7e460db28210f33d13d8ce5918fc4"	109	1	429.00	4	4	4	12	"Champions"
-- "c2d57de917675db2642016f79052b9c3"	109	1	599.90	4	4	4	12	"Champions"
-- "7ddd6c0f33720d313944857738fc1b14"	109	1	229.99	4	4	4	12	"Champions"
-- "923ad45645d9f88cfe41814d2a60ca21"	109	1	728.00	4	4	4	12	"Champions"
-- "26e025af2347c3968f6a578f853a9da2"	109	2	299.00	4	4	4	12	"Champions"
-- "f1564d4caeae524b41e3b42124ebea2a"	109	1	379.00	4	4	4	12	"Champions"
-- "c0019b5eb8e0621d40453fb37a7f4ede"	109	1	219.90	4	4	4	12	"Champions"
-- "27528cbb4b9112677add723caa6fa5f4"	109	1	230.00	4	4	4	12	"Champions"
-- "43f36759a3c130b73fe394747b59657c"	109	1	524.90	4	4	4	12	"Champions"
-- "fc8202798793a1c0c3207dba02b05def"	109	1	325.00	4	4	4	12	"Champions"
-- "f80d8204c73825ae317e4215f8d87cf2"	109	1	370.00	4	4	4	12	"Champions"
-- "e5a36d80dcebce80e07ae7626d1a8acd"	109	1	329.90	4	4	4	12	"Champions"
-- "fbc838cf7e5c279afad28109e3632d18"	109	1	238.00	4	4	4	12	"Champions"
-- "e1967ba1b15b23a95519bf8cf882530a"	109	1	519.00	4	4	4	12	"Champions"
-- "2fdf0e3721cc331df29ae59f11786e87"	109	1	279.90	4	4	4	12	"Champions"
-- "71f88e06eb78302859a034cd7d1877a1"	109	2	729.99	4	4	4	12	"Champions"
-- "f6fabad7c6a8cd11bd0619634456e2c7"	109	1	254.54	4	4	4	12	"Champions"
-- "93541741ba99116c5cf5773312eff953"	109	2	203.00	4	4	4	12	"Champions"
-- "05cc11f944a9cc2f8dd41fae770c313d"	109	1	510.00	4	4	4	12	"Champions"
-- "da533dfdc1a3ab068ab6107f443c6a9f"	109	1	598.00	4	4	4	12	"Champions"
-- "a253d10c681ebc4ee987907d2fd156ce"	109	2	387.90	4	4	4	12	"Champions"
-- "c9e24d1044102ec9b590df097e3dcdc0"	109	1	299.80	4	4	4	12	"Champions"
-- "c44eb6a87b4afdced0450af75a48eb20"	109	1	375.00	4	4	4	12	"Champions"
-- "5c3364a5e1791511f2dc82c2a41dfda8"	109	1	229.99	4	4	4	12	"Champions"
-- "ddce9e2963e71cb5713fdfb677341c4e"	109	1	599.00	4	4	4	12	"Champions"
-- "bb7422969f2b502894c5b02697ba986d"	109	1	219.99	4	4	4	12	"Champions"
-- "831f15b11a69340ee6ab04132ab40742"	109	1	399.00	4	4	4	12	"Champions"
-- "56e99250274944f6339597af9e1588ac"	109	1	699.00	4	4	4	12	"Champions"
-- "1500da334da019c68fda219f942ba38a"	109	2	541.55	4	4	4	12	"Champions"
-- "356698bfff8588efe6ce0ab749e4eff8"	109	1	659.80	4	4	4	12	"Champions"
-- "0a7cf55a3e4dcf8fdf11f6fd62c85803"	109	1	279.99	4	4	4	12	"Champions"
-- "55094b4209466f0537cc52a4e3481639"	109	1	489.00	4	4	4	12	"Champions"
-- "02e9109b7e0a985108b43e573b6afb23"	109	3	532.87	4	4	4	12	"Champions"
-- "5a4718628c0b05c0b2871f64caf90842"	109	1	259.00	4	4	4	12	"Champions"
-- "bd6c8e9ea5cd9adc391f0784e02eb855"	109	1	417.00	4	4	4	12	"Champions"
-- "5b1ff3e6acf9ea1441123e0be2aef453"	109	1	239.80	4	4	4	12	"Champions"
-- "1203dc7baad4bababc755c6c39936954"	109	1	274.00	4	4	4	12	"Champions"
-- "463d3789e69318871004f0aa503a8602"	109	1	259.00	4	4	4	12	"Champions"
-- "b2f1d4ad625708520281b3ce04a7edf3"	109	1	378.00	4	4	4	12	"Champions"
-- "45fec378a656a14acc8905a78e477cf9"	109	1	399.00	4	4	4	12	"Champions"
-- "e3f3bd612fca9ab1029f6e91d7028d9e"	109	1	766.32	4	4	4	12	"Champions"
-- "25a1ad8a564d758f233c587cc657aa4b"	109	2	445.89	4	4	4	12	"Champions"
-- "c61063a13d7fd0073ac4f051f45137f5"	109	1	249.90	4	4	4	12	"Champions"
-- "2bf6fd4ad93eb21b3d604481c48decbf"	109	1	586.56	4	4	4	12	"Champions"
-- "3413f9bca7b61d654f1da9a0afd68c7b"	109	1	228.00	4	4	4	12	"Champions"
-- "7247db1739364b45ac4fcd830ffeabab"	108	1	776.00	4	4	4	12	"Champions"
-- "5691d9e7584b97e1b450398f3476b800"	108	1	233.88	4	4	4	12	"Champions"
-- "24cbac6affa8cf515823960cefdd21ff"	108	1	229.90	4	4	4	12	"Champions"
-- "da87a19579eaff2f6444e57ad0c4f9b3"	108	1	219.90	4	4	4	12	"Champions"
-- "7b9c999cbf57b46a5f0f2cf8f652c3f4"	108	1	245.00	4	4	4	12	"Champions"
-- "db9a58053c3f7ab8be9970e6b2186567"	108	1	497.10	4	4	4	12	"Champions"
-- "28433590e9bb79f58dd9ce601796d004"	108	1	228.90	4	4	4	12	"Champions"
-- "fa08fff16b4da7ba209bd3175f659922"	108	1	279.00	4	4	4	12	"Champions"
-- "a0fb70a2f827809daf55d4ea33aaaa0d"	108	1	428.00	4	4	4	12	"Champions"
-- "44482ad67ba7af317fd50e27e5f0f009"	108	1	489.00	4	4	4	12	"Champions"
-- "4e81738c53901b2951b9c119ad918583"	108	1	219.90	4	4	4	12	"Champions"
-- "5f141a8330c7822bc86dc94d07dccc35"	108	1	379.90	4	4	4	12	"Champions"
-- "65ec42c914fb6a026fa005cce0a89a02"	108	1	399.00	4	4	4	12	"Champions"
-- "43e758e42b454d17bb5ec95b9b402864"	108	1	245.00	4	4	4	12	"Champions"
-- "448e3da0c2457f57cfc90d86dd839028"	108	1	265.00	4	4	4	12	"Champions"
-- "326489271c23dd3128b4480220e5232a"	108	2	616.99	4	4	4	12	"Champions"
-- "a1fadc991b897076fcd8e5fc1cd4a6ac"	108	1	239.70	4	4	4	12	"Champions"
-- "f33407700cab2fab56dbf90a859ca270"	108	1	749.55	4	4	4	12	"Champions"
-- "5a15fc7bce04e1882484322d3a742591"	108	1	300.00	4	4	4	12	"Champions"
-- "574eca8aac95f1f947e3bbc2564d1e9d"	108	1	460.00	4	4	4	12	"Champions"
-- "a0988feb55f4bf6cd3643c2a0d8d3899"	108	1	784.70	4	4	4	12	"Champions"
-- "b9cc54385a16364650ea5c9d26c212d9"	108	1	834.00	4	4	4	12	"Champions"
-- "d26c616e241736e0c1c1ab14150239e7"	108	3	515.90	4	4	4	12	"Champions"
-- "53beaaaafb7b657172c341e7f69e2ca0"	108	1	246.26	4	4	4	12	"Champions"
-- "21c437c8ba445290550180538e08f02b"	108	1	299.00	4	4	4	12	"Champions"
-- "d4e6dfcac8c74ccb645213f3af53bfdb"	108	1	607.95	4	4	4	12	"Champions"
-- "b88755fc8cb1c54b76728232e4d26a8e"	108	1	389.90	4	4	4	12	"Champions"
-- "188b4725e34369a393ae43a6f7703876"	108	1	666.89	4	4	4	12	"Champions"
-- "b3c889172aad7d04f662e9d837340a28"	108	1	699.60	4	4	4	12	"Champions"
-- "309ddce5bdba217553bf362683ada557"	108	1	249.90	4	4	4	12	"Champions"
-- "ac478d6a10a6d0d158576a4a022f5114"	108	1	185.00	4	4	4	12	"Champions"
-- "ee35b9cfd14f3898840c064e8eeefdff"	108	1	175.00	4	4	4	12	"Champions"
-- "97f602f47bf779de7d8654358f92c35b"	108	1	172.00	4	4	4	12	"Champions"
-- "898c64f6f6832078c1ea7f006ad3a54f"	108	1	900.00	4	4	4	12	"Champions"
-- "0fd107db0fd0dec34c21b6269549ffab"	108	1	175.99	4	4	4	12	"Champions"
-- "8fdbf4be9d2e2c8562b87483baabb13b"	108	1	155.98	4	4	4	12	"Champions"
-- "e461ade854a447180d93dc9806a80b28"	108	1	169.00	4	4	4	12	"Champions"
-- "e289cfccc692a345aa1994ee5b18d97d"	108	1	175.00	4	4	4	12	"Champions"
-- "3982801e677454880784b1344f467fd1"	108	1	157.00	4	4	4	12	"Champions"
-- "4922dae71ab06cbcbbc608ef6affebfb"	108	1	160.00	4	4	4	12	"Champions"
-- "7afcfd9fcdc57bc2266528bbfe55afbb"	108	1	157.00	4	4	4	12	"Champions"
-- "7453e76897787f054cb8194639518062"	108	1	169.99	4	4	4	12	"Champions"
-- "eed62c02f6a5da5c0b856bb612d42cd6"	108	1	173.80	4	4	4	12	"Champions"
-- "2542d967894acdc11dbffa8dd2e82a6a"	108	1	167.97	4	4	4	12	"Champions"
-- "8f544b4317da9ce83177c5a0e922a058"	108	1	159.90	4	4	4	12	"Champions"
-- "36d8163d058b1fef06dbe40506eb8aa4"	108	1	899.80	4	4	4	12	"Champions"
-- "5d107b2273cde9e18c6977a4d14bf83d"	108	1	156.00	4	4	4	12	"Champions"
-- "463d6437947645e6aadc5786034dddc3"	108	1	180.00	4	4	4	12	"Champions"
-- "9361aa5e3772dd008881e7126471406d"	108	1	194.90	4	4	4	12	"Champions"
-- "2a357a879d61172c33daeae85b0539f7"	108	1	159.80	4	4	4	12	"Champions"
-- "2a7ba86bfe5b3b196de840ad96adb597"	108	1	179.00	4	4	4	12	"Champions"
-- "5033efbf8c4c2ca17bcb3a2fe3b5b9db"	108	1	180.00	4	4	4	12	"Champions"
-- "cd3cab119292e31732f1f8d4256b4bb7"	108	1	163.90	4	4	4	12	"Champions"
-- "ee89f1d27832f366a6e224395aecf1df"	108	1	159.90	4	4	4	12	"Champions"
-- "71cb999c1d32266779aeffeb851ef99f"	108	1	173.80	4	4	4	12	"Champions"
-- "c396d1334ba8f1ce91954289ef4a3547"	108	1	189.80	4	4	4	12	"Champions"
-- "90b8655cad0249a3486a2fd8c8a3f4a6"	108	1	215.90	4	4	4	12	"Champions"
-- "577786ab410d98d13e0a00878cd9e8fa"	108	1	197.25	4	4	4	12	"Champions"
-- "d97fe0933e8ef1857700de4ac047dc89"	108	1	179.90	4	4	4	12	"Champions"
-- "ec52024988f3496c0f4ec74c624fc382"	108	1	196.80	4	4	4	12	"Champions"
-- "ea5bca346ed8b948d6ac23fd0bbbdaaf"	108	1	170.70	4	4	4	12	"Champions"
-- "3e76ae76da1581b80aad9d356b84e716"	108	1	196.80	4	4	4	12	"Champions"
-- "e07ced752d77608fad5260c058e09266"	108	1	165.90	4	4	4	12	"Champions"
-- "09893d0d5863460e0c8f6c369313452d"	108	1	199.00	4	4	4	12	"Champions"
-- "7fb9cc2b6c54c4c840fa02d4a02b783d"	108	1	169.99	4	4	4	12	"Champions"
-- "6cbe7f3860577d7f36833336f47f9e63"	108	1	159.49	4	4	4	12	"Champions"
-- "9d4ed7a07028101c01a9c4f9c11ee26b"	108	1	166.00	4	4	4	12	"Champions"
-- "90850b1bf110c8d4a9708f3a9c23e767"	108	1	166.00	4	4	4	12	"Champions"
-- "0cc1db7423555763a5c9bfda44746cd0"	107	1	309.00	4	4	4	12	"Champions"
-- "23e6034e441adc938c4da65f14aaabd1"	107	1	370.00	4	4	4	12	"Champions"
-- "cf95b0b5fae3a5db750d9b28c816e818"	107	1	889.00	4	4	4	12	"Champions"
-- "6798aed3617b733ee53f5114ec826395"	107	1	379.99	4	4	4	12	"Champions"
-- "472a03ae2a6048de27c71f5e4a1d974b"	107	1	749.00	4	4	4	12	"Champions"
-- "934c13cd388d7b39aa0abd304e90e4b0"	107	1	249.00	4	4	4	12	"Champions"
-- "44ab76c25210de009b75d6fef6c02335"	107	1	594.90	4	4	4	12	"Champions"
-- "f37230f81e6b31a1c64bb65973fe4cc1"	107	1	409.99	4	4	4	12	"Champions"
-- "473d9165586cfc6708841d07adf6c020"	107	2	549.14	4	4	4	12	"Champions"
-- "6c28e6a7642123fddaafcf789981dbb8"	107	1	879.00	4	4	4	12	"Champions"
-- "3d5fe73f9b69a86cd2a719a049e42da2"	107	1	750.00	4	4	4	12	"Champions"
-- "9ab2ca1b69d838fe7cf022b820a79561"	107	1	309.00	4	4	4	12	"Champions"
-- "679e485e4c0ec522fea92b0487036785"	107	1	223.00	4	4	4	12	"Champions"
-- "341b6946aa6278284d3986112c43def4"	107	1	579.90	4	4	4	12	"Champions"
-- "23cc5aa388da66112c809072f0643d25"	107	1	249.90	4	4	4	12	"Champions"
-- "f62f269f9ce7c41d20a90f70df873f42"	107	1	759.99	4	4	4	12	"Champions"
-- "dd9b235dbe7d48c82caca4da097a2240"	107	2	437.89	4	4	4	12	"Champions"
-- "c40d109a4036dc0bb01b522339af2220"	107	1	765.00	4	4	4	12	"Champions"
-- "d8ca95d946a44bf4af460bc5eea8c00f"	107	2	195.20	4	4	4	12	"Champions"
-- "26a9b95058d46f1e6a685688355a1cdb"	107	2	175.94	4	4	4	12	"Champions"
-- "57cf0cbb103c2cc76b54b0ddb00b293b"	107	1	650.00	4	4	4	12	"Champions"
-- "03dd3244bf71b675adc88a6d0dd7180c"	107	1	330.00	4	4	4	12	"Champions"
-- "d524e6d0027c6e4f03e9969e2613f1dd"	107	1	572.80	4	4	4	12	"Champions"
-- "8c4f1ee04e97bc9c43c73916cbb78479"	107	1	780.00	4	4	4	12	"Champions"
-- "88bde8f40f39641387aa05e675d23395"	107	1	399.00	4	4	4	12	"Champions"
-- "2ab36ff262a58b2671737325a4800883"	107	1	510.00	4	4	4	12	"Champions"
-- "2cedccf5607a7bcf86f8db2805bf713f"	107	1	299.00	4	4	4	12	"Champions"
-- "889cdbc2157d4b7fca66b33aabdcc680"	107	1	299.00	4	4	4	12	"Champions"
-- "5ce049f2479d3d89913200539bedf131"	107	1	229.98	4	4	4	12	"Champions"
-- "bd74c542112c5bfaf4b4211c766c08de"	107	1	249.99	4	4	4	12	"Champions"
-- "1184d75f9890549854acf4e919c6a317"	107	1	349.90	4	4	4	12	"Champions"
-- "e9199a70926b8f0e73254691a089e27b"	107	1	519.90	4	4	4	12	"Champions"
-- "0d51e04ae0b1d341e4f49812d1f4fbe2"	107	2	159.89	4	4	4	12	"Champions"
-- "93a97ded75d29ad3e94405a590b367f1"	107	1	524.90	4	4	4	12	"Champions"
-- "7b259f8f3478bbfd762784b4d1dabd1d"	107	1	264.00	4	4	4	12	"Champions"
-- "810581f011b77fb9ffb69c1c6d3c55ae"	107	1	829.00	4	4	4	12	"Champions"
-- "23230b975a6783fb7bb5678d90520855"	107	1	296.00	4	4	4	12	"Champions"
-- "9811f75e58306711797259182809ba81"	107	1	797.60	4	4	4	12	"Champions"
-- "d2200863f9f169ddb3a2d6203a8dc007"	107	1	329.90	4	4	4	12	"Champions"
-- "4255da282ea330efb8c5bc902bda9c83"	107	1	227.78	4	4	4	12	"Champions"
-- "e2eab1ff0a556609fefad08716e20165"	107	1	279.97	4	4	4	12	"Champions"
-- "9d0d761f119fc063198cc754fdd8eaf1"	107	1	265.00	4	4	4	12	"Champions"
-- "98b8cd94ba804e4149768255cdd5238e"	107	1	249.90	4	4	4	12	"Champions"
-- "357c1205f56093223740cf08ac514bb8"	107	1	329.00	4	4	4	12	"Champions"
-- "f267066511ae5e1555b3c2dcd9f44fbe"	107	1	265.00	4	4	4	12	"Champions"
-- "3bee75e8da82aef12b0859203cdf80a3"	107	1	269.00	4	4	4	12	"Champions"
-- "242d68fe55e871c756dfaf117ff478eb"	107	1	235.00	4	4	4	12	"Champions"
-- "5553a7c7bebd1de19f50e20a851c5eab"	107	1	439.98	4	4	4	12	"Champions"
-- "5a0243af0c5fb4181605df72296bc464"	107	1	248.97	4	4	4	12	"Champions"
-- "0f2ff855fa8276432645e0a4766d7e29"	107	1	359.00	4	4	4	12	"Champions"
-- "fdb213bb68db1651b4aec4b85a098b53"	107	1	662.99	4	4	4	12	"Champions"
-- "099fad9e8f7dfbd0412c300bcc697e0b"	107	2	360.37	4	4	4	12	"Champions"
-- "5f0b403304b047198b9cc1e2e92fe6d8"	107	1	479.96	4	4	4	12	"Champions"
-- "09baec50afccbb414f24bf8e0bc7c020"	107	2	666.80	4	4	4	12	"Champions"
-- "854519a25a87eac75808166bff67a6b3"	107	1	299.99	4	4	4	12	"Champions"
-- "c6be0cc10d1e3fe802b0b63599b59c1b"	107	1	219.00	4	4	4	12	"Champions"
-- "a220343cfac0d96c59aa3c46a2687c56"	107	1	178.00	4	4	4	12	"Champions"
-- "dea170647f2f74b0a96126e3393a2076"	107	1	178.00	4	4	4	12	"Champions"
-- "f1a72f5125865e4d3ed969e54f18157c"	107	1	179.99	4	4	4	12	"Champions"
-- "fbdb73892c8e05fb7be60b5eedaea946"	107	1	159.90	4	4	4	12	"Champions"
-- "8d434defc893fd9ac17fabd1462cbce3"	107	1	1799.00	4	4	4	12	"Champions"
-- "aee039e265274fecae97a2c47e9b14f1"	107	1	170.00	4	4	4	12	"Champions"
-- "8831da2a67b7007cd92faef855f9fb52"	107	1	1914.58	4	4	4	12	"Champions"
-- "5268e11e73cc9fa3bfc41173d2344821"	107	1	189.00	4	4	4	12	"Champions"
-- "4423ebd2c7b14e34ce996d757895bd3f"	107	1	170.00	4	4	4	12	"Champions"
-- "5112d7286a328a07d06a8051c3c55410"	107	1	199.00	4	4	4	12	"Champions"
-- "fc13f755faf0081d8390df3dd5a9d082"	107	1	156.00	4	4	4	12	"Champions"
-- "330d7392c0bb0f03bf59373f45e363f9"	107	1	179.00	4	4	4	12	"Champions"
-- "1640ac81a229cc1409c5606430f79ec9"	107	1	199.00	4	4	4	12	"Champions"
-- "314f4fa23e0008664d19f6058bcdc275"	107	1	185.90	4	4	4	12	"Champions"
-- "c598f4e0b9212af1836ec4027eb36c19"	107	1	185.00	4	4	4	12	"Champions"
-- "4fcf005606ebb2a031f3f9b5e22fa90b"	107	1	159.49	4	4	4	12	"Champions"
-- "5461d4be48404004bdb26a54c62ec541"	107	1	159.49	4	4	4	12	"Champions"
-- "3d46f3720b481bf721544699010b97fd"	107	1	157.80	4	4	4	12	"Champions"
-- "13f283df2f4760f22b57830865761d07"	107	1	179.80	4	4	4	12	"Champions"
-- "efb60ee8379abfd0fbe7526fcfb8275c"	107	1	179.80	4	4	4	12	"Champions"
-- "c8da585193f0d42bd9d69df20bb1a8af"	107	1	168.98	4	4	4	12	"Champions"
-- "04e1b4465899f282fe44bc0daca32f81"	107	1	169.00	4	4	4	12	"Champions"
-- "085d2f970d64f92ebc2f4456077e548d"	107	1	199.00	4	4	4	12	"Champions"
-- "c64199b55f928b9302b63c4f9d841fcb"	107	1	189.90	4	4	4	12	"Champions"
-- "3c08208c1c33f579bd243d16e095d762"	107	1	1186.00	4	4	4	12	"Champions"
-- "e4dfe28d804fe41883093064c994436c"	107	1	175.99	4	4	4	12	"Champions"
-- "f25d770c0aae2cfe4f2538f144a15b59"	107	1	1260.00	4	4	4	12	"Champions"
-- "599d8c19c6086d1444c3a430aebc8abe"	107	1	189.99	4	4	4	12	"Champions"
-- "9cac51d70c1ef9e4cd1480f1464b2843"	107	1	161.90	4	4	4	12	"Champions"
-- "d48d38cf62245af9640114e393a1a50a"	107	1	1054.00	4	4	4	12	"Champions"
-- "ecf7874aa8a2586adf6ca37fab21ecc2"	107	1	1050.00	4	4	4	12	"Champions"
-- "67723326689ea42327c892430d4590af"	106	1	189.90	4	4	4	12	"Champions"
-- "e09928ea33a320aab0102137cd3744ab"	106	1	174.99	4	4	4	12	"Champions"
-- "4bf6b77fe533c5b893f18e23d4591e06"	106	1	192.90	4	4	4	12	"Champions"
-- "39c92d1ce644b84c8b7236aba8a607d9"	106	1	938.90	4	4	4	12	"Champions"
-- "bdca02cf2195276d673c2b2b3a49a527"	106	1	179.00	4	4	4	12	"Champions"
-- "9c5acc6fafd7a5681cc826cadc4169cf"	106	1	192.00	4	4	4	12	"Champions"
-- "7ca3a08cd556fe6692e3b9c335f3251c"	106	1	175.99	4	4	4	12	"Champions"
-- "2da24bd85b344f81bf18ebb313ee0da0"	106	1	191.00	4	4	4	12	"Champions"
-- "1a2556d218fa8ae4904d75adcd5b4806"	106	1	198.00	4	4	4	12	"Champions"
-- "56b8af759a9a22c74b312662e0eade73"	106	1	1097.99	4	4	4	12	"Champions"
-- "6e94cdf4b593972f9d558b3d0c036851"	106	1	169.00	4	4	4	12	"Champions"
-- "076b35e139e2e3de142e4d424d1cfb27"	106	1	198.00	4	4	4	12	"Champions"
-- "7b4a91076722dc7d9922d8645b65ff89"	106	1	1049.70	4	4	4	12	"Champions"
-- "dbe44da2de2d7cba0aa6b57a7e819459"	106	1	159.90	4	4	4	12	"Champions"
-- "2d76a299ed106e5d6c3ad726c1397376"	106	1	989.00	4	4	4	12	"Champions"
-- "36f65f4678e9f39634c967ca1cc74428"	106	1	185.81	4	4	4	12	"Champions"
-- "1bbadaadd0914e2ef6bcb4098f56e7eb"	106	1	179.49	4	4	4	12	"Champions"
-- "fb1756887ae59c1b0efe8d0544d94815"	106	1	158.90	4	4	4	12	"Champions"
-- "b35bbea722303bf6e700f2b67ed6a88e"	106	1	166.00	4	4	4	12	"Champions"
-- "82a13035f3bed08d1d07c175af1a2c3e"	106	1	598.00	4	4	4	12	"Champions"
-- "bc06da4ef337c61d455d1e5b95ce9353"	106	1	550.99	4	4	4	12	"Champions"
-- "ac5d777c8eab479a43ca70db6294b161"	106	1	649.00	4	4	4	12	"Champions"
-- "42c69d0748468edb4bf96674d28e07ec"	106	1	399.00	4	4	4	12	"Champions"
-- "842a31ee1b53a7457cd7174cb0ebc931"	106	1	311.70	4	4	4	12	"Champions"
-- "552e5e9ae196001a9749ec363892a7b3"	106	1	239.00	4	4	4	12	"Champions"
-- "206b04b38a5dc8404458ec16edeca606"	106	2	192.89	4	4	4	12	"Champions"
-- "4d4d00884f3401e960f4650cc74bbf0e"	106	1	750.00	4	4	4	12	"Champions"
-- "5188090bf12661971a81f523d5b42f35"	106	1	429.00	4	4	4	12	"Champions"
-- "2178dc15f1526ac11f6ec40296163573"	106	1	249.99	4	4	4	12	"Champions"
-- "5ea2173f7b46070cf9827102aa248c46"	106	1	339.90	4	4	4	12	"Champions"
-- "782f78691d986d45ed2341715082b993"	106	1	330.00	4	4	4	12	"Champions"
-- "08d8ad84b0088cbeae77da4ff3817479"	106	2	224.28	4	4	4	12	"Champions"
-- "c03655414d78fc179eeb3c1dfeba84df"	106	1	289.00	4	4	4	12	"Champions"
-- "f55facac8c40907f178c8cbb6e6aa845"	106	1	682.98	4	4	4	12	"Champions"
-- "fc174418fd8dcc8694e3df5c837551a4"	106	1	254.90	4	4	4	12	"Champions"
-- "56421c47bfd636b238bc5de6eb7c8b87"	106	1	233.00	4	4	4	12	"Champions"
-- "1b8faff3d5246020c1779ee2be7103ed"	106	1	259.90	4	4	4	12	"Champions"
-- "20d55aefec63f14a88817c6c28125682"	106	1	428.00	4	4	4	12	"Champions"
-- "82d3e8adcc5eaecb0594f0b20a105d93"	106	1	249.00	4	4	4	12	"Champions"
-- "942db62653f6f1121ebeef2bfd740282"	106	1	450.00	4	4	4	12	"Champions"
-- "a55bb467166e95bca3fe4acd0e769d49"	106	1	858.90	4	4	4	12	"Champions"
-- "abd7e9db219836e58c3fca4965dd14e5"	106	1	275.00	4	4	4	12	"Champions"
-- "b8624f5635e1f66fa1910d775aab0055"	106	1	289.90	4	4	4	12	"Champions"
-- "b6fee1c78cf3fc61efeb49225981c593"	106	1	225.00	4	4	4	12	"Champions"
-- "239c38c21fc31782faa965955fe6d67b"	106	1	329.90	4	4	4	12	"Champions"
-- "d15398e68e82f5db291bc6c94675bce1"	106	1	369.00	4	4	4	12	"Champions"
-- "da7aed2e8fe57799e72ab172e4956aaf"	106	1	330.00	4	4	4	12	"Champions"
-- "1287bfd3869aaec082aa683512e593b5"	106	1	455.00	4	4	4	12	"Champions"
-- "53b23661544838db9c16bad67739f072"	106	1	369.00	4	4	4	12	"Champions"
-- "4e40f88729018a8129193dc0223912d4"	106	1	370.00	4	4	4	12	"Champions"
-- "b8329b2dd1bae9edf8e748f70dea3a14"	105	1	519.90	4	4	4	12	"Champions"
-- "2e1d9b01359126960a50a379dbafa00b"	105	1	279.99	4	4	4	12	"Champions"
-- "3279712e1ea8d52462488b4fb9dd7014"	105	2	173.67	4	4	4	12	"Champions"
-- "6603a86e401cf688d9dfeb155913ee16"	105	1	233.00	4	4	4	12	"Champions"
-- "876c5f7ffcad19a82c0da218ecf56ba3"	105	2	269.89	4	4	4	12	"Champions"
-- "e0a5163e8d7d76ca1fe345506a6552d7"	105	1	330.00	4	4	4	12	"Champions"
-- "dc2789ac94f950b30545e314f95e411e"	105	1	220.00	4	4	4	12	"Champions"
-- "2c8e68cad3121e0794c0c0e125a036dd"	105	1	299.00	4	4	4	12	"Champions"
-- "b65a65447f8a14cef396f6fb89195088"	105	1	299.80	4	4	4	12	"Champions"
-- "2b6e3f29a6dea0501566fb1127e48529"	105	1	429.90	4	4	4	12	"Champions"
-- "d646ec1a438d3c3436dcbbda21849479"	105	1	699.99	4	4	4	12	"Champions"
-- "2866c9e957865287f7f4256f0c91c9af"	105	1	329.90	4	4	4	12	"Champions"
-- "f96be73d5c1d3bfe8fcba7924798ba91"	105	2	406.80	4	4	4	12	"Champions"
-- "f27a3cee3bcebc5b64fb804f15f4c501"	105	1	878.00	4	4	4	12	"Champions"
-- "7c763b449a1a50b7cae7943be3dd5a06"	105	1	878.00	4	4	4	12	"Champions"
-- "a2027a1c6f9e04a875c44ea09061d3f2"	105	2	222.79	4	4	4	12	"Champions"
-- "523b7915f240831d06b34ab9b804a200"	105	2	184.99	4	4	4	12	"Champions"
-- "f67a2c438fe007cff6a7a6bb8629f342"	105	1	359.90	4	4	4	12	"Champions"
-- "f674cc26af3723f9aeda6971493ae276"	105	1	559.80	4	4	4	12	"Champions"
-- "e6c1bcc2640a9ca6016be5d45c7517b2"	105	1	399.00	4	4	4	12	"Champions"
-- "2ae2f3c177c42fc53754aa89990633fe"	105	1	299.00	4	4	4	12	"Champions"
-- "151bdb6d653a706699cee00174b5ab36"	105	1	450.00	4	4	4	12	"Champions"
-- "682ccf21d70f2c2e037c35adc2888109"	105	1	600.00	4	4	4	12	"Champions"
-- "cb36af177245c06f2eec15fb7afd4c72"	105	1	446.97	4	4	4	12	"Champions"
-- "ed7261cebaa1bece63123ff16da4e11e"	105	1	264.69	4	4	4	12	"Champions"
-- "c12ac817e00e9afad51c327ab2fc2ec3"	105	1	275.94	4	4	4	12	"Champions"
-- "8479be8528b1f06c698d38ecffae939f"	105	1	230.00	4	4	4	12	"Champions"
-- "4a64e946d6867537f422531feec7d966"	105	1	219.80	4	4	4	12	"Champions"
-- "9d82535b1ac9d3ec6acfdbdcc3a058a8"	105	1	230.00	4	4	4	12	"Champions"
-- "5dc9f6d97caad7b42b74f719cd5e90e9"	105	1	339.80	4	4	4	12	"Champions"
-- "ae4395be33e633d0c87010d59847e5ed"	105	2	263.80	4	4	4	12	"Champions"
-- "481060b29de0e9b3d7f4b2991cfb0767"	105	2	276.99	4	4	4	12	"Champions"
-- "9461c533a42feea7269efa908bbdef48"	105	1	199.30	4	4	4	12	"Champions"
-- "dbe76d05d62c31d6230f68258dd1cdc3"	105	1	195.90	4	4	4	12	"Champions"
-- "24015b979a21b2e70d156d11698270ce"	105	1	179.99	4	4	4	12	"Champions"
-- "f9cb074050db08ff0b4a0fb6ab37fa59"	105	1	199.90	4	4	4	12	"Champions"
-- "9b5ed7dd6e900a8dddac78911cc22562"	105	1	179.00	4	4	4	12	"Champions"
-- "b2c2e2635aded82494c5be5843664b74"	105	1	179.93	4	4	4	12	"Champions"
-- "2acd1014f0a4e286b0896f30b67c1e80"	105	1	156.45	4	4	4	12	"Champions"
-- "3893d70b2d99073bc0326b57d1bb1b19"	105	1	199.00	4	4	4	12	"Champions"
-- "19c1faaa7edee2484edc7968a5dc8a02"	105	1	179.00	4	4	4	12	"Champions"
-- "b14da98edc641a20d66551fdeaae5b92"	105	1	899.00	4	4	4	12	"Champions"
-- "a440ac198e3e7e955a1e99fa738b81d1"	105	1	215.60	4	4	4	12	"Champions"
-- "5b28f0cd69d0937dc74f55858d12bcf1"	105	1	169.90	4	4	4	12	"Champions"
-- "9deb1526d0da566452e9a6aa71564dfd"	105	1	198.90	4	4	4	12	"Champions"
-- "04951d4f64f1fb00783f6667a19a2915"	105	1	175.90	4	4	4	12	"Champions"
-- "fe203d7588a60b447f5c5f089b967097"	105	1	1599.00	4	4	4	12	"Champions"
-- "6802a5080e6f6ade0f077d30a4be19e6"	105	1	179.00	4	4	4	12	"Champions"
-- "c17023c486178e5a5855ae4736d435fb"	105	1	159.90	4	4	4	12	"Champions"
-- "f6b879ec05dbe0cea864f6bc8dcfe2e8"	105	1	159.90	4	4	4	12	"Champions"
-- "7b50def89c51f42400b796d7787ed658"	105	1	1001.00	4	4	4	12	"Champions"
-- "59da3c4be06e8efc9583f084fba97c3f"	105	1	179.49	4	4	4	12	"Champions"
-- "a04c7722cb3cfd6df3ad0bfd56519319"	105	1	185.00	4	4	4	12	"Champions"
-- "f0fb7b197ca6e41e0e03ffd685eaacd4"	105	1	159.90	4	4	4	12	"Champions"
-- "1b53b79fadf8ca4e24e013b575e7dfd6"	105	1	159.80	4	4	4	12	"Champions"
-- "5dfceca2174efc8d570e8c5664a74790"	105	1	185.90	4	4	4	12	"Champions"
-- "aabeb9e2c6ee7463645066a03437ea6d"	104	1	389.00	4	4	4	12	"Champions"
-- "a6a9bcd5bb8e470411ca79cdc1c6c6c1"	104	1	319.00	4	4	4	12	"Champions"
-- "a017de101a9c4fab4995c1bc81e737ea"	104	2	485.10	4	4	4	12	"Champions"
-- "1fe7ae92af636ff146a72d3e794c72d1"	104	1	255.00	4	4	4	12	"Champions"
-- "c8e1cd9cdfef5a269b059c117a0f244d"	104	1	330.00	4	4	4	12	"Champions"
-- "dbd6677a4cf469a8ac0aa22be1466630"	104	1	239.00	4	4	4	12	"Champions"
-- "1439b918601b3fc48b550a2e9925e413"	104	1	494.00	4	4	4	12	"Champions"
-- "f9165be8a411384aab9f945394418a0c"	104	2	240.90	4	4	4	12	"Champions"
-- "7223361f862a3cbbaad18f93f341e78f"	104	1	367.90	4	4	4	12	"Champions"
-- "ddbc31ac5198f6252ffd7811ff4c4e99"	104	1	229.90	4	4	4	12	"Champions"
-- "ba179ad4ba8c3916137aaad465eaa079"	104	1	780.00	4	4	4	12	"Champions"
-- "e3ad27e8ce89dac0796b09dbf9b4b0b8"	104	1	278.50	4	4	4	12	"Champions"
-- "92da8523fcb13b3941b639d03d6e6f30"	104	1	369.90	4	4	4	12	"Champions"
-- "c76dbe63126a89c815fe9716acfdb4a1"	104	2	317.90	4	4	4	12	"Champions"
-- "cee86ef4954e9d77f02cbc2276dd75e7"	104	2	639.70	4	4	4	12	"Champions"
-- "82c199ce18d8d976f3029a4310e8ac5c"	104	1	385.00	4	4	4	12	"Champions"
-- "ed4c785e11a78a73c48fa3af98008292"	104	2	331.49	4	4	4	12	"Champions"
-- "7b0eaf68a16e4808e5388c67345033c9"	104	2	2238.42	4	4	4	12	"Champions"
-- "f8b9ec13eba4f1bcc265416da29f0ba5"	104	1	169.00	4	4	4	12	"Champions"
-- "ca4a283fddc866a53908a24399a7c711"	104	1	177.80	4	4	4	12	"Champions"
-- "1e87bde63f0c69ced8c89104f60fadf7"	104	1	179.00	4	4	4	12	"Champions"
-- "e5e2698d69db1201c1084f1cdae68239"	104	1	179.90	4	4	4	12	"Champions"
-- "4c2759131ea45bbf124a6fd133ed3114"	104	1	189.90	4	4	4	12	"Champions"
-- "7f9bfee0390154778b2d2c4f06b50c14"	104	1	999.98	4	4	4	12	"Champions"
-- "ce062bc310d6e7ef233195118e090f1e"	104	1	1299.65	4	4	4	12	"Champions"
-- "6899ba25b05f771af3ede719ef5c861f"	104	1	1399.00	4	4	4	12	"Champions"
-- "12ebfdb41392890f9d7a8de957274741"	104	1	2110.00	4	4	4	12	"Champions"
-- "0621cda5f3ee9a2e6f3ae6ebb5fcdbe1"	104	1	2470.50	4	4	4	12	"Champions"
-- "33056e4605bf2fca436644ee21a6500e"	103	1	215.00	4	4	4	12	"Champions"
-- "378e62787b57eea9b2c037a12c6b8f59"	103	1	189.00	4	4	4	12	"Champions"
-- "36aad42658db613bb6d473de62a16391"	103	1	217.00	4	4	4	12	"Champions"
-- "6c20a0d058797463344295d2df549503"	103	1	199.00	4	4	4	12	"Champions"
-- "ab937298c3022bec8ae1ae1fa0bea6bf"	103	1	159.90	4	4	4	12	"Champions"
-- "b8fb9a0edb1d28b0c4207834a5b2a90a"	103	1	216.00	4	4	4	12	"Champions"
-- "e74047a9c3d3695325da90d83efc6e69"	103	1	179.90	4	4	4	12	"Champions"
-- "ab51e24e022fa42d70c04ab4fb4770f4"	103	1	179.98	4	4	4	12	"Champions"
-- "8ffc19affc6337074163ce2baf5ad841"	103	1	179.90	4	4	4	12	"Champions"
-- "30c1b3736cb88c0a104bf1089953b168"	103	1	159.49	4	4	4	12	"Champions"
-- "73f6c63a7d887f8f77dbb92fb0bee026"	103	1	157.89	4	4	4	12	"Champions"
-- "f9ea2418e0844db5b018bae082dc0eed"	103	1	159.00	4	4	4	12	"Champions"
-- "cbe89b81eb23d0e2f52d3c4c9ce1ad31"	103	1	159.00	4	4	4	12	"Champions"
-- "6aab877b564d98596500c9812b55d5c8"	103	1	158.20	4	4	4	12	"Champions"
-- "0e41533d246dc7f85a5a1de2cf23456b"	103	1	159.90	4	4	4	12	"Champions"
-- "fe4694b53dbfb6749ce5b8e16e59e96b"	103	1	179.90	4	4	4	12	"Champions"
-- "4095106fa4df8e377a44cd7dc86593a5"	103	1	169.90	4	4	4	12	"Champions"
-- "6f1b644a068a6fecb7fbac8f5fcfa056"	103	1	169.90	4	4	4	12	"Champions"
-- "98bb7b5e6f227eabf7e22634a5a5073e"	103	1	210.90	4	4	4	12	"Champions"
-- "9944b76be9da41b165d61c89598763d7"	103	1	344.00	4	4	4	12	"Champions"
-- "f546266e401753c3e88d310dd5843d03"	103	1	849.00	4	4	4	12	"Champions"
-- "07f5c42becf5d40e7778aa9953a19127"	103	1	230.00	4	4	4	12	"Champions"
-- "a4c6daf94bccd97601f8a793df390c50"	103	1	510.00	4	4	4	12	"Champions"
-- "902814c1c8358134a2233279c4e8463d"	103	1	601.80	4	4	4	12	"Champions"
-- "3a4acf4c4c97cc25075d29f8d29f405b"	103	2	447.90	4	4	4	12	"Champions"
-- "96701d73665eab8fc6fecb9863266efe"	103	2	252.90	4	4	4	12	"Champions"
-- "941aea93899e1ce73d06e2ce13ac5f84"	103	1	248.00	4	4	4	12	"Champions"
-- "56a0fd173511370007d218162d19bdd2"	103	1	259.99	4	4	4	12	"Champions"
-- "67b04a227b516a51455f20cd66d6457f"	103	1	367.90	4	4	4	12	"Champions"
-- "0318f66ddf6aa615fdb10d6d7b596194"	103	1	765.00	4	4	4	12	"Champions"
-- "8c21dd8c37144807c601f99f2a209dfb"	103	3	764.79	4	4	4	12	"Champions"
-- "081fcabcf2d562ac20877ff0e0e11c60"	103	1	349.00	4	4	4	12	"Champions"
-- "f1fc483a199c20417121d6ab1c5171a4"	103	1	348.20	4	4	4	12	"Champions"
-- "74f6957797ebda73b6c3990e98cc0ad5"	103	1	699.90	4	4	4	12	"Champions"
-- "3989cfd14391b8644422c0b34a5d3939"	103	1	289.00	4	4	4	12	"Champions"
-- "33169d9d412d3a3298190483cbd3fb06"	102	1	539.97	4	4	4	12	"Champions"
-- "6b8ae10a3b04e5828f3ca481565e2317"	102	1	299.00	4	4	4	12	"Champions"
-- "c91f28d2897be83bf943056ef4cf252e"	102	1	250.00	4	4	4	12	"Champions"
-- "75e4b658091a900167075f7e7fe1f78a"	102	1	223.00	4	4	4	12	"Champions"
-- "cbb5e2272aae14ce9f5d1d7d719d79e3"	102	1	299.99	4	4	4	12	"Champions"
-- "6395132a03f096da6f4c590ca2aa1a76"	102	1	299.00	4	4	4	12	"Champions"
-- "baad97a77fafd04f72a7f874dd67b37e"	102	2	238.89	4	4	4	12	"Champions"
-- "9160831db912b9fb5f89d075588d68a7"	102	1	625.00	4	4	4	12	"Champions"
-- "45391b7227315d0e4a045f2074eb27c4"	102	1	320.00	4	4	4	12	"Champions"
-- "d9ad5b8ce105bd3baced4648987fbbfc"	102	2	329.90	4	4	4	12	"Champions"
-- "70aa9ef908248a2ec9e03b77ce1ff357"	102	2	424.90	4	4	4	12	"Champions"
-- "9403933633aca7e3c413927cbf0ccfd5"	102	1	318.98	4	4	4	12	"Champions"
-- "bf4ab46b9030a846535307564fd4f525"	102	1	344.00	4	4	4	12	"Champions"
-- "edd3f97254cf3ce5e95da8245dea95dd"	102	1	298.60	4	4	4	12	"Champions"
-- "a660768f87f5460dead886e622dd5741"	102	2	163.49	4	4	4	12	"Champions"
-- "7a250ec45b3b94192c899e741b3231ad"	102	1	248.00	4	4	4	12	"Champions"
-- "9ee58215f365ea280a43bc9bd89dcabd"	102	1	535.00	4	4	4	12	"Champions"
-- "c9ae1d598a33315fdace01e3bfefc5ea"	102	1	630.00	4	4	4	12	"Champions"
-- "5790eb0a154162bb308fa4e642c20585"	102	1	277.80	4	4	4	12	"Champions"
-- "47a5a4129f85be0710fb1e87f0941fb4"	102	1	599.99	4	4	4	12	"Champions"
-- "f52f0e2afa2ce6c39854bd1ac2a355f6"	102	1	439.65	4	4	4	12	"Champions"
-- "021ac5734c4f62601583998bf0de4e03"	102	1	728.00	4	4	4	12	"Champions"
-- "a53fce785b05efe8e2315e593be3f517"	102	1	260.00	4	4	4	12	"Champions"
-- "d7dae4f93f4e804e66ba98e51e3efaf4"	102	1	212.00	4	4	4	12	"Champions"
-- "a4d5363120895cc3c9474f5483a39298"	102	1	174.97	4	4	4	12	"Champions"
-- "fef62bb69c27d647eb69eaac077cf3d7"	102	1	196.80	4	4	4	12	"Champions"
-- "b3d6341ff10832a54716444780256d87"	102	1	189.00	4	4	4	12	"Champions"
-- "232422c2db1f7c69daf3b0f0421ebb43"	102	1	179.00	4	4	4	12	"Champions"
-- "c16948c2abc51af80a151392f718e895"	102	1	199.00	4	4	4	12	"Champions"
-- "68d8acf19d02fb3b95c8954d31d75448"	102	1	199.80	4	4	4	12	"Champions"
-- "56dbd502ac5ebc9e4de6fc7c42213b3e"	102	1	169.99	4	4	4	12	"Champions"
-- "0cfd3bb78e947d0c37c6b6c113871fbd"	102	1	175.85	4	4	4	12	"Champions"
-- "7cf246813e2eba78e113376e61eb5c3b"	102	1	155.06	4	4	4	12	"Champions"
-- "32326030f94a88d5f606830e9f528349"	102	1	179.70	4	4	4	12	"Champions"
-- "6a53109a98162e696df52f83d20a2c03"	102	1	179.90	4	4	4	12	"Champions"
-- "212b7cfb2631b23e85a4645a7cba1733"	102	1	2470.50	4	4	4	12	"Champions"
-- "14418104e2b69c02fec4aa6b3c72d5bd"	101	1	595.00	4	4	4	12	"Champions"
-- "1c628081cb579ed6035b9aa8614e69f4"	101	3	168.90	4	4	4	12	"Champions"
-- "e55e436481078787e32349cee9febf5e"	101	1	219.90	4	4	4	12	"Champions"
-- "bd748b6890efcaa0e79187653b2d6a91"	101	2	158.33	4	4	4	12	"Champions"
-- "1287f6d27e4d6b299b6df65340831bc0"	101	1	525.00	4	4	4	12	"Champions"
-- "005f060d4223956c62b64e9567a36f0f"	101	1	689.00	4	4	4	12	"Champions"
-- "6bae3d248c2fcb847d59a027b4c30c89"	101	1	219.90	4	4	4	12	"Champions"
-- "cc6197eed38f9568999014e872eb432e"	101	1	730.00	4	4	4	12	"Champions"
-- "fce2525784cfc5e9bf69837bc1b9b474"	101	1	745.00	4	4	4	12	"Champions"
-- "a2992a92752d8ee1a8e2117636bdd699"	101	1	259.80	4	4	4	12	"Champions"
-- "b66da64051c395958d49bcf6f98589b4"	101	1	760.00	4	4	4	12	"Champions"
-- "24f597020fc5ef57ce93a6703a8da50a"	101	1	449.82	4	4	4	12	"Champions"
-- "d0c62583f73531eba6338b2390e7a861"	101	2	204.80	4	4	4	12	"Champions"
-- "65c8d5626ef56c53ff0336e24c7a9bd9"	101	1	252.00	4	4	4	12	"Champions"
-- "549417528351deb1fa8c2e41a232f755"	101	1	399.99	4	4	4	12	"Champions"
-- "4549ba22f341a2fcae487eec23de82f6"	101	1	338.80	4	4	4	12	"Champions"
-- "6d0845fb78d828c58be539febc4d4a8b"	101	1	250.00	4	4	4	12	"Champions"
-- "10949d619a29c56e7e370997a2603555"	101	1	399.00	4	4	4	12	"Champions"
-- "4438b887145e0848e91f390ad9bc299d"	101	1	224.00	4	4	4	12	"Champions"
-- "e3276a09829510513e2f055f953b2aed"	101	1	224.00	4	4	4	12	"Champions"
-- "29d72fba272ad06ed0b2ac6351da042f"	101	2	239.90	4	4	4	12	"Champions"
-- "e8933aa8c4fbfdec4781ccdf0a39740b"	101	1	249.90	4	4	4	12	"Champions"
-- "2f293b442348c20d12aa4537bd3d7234"	101	2	289.80	4	4	4	12	"Champions"
-- "52abba659c0a219f8de7076dc33e0e83"	101	2	249.80	4	4	4	12	"Champions"
-- "94cc5a9b3476fb489cea3b8554300d45"	101	1	359.00	4	4	4	12	"Champions"
-- "d6903bc66ac9ae94d0bec00ea5c39568"	101	2	248.90	4	4	4	12	"Champions"
-- "df1b06750f1f779cfc50dfd3ac735816"	101	1	383.50	4	4	4	12	"Champions"
-- "81133c6f891edaf2cd1193b262ab2ba7"	101	1	249.65	4	4	4	12	"Champions"
-- "8d26c82c2086dcacc175e2ffe6ee2f28"	101	2	229.70	4	4	4	12	"Champions"
-- "49a50b15e9bad2da9787ac8cc4e931fe"	101	1	159.80	4	4	4	12	"Champions"
-- "43978cedabadf283de4a06dfac108ffd"	101	1	156.94	4	4	4	12	"Champions"
-- "7ce5b57a120a2da6a804afa58ffcbfb5"	101	1	196.80	4	4	4	12	"Champions"
-- "2f329a5474b79da0cbb395721b633356"	101	1	169.90	4	4	4	12	"Champions"
-- "14cf1de486a8a3a9373a4eb38f8f5506"	101	1	198.70	4	4	4	12	"Champions"
-- "5950eb8fef0ee900da7fb4809ed0dd4a"	101	1	179.90	4	4	4	12	"Champions"
-- "b0cbcc2012a12e88cec35af43bdf2ffd"	101	1	159.80	4	4	4	12	"Champions"
-- "2d51fb14470de565e7930d56becb3f45"	101	1	158.90	4	4	4	12	"Champions"
-- "97931a3564e3864b299b37bb238568dd"	101	1	179.90	4	4	4	12	"Champions"
-- "c27fe69be20acb0c44a690e39d19ec07"	101	1	1189.90	4	4	4	12	"Champions"
-- "ecbd5e5e691f31008f06bd1f89d47da9"	101	1	180.00	4	4	4	12	"Champions"
-- "a768b94e8f3f630bc08ed436c791bff8"	101	1	179.90	4	4	4	12	"Champions"
-- "c8f6d10628c2e2adcd672d48a76a4614"	101	1	179.90	4	4	4	12	"Champions"
-- "1b76903617af13189607a36b0469f6f3"	101	1	3099.75	4	4	4	12	"Champions"
-- "d0ed0d8dd6a919b2aad302fa1cae682f"	101	1	163.89	4	4	4	12	"Champions"
-- "51a7e650cdc4c26aadc7708c1cb656e2"	101	1	179.90	4	4	4	12	"Champions"
-- "0891e5d4e534eb8585807582fc12cc3c"	101	1	190.00	4	4	4	12	"Champions"
-- "80983160f5a84682b0f41774c5e58789"	101	1	186.99	4	4	4	12	"Champions"
-- "c68ffc361044816323eebe6a756f3060"	101	1	195.00	4	4	4	12	"Champions"
-- "2b662952e348c3c3e5e7c4dc10241aa5"	101	1	189.00	4	4	4	12	"Champions"
-- "4b599442ff4a54a2bd46ec60a441afd5"	100	1	157.98	4	4	4	12	"Champions"
-- "c02930ca258cdfc2d3b6102b57086085"	100	1	189.00	4	4	4	12	"Champions"
-- "b845ca585648feec8dccd229c0ce48ee"	100	1	980.00	4	4	4	12	"Champions"
-- "71d0bdb856934e63fe9fd8019d7e3dcc"	100	1	156.94	4	4	4	12	"Champions"
-- "949a5efc8cd62cbe3888026bd0ddd1f6"	100	1	1079.90	4	4	4	12	"Champions"
-- "16a2e4356a0e4433e45df462ca7606fa"	100	1	174.90	4	4	4	12	"Champions"
-- "1ba069cf440ec45a011e1f5848965a7b"	100	1	159.90	4	4	4	12	"Champions"
-- "4dc331b70d624ca01f9fb5df8dad37b5"	100	1	159.90	4	4	4	12	"Champions"
-- "0bee4ef1025816711bd8c531720da011"	100	1	1189.90	4	4	4	12	"Champions"
-- "9e820807acc76b495c519f8034b74edc"	100	1	189.99	4	4	4	12	"Champions"
-- "f21b311edf78359967c818edc33d83b1"	100	1	165.00	4	4	4	12	"Champions"
-- "95c0772e8709029440f23baecd889e87"	100	1	189.90	4	4	4	12	"Champions"
-- "d0d042bc1cd9bdf6be6951f33c8e18c5"	100	1	169.99	4	4	4	12	"Champions"
-- "a2a66bd2fe21de351204cc6577312417"	100	1	185.00	4	4	4	12	"Champions"
-- "ae3f45a35de98e19b3ac981ff817f044"	100	1	249.99	4	4	4	12	"Champions"
-- "30ddfb9397deaa2700181ca7fab1260b"	100	1	429.90	4	4	4	12	"Champions"
-- "0b1715dfc26a6231c736058821dc0eb4"	100	1	379.80	4	4	4	12	"Champions"
-- "a2816010e66c2b2e4acb191fce3bbcf5"	100	1	391.25	4	4	4	12	"Champions"
-- "60ca7b9a3d66cbc1568e81f3f8332c11"	100	1	679.70	4	4	4	12	"Champions"
-- "f0663046f4fb8ab7073364aa3158ff1c"	100	1	279.90	4	4	4	12	"Champions"
-- "2a17ad8e3e7b1a0736096f005a07cefd"	100	1	349.90	4	4	4	12	"Champions"
-- "68a01a970a892626b445cdfad671db62"	100	1	329.00	4	4	4	12	"Champions"
-- "fec3e4a7b8f949d64af00058cc06c5c9"	100	1	250.00	4	4	4	12	"Champions"
-- "9d4a74be41297b2d408d5660085215fc"	100	1	416.50	4	4	4	12	"Champions"
-- "1b5a1fb128d2fb23ffc39090575c46ad"	100	1	649.00	4	4	4	12	"Champions"
-- "a1874c5550d2f0bc14cc122164603713"	100	4	670.39	4	4	4	12	"Champions"
-- "18d9a63b00f74956879ee01a9af44310"	100	1	419.80	4	4	4	12	"Champions"
-- "ad39475d18fc97e31bb5fc35b033946d"	100	1	438.08	4	4	4	12	"Champions"
-- "aee141085e7394b0d26736b002c65413"	99	1	249.00	4	4	4	12	"Champions"
-- "15e4c7c20b79fcad58b0010d4eae87b0"	99	1	249.00	4	4	4	12	"Champions"
-- "f69ed448d3c70ab7a332ca8a95fc2261"	99	1	299.99	4	4	4	12	"Champions"
-- "5ebfc38b642ccf73ce96dcb300476e00"	99	1	489.00	4	4	4	12	"Champions"
-- "efa1d1628ae9aca26075d17f7aa596bd"	99	1	238.00	4	4	4	12	"Champions"
-- "850e8006b4f239916012dfd4f9bdeb0e"	99	1	299.40	4	4	4	12	"Champions"
-- "ba07856943cc25d23d7950d5beb64553"	99	1	500.00	4	4	4	12	"Champions"
-- "bb1185da22886018db3140e842e52b80"	99	1	599.99	4	4	4	12	"Champions"
-- "81cfc2bc23a8deed7ee0c987d50db6be"	99	1	291.00	4	4	4	12	"Champions"
-- "641729a1cf61d2c021815d273d42fb74"	99	1	480.00	4	4	4	12	"Champions"
-- "ba0d837dcedd49f55686d5f00530077a"	99	1	249.00	4	4	4	12	"Champions"
-- "32458edbf45f89146ca6bebf9b4be256"	99	1	275.00	4	4	4	12	"Champions"
-- "bc13219ef5b1a254d34e3e6112303dfd"	99	1	330.00	4	4	4	12	"Champions"
-- "457fb3cb5ad59c352c8ca67ed9bad51a"	99	1	189.00	4	4	4	12	"Champions"
-- "adec8d35d0e9977d9562671cef505f8f"	99	1	189.90	4	4	4	12	"Champions"
-- "8ac03172dc8e36a4c5e0b694ef3235aa"	99	1	1799.00	4	4	4	12	"Champions"
-- "dda557b888ac6ac4a02a457e8ba36b46"	99	1	155.00	4	4	4	12	"Champions"
-- "5ea2a9453e4e5dfbdb7ba83435624914"	99	1	179.90	4	4	4	12	"Champions"
-- "f58b624587c166dc243abc92d8128b9e"	99	1	929.00	4	4	4	12	"Champions"
-- "7e6b73ca13a846a38c86885e98a63ada"	99	1	1299.99	4	4	4	12	"Champions"
-- "8f79dc5e831c5552d9fc8c03f0af2492"	99	1	156.90	4	4	4	12	"Champions"
-- "8a8a3b96590da699865fa7e07e0e08ff"	99	1	2062.99	4	4	4	12	"Champions"
-- "4d32ae832a9e254bda80dac89fd37afb"	99	1	1698.00	4	4	4	12	"Champions"
-- "dbf7d089aafd5899c92873b49f156040"	99	1	219.00	4	4	4	12	"Champions"
-- "b26a1f892a80a23b344995eec27b677a"	99	1	169.97	4	4	4	12	"Champions"
-- "2561161bc52cafa1be6e80ed9c92c9ea"	99	1	189.00	4	4	4	12	"Champions"
-- "ead67853687963974dfd6a3c23072deb"	98	1	579.00	4	4	4	12	"Champions"
-- "3f86db7a226a23bc9ad2cbc312f665d3"	98	1	230.00	4	4	4	12	"Champions"
-- "30b6d255385abae403f9df02c1948d74"	98	1	819.00	4	4	4	12	"Champions"
-- "fb729c7c87e874dfba7d6f75d40026f5"	98	1	319.88	4	4	4	12	"Champions"
-- "815a99cb9852a1011da9bb7f2070b93e"	98	2	169.48	4	4	4	12	"Champions"
-- "65ee274b862c5c053367be8a70dbc029"	98	2	181.98	4	4	4	12	"Champions"
-- "49c6b1ee895e59043bcd5e2135f08355"	98	2	158.90	4	4	4	12	"Champions"
-- "dea6f18f87ab85af01a9261d92ccf631"	98	1	250.00	4	4	4	12	"Champions"
-- "66e56177b9bf464a930e57edc3694403"	98	3	286.89	4	4	4	12	"Champions"
-- "91063750ff2a65c3ca7342c433dad7d2"	98	1	220.00	4	4	4	12	"Champions"
-- "e48dd47690c9c58d5b4bcca375755b37"	98	1	260.00	4	4	4	12	"Champions"
-- "a085f2883a0050fb733a66521c23d5f6"	98	1	379.00	4	4	4	12	"Champions"
-- "c91a2298842d411ec99d3b1f0b1b2e5a"	98	1	338.00	4	4	4	12	"Champions"
-- "31d1ec8fb80004b9a556acace88a9468"	98	1	881.64	4	4	4	12	"Champions"
-- "af116fbccaa2f1d9db020b0625f4db08"	98	1	159.49	4	4	4	12	"Champions"
-- "bef3ce10ea5715fbcbcbe3b266ee94c5"	98	1	2370.00	4	4	4	12	"Champions"
-- "f07771c6d7e9bb6169075668480cd7ce"	98	1	174.99	4	4	4	12	"Champions"



-- RFM SEGMENT SUMMARY (Fixed for PostgreSQL)
WITH rfm_base AS (
    SELECT
        customer_unique_id,
        -- Postgres: date - date = integer days. No need for EXTRACT EPOCH.
        (DATE '2018-08-31' - MAX(order_purchase_timestamp)::date) AS recency_days,
        COUNT(DISTINCT order_id)           AS frequency,
        ROUND(SUM(item_price)::numeric, 2)  AS monetary
    FROM delivered_orders
    GROUP BY customer_unique_id
),
rfm_scored AS (
    SELECT
        customer_unique_id,
        recency_days,
        frequency,
        monetary,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency ASC)    AS f_score,
        NTILE(4) OVER (ORDER BY monetary ASC)     AS m_score
    FROM rfm_base
),
rfm_segmented AS (
    SELECT
        customer_unique_id,
        monetary,
        CASE
            WHEN (r_score + f_score + m_score) >= 10 THEN 'Champions'
            WHEN (r_score + f_score + m_score) >= 8  THEN 'Loyal Customers'
            WHEN (r_score + f_score + m_score) >= 6 
                AND r_score >= 3                     THEN 'Potential Loyalists'
            WHEN r_score = 4 
                AND (f_score + m_score) <= 4         THEN 'New Customers'
            WHEN r_score <= 2 
                AND (f_score + m_score) >= 6         THEN 'At Risk'
            WHEN r_score = 1 
                AND f_score = 1                      THEN 'Lost Customers'
            ELSE 'Needs Attention'
        END AS rfm_segment
    FROM rfm_scored
)
SELECT
    rfm_segment,
    COUNT(customer_unique_id)              AS customer_count,
    ROUND(
        COUNT(customer_unique_id) * 100.0 
        / SUM(COUNT(customer_unique_id)) OVER ()
    , 1)                                   AS pct_of_customers,
    ROUND(AVG(monetary)::numeric, 2)       AS avg_ltv,
    ROUND(SUM(monetary)::numeric, 2)       AS total_revenue,
    ROUND(
        (SUM(monetary) * 100.0 
        / SUM(SUM(monetary)) OVER ())::numeric
    , 1)                                   AS pct_of_revenue
FROM rfm_segmented
GROUP BY rfm_segment
ORDER BY total_revenue DESC;

OUTPUT:
-- "rfm_segment"	"customer_count"	"pct_of_customers"	"avg_ltv"	"total_revenue"	"pct_of_revenue"
-- "Champions"	23254	24.9	291.93	6788582.65	51.3
-- "Loyal Customers"	23666	25.4	165.61	3919318.64	29.6
-- "Needs Attention"	23233	24.9	47.24	1097471.52	8.3
-- "At Risk"	5949	6.4	120.74	718292.76	5.4
-- "Potential Loyalists"	11274	12.1	46.27	521592.26	3.9
-- "Lost Customers"	5974	6.4	29.29	174991.10	1.3


