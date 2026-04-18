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



## Section 9 — Product Performance Analysis

Analysis covers delivered orders only. Categories with fewer than 50 orders excluded from freight and satisfaction rankings (statistical significance threshold). Portuguese category names shown with English translations.

### 9.1 Revenue by Category — Top 10
Rank	Category (EN)	Category (PT)	GMV (R$)	% of GMV	Freight %	Avg Review
1	Health & Beauty	beleza_saude	R$ 1,233,132	9.33%	14.5%	4.19
2	Watches & Gifts	relogios_presentes	R$ 1,165,899	8.82%	8.4%	4.07
3	Bed, Bath & Table	cama_mesa_banho	R$ 1,023,435	7.74%	19.7%	3.92
4	Sports & Leisure	esporte_lazer	R$ 954,674	7.22%	17.1%	4.17
5	Computer Accessories	informatica_acessorios	R$ 888,614	6.72%	16.2%	3.99
6	Furniture & Decor	moveis_decoracao	R$ 711,928	5.39%	23.7%	3.95
7	Household Utilities	utilidades_domesticas	R$ 615,629	4.66%	23.2%	4.11
8	Cool Stuff	cool_stuff	R$ 610,204	4.62%	13.4%	4.20
9	Automotive	automotivo	R$ 578,849	4.38%	15.6%	4.11
10	Toys	brinquedos	R$ 471,097	3.56%	16.1%	4.21
Key finding — revenue concentration:
The top 5 categories generate ~39.8% of total platform GMV. Health & Beauty alone accounts for nearly 1 in every 10 reals spent on Olist. This concentration is both a strength (predictable revenue) and a risk (one bad season in Health & Beauty materially hurts the whole platform).

### 9.2 Category Performance Quadrant
Each category classified against platform averages for order volume and average order value.

Star categories — high volume AND high value
(Invest, protect, grow)

Category (EN)	Category (PT)	Why it is a Star
Watches & Gifts	relogios_presentes	High AOV + strong order volume + low freight
Cool Stuff	cool_stuff	Above average on both dimensions
These are Olist's crown jewels. Seller recruitment, promotional spend, and category investment should prioritize these two above all others.

### Hidden gem categories — low volume but high value
(Underinvested — high growth potential)

Top 5 most strategically interesting:

Category (EN)	Category (PT)	Opportunity
Office Furniture	moveis_escritorio	High AOV, needs delivery improvement
PCs	pcs	High ticket, limited seller supply
Musical Instruments	instrumentos_musicais	Niche but premium buyer profile
Small Appliances	eletroportateis	High repeat purchase potential
Home Appliances 2	eletrodomesticos_2	High AOV, underpenetrated market
Full hidden gem list contains 18 categories. The 5 above are prioritized based on AOV size and natural repeat purchase potential. These categories need more sellers, not more marketing — supply is the constraint.

Workhorse categories — high volume but low value
(Optimize economics or accept as loss leaders)

Key workhorses: Health & Beauty, Bed Bath & Table, Sports & Leisure, Computer Accessories, Furniture & Decor, Household Utilities, Automotive, Toys, Electronics (15 total).

Workhorses drive traffic and order volume but generate lower revenue per transaction. They are valuable for customer acquisition but should not be the focus of premium seller recruitment. The goal here is operational efficiency, not growth investment.

Underperformers — low volume AND low value
37 categories fall into this quadrant.

###9.3 Customer Satisfaction by Category
Minimum 100 orders required for inclusion.

Best reviewed categories:

Rank	Category (EN)	Category (PT)	Avg Score	Positive %
1	General Interest Books	livros_interesse_geral	4.51	89.5%
2	Technical Books	livros_tecnicos	4.39	85.9%
3	Food & Drink	alimentos_bebidas	4.36	82.5%
Worst reviewed categories:

