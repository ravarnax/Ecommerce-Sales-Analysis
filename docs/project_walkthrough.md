# Olist E-Commerce Analytics — Project Walkthrough

**A case study in end-to-end business intelligence**

---

## Executive Summary

**Scenario:** Olist, a Brazilian marketplace platform, experienced 706% revenue growth from 2016–2018 but was seeing signs of growth plateau in 2018. Leadership needed to understand what was working, what was breaking, and where to invest next.

**My Role:** Conducted a comprehensive 6-domain analytics engagement covering revenue, customers, products, sellers, and logistics using PostgreSQL and Power BI.

**Key Finding:** Identified that delivery delays were the root cause of a 97% one-time buyer problem — orders delivered 15+ days late received review scores 2.5 points lower, directly causing customer churn.

**Business Impact:** Proposed 7 prioritized recommendations projected to generate R$2.6M incremental annual GMV and improve repeat purchase rate from 3% to 6%.

---

## Problem Statement

Olist's growth looked healthy on the surface (706% revenue increase), but several red flags emerged:

1. Month-over-month growth rates oscillating between -12% and +15% in 2018
2. Unknown customer retention dynamics
3. Geographic expansion showing uneven results
4. Rising freight costs (15.3% → 18.0% of GMV)
5. No seller quality monitoring framework

**The ask:** Conduct a full platform health assessment and identify the highest-leverage interventions.

---

## Approach & Methodology

### Phase 1: Data Foundation (Week 1)

**Objective:** Ensure data quality before any analysis

**Activities:**
- Loaded 8 tables (~1.3M total rows) into PostgreSQL
- Ran 7 validation queries: row counts, null audits, duplicate checks, referential integrity
- Identified and handled 610 null product categories (labeled as "uncategorized")
- Built `master_orders_view` — single analytical layer joining all 8 tables
- Created `delivered_orders` view filtered to completed transactions only

**Outcome:** Clean, trusted dataset ready for business analysis (96,470 delivered orders confirmed)

---

### Phase 2: Analysis Execution (Weeks 2-3)

Conducted 40+ SQL queries across 7 domains:

#### 1. Revenue Analysis
**Questions:** Is revenue growing? What's driving it? Where are the risks?

**Method:**
- Monthly GMV aggregation with MoM growth calculation using LAG() window function
- Quarterly trends to smooth seasonal noise
- AOV analysis (average vs median to detect skew)
- Day-of-week and hourly patterns for operational planning

**Finding:** November 2017 Black Friday peak generated R$987K GMV (highest month), but 2018 growth flattening to near-zero in multiple months signals end of hyper-growth phase.

---

#### 2. Customer Behavior Analysis
**Questions:** Are we building loyalty or just churning through customers?

**Method:**
- Purchase frequency distribution (1 order vs 2+ orders)
- RFM segmentation using NTILE(4) on recency, frequency, monetary dimensions
- Customer LTV quartile analysis
- New vs returning customer tracking month-over-month

**Finding:** 97% one-time buyer rate confirmed. RFM revealed Champions (25% of base) fund 51.3% of revenue — massive concentration risk.

**"Aha" moment:** Calculated that moving repeat rate from 3% to 6% would generate R$600K with zero acquisition cost.

---

#### 3. Product Performance Analysis
**Questions:** Which categories are winners vs losers? What's hurting margins?

**Method:**
- Category revenue ranking with freight ratio calculation
- 2x2 quadrant classification (high/low volume × high/low value)
- Satisfaction ranking with minimum 100 orders threshold
- Freight-to-price ratio analysis to identify unprofitable categories

**Finding:** 7 categories exceed 30% freight ratio — structurally unprofitable. `casa_conforto_2` at 54% freight ratio is actively destroying value at scale.

---

#### 4. Seller Performance Analysis
**Questions:** Who are our best sellers? Who's hurting the platform?

**Method:**
- Seller tier classification (Platinum/Gold/Silver/Bronze) based on review score, late%, delivery days
- Pareto concentration analysis using ROW_NUMBER() and cumulative sums
- Geographic distribution vs customer distribution comparison
- Same-state vs cross-state delivery performance proxy

**Finding:** Top 20% of sellers generate 80%+ revenue. Bronze sellers (4.8% of GMV) drag down platform reputation — implementing SLAs could prevent this.

---

#### 5. Delivery & Logistics Analysis
**Questions:** Is delivery performance good enough? What's the business cost of delays?

**Method:**
- On-time % calculation (delivered by estimated date)
- Delay bucket analysis (5+ days early → 15+ days late)
- State-level performance ranking
- Delay impact on review score correlation

**Finding — THE SMOKING GUN:**
Orders delivered 15+ days late: avg review 1.71  
Orders delivered on-time/early: avg review 4.22  
**Difference: 2.5 points**

This is not correlation. This is causation. Delivery delay → bad reviews → customer churn.

---

### Phase 3: Insights Synthesis & Recommendations (Week 4)

