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



### 5. AVERAGE ORDER VALUE TREND 

Compare avg vs median order value. If avg is much higher than median, expensive orders are skewing the average — median is the truer picture of typical customer behavior."


The Trend: Your Average ($120.33) is consistently ~$35–$40 higher than your Median (~$80–$85).
The Conclusion: AuraTech’s revenue is positively skewed. This confirms that a small percentage of high-ticket "Whale" orders (visible in your max_order_value column) is pulling the average upward.



Critical Insights :
1. The "Whale" Dependency:
    The gap between $120$ and $85$ means your "typical" customer spends 30% less than the average suggests.

    The Lesson: If you base your marketing budget (Cost Per Acquisition) on the $120 average, you will overspend. You must optimize for the $85$ customer to remain profitable for the majority of your base.


2. Identifying "B2B" vs. "B2C":
    Look at the max_order_value in your output. If you see values like $6,735, that is not a standard retail consumer; that is a business or a bulk buyer.
    
    The Lesson: A Senior Analyst separates these. One single $6,000 order has the same impact on the Average as 70 normal customers. In Power BI, use Median to describe user behavior and Sum to describe financial performance.
    
3. Stability vs. Volatility:
    Notice if the Median remains flat while the Average fluctuates month-to-month.
    
    The Lesson: Fluctuations in the Average usually mean you ran a promotion on expensive items (like Furniture). If the Median stays flat, your "Core" customer behavior hasn't changed. The Median is your shield against noise.


4. Operational Accuracy : 
    The MIN(order_gmv) check is your final safety net.
    
    The Lesson: If the min_order_value is extremely low (e.g., $0.85$), check if freight was charged. Shipping a $1 item costs the same as shipping a $100 item. Low-value orders are often negative-margin traps for the business.


Senior Tip: In your final project presentation, show both. Use the Average to show Revenue Potential and the Median to show Customer Reality.


### Query 6 — Day of Week Revenue Pattern

"Monday and Tuesday typically show highest order volume in e-commerce. Does Olist follow this pattern? What does this mean for when Olist should run promotions?"

The Pattern Analysis
Yes, Olist follows the classic e-commerce pattern perfectly. According to your data, Monday (15,701 orders) and Tuesday (15,502 orders) are the undisputed peak days for transaction volume. This represents a 48% surge compared to the Saturday low (10,555).

Precise Business Analysis
1. The "Monday Motivation" Peak
Monday is the strongest day for both Volume (15,701) and Velocity. In e-commerce, this is usually caused by "Weekend Catch-up." Customers browse over the weekend but wait until the work week begins—when they are back at their desks and in "execution mode"—to finalize the purchase.

2. The "Weekend Valley"
Saturday (10,555) and Sunday (11,632) are the lowest volume days.

Insight: People are away from their screens and out living their lives.

The Counter-Intuitive Twist: Look at the Average Order Value (AOV). Saturday has the highest AOV ($123.18).

Senior Interpretation: While fewer people shop on Saturday, those who do are likely buying deliberate, high-ticket items (like Furniture or Appliances) rather than small impulse buys.

Strategic Promotion Recommendations
As a Senior Analyst, I would advise the marketing team to use this data for a two-pronged strategy:

![strategy](image.png)

### Junior Analyst Insight: The "Operational Strain"

    Why does this matter beyond marketing? Logistics.
    If your orders spike on Monday/Tuesday, your warehouse and sellers will be overwhelmed by Tuesday afternoon.

    The lesson: If Olist offers a "2-day shipping" promise, a Monday order must ship by Wednesday. If the Monday surge is too high, you will see a spike in Late Deliveries.

### Query 7 — Peak Revenue Hours

"What time of day do customers buy the most?"

The Pattern Analysis
    The data shows a very distinct "Productive Hours" shopping cycle. Unlike entertainment platforms that peak late at night, Olist sees its heaviest traffic during standard business and afternoon hours.

    The Peak Window: The peak occurs between 10:00 (10 AM) and 16:00 (4 PM), with volume holding remarkably steady above 6,000 orders per hour during this block.

    The "Dead Zone": Orders bottom out between 03:00 and 05:00, where volume drops to ~200 orders per hour (a 97% decrease from peak).

Precise Business Analysis
1. The "Workday Shopper" Persona
    The highest volume peaks at 16:00 (4:00 PM) with 6,475 orders.

    Insight: Shopping behavior is closely tied to the workday. Volume ramps up sharply at 08:00 (when people start work) and stays high until 22:00. This suggests customers are shopping during breaks or as a "reward" at the end of their workday.

