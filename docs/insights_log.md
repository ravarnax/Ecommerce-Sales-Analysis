# Insights Log — Revenue Analysis
# Olist E-Commerce | Brazilian Market | 2016–2018
# Analyst: [Your Name] | Tool: PostgreSQL + Power BI
# Dataset: ~100k delivered orders | Source: Kaggle (Olist Public Dataset)

---

## Data Quality & Scope Caveat

| Year | Status       | Note                                              |
|------|-------------|---------------------------------------------------|
| 2016 | Partial      | Only Sep–Dec. Platform pre-launch. Exclude from YoY comparisons. |
| 2017 | Full year    | Primary baseline year for analysis.               |
| 2018 | Partial      | Only Jan–Aug. Do not compare annual totals to 2017 directly. |

> All revenue figures are in Brazilian Real (BRL, R$).
> Revenue scope: Delivered orders only (order_status = 'delivered').
> GMV = item_price only. Total Revenue = item_price + freight_value.

---

## Section 1 — Monthly Revenue Trend

### What Happened
| Metric                        | Value                                              |
|-------------------------------|----------------------------------------------------|
| Highest revenue month         | November 2017 — GMV: R$ 987,648 / Revenue: R$ 1,153,229 |
| Lowest operational month      | January 2017 — GMV: R$ 111,798 (first full month) |
| Anomaly month                 | December 2016 — GMV: R$ 10.90 (pre-launch, exclude) |
| Overall growth (Jan→Jul 2018) | ~706% revenue growth across 19 operational months  |

### Why It Matters
706% growth in under two years is platform-level scale.
However, raw revenue growth alone is misleading — the driver
matters. In Olist's case, growth is being powered almost entirely
by new customer acquisition, not repeat purchasing (see Section 5).

### Business Recommendation
> Flag for leadership: sustainable marketplace growth requires
> a balance of acquisition AND retention. At current retention
> rates (~0% repeat buyers), growth will stall the moment
> acquisition slows down — which the 2018 data suggests
> is already beginning.

---

## Section 2 — Month over Month Growth Rate

### What Happened

**Operationally significant growth months:**
| Month         | MoM Growth | Driver                                |
|---------------|------------|---------------------------------------|
| November 2017 | +52.4%     | Black Friday — single biggest spike   |
| March 2017    | High       | Post-Q1 ramp-up                       |
| Q2 2018       | Moderate   | Strongest quarter overall             |

**Months with negative growth:**
| Month         | MoM Growth | Likely Cause                          |
|---------------|------------|---------------------------------------|
| April 2017    | -5.2%      | Post-Q1 normalization                 |
| June 2017     | -13.7%     | Mid-year seasonal dip                 |
| December 2017 | -26.5%     | Post-holiday hangover — classic pattern |
| February 2018 | -10.6%     | Carnival season (Brazil), fewer workdays |
| June 2018     | -12.5%     | Mid-year seasonal dip (repeating pattern) |
| August 2018   | -3.3%      | Growth plateau beginning              |

### Pattern Identified — "The Brazilian Seasonality Curve"
Two consistent dip windows emerge: June (mid-year) and
December→February (post-holiday + Carnival). These are
**predictable and plannable** — Olist's marketing team should
use these windows for retention campaigns, not just acquisition.

### Business Recommendation
> Run targeted re-engagement campaigns in May (before the June
> dip) and November (to extend the Black Friday spike into
> December rather than suffering a -26% hangover).

---

## Section 3 — Average Order Value vs. Median Order Value

### What Happened
| Metric                  | Value         |
|-------------------------|---------------|
| Average order value     | ~R$ 120.00    |
| Median order value      | ~R$ 85–90.00  |
| Gap (avg vs median)     | ~35% higher   |
| Maximum single order    | R$ 13,440     |

### Why It Matters — The "Whale Skew" Problem
The average is consistently 35% above the median. This means
a small number of high-ticket buyers ("whales") are pulling
the average up, masking the true behavior of the typical Olist
customer who spends around R$ 85–90 per order.

**Practical consequence:** If your marketing team optimizes
for average AOV (R$ 120), they are designing campaigns for
a customer who barely exists. The real typical customer
spends R$ 85.

### Business Recommendation
> Use median order value as the primary AOV KPI in all
> operational reporting. Reserve average AOV for executive
> summary only, always shown alongside median.
> Consider segmenting whale buyers (top 5% by spend) as a
> separate cohort with dedicated retention strategies —
> they are disproportionately valuable.

---

## Section 4 — Quarterly & Annual Summary