Rank	Category (EN)	Category (PT)	Avg Score	Avg Delivery Days	Freight %
1	Office Furniture	moveis_escritorio	3.51	20.8 days	25.0%
2	Fixed Telephony	telefonia_fixa	3.76	12.6 days	8.1%
3	Men's Fashion	fashion_roupa_masculina	3.76	12.8 days	19.7%
The causal chain — confirmed:
Delivery time directly drives review scores. Categories with the worst satisfaction scores average 20.8 days to deliver vs. 12–13 days for highly rated categories. This is a 60% longer delivery time producing measurably worse customer experiences.

### 9.4 Freight Risk Analysis
Categories where logistics cost exceeds 30% of item price are classified as Freight Risk categories.

Category (EN)	Category (PT)	Freight %	Risk Level
Home Comfort 2	casa_conforto_2	54.0%	Critical
Flowers	flores	44.0%	Critical
Mattresses & Upholstery	moveis_colchao_e_estofado	36.6%	High
Christmas Items	artigos_de_natal	36.5%	High
Diapers & Hygiene	fraldas_higiene	36.3%	High
CDs, DVDs & Music	cds_dvds_musicais	30.8%	Moderate
Safety & Signage	sinalizacao_e_seguranca	30.4%	Moderate

### 9.5 Category Growth Trends (Jan-Aug 2017 vs Jan-Aug 2018)
Growing categories:

Watches & Gifts: grew from R$ 201,138 to R$ 687,577 — 241.8% growth

Health & Beauty: grew from R$ 243,522 to R$ 755,725 — 210.3% growth

Household Utilities: grew from R$ 127,535 to R$ 391,823 — 207.2% growth

Declining categories:

Toys: GMV dropped in the recorded Jan-Aug period from 2017 to 2018 by ~43.8% due to missing Q4 seasonal spikes in the 2018 data.

### 9.6 Top Category by State
State	Top Category (EN)	Top Category (PT)	Orders
SP	Bed, Bath & Table	cama_mesa_banho	4,347
RJ	Bed, Bath & Table	cama_mesa_banho	1,357
MG	Bed, Bath & Table	cama_mesa_banho	1,120
RS	Bed, Bath & Table	cama_mesa_banho	537
PR	Sports & Leisure	esporte_lazer	420
Key finding:
"Bed, Bath & Table" dominates high-volume states. Southern states (PR, SC) prefer "Sports & Leisure". "Health & Beauty" is the absolute #1 in the Northeast (BA, PE) and Midwest (DF, GO).





## Section 10 — Seller Performance Analysis

### Seller Tier Distribution
Tier	Sellers	% of Sellers	GMV (R$)	% of Revenue	Avg Review	Late %
Platinum	225	28.1%	R$ 2,498,180.04	23.1%	4.42	3.7%
Gold	271	33.9%	R$ 4,352,020.03	40.3%	4.22	7.0%
Silver	271	33.9%	R$ 3,431,934.59	31.8%	3.90	10.0%
Bronze	33	4.1%	R$ 519,182.85	4.8%	3.21	17.5%

### Geographic Concentration
Top seller state: SP (São Paulo) (59.56% of sellers)

Seller vs customer state match: Massive Mismatch. While nearly 60% of sellers are located in São Paulo, only 42% of customers are based there. This geographic imbalance forces roughly 18% of the platform's total volume to be shipped out-of-state, increasing freight costs, delaying deliveries, and ultimately hurting customer satisfaction in the Northern and Northeastern regions.

### Delivery Performance by Distance
Delivery Type	Avg Days	Late %	Avg Freight %	Avg Review
Same state	7.9	5.9%	13.0%	4.20
Different state	15.0	8.8%	18.3%	4.02
Seller Concentration (Pareto)

Top 1% of sellers generate: 25.9% of revenue

Top 20% of sellers generate: 15.2% of revenue

### At-Risk Sellers
Total sellers on danger list: 32 sellers (Consistent underperformers with 30+ orders)

GMV at risk from Bronze sellers: R$ 519,182.85 (4.8% of total)

