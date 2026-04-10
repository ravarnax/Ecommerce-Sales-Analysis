-- =============================================
-- REVENUE ANALYSIS
-- File: 03_revenue_analysis.sql
-- =============================================



-- 1. MONTHLY GMV TREND
SELECT
    order_month,
    order_month_name,
    order_year,
    order_month_num,
    COUNT(DISTINCT order_id) AS total_orders,
	COUNT(DISTINCT customer_unique_id) AS unique_customers,
	ROUND(SUM(item_price), 2) AS gmv,
	ROUND(SUM(freight_value), 2) AS total_freight,
	ROUND(SUM(total_item_revenue), 2) AS total_revenue,
	ROUND(AVG(item_price), 2) AS average_order_value
FROM delivered_orders
GROUP BY order_month, order_month_name, order_year, order_month_num
ORDER BY order_month ASC;


-- -- Output
-- "order_month"	            "order_month_name"	"order_year"	"order_month_num"	"total_orders"	"unique_customers"  	    "gmv"	      "total_freight"	   "total_revenue"	    "average_order_value"
-- "2016-09-01 00:00:00"	    "Sep 2016"	        2016	        9	                    1	                 1	                 134.97	        8.49	            143.46	                    44.99
-- "2016-10-01 00:00:00"	    "Oct 2016"	        2016	        10	                    265	                 262	            40325.11	    6165.55	              46490.66	                128.83
-- "2016-12-01 00:00:00"	    "Dec 2016"	        2016	        12	                    1	                 1	                 10.90	        8.72	             19.62	                    10.90
-- "2017-01-01 00:00:00"	    "Jan 2017"	        2017	        1	                    750	                 718	            111798.36	    15684.01	         127482.37	                122.45
-- "2017-02-01 00:00:00"	    "Feb 2017"	        2017	        2	                    1653	            1630	            234223.40	    37015.92	         271239.32	                126.06
-- "2017-03-01 00:00:00"	    "Mar 2017"	        2017	        3	                    2546	            2508	            359198.85	    55132.10	         414330.95	                123.99
-- "2017-04-01 00:00:00"	    "Apr 2017"	        2017	        4	                    2303	            2274	            340669.68	    50142.72	         390812.40	                132.61
-- "2017-05-01 00:00:00"	    "May 2017"	        2017	        5	                    3545	            3478	            489159.25	    77498.15	         566657.40	                122.20
-- "2017-06-01 00:00:00"	    "Jun 2017"	        2017	        6	                    3135	            3076	            421923.37	    68127.00	         490050.37	                120.93
-- "2017-07-01 00:00:00"	    "Jul 2017"	        2017	        7	                    3872	            3802	            481604.52	    84694.56	         566299.08	                109.06
-- "2017-08-01 00:00:00"	    "Aug 2017"	        2017	        8	                    4193	            4114	            554699.70	    91132.66	         645832.36	                115.63
-- "2017-09-01 00:00:00"	    "Sep 2017"	        2017	        9	                    4150	            4083	            607399.67	    93677.82	         701077.49	                128.22
-- "2017-10-01 00:00:00"	    "Oct 2017"	        2017	        10	                    4478	            4417	            648247.65	    102869.36	         751117.01	                124.33
-- "2017-11-01 00:00:00"	    "Nov 2017"	        2017	        11	                    7288	            7182	            987648.07	    165581.30	        1153229.37	                116.55
-- "2017-12-01 00:00:00"	    "Dec 2017"	        2017	        12	                    5513	            5450	            726033.19	    117045.10	         843078.29	                117.35
-- "2018-01-01 00:00:00"	    "Jan 2018"	        2018	        1	                    7069	            6974	            924645.00	    153242.46	        1077887.46	                115.05
-- "2018-02-01 00:00:00"	    "Feb 2018"	        2018	        2	                    6555	            6400	            826437.13	    139731.28	         966168.41	                109.93
-- "2018-03-01 00:00:00"	    "Mar 2018"	        2018	        3	                    7003	            6914	            953356.25	    167241.99	        1120598.24	                118.92
-- "2018-04-01 00:00:00"	    "Apr 2018"	        2018	        4	                    6798	            6744	            973534.09	    159344.84	        1132878.93	                124.38
-- "2018-05-01 00:00:00"	    "May 2018"	        2018	        5	                    6749	            6693	            977544.69	    151229.83	        1128774.52	                125.17
-- "2018-06-01 00:00:00"	    "Jun 2018"	        2018	        6	                    6096	            6058	            855591.97	    155856.99	        1011448.96	                122.11
-- "2018-07-01 00:00:00"	    "Jul 2018"	        2018	        7	                    6156	            6097	            867486.47	    159800.05	        1027286.52	                124.64
-- "2018-08-01 00:00:00"	    "Aug 2018"	        2018	        8	                    6351	            6310	            838576.64	    146915.00	         985491.64	                117.41