### Quarterly Performance
| Quarter | GMV (R$)      | Orders | Notes                     |
|---------|--------------|--------|---------------------------|
| Q1 2017 | 705,221      | ~5,200 | First full quarter        |
| Q2 2017 | Growing      | —      | Steady ramp               |
| Q3 2017 | Growing      | —      | Pre-Black Friday buildup  |
| Q4 2017 | Peak (Nov)   | —      | Black Friday dominates    |
| Q1 2018 | Strong       | —      | Post-holiday recovery     |
| Q2 2018 | 2,806,671    | 19,643 | Strongest quarter overall |
| Q3 2018 | Plateau      | —      | Growth rate flattening    |

### Annual Orders vs. Unique Customers Ratio
| Year | Orders | Unique Customers | Ratio  |
|------|--------|-----------------|--------|
| 2017 | 43,426 | 42,134          | 1.03:1 |
| 2018 | 52,777 | 51,606          | 1.02:1 |

A ratio of ~1:1 means nearly every order comes from a
different person. Repeat purchasing is effectively zero.

---

## Section 5 — Seasonality & Behavioral Patterns

### Day of Week Pattern — "The Workday Wave"
| Day       | Orders | AOV (R$) | Insight                        |
|-----------|--------|----------|--------------------------------|
| Monday    | 15,701 | ~R$ 119  | Highest volume day             |
| Tuesday   | 15,502 | ~R$ 118  | Second highest volume          |
| Saturday  | Lowest | R$ 123   | Lowest volume, highest AOV     |

**Insight:** Customers browse and decide on weekends,
then purchase on Monday mornings. Weekend buyers are
fewer but spend more — likely higher-intent purchases.

### Hourly Pattern — "The Afternoon Peak"
| Period           | Hours     | Behavior                              |
|------------------|-----------|---------------------------------------|
| Morning ramp     | 7–10 AM   | Orders begin climbing                 |
| Peak window      | 10 AM–4 PM| Sustained high volume (work hours)    |
| Top hour         | 4:00 PM   | 6,475 orders — end of workday spike   |
| Secondary peak   | 8:00 PM   | After-dinner browsing                 |
| Dead zone        | 12–5 AM   | Minimal activity                      |

### Business Recommendation
> Schedule all marketing emails, push notifications, and
> paid ad spend to land between 9–10 AM (catches the
> morning ramp) or 3–4 PM (catches the end-of-day peak).
> Weekend campaigns should focus on higher-ticket categories
> to match the higher-AOV weekend buyer profile.

---

## Section 6 — Strategic Risk Flags

### Risk 1 — The Profitability Leak (Freight Ratio Rising)
| Period  | Freight as % of GMV |
|---------|---------------------|
| Q1 2017 | 15.3%               |
| Q3 2018 | 18.0%               |

Revenue is growing, but logistics costs are growing faster.
An 18% freight-to-GMV ratio erodes net margins significantly
at scale. This is a structural problem, not a temporary one.

> **Recommendation:** Investigate which seller states and
> product categories have the highest freight ratios.
> Negotiate carrier rates for high-volume corridors.
> Consider incentivizing sellers closer to customer clusters
> to reduce last-mile distance.

### Risk 2 — The Retention Crisis
Olist's orders-to-unique-customers ratio is ~1:1 across
both 2017 and 2018. The platform has virtually no repeat
buyers. Every single percentage point of revenue growth
requires acquiring a net-new customer.

> **Recommendation:** Introduce a loyalty or rewards program.
> Analyze which product categories have the highest natural
> repeat purchase rate (consumables, household goods) and
> prioritize those categories in acquisition campaigns —
> acquiring a customer who will naturally reorder is worth
> significantly more than acquiring a one-time buyer.

### Risk 3 — Growth Plateau Beginning in 2018
After explosive 2017 growth, MoM growth in 2018 oscillates
between -12% and +15%, with multiple near-zero months.
The hyper-growth phase driven by market novelty is ending.
Future growth must come from retention, higher AOV, or
new geographies — not just acquisition.

> **Recommendation:** Shift KPI focus from "new orders"
> to "revenue per customer" and "repeat purchase rate."
> The metrics that got Olist here will not get it to the
> next phase.

---

## Section 7 — Power BI Dashboard Assembly Notes

