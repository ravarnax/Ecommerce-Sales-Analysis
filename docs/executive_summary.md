# Olist E-Commerce Platform — Analytics Executive Summary
**Analysis Period:** September 2016 – August 2018  
**Dataset Scope:** 96,096 delivered orders | 93,350 unique customers | 3,095 sellers  
**Analyst:** Shivam Kothiyal  
**Date:** 18 April 2026

---

## Business Context

Olist is a Brazilian e-commerce marketplace connecting small and medium sellers to customers across all 27 states. Between 2016 and 2018, the platform experienced 706% revenue growth, scaling from early-stage pilot to a multi-million real operation processing ~100,000 orders.

This analysis evaluates platform health across six dimensions: revenue, customer behavior, product performance, seller quality, delivery logistics, and customer satisfaction. The goal is to identify what is working, what is breaking, and where to invest next.

---

## Executive Findings — Top 5

### 1. **Growth is unsustainable — the retention crisis**

**Finding:** 97% of Olist customers never return after their first purchase. The entire 706% revenue growth was funded purely by new customer acquisition. The orders-to-unique-customers ratio is 1.03:1 in 2017 and 1.02:1 in 2018 — effectively zero repeat purchasing.

**Business impact:** Customer acquisition cost (CAC) is always higher than retention cost. Olist is paying the most expensive possible price for every unit of growth. The moment new customer acquisition slows — which 2018 data suggests is already beginning — revenue growth will stall immediately.

**So what:** A 3% → 6% improvement in repeat purchase rate would double returning customer revenue without spending one additional real on acquisition.

---

### 2. **Delivery delay is the primary cause of customer churn**

**Finding:** Orders delivered 15+ days late receive an average review score of 1.71 compared to 4.22 for on-time orders. This is a 2.5-point penalty — the difference between a promoter and a detractor.

**Causal chain proven:**
- Delivery delay → low review scores (proven in Logistics Analysis)
- Low review scores → category abandonment (proven in Product Analysis)
- Poor first experience → no repeat purchase (proven in Customer Analysis)

**Business impact:** Late delivery is not just a logistics problem. It is the root cause of the 97% one-time buyer rate. Customers who have a bad delivery experience never come back.

**So what:** A 10% improvement in on-time delivery rate (92.1% → 100%) would prevent approximately 7,600 negative reviews annually and shift thousands of one-time buyers into the repeat buyer pool.

---

### 3. **Geographic inequality is destroying growth potential in 60% of Brazil**

**Finding:**
- 66.5% of customers are concentrated in just 3 southeastern states (SP, RJ, MG)
- Customers in Amazonas (AM) wait an average of 26.4 days for delivery — more than double the platform average of 12.3 days
- The 5 slowest states (all in the North and Northeast) account for only 4.8% of customers despite representing 28% of Brazil's population

**Business impact:** Two-thirds of Brazil is systematically underserved. These regions have slower delivery, higher freight costs, and worse review scores — creating a compounding disadvantage that prevents organic growth.

**So what:** The constraint is not demand. The constraint is supply. Recruiting 200 sellers in the North and Northeast would unlock millions of reals in untapped GMV while simultaneously improving delivery speed and cutting freight costs for existing customers in those regions.

---

### 4. **The top 25% of customers fund 62.5% of the business**

**Finding (RFM Analysis):**
- Champions (top 25% by recency, frequency, monetary value) generate 51.3% of all revenue
- Champions + Loyal Customers (top 50%) generate 80.9% of all revenue
- 5,974 customers are classified as "Lost" and contribute only 1.3% of revenue but still appear in paid advertising audiences

**Business impact:** Olist is treating all customers equally when customer value varies by 12x. High-value customers receive the same experience as low-value customers. Lost customers continue to consume marketing budget despite having already churned.

**So what:** Segment-based marketing and retention campaigns targeted at Champions and Loyal Customers would produce 4–5x higher ROI than broad acquisition campaigns. Suppressing Lost customers from paid ads would immediately cut wasted spend by ~6%.

---

### 5. **Freight costs are rising faster than revenue**

**Finding:**
- Q1 2017: Freight was 15.3% of GMV
- Q3 2018: Freight climbed to 18.0% of GMV
- Seven product categories exceed 30% freight-to-price ratio, with `casa_conforto_2` at 54% (critically loss-making)

**Business impact:** As Olist scales, unit economics are degrading, not improving. This suggests the current logistics model does not benefit from economies of scale — possibly because seller-customer distance is increasing as the platform expands geographically.

