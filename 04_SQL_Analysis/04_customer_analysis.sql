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