2. The "After-Dinner" Surge
    Notice the secondary peak at 20:00 and 21:00 (8-9 PM).

    Insight: After a brief dip during the commute/dinner hour (17:00–18:00), customers return for one last session before bed. Interestingly, the Average Order Value (AOV) at 20:00 ($123.27) is higher than the morning peaks.


![strategy recommedation](image-1.png)

### Junior Analyst Insight: AOV vs. Volume
    The "Night Owl" Premium:
         Notice that 09:00 AM ($124.69), 14:00 PM ($124.88), and 18:00 PM ($124.97) have the highest AOVs.

The Lesson:
     Volume and Value don't always peak at the exact same second. The 18:00 (6 PM) shopper may be buying fewer things, but they are buying more expensive items.

Senior Warning on Server Load:
    If you are planning a Black Friday event based on this data, you must prepare your servers for a "Dual Peak." You will have a sustained 6-hour load in the afternoon and a sudden, sharp spike between 8 PM and 10 PM. If your checkout process lags at 4 PM, you will lose the most revenue of the day.







### Step 5 — Customer Behavior Analysis 👥

"Revenue tells you what happened. Customer analysis tells you why it happened and whether it will keep happening. At every company I've worked at, the customer analysis is what separates analysts who describe the past from analysts who predict the future."


    ### The Business Context First
    For Olist, customer analysis answers:

    Are we building a loyal customer base or a leaky bucket?
    What does a typical customer journey look like?
    Which customers are worth the most — and are we keeping them?
    Where are our customers geographically concentrated?

    Is our customer base growing in quality or just quantity?
    We already spotted the retention crisis in Revenue Analysis. Now we quantify it precisely and find every angle of the customer story.


    ### Query 1 — Customer Purchase Frequency Distribution
    Business question: How many customers bought once vs. multiple times?
    Why it matters: This is the single most important customer health metric for any marketplace. It directly measures platform loyalty.

    X% of customers are one-time buyers. Only Y% bought 3 or more times. These repeat buyers generate disproportionate revenue — calculate their share of total GMV."

        Here is the precise mathematical breakdown and the strategic interpretation of your customer behavior data.

        ### **The Precise Answers for Your Insight Note**
        * **X (One-Time Buyers):** **97.00%**
        * **Y (Bought 3 or more times):** **0.24%** *(Calculated by adding the percentages for 3, 4, 5, 6, 7, 9, and 15 orders).*

        Here is the exact sentence you should put in your final presentation:
        > *"**97.0%** of customers are one-time buyers. Only **0.24%** bought 3 or more times. However, repeat buyers (those with 2 or more orders) represent just **3%** of our customer base but generate **5.5%** of our total revenue, proving that their lifetime value is nearly double that of a one-time shopper."*

        ---

        ### **Senior Analyst Deep Dive (The "Why It Matters")**

        When you build your dashboard, this is the story you need to tell the business leaders. E-commerce businesses generally fall into one of two categories: a **"Subscription/Loyalty"** business (like Amazon Prime or Chewy) or an **"Acquisition Treadmill"** (like a company selling mattresses where people only buy once every 10 years).

        Your data proves that **AuraTech/Olist is an Acquisition Treadmill.**

        #### **1. The "One-and-Done" Crisis**
        * **The Math:** Out of 93,350 total customers, 90,549 bought exactly once and never returned. 
        * **The Business Risk:** This means the company is constantly paying Marketing and Advertising costs (Customer Acquisition Cost, or CAC) to find *new* people. If the cost of Facebook or Google ads goes up, this business will instantly lose its profitability because they have no free "organic" revenue coming from loyal returning customers.

        #### **2. The Value of Loyalty (The "Multiplier" Effect)**
        Look at the **`avg_ltv`** (Average Lifetime Value) column:
        * **1 Order:** R$ 137.96
        * **2 Orders:** R$ 245.35 *(1.7x higher)*
        * **4 Orders:** R$ 676.67 *(4.9x higher)*
        * **9 Orders:** R$ 1,000.85 *(7.2x higher)*

        **The Insight:** When a customer *does* return, they don't just buy small items; their value compounds massively. A customer who buys 4 times is worth almost **5 times more** revenue than a one-time buyer. 

        #### **Actionable Business Recommendation**
        In your Power BI report, recommend the following to the Marketing Team:
        **"We must shift 2% of our marketing budget away from acquiring new users and spend it on Retargeting Campaigns (Email discounts, 'We miss you' coupons). Moving just 5% of our one-time buyers (4,500 people) into the '2 Order' tier would instantly generate over R$ 1.1 Million in new revenue with zero new acquisition costs."**


