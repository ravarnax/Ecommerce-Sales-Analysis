# 🛒 Olist E-Commerce Analytics — End-to-End Data Analytics Portfolio Project

**A complete business intelligence case study analyzing 100k+ orders from a Brazilian marketplace**

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Power BI](https://img.shields.io/badge/PowerBI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)
[![Excel](https://img.shields.io/badge/Microsoft_Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)](https://www.microsoft.com/en-us/microsoft-365/excel)

---

## 📊 Project Overview

This project simulates a **real-world analytics engagement** for Olist, a Brazilian e-commerce marketplace platform. Using ~100,000 real anonymized orders from 2016–2018, I conducted a comprehensive business analysis covering revenue, customer behavior, product performance, seller quality, and delivery logistics.

**Key Achievement:** Identified that 97% one-time buyer rate was caused by delivery delays — orders delivered 15+ days late received review scores 2.5 points lower (1.71 vs 4.22), directly driving customer churn. Proposed retention programs and seller quality SLAs projected to generate R$2.6M incremental annual GMV.

---

## 🎯 Business Questions Answered

| Category | Key Findings |
|----------|--------------|
| **Revenue** | 706% growth over 2 years, but MoM growth plateauing in 2018 at <5% |
| **Customer Retention** | 97% one-time buyers — entire growth funded by new acquisition |
| **Delivery Performance** | 92.1% on-time rate, but 26.4-day avg in Amazonas (2x platform avg) |
| **Geographic Inequality** | 66.5% of customers in 3 southeastern states; North/Northeast underserved |
| **Product Categories** | Top 5 categories generate 40% of GMV; 7 categories have >30% freight ratios |
| **Seller Quality** | Top 20% of sellers generate 80%+ of revenue (Pareto confirmed) |

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| **PostgreSQL** | Data warehouse, ETL, analytical views |
| **SQL** | 40+ business queries across 7 analysis domains |
| **Power BI** | 5-page interactive dashboard with drill-down capability |
| **Excel** | Data validation and exploration |
| **Git/GitHub** | Version control and documentation |

---

## 📁 Repository Structure

```
Ecommerce-Sales-Analysis/
│
├── data/                                        # Raw source datasets (9 CSV files)
│   ├── olist_orders_dataset.csv                 # Core orders fact table (99,441 rows)
│   ├── olist_customers_dataset.csv              # Customer dimension (99,441 rows)
│   ├── olist_order_items_dataset.csv            # Order line items (112,650 rows)
│   ├── olist_order_payments_dataset.csv         # Payment transactions (103,886 rows)
│   ├── olist_order_reviews_dataset.csv          # Customer reviews (104,164 rows)
│   ├── olist_products_dataset.csv               # Product catalogue (32,951 rows)
│   ├── olist_sellers_dataset.csv                # Seller dimension (3,095 rows)
│   ├── olist_geolocation_dataset.csv            # ZIP code coordinates (1,000,163 rows)
│   ├── product_category_name_translation.csv    # PT → EN category lookup (71 rows)
│   └── schema.sql                               # PostgreSQL table definitions
│
├── sql/                                         # All analytical SQL queries
│   ├── 01_data_validation.sql                   # Data quality audit (nulls, dupes, referential integrity)
│   ├── 02_correction.sql                        # Data cleaning corrections
│   ├── 02_master_view.sql                       # master_orders_view — 8-table analytical join
│   ├── 03_revenue_analysis.sql                  # GMV trends, MoM growth, seasonality, freight ratios
│   ├── 04_customer_analysis.sql                 # RFM segmentation, retention, LTV, geographic analysis
│   ├── 05_product_analysis.sql                  # Category performance, quadrant matrix, freight risk
│   ├── 06_seller_analysis.sql                   # Seller tiers, Pareto distribution, quality metrics
│   ├── 07_delivery_logistics_analysis.sql       # On-time %, delay impact on reviews, state-level SLA
│   └── exploratory_queries.sql                  # Ad-hoc exploration queries
│
├── powerbi/                                     # Power BI dashboard assets
│   ├── ecommerce_dashboard.pbit                 # Power BI template (5-page interactive dashboard)
│   ├── Executive Dashboard (Olist Dataset).png
│   ├── Revenue and Growth Dashboard (Olist Dataset).png
│   ├── Customer Insights Dashboard (Olist Dataset).png
│   ├── Product Performance Dashboard (Olist Dataset).png
│   └── Delivery and Logistics Dashboard (Olist Dataset).png
│
├── excel/                                       # Exported datasets for Power BI data model
│   ├── delivered_orders.csv                     # All delivered orders with enriched fields
│   ├── rfm_customer_segments.csv                # RFM scoring and segment labels
│   ├── seller_tiers.csv                         # Seller tier classifications
│   ├── category_quadrant.csv                    # Product category quadrant matrix
│   ├── monthly_summary.csv                      # Monthly GMV and order volume summary
│   └── delivery_delay_impact.csv                # Delay buckets vs. average review scores
│
├── docs/                                        # Project documentation
│   ├── executive_summary.md                     # C-suite 1-page findings summary
│   ├── insights_log.md                          # Full domain-by-domain analytical findings
│   ├── project_walkthrough.md                   # End-to-end methodology walkthrough
│   ├── data_dictionary.md                       # Legacy data notes (see 02_Data_Understanding/)
│   └── business_questions.md                    # Original analysis scope definition
│
├── Insights/                                    # Output exports and visual results
│   ├── insights.md                              # Consolidated insight summaries
│   ├── 05_product_analysis.result.csv           # Product analysis query results
│   ├── 06_seller_analysis.csv                   # Seller analysis query results
│   ├── 07_delivery_logistics_analysis.csv       # Logistics analysis query results
│   ├── image.png                                # Supporting chart exports
│   └── image-1.png
│
├── .gitignore                                   # Git ignore rules
└── README.md                                    # You are here
```



---

## 🔍 Analysis Methodology

### Phase 1: Data Foundation
- **Validation**: 7-query audit covering row counts, nulls, duplicates, referential integrity
- **Cleaning**: Handled 610 null product categories, standardized naming conventions
- **Modeling**: Built `master_orders_view` — single analytical layer joining 8 tables

### Phase 2: Business Analysis (7 Domains)

<details>
<summary><b>1. Revenue Analysis</b></summary>

**Queries:** 7 analytical queries  
**Key Metrics:** GMV, MoM growth %, AOV, freight ratio

**Findings:**
- R$13.2M total GMV across 96,470 delivered orders
- November 2017 peak (Black Friday): R$987K GMV in a single month
- Freight costs rising from 15.3% (Q1 2017) to 18.0% (Q3 2018) — margin compression risk
- Growth rate flattening in 2018 (May: +0.4% MoM)

**Business Impact:** Identified unsustainable growth model reliant on acquisition, not retention

</details>

<details>
<summary><b>2. Customer Behavior Analysis</b></summary>

**Queries:** 7 analytical queries  
**Key Metrics:** Repeat purchase rate, RFM segments, LTV distribution, geographic concentration

**Findings:**
- **97% one-time buyers** — critical retention crisis
- Orders-to-customers ratio: 1.02:1 (effectively zero repeat purchasing)
- RFM analysis: Champions (25%) generate 51.3% of revenue
- 66.5% customer concentration in SP, RJ, MG (3 states)

**Business Impact:** Calculated that 3% → 6% repeat rate improvement = R$600K incremental GMV with zero acquisition cost

</details>

<details>
<summary><b>3. Product Performance Analysis</b></summary>

**Queries:** 7 analytical queries  
**Key Metrics:** Category GMV, quadrant classification, satisfaction scores, freight ratios

**Findings:**
- Health & Beauty (9.3% of GMV) is platform anchor category
- 7 categories exceed 30% freight-to-price ratio (casa_conforto_2: 54%)
- Delivery time correlates directly with review scores (proven causal chain)
- Regional preferences: Northeast prefers Health & Beauty, Southeast prefers Bed Bath & Table

**Business Impact:** Identified R$150K annual losses in structurally unprofitable high-freight categories

</details>

<details>
<summary><b>4. Seller Performance Analysis</b></summary>

**Queries:** 7 analytical queries  
**Key Metrics:** Seller tiers (Platinum/Gold/Silver/Bronze), Pareto distribution, geographic concentration

**Findings:**
- 4.8% of GMV comes from Bronze-tier sellers (review <3.5, late% >40%)
- Top 20% of sellers generate 80%+ of revenue (Pareto confirmed)
- Seller concentration mirrors customer concentration (both in SP/RJ/MG)

**Business Impact:** Bronze sellers represent reputation liability — implementing SLAs projected to improve platform review score by 0.2 points

</details>

<details>
<summary><b>5. Delivery & Logistics Analysis</b></summary>

**Queries:** 7 analytical queries  
**Key Metrics:** On-time %, delivery days, delay impact, state-level performance

**Findings:**
- **92.1% on-time delivery** (above 90% industry standard)
- Amazonas: 26.4 days avg delivery (2x platform average of 12.3 days)
- **2.5-point review score penalty** for orders 15+ days late (1.71 vs 4.22)
- Same-state delivery: 9.2 days avg | Cross-state: 14.8 days avg

**Business Impact:** Proved delivery delay is root cause of retention crisis — 10% on-time improvement prevents ~7,600 negative reviews annually

</details>

</details>

---

## 📸 Dashboard Preview

### Executive Overview
![Executive Dashboard](powerbi/screenshots/Executive%20Dashboard%20(Olist%20Dataset).png)
*High-level KPIs and trends — designed for C-suite consumption*

### Revenue & Growth Analysis
![Revenue Dashboard](powerbi/screenshots/Revenue%20and%20Growth%20Dashboard%20(Olist%20Dataset).png)
*Monthly GMV trends, MoM growth rates, and seasonality patterns*

### Customer Insights
![Customer Dashboard](powerbi/screenshots/Customer%20Insights%20Dashboard%20(Olist%20Dataset).png)
*RFM segmentation, retention analysis, and geographic distribution*

### Product Performance
![Product Dashboard](powerbi/screenshots/Product%20Performance%20Dashboard%20(Olist%20Dataset).png)
*Category quadrant matrix, satisfaction rankings, and freight risk analysis*

### Delivery & Logistics
![Logistics Dashboard](powerbi/screenshots/Delivery%20and%20Logistics%20Dashboard%20(Olist%20Dataset).png)
*On-time performance, state-level analysis, and delay impact on reviews*

---

## 💡 Key Strategic Recommendations

| Priority | Recommendation | Estimated Impact | Complexity |
|----------|----------------|------------------|------------|
| **P1** | Post-purchase retention program (email sequence) | +R$600K GMV, +2% repeat rate | Low |
| **P2** | Recruit 200 sellers in North/Northeast states | +R$2M GMV, -3 days avg delivery | Medium |
| **P3** | Implement seller performance SLAs | +0.2 review score | Low |
| **P4** | Renegotiate carrier contracts | -3% freight ratio | High |
| **P5** | Regional marketing campaigns by state | +15% campaign ROI | Low |

**Total Projected Impact:** +R$2.6M annual GMV, +2–3% repeat purchase rate, -3 days delivery time

---

## 🎓 What I Learned

**Technical Skills:**
- Advanced SQL: window functions (NTILE, RANK, LAG), CTEs, complex joins, aggregate filters
- Data modeling: star schema design, analytical view layers
- Power BI: DAX measures, relationship modeling, conditional formatting, interactive slicers
- Business intelligence: translating data into executive-ready insights

**Business Skills:**
- RFM customer segmentation framework
- Pareto analysis and concentration risk assessment
- Causal analysis: proving delivery → satisfaction → retention chain
- Executive communication: prioritizing recommendations by ROI

---

## 📬 Contact & Links

**Author:** Shivam Kothiyal 

**LinkedIn:** https://www.linkedin.com/in/shivam-kothiyal-161b531b8/  

**Portfolio:** https://github.com/shivamkothiyal17

**Email:** shivamkothiyal170@gmail.com

---

## 📄 License

This project uses the publicly available [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle (CC BY-NC-SA 4.0).

---

## ⭐ Acknowledgments

Dataset provided by Olist and made available on Kaggle. Analysis methodology inspired by real-world marketplace analytics workflows at companies like Amazon, Shopify, and Mercado Livre.

---

**⭐ If this project helped you, please star the repository!**