### Page: Revenue Overview
| Visual                  | Type              | Fields                                      |
|-------------------------|-------------------|---------------------------------------------|
| Total GMV               | KPI Card          | SUM(item_price) — delivered orders only     |
| Total Revenue           | KPI Card          | SUM(total_item_revenue)                     |
| Total Orders            | KPI Card          | COUNT(DISTINCT order_id)                    |
| Avg Order Value         | KPI Card          | AVERAGE(item_price) per order               |
| Monthly GMV Trend       | Line Chart        | order_month vs SUM(item_price) — annotate Nov 2017 |
| MoM Growth Rate         | Bar Chart         | Conditional format: red = negative, green = positive |
| Quarterly Revenue       | Clustered Column  | order_quarter_label + order_year vs GMV     |
| Freight % of GMV        | Line Chart        | Quarterly — overlaid on revenue chart       |
| Avg vs Median AOV       | Dual-axis Line    | Two measures over order_month               |
| Day x Hour Heatmap      | Matrix Visual     | Rows: day_of_week / Cols: hour / Values: order count |

### Filters to add on this page
- order_year (slicer)
- order_status = 'delivered' (hidden filter, always on)
- product_category (optional drill-through)

---

## Analyst Sign-off

> All findings derived from PostgreSQL queries on the Olist
> public dataset. Partial year data (2016, 2018) excluded
> from year-over-year comparisons. Revenue figures in BRL.
> Analysis conducted as part of portfolio project.




## Section 8 — Customer Behavior Analysis

> Analysis based on 93,350 unique customers across delivered orders.
> RFM reference date: 2018-08-31 (dataset end date).
> All revenue figures in Brazilian Real (BRL, R$).

---

### 8.1 Purchase Frequency Distribution

| Orders Placed | Customers | % of Base | Avg LTV (R$) |
|---------------|-----------|-----------|--------------|
| 1 order       | 90,557    | 97.00%    | ~R$ 85       |
| 2 orders      | 2,746     | 2.95%     | ~R$ 170      |
| 3 orders      | 193       | 0.21%     | ~R$ 255      |
| 4+ orders     | 47        | 0.05%     | ~R$ 354+     |

**Key finding:** 97% of Olist's customer base has never returned
after their first purchase. Only 47 customers out of 93,350 can
be classified as Champion-level repeat buyers. This is the most
critical risk metric in this entire analysis.

**Business recommendation:**
> Even moving the needle from 3% to 6% repeat purchase rate
> would double the revenue contribution of returning customers
> without spending a single additional Real on acquisition.
> A post-purchase email sequence, loyalty points system, or
> even a simple "you might also like" recommendation engine
> would likely produce measurable improvement given how low
> the baseline currently is.

---

### 8.2 Customer Lifetime Value (LTV) Segmentation

Customers divided into quartiles by total spend across all orders.

| Segment              | Customers | Avg LTV (R$) | % of Total Revenue |
|----------------------|-----------|--------------|--------------------|
| Platinum — top 25%   | ~23,338   | R$ 354.23    | 62.5%              |
| Gold — upper mid 25% | ~23,338   | —            | —                  |
| Silver — lower mid 25%| ~23,338  | —            | —                  |
| Bronze — bottom 25%  | ~23,338   | R$ 29.10     | —                  |

**Key finding:** The top 25% of customers generate 62.5% of all
revenue. The gap between Platinum avg LTV (R$ 354) and Bronze
avg LTV (R$ 29) is a 12x difference. These are not the same
customer — they should never receive the same marketing message.

**Business recommendation:**
> Platinum customers must be identified and protected first.
> Build a suppression list of Bronze customers for paid
> acquisition lookalike audiences — you do not want to spend
> money acquiring more R$ 29 customers. Model your acquisition
> targeting on Platinum customer characteristics instead.

---

### 8.3 RFM Segmentation Results

**Methodology note:** RFM scores each customer on three dimensions
(Recency, Frequency, Monetary value) independently using NTILE(4)
quartile scoring. A customer can score high on Recency (bought
recently) even if they only bought once — which is why RFM
segment counts do not directly match the raw frequency
distribution above. Both analyses are valid and measure
different things.

| RFM Segment         | Customers | % of Customers | % of Revenue | Avg LTV (R$) |
|---------------------|-----------|----------------|--------------|--------------|
| Champions           | 23,254    | 24.9%          | 51.3%        | High         |
| Loyal Customers     | 23,666    | 25.3%          | 29.6%        | Medium-high  |
| Needs Attention     | 23,233    | 24.9%          | 8.3%         | Low-medium   |
| Potential Loyalists | 11,274    | 12.1%          | 3.9%         | Low-medium   |
| At Risk             | 5,949     | 6.4%           | 5.4%         | Medium       |
| Lost Customers      | 5,974     | 6.4%           | 1.3%         | Low          |