-- Query 03 - Customer Lifetime Value Segments 
This query is the **"Pareto Principle" (80/20 Rule) Audit**. In e-commerce, not all customers are created equal. This analysis proves that a tiny fraction of your user base is essentially "carrying" the entire business on their backs.

As a Senior Analyst, I call the **Platinum Segment** your "High-Velocity Engine." If you lose a Platinum customer, you have to acquire **twelve (12)** Bronze customers just to replace the lost revenue.

---

### **The Precise Analysis**

#### **1. The "Catastrophic" Revenue Concentration**
* **The Stat:** Your **Platinum (Top 25%)** customers generate **62.5%** of your total revenue.
* **The Insight:** Even though each segment has exactly the same number of people (~23,337), the Platinum segment is **12 times more valuable** than the Bronze segment (62.5% vs 5.1%).

#### **2. The Whale Factor**
* **LTV Spread:** The jump from the Bronze average LTV (R$ 29.10) to the Platinum average LTV (R$ 354.23) is staggering. 
* **The Outlier:** Note the `max_ltv` of **R$ 13,440**. This single customer is worth as much as the combined revenue of **461 Bronze customers**.

#### **3. The "Order Frequency" Illusion**
* **The Data:** Look at `avg_orders_per_customer`. Even in the Platinum tier, the average is only **1.08**. 
* **The Senior Insight:** This tells us that **Platinum status is driven by high-ticket items, not loyalty.** These aren't necessarily people coming back every week; they are people who bought an expensive sofa or a laptop once. 
* **The Conclusion:** AuraTech doesn't have a "Loyalty" problem—it has a **"Retention"** problem. Even your best customers are only buying 1.08 times.

---

### **Junior Analyst Insight: The "Marketing Trap"**

If the Marketing team says, *"We are spending the same amount of ad money to acquire every customer,"* you should show them this table immediately.

* **Bronze Segment:** You are likely **losing money** on these customers. If the cost to acquire a customer (CAC) is R$ 30, and they only spend R$ 29.10 (Avg LTV), you have a negative margin before even considering shipping or product costs.
* **Platinum Segment:** This is where your profit lives. 

---

### **Actionable Business Recommendations**

| Segment | Strategy | Business Goal |
| :--- | :--- | :--- |
| **Platinum** | **"The Red Carpet"** | **VIP Service.** If a Platinum customer files a support ticket, it should be answered in 5 minutes. Losing them is a financial disaster. |
| **Gold/Silver** | **"The Upsell"** | **Basket Growth.** Use "Bundling" (e.g., "Buy this and get 20% off a second item") to push them from an LTV of R$ 100 to R$ 200. |
| **Bronze** | **"The Filter"** | **Cost Control.** Stop spending expensive Retargeting Ads on this group. They are "Low-Value, High-Cost" users. |






-- 4. REPEAT CUSTOMER PROFILE

This query provides the definitive profile of **Loyalty** for AuraTech. As a Senior Analyst, I see a very clear "Loyalty Correlation" here: higher engagement isn't just about spending more; it's about a better relationship with the platform.

Here is the in-depth analysis of your results:

---

### **1. Do repeat customers have higher satisfaction scores?**
**Yes, significantly.**
* **The Trend:** Satisfaction climbs steadily from **4.15** (One-time) to **4.37** (Champion).
* **The Insight:** This is a "Positive Feedback Loop." Customers who have a great first experience (high review score) are the ones who come back. 
* **Senior Interpretation:** The 4.37 score for Champions tells us that **satisfaction is a prerequisite for loyalty.** If a customer has even a slightly mediocre experience (3 stars or less), the data shows they almost never move into the "Loyal" or "Champion" tiers.

### **2. Do they explore more categories?**
**Yes, they are the platform's "Explorers."**
* **The Trend:** One-time buyers stick to **1.0** category, while Champions explore nearly **3 distinct categories (2.8).**
* **The Insight:** Loyalty at Olist isn't about buying the same thing over and over (like groceries); it's about **trusting the platform** to provide different types of goods. 
* **Strategic Action:** To turn a "One-time" buyer into a "Returning" buyer, the data suggests we shouldn't show them the *same* category again. Instead, cross-category recommendations are the key to building champions.

