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


-- 5. AVERAGE ORDER VALUE TREND 
WITH order_level AS (
    SELECT
        order_month,
        order_month_name,
        order_id,
        SUM(item_price)  AS order_gmv,
        SUM(freight_value) AS order_freight
    FROM delivered_orders
    GROUP BY order_month, order_month_name, order_id
)
SELECT
    order_month,
    order_month_name,
    COUNT(order_id)                   AS total_orders,
    ROUND(AVG(order_gmv)::numeric, 2) AS avg_order_value, -- Cast to numeric
    ROUND(MIN(order_gmv)::numeric, 2) AS min_order_value, -- Cast to numeric
    ROUND(MAX(order_gmv)::numeric, 2) AS max_order_value, -- Cast to numeric
    -- Fixed the percentile rounding error by casting to numeric first
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY order_gmv)::numeric
    , 2)                              AS median_order_value
FROM order_level
GROUP BY order_month, order_month_name
ORDER BY order_month;



-- OUTPUT:
--      "order_month"		"order_month_name"	"total_orders"	"avg_order_value"	"min_order_value"	"max_order_value"	"median_order_value"
-- "2016-09-01 00:00:00"	    "Sep 2016"	            1	       134.97	            134.97	           134.97	                134.97
-- "2016-10-01 00:00:00"	    "Oct 2016"	            265	       152.17	            6.00	           1399.00	                89.00
-- "2016-12-01 00:00:00"	    "Dec 2016"	            1	       10.90	            10.90	           10.90	                10.90
-- "2017-01-01 00:00:00"	    "Jan 2017"	            750	       149.06	            2.90	           2999.00	                82.65
-- "2017-02-01 00:00:00"	    "Feb 2017"	            1653	   141.70	            5.90	           6735.00	                84.90
-- "2017-03-01 00:00:00"	    "Mar 2017"	            2546	   141.08	            4.90	           3999.90	                84.99
-- "2017-04-01 00:00:00"	    "Apr 2017"	            2303	   147.92	            4.90	           4799.00	                87.89
-- "2017-05-01 00:00:00"	    "May 2017"	            3545	   137.99	            4.50	           6499.00	                87.90
-- "2017-06-01 00:00:00"	    "Jun 2017"	            3135	   134.58	            3.49	           2999.89	                79.90
-- "2017-07-01 00:00:00"	    "Jul 2017"	            3872	   124.38	            3.90	           2999.89	                84.50
-- "2017-08-01 00:00:00"	    "Aug 2017"	            4193	   132.29	            3.99	           2159.98	                79.99
-- "2017-09-01 00:00:00"	    "Sep 2017"	            4150	   146.36	            2.29	           13440.00	                85.00
-- "2017-10-01 00:00:00"	    "Oct 2017"	            4478	   144.76	            3.85	           2999.99	                89.00
-- "2017-11-01 00:00:00"	    "Nov 2017"	            7288	   135.52	            3.90	           5934.60	                84.99
-- "2017-12-01 00:00:00"	    "Dec 2017"	            5513	   131.69	            5.40	           3124.00	                88.60
-- "2018-01-01 00:00:00"	    "Jan 2018"	            7069	   130.80	            4.99	           3690.00	                87.00
-- "2018-02-01 00:00:00"	    "Feb 2018"	            6555	   126.08	            2.99	           3300.00	                84.90
-- "2018-03-01 00:00:00"	    "Mar 2018"	            7003	   136.14	            4.99	           4099.99	                86.90
-- "2018-04-01 00:00:00"	    "Apr 2018"	            6798	   143.21	            0.85	           3399.99	                89.99
-- "2018-05-01 00:00:00"	    "May 2018"	            6749	   144.84	            4.99	           4400.00	                89.99
-- "2018-06-01 00:00:00"	    "Jun 2018"	            6096	   140.35	            3.50	           4590.00	                89.90
-- "2018-07-01 00:00:00"	    "Jul 2018"	            6156	   140.92	            3.00	           7160.00	                86.00
-- "2018-08-01 00:00:00"	    "Aug 2018"	            6351	   132.04	            2.20	           4399.87	                79.99



-- Query 6 : DAY OF WEEK REVENUE PATTERN
-- Business question: Which days do customers order most?
-- Why it matters: Marketing teams use this to time campaigns, email sends, and promotions.

SELECT
    TRIM(order_day_of_week) AS day_of_week,
    EXTRACT(DOW FROM order_purchase_timestamp) AS day_num,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(item_price), 2) AS gmv,
    ROUND(AVG(item_price), 2) AS avg_order_value
FROM delivered_orders
GROUP BY TRIM(order_day_of_week), EXTRACT(DOW FROM order_purchase_timestamp)
ORDER BY day_num;


-- OUTPUT:
--      "day_of_week"	"day_num"	"total_orders"	      "gmv"	    "avg_order_value"
--      "Sunday"	        0	        11632	        1545181.07	   117.71
--      "Monday"	        1	        15701	        2168905.61	   120.68
--      "Tuesday"	        2	        15502	        2122147.22	   118.84
--      "Wednesday"	        3	        15074	        2051158.81	   119.14
--      "Thursday"	        4	        14322	        1958421.49	   119.18
--      "Friday"	        5	        13684	        1910385.13	   121.70
--      "Saturday"	        6	        10555	        1464049.60	   123.18


-- Query 7 — Peak Revenue Hours

-- 7. HOURLY ORDER PATTERN
-- Business question: What time of day do most orders happen?
-- Why it matters: This tells you when your servers are busiest and when to schedule maintenance or email drops.

SELECT
    EXTRACT(HOUR FROM order_purchase_timestamp)  AS hour_of_day,
    COUNT(DISTINCT order_id)                     AS total_orders,
    ROUND(SUM(item_price), 2)                    AS gmv,
    ROUND(AVG(item_price), 2)                    AS avg_order_value
FROM delivered_orders
GROUP BY EXTRACT(HOUR FROM order_purchase_timestamp)
ORDER BY hour_of_day;


-- OUTPUT:
--       "hour_of_day"	"total_orders"	"gmv"	    "avg_order_value"
--              0	        2321	    307166.35	    115.69
--              1	        1133	    147608.07	    116.78
--              2	        496	        54028.76	    93.96
--              3	        259	        32100.68	    107.36
--              4	        203	        24191.61	    99.97
--              5	        182	        21905.22	    102.84
--              6	        477	        53443.91	    100.46
--              7	        1199	    147781.69	    110.04
--              8	        2907	    386356.06	    115.78
--              9	        4647	    666581.16	    124.69
--              10         5978	        813492.67	    118.22
--              11         6385	        852420.68	    117.22
--              12         5802	        814872.16	    122.35
--              13         6309	        848708.07	    117.48
--              14         6383	        925967.10	    124.88
--              15         6249	        880248.22	    122.02
--              16         6475	        907844.74	    121.40
--              17         5961	        812172.99	    118.79
--              18         5585	        798578.94	    124.97
--              19         5801	        800102.61	    121.65
--              20         6007	        829998.61	    123.27
--              21         6039	        811540.81	    120.12
--              22         5658	        768521.96	    120.12
--              23         4014	        514615.86	    113.15  