**Segment definitions:**
- Champions — bought recently, buy often, spend the most
- Loyal Customers — buy regularly, good spend, slightly less recent
- Needs Attention — average across all three dimensions, declining engagement
- Potential Loyalists — recent buyers with moderate frequency, worth nurturing
- At Risk — used to spend well but have not returned recently
- Lost Customers — low recency, low frequency, low spend — effectively churned

**Key finding — the Pareto effect amplified:**
The top two RFM segments (Champions + Loyal Customers) represent
50.2% of customers but generate 80.9% of all revenue. Half your
customer base is funding 80% of the business. Losing even a
fraction of this group would be catastrophic.

**Business recommendations by segment:**

| Segment             | Recommended Action                                          |
|---------------------|-------------------------------------------------------------|
| Champions           | Reward them. Early access, VIP perks, referral incentives. |
| Loyal Customers     | Upsell to higher categories. Protect with loyalty program. |
| Needs Attention     | Re-engage with personalized email. Limited-time offer.     |
| Potential Loyalists | Second purchase incentive. Free shipping on next order.    |
| At Risk             | Win-back campaign. Survey why they stopped.                |
| Lost Customers      | Exclude from paid ads. One final re-engagement attempt.    |

---

### 8.4 Geographic Customer Concentration

| Rank | State         | Unique Customers | % of Total |
|------|---------------|-----------------|------------|
| 1    | SP (São Paulo)| ~39,188         | 41.92%     |
| 2    | RJ (Rio)      | —               | —          |
| 3    | MG (Minas)    | —               | —          |
| Top 3 combined | —    | —               | 66.46%     |

**Key finding — the Southeast concentration:**
Two thirds of Olist's entire customer base lives in three
adjacent southeastern states. This makes current logistics
efficient for the majority but creates three structural risks:

1. A regional disruption (weather, strikes, infrastructure)
in the Southeast could simultaneously impact 66% of revenue
2. The remaining 34% of Brazil is significantly underserved —
this is an untapped growth opportunity, not just a gap
3. Seller concentration likely mirrors customer concentration,
which means long-distance deliveries to the North and
Northeast are both slower and more expensive — directly
explaining the logistics cost increase identified in the
Revenue Analysis section

**Business recommendation:**
> Prioritize seller recruitment in the North (AM, PA) and
> Northeast (BA, CE, PE) regions. A seller closer to an
> underserved customer cuts freight cost, cuts delivery time,
> and improves review scores simultaneously — three KPIs
> improved with one strategic move.

---

### 8.5 Power BI Dashboard — Customer Page Build Notes

| Visual                  | Type         | X / Axis field      | Y / Value field      | Legend / Color        |
|-------------------------|--------------|---------------------|----------------------|-----------------------|
| New vs returning trend  | Stacked bar  | order_month_name    | unique_customers     | customer_type         |
| Cumulative customers    | Area chart   | acquisition_month   | cumulative_customers | —                     |
| RFM segment breakdown   | Donut chart  | rfm_segment         | customer_count       | rfm_segment           |
| LTV by segment          | Bar chart    | customer_segment    | avg_ltv              | customer_segment      |
| Customer map by state   | Filled map   | customer_state      | unique_customers     | gradient scale        |
| Buyer segment table     | Table visual | buyer_segment       | all metrics          | conditional format    |

**Conditional formatting rules for buyer segment table:**
- avg_ltv column → color scale (white → green, low → high)
- avg_satisfaction_score → color scale (red → green)
- customer_count → data bars

**Slicer to add on this page:**
- order_year (to show how segments shift year over year)
- customer_state (to filter geographic view)

---

### 8.6 Key Strategic Takeaways

**Takeaway 1 — The Pareto Principle, amplified**
Champions (25% of customers) generate 51.3% of revenue.
The top half of the RFM base funds 80.9% of the company.
Every retention investment should start here, not with
broad acquisition campaigns.

**Takeaway 2 — The lost customer budget drain**
5,974 customers are officially Lost, contributing only 1.3%
of revenue. In a real business, these customers should be
immediately removed from all paid advertising audiences.
Continuing to target them wastes budget on people who
have already decided to leave.

**Takeaway 3 — The Southeast logistics dependency**
66.46% of customers concentrated in SP, RJ, and MG creates
both a logistics efficiency advantage today and a single
point of failure risk tomorrow. Geographic diversification
of both customers and sellers is the highest-leverage
long-term strategic move available to Olist.

**Takeaway 4 — The retention math**
97% one-time buyers. 3% return rate. The entire 706% revenue
growth identified in the Revenue Analysis section was funded
purely by new customer acquisition. This is not sustainable.
The cost of acquiring a new customer is always higher than
the cost of retaining an existing one. Olist is currently
paying the most expensive possible price for every unit of
revenue growth.