### **3. The "AOV Paradox"**
* **The Data:** Interestingly, the **Average Order Value (AOV)** actually **drops** as customers become more loyal ($126 for One-time vs. $94 for Loyal).
* **The Insight:** One-time buyers often come for a specific, higher-priced item they found via search (e.g., a specific piece of furniture). Loyal buyers, however, use the platform for **smaller, everyday purchases.** * **The Lesson:** Loyalty doesn't mean "bigger orders"; it means "more frequent, smaller orders."

---

### **Executive Summary for your Portfolio**

| Metric | One-Time Buyer | Champion Buyer (4+) | Difference |
| :--- | :--- | :--- | :--- |
| **LTV** | R$ 137.94 | R$ 664.38 | **+381% Revenue** |
| **Satisfaction** | 4.15 | 4.37 | **Higher Trust** |
| **Categories** | 1.0 | 2.8 | **Broader Interest** |
| **Longevity** | 0 Days | 205 Days | **Sustained Value** |

---

### **Power BI Visualization Strategy**

1.  **Radar (Spider) Chart:** Use the segments as the categories and map Satisfaction, Category Exploration, and AOV. It will show the "Loyalty Shape" expanding outward.
2.  **Scatter Plot:** X-axis = `avg_days_as_customer`, Y-axis = `lifetime_value`, Size = `avg_satisfaction_score`. This will visually prove that "Time + Satisfaction = High Value."
3.  **Key Insight Card:** *"A Champion Customer is worth 4.8x more than a One-Time buyer and explores 180% more of our product catalog."*

**Does this finalize your Customer Analysis, or shall we look at the "Category Deep Dive" to see which products specifically create these Champions?**



-- QUERY 5 - CUSTOMER ACQUISITION TREND

This analysis of the **Customer Acquisition Trend** provides the "Scale" story of AuraTech. While your previous queries focused on money (GMV), this query focuses on **Market Penetration**.

By August 2018, you have built a platform with a total reach of **93,350 unique customers.** ---

### **1. The Three Phases of Growth**

Looking at the `new_customers_acquired` column, the business clearly moved through three distinct life cycles:

* **Phase 1: The Pilot (Late 2016)**
    * Acquiring ~250–300 customers a month. The business was testing its systems and logistics.
* **Phase 2: The Hyper-Growth "S-Curve" (2017)**
    * **January 2017:** 700+ new users.
    * **May 2017:** 3,300+ new users.
    * **November 2017:** **6,926 new users (The all-time peak).**
    * *Insight:* In just 11 months, your monthly acquisition velocity increased by **980%**. This is the classic "Hockey Stick" growth investors love.
* **Phase 3: The Scaling Plateau (2018)**
    * Acquisition stabilized between **6,100 and 6,800** new users per month. 
    * *Senior Interpretation:* The "low-hanging fruit" in the market has been picked. The company is now in a "Maintenance & Scale" phase where customer acquisition costs (CAC) likely started to rise.

### **2. The "Hero Chart": Cumulative Growth**
The `cumulative_customers` column is your most powerful asset for an investor presentation. 
* **Milestone 1:** You crossed **10,000** total users in **May 2017**.
* **Milestone 2:** You crossed **50,000** total users in **January 2018**.
* **Milestone 3:** You finished the dataset at **93,350** users.
* **Why it's the "Hero":** Even if monthly growth looks "flat" in 2018, the cumulative line is a beautiful diagonal climb. It proves the platform is **retaining its market share** even if the *rate* of new user discovery has leveled off.

### **3. Strategic "Senior Analyst" Insight: The Growth Trap**
Compare this data to your earlier **Retention Query** (where we found that 97% of people only buy once):
* **The Reality:** Your cumulative growth of 93k users is impressive, but because retention is so low, this 93k is a **leaky bucket**. 
* **The Risk:** If marketing stopped today, your revenue would plummet because you don't have a "base" of users. You are essentially "renting" these 93k users, not "owning" them.

---

### **⚠️ Technical Note: Cleaning your SQL Output**
I noticed your output has a "bug" where one month (like Oct 2016) shows multiple names (Apr 2017, Jun 2018, etc.) because you used `MIN(order_month_name)` and grouped by it. 

**To get a clean line for Power BI, use this simplified Grouping:**
```sql
SELECT
    acquisition_month,
    -- Just take the first name encountered for the month
    MAX(acquisition_month_name) AS month_label, 
    COUNT(customer_unique_id) AS new_customers_acquired,
    SUM(COUNT(customer_unique_id)) OVER (ORDER BY acquisition_month) AS cumulative_customers
FROM first_orders
GROUP BY acquisition_month
ORDER BY acquisition_month;
```

