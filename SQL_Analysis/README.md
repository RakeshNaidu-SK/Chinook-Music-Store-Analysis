# 📂 SQL Analysis: Technical Documentation

This folder contains the core SQL engine for the Chinook Digital Media Store audit. The analysis is divided into three tiers of complexity to demonstrate proficiency in relational database management and business intelligence.

## 🛠️ Key SQL Techniques Implemented
* **Multi-Table Joins:** Connecting up to 5 tables (Artists -> Albums -> Tracks -> InvoiceLines -> Invoices) to trace revenue back to the original creator.
* **Window Functions:** Utilizing `LAG()` for month-over-month growth and `ROW_NUMBER()` with `PARTITION BY` for localized market leadership.
* **Common Table Expressions (CTEs):** Writing modular, readable code for complex multi-step calculations like Album Efficiency.
* **Aggregations & Logic:** Using `CASE` statements for customer segmentation (CLV) and `HAVING` clauses for behavior-based filtering.

## 📊 Analytical Highlights
1. **Customer Segmentation:** Classifying users into Gold, Silver, and Bronze tiers based on lifetime spending.
2. **Sales Volatility:** Calculating the percentage growth of revenue on a monthly basis to identify seasonal trends.
3. **Market Localization:** pinpointing the top-selling artists specifically for the USA and Canada markets.
4. **Inventory Health:** Identifying "Dead Stock" (tracks with zero sales) to optimize database and storage efficiency.

---
*All queries are written in MySQL/SQLite compatible syntax.*
