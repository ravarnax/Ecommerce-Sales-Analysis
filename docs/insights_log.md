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
> Author: [Your Name] | Date: [Today's Date]