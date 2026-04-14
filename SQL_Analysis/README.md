# 📂 SQL Analysis: Technical Documentation

This folder contains the core SQL engine for the Chinook Digital Media Store audit. The analysis is structured into three levels of complexity to demonstrate proficiency in relational database management.

## 🛠️ Key SQL Techniques Implemented
* **Multi-Table Joins:** Connecting up to 5 tables (Artists → Albums → Tracks → InvoiceLines → Invoices) to map revenue back to artists.
* **Window Functions:** Utilizing `LAG()` for MoM growth and `ROW_NUMBER()` for regional market leadership.
* **Common Table Expressions (CTEs):** Writing modular, readable code for complex multi-step calculations.
* **Aggregations & Logic:** Using `CASE` statements for CLV segmentation and `HAVING` clauses for behavior-based filtering.

## 📊 Analytical Highlights
1. **Customer Segmentation:** Classifying users into Gold, Silver, and Bronze tiers based on total lifetime spending.
2. **Sales Volatility:** Calculating the percentage growth of revenue on a monthly basis to identify seasonal trends.
3. **Market Localization:** Pinpointing the top-selling artists specifically for the USA and Canada markets.
4. **Inventory Health:** Identifying tracks with zero sales to optimize digital storage efficiency.

---
**Tech Stack:** MySQL 8.0 / SQLite compatible.