-- Insights : November 2017 is a single highest revenue month - Black Friday effect. Business grow approximately 706% from January 2017 to July 2018.


-- Query 2 - Month over Month Growth Rate.
-- Business question how fast are we actually growing each month 
-- Why it matters : 
-- Raw revenue going up is good, but growth rate tell you if momentum is accelerating or slowing 
--                                  - which is what investor and leadership actually care about?


WITH monthly_revenue AS (
    SELECT 
        order_month,
        order_month_name,
        ROUND(SUM(item_price), 2) AS gmv
    FROM delivered_orders
    GROUP BY order_month, order_month_name
)
SELECT
    order_month,
    order_month_name,
    gmv,
    LAG(gmv) OVER (ORDER BY order_month) AS prev_month_gmv,
    ROUND(
        (gmv - LAG(gmv) OVER (ORDER BY order_month))
        / NULLIF(LAG(gmv) OVER (ORDER BY order_month), 0)
        * 100
    , 1) AS mom_growth_pct
FROM monthly_revenue
ORDER BY order_month;


-- Output:
-- "order_month"	"order_month_name"	"gmv"	    "prev_month_gmv"	"mom_growth_pct"
-- "2016-09-01 00:00:00"	"Sep 2016"	134.97		
-- "2016-10-01 00:00:00"	"Oct 2016"	40325.11	134.97	                29777.1
-- "2016-12-01 00:00:00"	"Dec 2016"	10.90	    40325.11	            -100.0
-- "2017-01-01 00:00:00"	"Jan 2017"	111798.36	10.90	                1025573.0
-- "2017-02-01 00:00:00"	"Feb 2017"	234223.40	111798.36	            109.5
-- "2017-03-01 00:00:00"	"Mar 2017"	359198.85	234223.40	            53.4
-- "2017-04-01 00:00:00"	"Apr 2017"	340669.68	359198.85	            -5.2
-- "2017-05-01 00:00:00"	"May 2017"	489159.25	340669.68	            43.6
-- "2017-06-01 00:00:00"	"Jun 2017"	421923.37	489159.25	            -13.7
-- "2017-07-01 00:00:00"	"Jul 2017"	481604.52	421923.37	            14.1
-- "2017-08-01 00:00:00"	"Aug 2017"	554699.70	481604.52	            15.2
-- "2017-09-01 00:00:00"	"Sep 2017"	607399.67	554699.70	            9.5
-- "2017-10-01 00:00:00"	"Oct 2017"	648247.65	607399.67	            6.7
-- "2017-11-01 00:00:00"	"Nov 2017"	987648.07	648247.65	            52.4
-- "2017-12-01 00:00:00"	"Dec 2017"	726033.19	987648.07	            -26.5
-- "2018-01-01 00:00:00"	"Jan 2018"	924645.00	726033.19	            27.4
-- "2018-02-01 00:00:00"	"Feb 2018"	826437.13	924645.00	            -10.6
-- "2018-03-01 00:00:00"	"Mar 2018"	953356.25	826437.13	            15.4
-- "2018-04-01 00:00:00"	"Apr 2018"	973534.09	953356.25	            2.1
-- "2018-05-01 00:00:00"	"May 2018"	977544.69	973534.09	            0.4
-- "2018-06-01 00:00:00"	"Jun 2018"	855591.97	977544.69	            -12.5
-- "2018-07-01 00:00:00"	"Jul 2018"	867486.47	855591.97	            1.4
-- "2018-08-01 00:00:00"	"Aug 2018"	838576.64	867486.47	            -3.3