---

### **Power BI Visualization Guide: The "Investor Slide"**

1.  **The Hero Visual (Area Chart):**
    * **X-Axis:** `acquisition_month`
    * **Y-Axis:** `cumulative_customers`
    * *Style:* Use a "Smooth Line" with a gradient fill under it. It should look like a mountain climbing to the right.
2.  **The Velocity Visual (Bar Chart):**
    * **X-Axis:** `acquisition_month`
    * **Y-Axis:** `new_customers_acquired`
    * *Insight:* This shows the "fuel" (new users) being added to the engine every month.
3.  **The Milestone Card:**
    * Create a Big Number card: **"93.4K Total Platform Reach"**.

**Next Step Recommendation:** Now that we know how we *get* customers, we should look at **Query 6: Payment Behavior**. Are these 93k users paying in full, or are they relying on installments? This will tell us about the "Credit Risk" of your customer base.



**Query 6: Payment Behavior**

This geographic distribution table provides a clear map of where AuraTech’s (Olist) business lives and where it struggles. As a Senior Analyst, I see a business that is highly concentrated in the Southeast of Brazil, which creates a specific set of logistical advantages and strategic vulnerabilities.

### **Direct Answers**
* **State with the most customers:** **São Paulo (SP)** with **39,149** unique customers.
* **Percentage of total customers (SP):** **41.92%**. 

---

### **Strategic Analysis: Geographic Concentration**

#### **1. The "São Paulo Powerhouse"**
São Paulo is more than just the top state; it is the engine of the entire platform. 
* **The Scale:** With nearly **42% of the customer base**, SP alone has more customers than the next **10 states combined**.
* **The Efficiency:** It has the fastest delivery (**8.7 days**) and a high satisfaction score (**4.18**).
* **The Risk:** This is a "Single Point of Failure." If a logistics strike or a local economic downturn hits São Paulo, nearly half of AuraTech's revenue disappears instantly.

#### **2. The "Logistics-Sentiment" Correlation**
There is a clear trend: as you move further from the Southeast (SP/MG/PR), delivery times increase and satisfaction scores tend to dip.
* **The Red Flag (RJ):** Rio de Janeiro is the second-largest market (12.76%), yet it has one of the **lowest satisfaction scores (3.87)** and a delivery time nearly double that of SP (**15.1 days**). 
* **The Frontier (AP/RR):** Remote states like Amapá (AP) and Roraima (RR) take **28 days** to deliver. While they represent a tiny fraction of customers, the logistical burden to serve them is massive.

#### **3. The "Value Gap" Opportunity**
Interestingly, customers in remote states spend **significantly more per order** than those in São Paulo.
* **SP AOV:** $109.10
* **PB (Paraíba) AOV:** **$192.13** (The highest in the dataset)
* **AL (Alagoas) AOV:** $184.67
* **The Insight:** Customers in the North and Northeast are likely using AuraTech to buy high-ticket items that are not available in their local brick-and-mortar stores. Even though shipping is expensive and slow, they are willing to pay a premium.

---

### **Executive Recommendations for your Portfolio**

| Observation | Risk/Opportunity | Strategic Action |
| :--- | :--- | :--- |
| **SP Dominance** | **Risk:** Over-reliance on one region. | Diversify marketing spend into **MG (Minas Gerais)** and **PR (Paraná)**, which already show healthy delivery speeds (~12 days). |
| **RJ Dissatisfaction** | **Risk:** High churn in a major market. | Investigate why RJ is underperforming. Is it security-related delays or specific carrier issues in Rio? |
| **Remote High AOV** | **Opportunity:** Profitable "Whales." | Create "Express Shipping" tiers for high-value regions like **PB** and **AL**. These customers spend almost 2x the average; they might pay more for faster delivery. |

### **Power BI Visualization Step**
When you build your dashboard:
1.  **Filled Map:** Use `customer_state` as the location and `unique_customers` as the color saturation.
2.  **Scatter Chart:** Plot `avg_delivery_days` (X-Axis) against `avg_review_score` (Y-Axis). You will see a downward sloping line—this is your visual proof that **speed equals happiness**.
3.  **Tooltip:** When hovering over a state on the map, show the **AOV** vs **Avg Freight**. This will highlight the "High Spend, High Cost" nature of the Northern states.

**Would you like to analyze the "Top 10 Cities" next?** Usually, 80% of those SP customers are concentrated in just 2 or 3 specific metro areas.



**7. RFM SEGMENTATION**