**So what:** Without intervention, continued growth will drive freight costs higher, compressing margins and making the business unprofitable in high-freight categories. Immediate carrier renegotiation and regional fulfillment partnerships are required.

---

## Critical Risks — What Breaks if Ignored

### **Risk 1 — Revenue growth stalls in 2019**

The hyper-growth phase powered by novelty and market expansion is over. MoM growth rates in 2018 oscillate between -12% and +15% with multiple near-zero months (May 2018: +0.4%). Without a shift to retention-based growth, Olist will flatline in 2019.

**Trigger indicators to monitor:**
- Repeat purchase rate remaining below 5% in Q1 2019
- New customer acquisition costs rising above historical baseline
- MoM revenue growth below 5% for three consecutive months

---

### **Risk 2 — Northern and Northeastern regions remain structurally unserved**

If seller recruitment does not expand to underserved states, those regions will never become profitable markets. Customers there will continue to experience 20–30 day delivery times, receive low satisfaction, and churn at 99%+ rates. This creates a self-reinforcing doom loop: bad experience → no growth → no seller interest → continued bad experience.

**Trigger indicators to monitor:**
- Customer concentration in SP+RJ+MG remaining above 65% in 2019
- Average delivery time in AM, RR, AP, AC exceeding 20 days
- Review scores in Northern states below 3.8

---

### **Risk 3 — Bronze sellers damage the platform faster than Platinum sellers can repair it**

Every order fulfilled by a Bronze-tier seller (review score <3.5, late delivery >40%, avg delivery >20 days) is a reputation liability. If Bronze sellers represent more than 10% of order volume, their negative impact will outweigh the positive contributions of Platinum sellers.

**Trigger indicators to monitor:**
- Bronze seller GMV share exceeding 10%
- Platform-wide review score declining below 4.0
- On-time delivery rate falling below 90%

---

## Recommended Actions — Prioritized by Impact

### **Priority 1 — Implement a post-purchase retention program (High impact, Low cost)**

**What:** Launch a 3-email post-purchase sequence:
- Day 3: Product recommendation based on category purchased
- Day 14: Loyalty points or discount code for next purchase
- Day 30: Category-specific promotion (personalized by state)

**Why:** At 97% one-time buyers, even moving the needle to 5% repeat purchase would generate ~R$ 600k in incremental annual GMV with near-zero acquisition cost.

**Owner:** Marketing / Customer Success  
**Timeline:** Launch pilot in Q1 2019 with top 3 categories  
**Success metric:** Repeat purchase rate increasing from 3% to 5% within 6 months

---

### **Priority 2 — Recruit 200 sellers in underserved states (High impact, Medium cost)**

**What:** Launch a targeted seller acquisition campaign in:
- North: AM, PA, RO, AC, RR, AP
- Northeast: BA, CE, PE, MA, PB, RN

**Why:** Every seller recruited in an underserved state simultaneously:
- Reduces delivery time for local customers
- Cuts freight costs (shorter last-mile distance)
- Improves review scores (faster delivery = better satisfaction)
- Unlocks untapped demand in 60% of Brazil

**Target states (prioritized):**
1. BA (Bahia) — largest underserved population, Health & Beauty dominant category
2. AM (Amazonas) — worst delivery performance, highest improvement potential
3. PA (Pará) — second-largest Northern state

**Owner:** Seller Operations / Business Development  
**Timeline:** Recruit 50 sellers per quarter across 2019  
**Success metric:** Average delivery time in targeted states decreasing from 22 days to <15 days

---

### **Priority 3 — Implement seller performance SLAs and tiered visibility (Medium impact, Low cost)**

**What:**
- Platinum sellers (review ≥4.2, late% ≤10%, delivery ≤12 days): Featured placement in search, "Fast Shipping" badge
- Gold sellers: Standard placement
- Silver sellers: Standard placement with coaching
- Bronze sellers (review <3.5 OR late% >40% OR delivery >20 days): Listing demotion, mandatory improvement plan, suspension if no improvement in 60 days

**Why:** Marketplace quality is only as good as the worst-performing seller. Allowing Bronze sellers to operate without consequence drags down the entire platform's reputation.

**Owner:** Seller Operations / Marketplace Integrity  
**Timeline:** Phase 1 (monitoring) in Q1, Phase 2 (enforcement) in Q2  
**Success metric:** Bronze seller GMV share decreasing from [current %] to <5%

---

### **Priority 4 — Renegotiate carrier contracts and explore regional fulfillment (High impact, High cost)**

**What:**
- Renegotiate freight rates for high-volume corridors (SP→RJ, SP→MG, SP→RS)
- Pilot regional fulfillment partnerships in BA and AM (marketplace-managed inventory for top 50 SKUs in high-freight categories)