-- Query 3 — Quarterly Revenue Summary
-- Business question :  How does performance look at the quarterly level 
-- Why it matters? Month level data is noisy.
-- Executives often prefer quarterly use to see the cleaner trends without seasonal noise.


-- 3. QUARTERLY REVENUE SUMMARY
SELECT
    order_year,
    EXTRACT(QUARTER FROM order_purchase_timestamp)::INT AS quarter,
    CONCAT('Q', EXTRACT(QUARTER FROM order_purchase_timestamp), ' ', order_year) AS period_label,
    
    COUNT(DISTINCT order_id)           AS total_orders,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,
    ROUND(SUM(item_price), 2)          AS gmv,
    ROUND(AVG(item_price), 2)          AS avg_order_value,
    ROUND(SUM(freight_value), 2)       AS total_freight,
    -- Calculate the Freight Ratio
    ROUND(
        SUM(freight_value) / NULLIF(SUM(item_price), 0) * 100
    , 1)                                AS freight_as_pct_of_gmv
FROM delivered_orders
GROUP BY 1, 2, 3 -- Groups by the first three columns in the SELECT list
ORDER BY order_year, quarter;




-- Output:
--     "order_year"	"quarter"	"period_label"	"total_orders"	"unique_customers"	"gmv"	"avg_order_value"	"total_freight"	"freight_as_pct_of_gmv"
--         2016	        3	       "Q3 2016"	    1	                1	        134.97	        44.99	        8.49	        6.3
--         2016	        4	       "Q4 2016"	    266	                263	        40336.01	    128.46	        6174.27	        15.3
--         2017	        1	       "Q1 2017"	    4949	            4849	    705220.61	    124.42	        107832.03	    15.3
--         2017	        2	       "Q2 2017"	    8983	            8792	    1251752.30	    124.42	        195767.87	    15.6
--         2017	        3	       "Q3 2017"	    12215	            11931	    1643703.89	    117.83	        269505.04	    16.4
--         2017	        4	       "Q4 2017"	    17279	            16960	    2361928.91	    118.84	        385495.76	    16.3
--         2018	        1	       "Q1 2018"	    20627	            20211	    2704438.38	    114.73	        460215.73	    17.0
--         2018	        2	       "Q2 2018"	    19643	            19388	    2806670.75	    123.95	        466431.66	    16.6
--         2018	        3	       "Q3 2018"	    12507	            12370	    1706063.11	    120.98	        306715.05	    18.0



-- Query 4 — Annual Revenue Summary
-- Business question: What is our year over year performance?


-- 4. ANNUAL REVENUE SUMMARY
-- Note: 2016 is partial (starts Sep), 2018 is partial (ends Aug)
SELECT
    order_year,
    COUNT(DISTINCT order_id)             AS total_orders,
    COUNT(DISTINCT customer_unique_id)   AS unique_customers,
    ROUND(SUM(item_price), 2)            AS gmv,
    ROUND(AVG(item_price), 2)            AS avg_order_value,
    ROUND(SUM(freight_value), 2)         AS total_freight,
    ROUND(SUM(total_item_revenue), 2)    AS total_revenue,
    COUNT(DISTINCT seller_id)            AS active_sellers,
    COUNT(DISTINCT product_category)     AS categories_sold
FROM delivered_orders
GROUP BY order_year
ORDER BY order_year;


-- Output:
    -- "order_year"	"total_orders"	"unique_customers"  	"gmv"	"avg_order_value"	"total_freight" 	"total_revenue"	 "active_sellers"	"categories_sold"
    -- 2016	             267	           264	           40470.98	    127.67	            6182.76	            46653.74	        129	            30
    -- 2017	             43426	         42134	         5962605.71	    120.33	            958600.70	        6921206.41	        1690	        73
    -- 2018	             52777	         51606	         7217172.24	    119.65	            1233362.44	        8450534.68	        2330	        73



-- Query 5 — Average Order Value Trend
-- Business question: Are customers spending more or less per order over time?
-- Why it matters: Growing GMV from more orders is good. Growing GMV from higher spend per customer is better — it means richer product mix or better upselling.

