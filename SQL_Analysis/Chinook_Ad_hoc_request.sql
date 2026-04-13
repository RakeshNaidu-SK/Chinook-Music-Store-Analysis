/* 1. GLOBAL CUSTOMER FOOTPRINT
   Business Impact: Identifies market penetration. Helps the marketing team 
   decide which cities need localized ad campaigns. */
SELECT city, COUNT(customerid) AS total_customers
FROM customer
GROUP BY city
ORDER BY total_customers DESC;

/* 2. PRODUCT CATALOG SIZE BY GENRE
   Business Impact: Helps inventory management understand the diversity 
   of the catalog and identify niche genres that may need more content. */
SELECT g.name AS genre_name, COUNT(t.trackid) AS total_tracks
FROM genre g
JOIN track t ON g.GenreId = t.GenreId
GROUP BY genre_name
ORDER BY total_tracks DESC;

/* 3. MEDIA FORMAT AUDIT
   Business Impact: Identifies technical debt. If old formats (like ACC) 
   aren't selling, we can stop supporting them to save on storage costs. */
SELECT m.name AS media_type, COUNT(t.trackid) AS total_tracks
FROM mediatype AS m
JOIN track t ON m.MediaTypeId = t.MediaTypeId
GROUP BY media_type
ORDER BY total_tracks DESC;

/* 4. EMPLOYEE HIERARCHY (SELF-JOIN)
   Business Impact: Maps internal reporting lines. Crucial for HR 
   audits and identifying spans of control within the sales team. */
SELECT 
    CONCAT(e.LastName, ' ', e.FirstName) AS emp_name,
    CONCAT(m.LastName, ' ', m.FirstName) AS manager_name
FROM employee e
LEFT JOIN employee m ON e.ReportsTo = m.EmployeeId;

/* 5. ANNUAL SALES VOLUME (2021)
   Business Impact: A quick health check of the store's transaction 
   volume for the most recent complete fiscal year. */
SELECT COUNT(invoiceid) AS total_invoices
FROM invoice
WHERE YEAR(invoicedate) = 2021;

/* 6. AVERAGE ORDER VALUE (AOV)
   Business Impact: A key KPI. Increasing the AOV is often easier 
   than acquiring new customers. This is the baseline for growth. */
SELECT ROUND(AVG(total), 2) AS avg_invoice_total
FROM invoice;



/* 7. TOP 5 REVENUE-GENERATING COUNTRIES
   Business Impact: Dictates international strategy. Focuses the 
   legal and logistics team on the highest-priority markets. */
SELECT billingcountry, SUM(total) AS total_revenue
FROM invoice
GROUP BY BillingCountry
ORDER BY total_revenue DESC
LIMIT 5;

/* 8. THE "SILENT" TRACKS (ZERO SALES)
   Business Impact: Identifies "Dead Stock." These tracks take up 
   database space but generate zero ROI. Possible candidates for deletion. */
SELECT t.*
FROM track t
LEFT JOIN invoiceline l ON t.TrackId = l.TrackId
WHERE l.TrackId IS NULL;

/* 9. CUSTOMER SPENDING LEADERBOARD
   Business Impact: Identifies the top 1% of customers. These 
   individuals should be targeted for "VIP" loyalty programs. */
SELECT 
    CONCAT(c.lastname, ' ', c.firstname) AS customer_name,
    SUM(i.total) AS total_spend
FROM customer c
LEFT JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY customer_name
ORDER BY total_spend DESC;

/* 10. SALES AGENT REVENUE PERFORMANCE
   Business Impact: Directly links employee performance to revenue. 
   Used for calculating quarterly bonuses and sales commissions. */
SELECT 
    CONCAT(e.lastname, ' ', e.firstname) AS emp_name,
    SUM(i.Total) AS total_rev
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY emp_name;

/* 11. TOP 10 ALBUMS BY REVENUE
   Business Impact: Informs procurement. If certain albums are 
   blockbusters, we should promote similar artists or sequels. */
SELECT a.title AS alb_title, SUM(i.total) AS total_rev
FROM album a
JOIN track t ON a.AlbumId = t.AlbumId
JOIN invoiceline il ON t.TrackId = il.TrackId
JOIN invoice i ON il.InvoiceId = i.InvoiceId
GROUP BY alb_title
ORDER BY total_rev DESC
LIMIT 10;

/* 12. GENRE POPULARITY (USA MARKET)
   Business Impact: Specific regional insight. Allows the US 
   marketing team to tailor "Genre of the Month" promotions. */
SELECT g.name AS genre_name, SUM(il.quantity) AS total_tracks_sold
FROM genre g
JOIN track t ON g.genreid = t.GenreId
JOIN invoiceline il ON t.TrackId = il.TrackId
JOIN invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.BillingCountry = 'USA'
GROUP BY genre_name
ORDER BY total_tracks_sold DESC;

/* 13. ARTIST PRODUCTION VOLUME
   Business Impact: Identifies our "Anchor Artists"—those with 
   the largest presence in our digital library. */
