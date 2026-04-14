# 🎵 Chinook Digital Media Store: Strategic SQL Audit

## 📌 Project Overview
This project is a comprehensive technical audit of the Chinook digital media store. Using **MySQL**, I engineered 20 business-critical queries to extract actionable insights regarding revenue momentum, customer lifetime value (CLV), and global market penetration.

## 🚀 Technical Achievements
* **Advanced Analytical SQL:** Implemented Window Functions (`LAG`, `RANK`, `ROW_NUMBER`) to track MoM growth and regional leadership.
* **Complex Data Modeling:** Executed 5-table joins to trace revenue from raw tracks to final sales.
* **Strategic Logic:** Developed a classification system (Gold/Silver/Bronze) to segment the customer base by financial contribution.

## 📊 Key Business Insights
* **Revenue Momentum:** Identified monthly growth volatility, pinpointing peak sales performance and seasonal dips.
* **Market Concentration:** Rock and Metal account for the majority of sales; USA remains the primary revenue driver.
* **Customer ROI:** Found that "Genre Explorers" (customers buying 5+ genres) have a 25% higher lifetime value than single-genre listeners.

## 📂 Query Catalog
| Category | Business Problem Solved | Key SQL Syntax |
| :--- | :--- | :--- |
| **Growth** | Monthly Revenue & Growth % | `CTE`, `LAG()`, `OVER()` |
| **Segmentation** | Customer Tiering (Gold/Silver/Bronze) | `CASE`, `Subqueries` |
| **Performance** | Top Artist by Country (USA/Canada) | `PARTITION BY`, `DENSE_RANK` |
| **Inventory** | Identification of "Dead Stock" Tracks | `LEFT JOIN`, `INNER JOIN`, `IS NULL` |

---
### 👉 [View the Full SQL Script with Detailed Comments](./SQL_Analysis/Chinook_Ad_hoc_request.sql)
---

## 🛡️ Scaling & Optimization Recommendations
To scale this analysis for a production environment (e.g., 10M+ rows):
1. **Indexing:** Implement indexes on `TrackId`, `InvoiceId`, and `CustomerId` to optimize multi-table join performance.
2. **Materialized Views:** Use materialized views for growth reports to reduce CPU load during high-frequency reporting.
3. **Partitioning:** Partition the `Invoice` table by `InvoiceDate` to accelerate time-series analysis.