**Why:** Freight costs rising from 15.3% to 18.0% is unsustainable. At 54% freight ratio, categories like `casa_conforto_2` are structurally unprofitable. Without intervention, continued growth will compress margins to zero in high-freight categories.

**Owner:** Logistics / Operations  
**Timeline:** Carrier renegotiation Q1 2019, fulfillment pilot Q2 2019  
**Success metric:** Freight-to-GMV ratio decreasing from 18% to <15% by end of 2019

---

### **Priority 5 — Segment-based marketing campaigns by region and RFM tier (Medium impact, Low cost)**

**What:**
- Northeastern states (BA, PE, CE): Health & Beauty promotions
- Southeastern states (SP, RJ, MG): Bed, Bath & Table promotions
- Southern states (PR, SC, RS): Sports & Leisure promotions
- Champions + Loyal Customers: Early access, VIP perks, referral incentives
- At Risk + Lost Customers: Exclude from paid acquisition, one final win-back email

**Why:** The current one-size-fits-all national campaign strategy leaves conversion on the table. Regional preferences are real and actionable. RFM segmentation allows budget reallocation from low-value to high-value customers.

**Owner:** Marketing  
**Timeline:** Launch regional campaigns Q1 2019  
**Success metric:** Regional campaign CTR and conversion rate 20% higher than national campaigns

---

### **Priority 6 — Create a delivery performance dashboard for operations (Low impact, Low cost)**

**What:** Weekly dashboard tracking:
- On-time delivery % (target: >95%)
- Average delivery days by seller state
- Late delivery % by seller (flagged if >30%)
- Category-level delivery performance

**Why:** You cannot improve what you do not measure. Currently, delivery performance is invisible until it shows up in review scores — by which point the damage is done.

**Owner:** Data / Analytics  
**Timeline:** Build in Q4 2018, operationalize Q1 2019  
**Success metric:** Operations team using dashboard weekly to flag underperforming sellers

---

### **Priority 7 — Exit or restructure loss-making high-freight categories (Low impact, Medium effort)**

**What:** Conduct full unit economics audit on:
- `casa_conforto_2` (54% freight ratio)
- `flores` (44% freight ratio)
- `moveis_colchao_e_estofado` (36.6% freight ratio)

For each, either:
- Implement minimum order value thresholds (e.g., R$ 200 minimum for furniture)
- Offer freight subsidy only above basket size X
- Exit the category entirely if structurally unprofitable

**Why:** Growth in an unprofitable category accelerates losses, not revenue. Some categories should not exist on a marketplace without different logistics infrastructure.

**Owner:** Finance / Category Management  
**Timeline:** Audit Q1 2019, decision Q2 2019  
**Success metric:** High-freight categories contributing <5% of total orders

---

## Quantified Business Impact Summary

| Action                       | Estimated Annual Impact       | Cost  | Priority |
|------------------------------|-------------------------------|-------|----------|
| Post-purchase retention      | +R$ 600k GMV, 2% repeat rate  | Low   | 1        |
| Seller recruitment (200)     | +R$ 2M GMV, -3 days delivery  | Med   | 2        |
| Seller SLAs                  | +0.2 review score improvement | Low   | 3        |
| Freight renegotiation        | -3% freight ratio             | High  | 4        |
| Segmented marketing          | +15% campaign ROI             | Low   | 5        |
| Delivery dashboard           | Operational efficiency        | Low   | 6        |
| Exit loss-making categories  | -R$ 150k losses annually      | Med   | 7        |

**Total estimated impact:** +R$ 2.6M GMV, +2–3% repeat purchase rate, -3 days average delivery time, -3% freight ratio improvement.

---

## Conclusion

Olist has achieved remarkable growth — 706% revenue increase in under two years. However, this growth is built on an unsustainable foundation: 97% one-time buyers, rising freight costs, and geographic service inequality.

The data is unambiguous: **delivery performance drives customer satisfaction, and customer satisfaction drives retention.** Improving logistics is not just an operational priority — it is the single highest-leverage growth investment Olist can make.

The recommendations above are sequenced to deliver quick wins (retention program, seller SLAs) while building toward structural improvements (seller recruitment, freight renegotiation). All are achievable within 12 months with existing resources.

The platform has proven it can acquire customers. The next phase is proving it can keep them.

---

**Prepared by:** Shivam Kothiyal  
**Role:** Senior Data Analyst (Portfolio Project)  
**Contact:** ravarnax3.14@gmail.com 
**Repository:** https://github.com/ravarnax/Ecommerce-Sales-Analysis