SELECT art.name AS artist_name, COUNT(t.trackid) AS total_tracks
FROM artist art
JOIN album a ON art.ArtistId = a.ArtistId
JOIN track t ON a.AlbumId = t.albumid
GROUP BY artist_name
ORDER BY total_tracks DESC
LIMIT 1;

/* 14. ABOVE-AVERAGE INVOICES
   Business Impact: Identifies "High-Value Transactions." Helps 
   fraud detection and premium service teams monitor large orders. */
SELECT * FROM invoice
WHERE total > (SELECT AVG(total) FROM invoice);



/* 15. CUSTOMER LIFETIME VALUE (CLV) SEGMENTATION
   Business Impact: Categorizes the user base into actionable segments. 
   Gold customers get perks, while Bronze customers get discount triggers. */
SELECT 
    cust_name AS customer_name,
    total_spend,
    CASE
        WHEN total_spend < 30 THEN 'Bronze'
        WHEN total_spend < 45 THEN 'Silver'
        WHEN total_spend >= 45 THEN 'Gold'
    END AS CLV
FROM (
    SELECT CONCAT(c.FirstName, ' ', c.LastName) AS cust_name, SUM(i.total) AS total_spend
    FROM customer c
    LEFT JOIN invoice i ON c.customerid = i.customerid
    GROUP BY cust_name
) gp_data
ORDER BY total_spend DESC;

/* 16. GENRE REVENUE CONTRIBUTION (%)
   Business Impact: Shows the true financial weight of each genre. 
   Essential for determining budget allocation for licensing content. */
SELECT 
    g.name AS genre_name, 
    SUM(il.UnitPrice * il.Quantity) AS total_rev,
    ROUND(SUM(il.UnitPrice * il.Quantity) * 100.0 / SUM(SUM(il.UnitPrice * il.Quantity)) OVER(), 2) AS pct_contribution
FROM genre g
LEFT JOIN track t ON g.GenreId = t.GenreId
JOIN invoiceline il ON t.TrackId = il.TrackId
GROUP BY g.name;

/* 17. TOP ARTIST BY COUNTRY (USA & CANADA)
   Business Impact: Identifies regional superstars. Allows for 
   targeted "Artist Takeover" events in specific geographic regions. */
SELECT *
FROM (
    SELECT 
        a.name AS artist_name,
        i.BillingCountry,
        SUM(il.UnitPrice * il.Quantity) AS total_rev,
        ROW_NUMBER() OVER (PARTITION BY i.BillingCountry ORDER BY SUM(il.UnitPrice * il.Quantity) DESC) AS rn
    FROM artist a
    LEFT JOIN album al ON a.ArtistId = al.ArtistId
    JOIN track t ON al.AlbumId = t.AlbumId
    JOIN invoiceline il ON t.TrackId = il.TrackId
    JOIN invoice i ON il.InvoiceId = i.InvoiceId
    WHERE i.BillingCountry IN ('USA', 'Canada')
    GROUP BY a.name, i.BillingCountry
) ranked
WHERE rn = 1;

/* 18. MONTHLY SALES GROWTH (%)
   Business Impact: Tracks business momentum. Identifying "dip" 
   months allows the business to schedule sales or clearance events. */
WITH monthly_data AS (
    SELECT DATE_FORMAT(invoicedate, '%Y-%m') AS year_mon, SUM(total) AS total_rev
    FROM invoice
    GROUP BY year_mon
)
SELECT 
    year_mon, total_rev,
    LAG(total_rev) OVER (ORDER BY year_mon) AS prev_month_rev,
    ROUND((total_rev - LAG(total_rev) OVER (ORDER BY year_mon)) * 100.0 / LAG(total_rev) OVER (ORDER BY year_mon), 2) AS per_growth
FROM monthly_data;

/* 19. GENRE EXPLORER AUDIT (DIVERSE LISTENERS)
   Business Impact: Identifies "Omnivores"—customers who explore 
   multiple genres. These are perfect candidates for personalized "Discovery" playlists. */
SELECT 
    c.CustomerId AS cust_id,
    CONCAT(c.firstname, ' ', c.lastname) AS cust_name,
    COUNT(DISTINCT g.GenreId) AS genre_count
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
JOIN invoiceline il ON i.InvoiceId = il.InvoiceId
JOIN track t ON il.TrackId = t.TrackId
JOIN genre g ON t.GenreId = g.GenreId
GROUP BY cust_id, cust_name
HAVING COUNT(DISTINCT g.genreid) > 5;

/* 20. ALBUM PRICING EFFICIENCY
   Business Impact: Checks for pricing consistency. If an album has 
   a high rank (expensive tracks), we audit if the content quality matches the price. */
WITH album_price AS (
    SELECT a.Title AS album_name, AVG(t.UnitPrice) AS avg_price
    FROM album a
    JOIN track t ON a.AlbumId = t.AlbumId
    GROUP BY a.Title
)
SELECT album_name, ROUND(avg_price, 2) AS avg_price,
       DENSE_RANK() OVER (ORDER BY avg_price DESC) AS price_rank
FROM album_price;