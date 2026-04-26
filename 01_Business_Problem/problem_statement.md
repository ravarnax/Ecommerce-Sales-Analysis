# Business Problem Statement
## Olist E-Commerce Analytics — End-to-End Business Intelligence Engagement

---

## 1. Business Context

**Olist** is Brazil's largest marketplace aggregator, connecting small and medium-sized merchants to major e-commerce channels through a single unified storefront. Unlike Amazon or Shopify — which operate their own fulfilment — Olist acts as a managed marketplace: sellers list products through the platform, and Olist handles billing, logistics coordination, and customer satisfaction management.

Between **September 2016 and October 2018**, Olist processed approximately **100,000 orders** across 26 Brazilian states, generating over **R$13.6 million in Gross Merchandise Value (GMV)**. During this period the platform exhibited explosive top-line growth — GMV grew by over **700% over two years** — but beneath that headline figure, critical operational and structural problems were quietly undermining long-term viability.

This analysis was commissioned to diagnose those problems, quantify their business impact, and produce actionable, prioritized recommendations.

---

## 2. The Core Problem

> **Olist is growing in revenue but not in customers. Nearly every customer who buys once never returns.**

Despite sustained GMV growth, the platform's customer retention rate is critically low:

- **97% of all customers made only one purchase** during the entire two-year period
- The orders-to-unique-customers ratio is effectively **1.02:1** — statistically indistinguishable from zero repeat purchasing
- All revenue growth is therefore entirely funded by **new customer acquisition** — an expensive, unsustainable model

This means Olist is running a leaky bucket: marketing and seller onboarding efforts continuously fill the top of the funnel, but almost no customers are retained to generate organic, compounding revenue.

**The strategic risk:** As new customer acquisition costs rise and growth plateaus (MoM growth was already slowing to below 5% by mid-2018), the business has no retention flywheel to fall back on.

---

## 3. Problem Decomposition

The retention crisis does not have a single root cause. This analysis breaks the problem into five interconnected domains:

### 3.1 Revenue & Growth Sustainability
- Is GMV growth genuine and durable, or driven by a small number of peak events?
- Are freight costs — a direct margin driver — rising over time?
- At what point does growth plateau without a retention improvement?

**Hypothesis:** Revenue growth is concentrated around seasonal spikes (Black Friday) and is masking a structural slowdown in organic demand.

### 3.2 Customer Retention & Behaviour
- Why do 97% of customers not return after their first purchase?
- Which customer segments (by RFM profile) generate disproportionate lifetime value?
- Where are customers geographically concentrated, and are underserved regions a growth opportunity?

**Hypothesis:** Poor post-purchase experience — driven by delivery delays — is the primary barrier to repeat purchasing.

### 3.3 Delivery & Logistics Performance
- What percentage of orders are delivered on time vs. late?
- How does delivery delay correlate with customer satisfaction scores?
- Which states or regions suffer the worst delivery performance, and why?

**Hypothesis:** Delivery delays are the proximate cause of negative reviews, which in turn drive customer churn. Proving this causal chain is the analytical centrepiece of the engagement.

### 3.4 Product Category Performance
- Which categories drive the most GMV and customer satisfaction?
- Are there categories with structurally unprofitable freight ratios?
- Do certain categories perform differently by region?

**Hypothesis:** A small number of anchor categories generate the majority of GMV, while a long tail of high-freight, low-satisfaction categories drag platform performance.

### 3.5 Seller Quality & Marketplace Health
- What proportion of sellers are underperforming on delivery and satisfaction?
- Is there a Pareto concentration of GMV among a small seller cohort?
- What is the geographic distribution of sellers relative to customers?

**Hypothesis:** A small tier of high-performing sellers carry the platform, while a "Bronze tier" of low-quality sellers create disproportionate reputation risk and customer churn.

---

## 4. Business Questions to Answer

