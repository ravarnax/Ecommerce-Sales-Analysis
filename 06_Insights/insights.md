*Insights will go here.*




-- 7. PRICE SANITY CHECK

        "Economic Pulse Check." As a Senior Analyst, I never trust a mean (average) without seeing the min and max first. A single "fat-finger" error—like someone accidentally listing a $10 cable for $10,000—will completely hallucinate your revenue projections and skew your entire analysis.
        
        1. The Outlier Investigation (MAX values)
            If your max_price is significantly higher (e.g., 50x) than your avg_price, you have Outliers.

            Business Insight: Are these "Lush" luxury items that drive our brand, or are they wholesale bulk orders?

            Senior Action: When we move to Power BI, we might need to use a Median instead of an Average to represent the "typical" customer experience, as the average will be "dragged" up by these expensive items.

        2. The "Freight Burden" (AVG freight)
            Compare your avg_freight to your avg_price.

            The Ratio: If freight is consistently more than 20–30% of the item price, your business has a Logistics Problem. High shipping-to-price ratios are the #1 cause of cart abandonment.

            Senior Action: We’ll eventually create a "Freight Ratio" column to see which regions or categories are the most expensive to serve.

        3. The "System Glitch" Check (zero_or_neg_price)
            Price <= 0: Unless AuraTech has an intentional "Free Gift" program, a price of 0 is a data entry failure.

            Negative Freight: This is a major red flag. Shipping costs the company money; it shouldn't be a "credit" unless it’s a refund being recorded incorrectly in the wrong table.



### STEP 04 --- REVENUE ANALYSIS

### QUERY 01 --- MONTHLY GMV TREND

This output is the "Gold Mine" for your project. As a Senior Analyst, looking at these numbers reveals exactly how AuraTech (Olist) grew and where the risks are.

Here is the **Executive Growth Analysis** based on your SQL output:

---

### 1. The "Hockey Stick" Growth Curve
* **The Launch (2016):** The business started nearly invisible in Sept 2016 (1 order). By Oct, it jumped to 265, but Dec saw a complete collapse (1 order). This suggests a **system shutdown** or a pilot phase ending before the official 2017 relaunch.
* **The Scalability Milestone:** Revenue crossed the **1 Million BRL** mark for the first time in **November 2017**.
* **Peak Performance:** Your best month in terms of volume and revenue was **November 2017** ($1.15M Total Revenue).
    * **Insight:** This was likely driven by **Black Friday**. Notice how December 2017 dropped significantly immediately after—this is classic "Holiday Burnout."

### 2. High-Level Performance Metrics
| Metric                        | Value / Trend | Senior Analyst Interpretation |

| **AOV (Average Order Value)** | **~$120.00**  | Extremely stable. It rarely dips below $110 or rises above $130. This means the product mix is consistent. |
| **Customer Loyalty**          | **Very Low**  | Look at Jan 2018: 7,069 orders from 6,974 customers. This means **98.6%** of your customers are one-time buyers. You have a **retention problem.** |
| **Freight Burden**            | **~15-18%**   | Total Freight is consistently about 16% of total revenue. For e-commerce, this is high. You are spending a lot on logistics. |

### 3. The "2018 Plateau" Warning
Look at the sequence from Jan 2018 to Aug 2018:
* **Orders:** 7,069 → 6,351 (A **10% decline** in volume).
* **Revenue:** $1.07M → $0.98M.
* **The "So What?":** Growth has stalled. After the massive surge in late 2017, the business is no longer growing month-over-month. In a real boardroom, I would be asking: *"Did we cut marketing spend in 2018, or has the market reached saturation?"*

### 4. Logistics "Red Flag" (June 2018)
Compare **May 2018** to **June 2018**:
* May Freight: $151k for 6,749 orders.
* June Freight: **$155k for 6,096 orders**.
* **The Insight:** You had **fewer orders** in June, but paid **more in total freight**.
* **Hypothesis:** Did shipping rates increase in June? Or did the business start shipping heavier items/longer distances? This is a "Profit Leak" you should investigate in your Power BI maps.




### Query 2 — Month over Month Growth Rate
2016 was a Pilot: The data shows 2016 was likely a testing phase. The real analytical baseline for AuraTech should begin in January 2017.

The November Peak: November 2017 wasn't just a "good month"—it set a new revenue floor that the company stayed above for the rest of its history.

2018 Plateau: Notice that in 2018, growth became very "flat" (e.g., May 2018 at 0.4%). The company moved from an Exponential Growth phase (2017) to a Saturation/Optimization phase (2018).



### 3. QUARTERLY REVENUE SUMMARY
### Metric                  Status              Strategic Observation
AOV Stability           Healthy             "Hovering around $120. The business has a solid, predictable price point."
Customer Acquisition    Aggressive          "Total Orders vs Unique Customers shows almost no repeat business. You are ""buying"" growth."
Logistics Efficiency    Critical            "The 18% freight ratio in 2018 is a ""Profit Leak"" that needs immediate attention."