Power BI Notes — Seller Page
Visual	Type	Fields
Seller Tier Distribution	Donut Chart	seller_tier (Legend), seller_id (Count)
Supply vs. Demand Match	2x Filled Maps	Map 1: seller_state, Map 2: customer_state
The Logistics Penalty	Clustered Column	X-Axis: delivery_type, Y-Axis: avg_delivery_days & avg_freight_cost
Seller Pareto Curve	Line & Stacked Column	X-Axis: seller_id, Column: total_gmv, Line: cumulative_gmv_pct
Danger List / At-Risk Sellers	Table	seller_id, avg_review_score, late_delivery_pct (Conditional format Red for < 3.5 score)


💡 Summary
The Logistics Friction Hypothesis is Proven:
The data clearly shows that "Geography is Fate" on this platform. When a seller and customer are in the same state, the system works beautifully (7.9 days delivery, 4.20 satisfaction). When they are in different states—which accounts for a massive 64% of all orders—delivery times nearly double (15.0 days), freight eats up 18.3% of the product's price, and satisfaction drops.

The Bronze Tier Liability:
Though Bronze sellers make up only 4.1% of the seller base, they are processing over half a million Reais in GMV. With an average review score of 3.21 and a 17.5% late delivery rate, these 33 sellers act as a "leaky bucket," permanently churning customers who have a terrible first experience. Transitioning volume away from Bronze sellers to Platinum/Gold sellers is the fastest way to improve platform-wide retention without spending a single dollar on marketing.







## Section 11 — Delivery & Logistics Performance Analysis

> Analysis based on delivered orders with non-null delivery timestamps.
> On-time defined as: delivered on or before estimated delivery date.
> Late defined as: delivered after estimated delivery date.

---

### 11.1 Platform-Wide Delivery Performance

| Metric                      | Value      |
|-----------------------------|------------|
| Total delivered orders      | 96,470     |
| Avg delivery time           | 12.5 days  |
| Median delivery time        | 10.2 days  |
| On-time delivery rate       | 92.1%      |
| Late delivery rate          | 7.9%       |
| Early delivery rate         | 92.0%      |
| Avg delay (late orders)     | 9.4 days   |
| Avg freight cost            | R$ 19.95   |
| Freight as % of item price  | 16.6%      |

**Key finding:**
> The on-time delivery rate is a healthy 92.1%, successfully clearing the standard 90% e-commerce benchmark. However, this success relies heavily on highly conservative delivery estimates, leading to a massive 92.0% early delivery rate. The primary vulnerability is the severity of failures: when an order is late, it misses the mark by an average of 9.4 days. Furthermore, an average freight cost representing 16.6% of the item price constitutes a significant burden on overall unit economics.

---

### 11.2 Delivery Performance Trend (2017–2018)

**Pattern observed:**
> Delivery performance degrades severely under volume spikes. November 2017 (Black Friday) saw a 63% jump in order volume, causing late deliveries to more than double (from 5.1% to 13.8%) and average delivery time to rise from 11.7 to 15.0 days. This negative trajectory snowballed into a major crisis in March 2018, where 1 in 5 orders (20.5%) were delivered late, driving the platform's average review score to a historical low of 3.75. The logistics infrastructure breaks under sudden scale.

---

### 11.3 Delivery Performance by State

**Slowest 5 customer states:**

| State | Avg Delivery Days | Late % | Avg Review | Freight % |
|-------|-------------------|--------|------------|-----------|
| AM    | 26.4              | 4.3%   | 4.11       | 24.5%     |
| AL    | 24.5              | 24.1%  | 3.82       | 19.4%     |
| PA    | 23.8              | 12.4%  | 3.84       | 21.5%     |
| MA    | 21.6              | 20.4%  | 3.76       | 26.3%     |
| SE    | 21.5              | 16.3%  | 3.90       | 24.2%     |