| # | Domain | Business Question |
|---|--------|-------------------|
| 1 | Revenue | What is total GMV, and what is the month-over-month growth trend? |
| 2 | Revenue | Is freight cost rising as a proportion of GMV (margin compression)? |
| 3 | Revenue | Which months and seasons drive the highest order volume? |
| 4 | Customers | What is the exact repeat purchase rate, and how has it changed? |
| 5 | Customers | What do RFM segments reveal about customer value distribution? |
| 6 | Customers | Which Brazilian states are over/underserved by the platform? |
| 7 | Delivery | What is the platform-wide on-time delivery rate? |
| 8 | Delivery | How many review score points are lost per unit of delivery delay? |
| 9 | Delivery | Which states have the longest average delivery times? |
| 10 | Products | Which categories rank highest by GMV, satisfaction, and volume? |
| 11 | Products | Which categories have dangerously high freight-to-price ratios? |
| 12 | Sellers | What percentage of GMV comes from the top 20% of sellers? |
| 13 | Sellers | What share of GMV is at risk from Bronze-tier (low-quality) sellers? |
| 14 | Sellers | Is there a seller supply gap in regions with poor delivery performance? |

---

## 5. Success Criteria

This engagement is considered successful if it delivers:

1. **A quantified root cause** of the 97% one-time buyer rate, supported by statistical evidence
2. **A ranked set of business recommendations** with estimated revenue impact and implementation complexity
3. **An interactive dashboard** enabling Olist leadership to self-serve on KPI monitoring
4. **A projected financial model** attaching R$ values to retention improvement scenarios

---

## 6. Analytical Approach

| Phase | Activity | Output |
|-------|----------|--------|
| **1 — Data Foundation** | Validate 9 source tables; audit for nulls, duplicates, referential integrity; build unified analytical view | `master_orders_view` (8-table join), data quality report |
| **2 — Exploratory Analysis** | SQL-based analysis across 5 business domains; 40+ analytical queries | Domain-level findings and KPI baselines |
| **3 — Root Cause Analysis** | Quantify delivery → satisfaction → churn causal chain; RFM segmentation | Causal evidence; customer segment profiles |
| **4 — Visualisation** | 5-page interactive Power BI dashboard | Executive dashboard with drill-down capability |
| **5 — Recommendations** | Prioritise interventions by projected ROI and implementation cost | Strategic recommendations with financial projections |

---

## 7. Scope & Constraints

**In Scope:**
- All orders placed between September 2016 and October 2018
- All 26 Brazilian states + Federal District
- Revenue, customer, product, seller, and logistics analysis

**Out of Scope:**
- Real-time or streaming data analysis
- Individual seller or customer PII (data is fully anonymised)
- Marketing spend or acquisition cost data (not available in the dataset)
- Predictive modelling / machine learning

**Key Constraints:**
- Dataset covers only 2 years; long-term cohort trends are limited
- No external benchmark data for Brazilian e-commerce market context
- Seller and customer identities are hashed; no external enrichment possible
- Geographic analysis relies on ZIP prefix approximations, not precise coordinates

---

## 8. Stakeholders & Audience

| Stakeholder | Role | Primary Interest |
|---|---|---|
| **CEO / Founders** | Executive sponsor | Revenue growth, retention strategy, market expansion |
| **Head of Operations** | Operational lead | Delivery performance, seller SLAs, logistics gaps |
| **Head of Marketing** | Demand owner | Customer acquisition vs. retention trade-off, RFM segments |
| **Category Managers** | Product owners | Category GMV, freight profitability, regional preferences |
| **Seller Success Team** | Seller relations | Seller tier distribution, underperforming seller intervention |

---

## 9. Key Finding (Summary)

> After completing the full analysis, the root cause was confirmed:
>
> **Delivery delays are the primary driver of negative reviews, and negative reviews are the primary driver of customer churn.**
>
> Orders delivered 15 or more days late received an average review score of **1.71 out of 5** — compared to **4.22** for on-time orders. That 2.5-point gap represents a statistically significant customer experience failure that directly suppresses repeat purchasing.
>
> The highest-delay states (Amazonas: 26.4 days avg) suffer from a **seller supply gap** — no sellers are located nearby, forcing all shipments to cross state lines. This creates a self-reinforcing cycle: poor delivery → bad reviews → lost customers → no incentive to invest in those regions.

**Projected impact of recommended interventions: +R$2.6M annual GMV, +2–3% repeat purchase rate, –3 days average delivery time.**