**Causal Chain Proven:**

        Seller far from customer
        ↓
        Long delivery time (26 days in AM vs 12 platform avg)
        ↓
        Late delivery (beyond estimated date)
        ↓
        Low review score (1.71 vs 4.22)
        ↓
        Customer never returns (97% one-time buyer rate)
        ↓
        Growth dependent on acquisition, not retention


**Strategic Recommendations (Prioritized):**

1. **Post-purchase retention program** — Quick win, low cost
2. **Recruit sellers in underserved states** — Structural fix, high impact
3. **Seller performance SLAs** — Protect platform quality
4. **Freight renegotiation** — Margin protection
5. **Regional marketing campaigns** — Efficiency improvement

---

## Technical Highlights

### SQL Techniques Used

**Window Functions:**
```sql
-- RFM scoring with NTILE
NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score

-- Month-over-month growth with LAG
LAG(gmv) OVER (ORDER BY order_month) AS prev_month_gmv

-- Running total for cumulative customers
SUM(COUNT(*)) OVER (ORDER BY order_month) AS cumulative_total
```

**CTEs for Complex Logic:**
```sql
WITH seller_metrics AS (...),
     seller_tiers AS (...)
SELECT ...
```

**Conditional Aggregation:**
```sql
COUNT(*) FILTER (WHERE is_late_delivery = 1) AS late_orders
ROUND(AVG(review_score) FILTER (WHERE delay > 15), 2) AS late_review_avg
```

### Power BI Features

- **DAX Measures:** 12 custom measures (GMV, MoM Growth %, On-Time %, etc.)
- **Time Intelligence:** DateTable with relationships for temporal analysis
- **Conditional Formatting:** Traffic light colors on KPIs (green/amber/red)
- **Drill-through:** Click state → see all sellers in that state
- **Slicers:** Year, Quarter, Category for interactive filtering
- **Tooltips:** Custom tooltips showing 5-6 metrics on hover

---

## Business Impact Summary

| Finding | Action | Impact |
|---------|--------|--------|
| 97% one-time buyers | Retention program | +R$600K GMV |
| Geographic inequality | Recruit 200 sellers in North/NE | +R$2M GMV, -3 days delivery |
| Bronze sellers hurting NPS | Seller SLAs | +0.2 review score |
| Freight rising 15.3% → 18% | Carrier renegotiation | -3% freight ratio |
| One-size-fits-all marketing | Regional campaigns | +15% ROI |

**Total: +R$2.6M annual impact**

---

## Challenges & Solutions

**Challenge 1:** Dataset has partial years (2016 only Q4, 2018 only Jan-Aug)  
**Solution:** Always compared like-for-like periods (Jan-Aug 2017 vs Jan-Aug 2018). Documented partial year caveats in every report.

**Challenge 2:** Multiple payment records per order causing row multiplication  
**Solution:** Pre-aggregated payments in CTE using MODE() for payment type, SUM() for value before joining to orders.

**Challenge 3:** Portuguese category names hard to interpret  
**Solution:** Added English translations in all documentation and Power BI visuals.

**Challenge 4:** RFM logic complex to explain to non-technical stakeholders  
**Solution:** Created visual quadrant chart in Power BI showing customer value distribution — immediately intuitive.

---

## Key Learnings

**Technical:**
- Importance of data validation BEFORE analysis (found issues early)
- Window functions are essential for time-series and ranking analysis
- Pre-aggregation in CTEs prevents row multiplication bugs
- Power BI relationships must be one-to-many for clean aggregation

**Business:**
- Always prove causation, not just correlation (delivery → reviews → retention chain)
- Quantify impact in currency terms — "R$600K" > "retention improvement"
- Prioritize recommendations by ROI and implementation complexity
- Executive summaries must lead with "so what" not "here's what I found"

---

## Next Steps (If This Were a Real Engagement)

1. **Week 5-6:** Pilot retention email program with top 3 categories
2. **Week 7-8:** Launch seller recruitment campaign in BA (Bahia) — largest underserved state
3. **Month 2:** Implement weekly seller performance dashboard for ops team
4. **Month 3:** Renegotiate carrier contracts for SP→RJ, SP→MG routes (highest volume)
5. **Quarter 2:** Roll out regional marketing campaigns (Northeast = Health & Beauty focus)

**Success Metrics:**
- Repeat purchase rate increasing from 3% → 5% within 6 months
- Average delivery time in targeted states decreasing from 22 days → <15 days
- Bronze seller GMV share decreasing from 4.8% → <3%
- Platform on-time % improving from 92.1% → 95%+

---

## Conclusion

This project demonstrates the full analytics lifecycle: data validation → exploration → analysis → insight → recommendation → impact quantification. The 2.5-point review score penalty finding alone justified the entire engagement and gave leadership a clear, measurable path forward.

**Portfolio value:** Shows I can not only execute SQL and build dashboards, but think like a business analyst — connecting technical findings to strategic actions that drive revenue.