**Fastest 5 customer states:**

| State | Avg Delivery Days | Late % | Avg Review | Freight % |
|-------|-------------------|--------|------------|-----------|
| SP    | 8.7               | 5.8%   | 4.18       | 13.9%     |
| PR    | 11.9              | 4.8%   | 4.15       | 17.4%     |
| MG    | 12.0              | 5.4%   | 4.12       | 17.2%     |
| DF    | 13.0              | 7.4%   | 4.06       | 16.7%     |
| SC    | 15.0              | 9.6%   | 4.05       | 17.4%     |

**Key finding — the geographic divide:**
> There is a severe structural divide between the industrial core and the periphery. Customers in the North and Northeast wait nearly three times longer (21–26 days) and pay significantly higher freight penalties (19–26% of item price) compared to the Southeast (SP, PR, MG). Unless the wait is highly predictable and appropriately communicated (as seen in Amazonas, which has a low 4.3% late rate and high 4.11 score), slow speeds combined with high unpredictability (like Alagoas' 24.1% late rate) rapidly destroy regional review scores.

---

### 11.4 Slowest Delivery Routes (Top 10)

| From State | To State | Orders | Avg Days | Late % | Avg Review |
|------------|----------|--------|----------|--------|------------|
| MG         | PA       | 84     | 27.8     | 17.4%  | 4.05       |
| SP         | AM       | 99     | 26.2     | 4.6%   | 4.12       |
| RJ         | CE       | 54     | 26.0     | 25.0%  | 3.55       |
| PR         | PA       | 54     | 25.4     | 12.1%  | 4.07       |
| SP         | AL       | 256    | 24.6     | 25.3%  | 3.69       |
| PR         | CE       | 64     | 24.0     | 12.5%  | 3.52       |
| SP         | PA       | 683    | 23.3     | 12.9%  | 3.79       |
| SP         | MA       | 493    | 22.2     | 22.2%  | 3.67       |
| PR         | BA       | 144    | 21.5     | 15.3%  | 3.77       |
| SP         | SE       | 208    | 21.3     | 18.1%  | 3.80       |

**Key finding — the long-haul problem:**
> Cross-country routes entirely dominate the failure list, with 6 out of the 10 slowest corridors originating from the main logistics hub in São Paulo (SP). Forcing inventory to travel from SP to the North and Northeast creates a massive bottleneck that breaks delivery SLAs. This definitively highlights the immediate seller recruitment targets: the platform must acquire sellers natively in PA, CE, AL, MA, and BA to bypass these catastrophic long-haul routes.

---

### 11.5 Delivery Delay Impact on Review Score

| Delay Bucket   | Orders | % of Orders | Avg Review | Negative % | Positive % |
|----------------|--------|-------------|------------|------------|------------|
| 5+ days early  | 79,481 | 82.9%       | 4.22       | 11.3%      | 80.9%      |
| 1-4 days early | 7,296  | 7.6%        | 4.08       | 12.8%      | 75.7%      |
| On time        | 175    | 0.2%        | 4.17       | 9.7%       | 76.5%      |
| 1-3 days late  | 3,863  | 4.0%        | 3.84       | 18.1%      | 68.9%      |
| 4-7 days late  | 1,787  | 1.9%        | 2.27       | 62.5%      | 26.9%      |
| 8-14 days late | 1,722  | 1.8%        | 1.74       | 78.5%      | 12.5%      |
| 15+ days late  | 1,500  | 1.6%        | 1.71       | 78.8%      | 12.6%      |

**The causal proof — quantified:**
> Orders delivered on-time (or 5+ days early) average a 4.17 to 4.22 review score.
> Orders delivered 15+ days late average a 1.71 review score.
> That is a 2.51-point penalty for late delivery.
>
> This is not correlation. This is causation. Delivery delay directly destroys customer satisfaction. Every day of delay past the 3-day mark pushes the order off a "satisfaction cliff," costing measurable reputation damage.

**Business implication:**
> A 10% improvement in on-time delivery rate would shift over 9,600 orders from the late buckets to the on-time bucket, preventing thousands of negative reviews per month. At scale, this directly impacts the platform's repeat purchase rate and customer lifetime value.

---

### 11.6 Delivery Performance by Product Category

**Slowest 5 categories:**

| Category (EN)        | Avg Days | Late % | Freight % | Avg Review | Avg Weight |
|----------------------|----------|--------|-----------|------------|------------|
| Office Furniture     | 20.8     | 8.9%   | 25.0%     | 3.51       | N/A        |
| Garden Tools         | 13.7     | 8.0%   | 20.5%     | 4.08       | N/A        |
| Computer Accessories | 13.2     | 7.8%   | 16.2%     | 3.99       | N/A        |
| Furniture & Decor    | 12.9     | 8.4%   | 23.7%     | 3.95       | N/A        |
| Telephony            | 12.9     | 8.3%   | 22.4%     | 3.99       | N/A        |

**Key finding — the bulky product problem:**
> The worst-reviewed categories identified in the Product Analysis (specifically Office Furniture and Furniture & Decor) sit firmly at the top of the slowest delivery list. Office Furniture is an extreme outlier, requiring 20.8 days for delivery while eating up 25.0% of the item price in freight. This confirms the causal chain: bulky, non-standard items strain the logistics network, inflating transit times and delivery costs, which in turn plummets customer satisfaction scores down to 3.51.

---

### 11.7 Power BI Dashboard — Logistics Page Build Notes

| Visual                    | Type         | Fields                                      |
|---------------------------|--------------|---------------------------------------------|
| On-time % KPI             | Card         | on_time_pct                                 |
| Avg delivery days KPI     | Card         | avg_delivery_days                           |
| Late delivery % KPI       | Card         | late_pct                                    |
| Delivery trend            | Line chart   | order_month, avg_delivery_days, late_pct    |
| State performance map     | Filled map   | customer_state, avg_delivery_days           |
| Delay impact on reviews   | Bar chart    | delay_bucket, avg_review_score              |
| Slowest routes heatmap    | Matrix       | seller_state (rows), customer_state (cols)  |
| Category delivery table   | Table        | product_category, all delivery metrics      |

**Conditional formatting:**
- On-time % card: green if >90%, amber 80-90%, red <80%
- Avg delivery days card: green if <12, amber 12-15, red >15
- State map: color gradient from green (fast) to red (slow)
- Heatmap: color scale from green (<10 days) to red (>20 days)

---

### 11.8 Strategic Takeaways

**Takeaway 1 — The on-time crisis:**
> The 92.1% overall on-time rate indicates the baseline system functions reasonably well, but the vulnerability is in the severe tail-end failures. When an order breaks the delivery SLA, it does so by a massive 9.4 days. Customers expect their packages when promised; an average 10-day delay on late items is a broken promise at scale.

**Takeaway 2 — Geography is destiny:**
> The 17.7-day delivery gap between the fastest (SP) and slowest (AM) states proves that where a seller is located determines customer satisfaction more than what they sell. Recruiting sellers in underserved states is not just a catalog growth strategy — it is a mandatory customer experience fix to eradicate the long-haul freight penalty.

**Takeaway 3 — Late delivery = lost customers:**
> Every order delivered 15+ days late suffers a staggering 2.51-point review score penalty. Given the 97% one-time buyer rate identified in the Customer Analysis, this means late delivery is directly and permanently causing customer churn. Fix delivery consistency, fix retention.

**Takeaway 4 — The freight-delay double penalty:**
> Slow routes also have the highest freight burdens (routinely exceeding 20% of the item price). Customers in remote states pay MORE for freight AND wait LONGER for their order. This is the worst possible customer experience — expensive and slow. It must be resolved through localized cross-docking or localized seller acquisition, or those regional markets will remain locked off from profitable growth.