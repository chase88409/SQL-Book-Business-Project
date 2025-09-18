/*
===============================================================================
Sales Analysis
===============================================================================
Purpose:
  - To identify top customer's states to focus on with shipping
	- To identify best selling books and authors to focus on for future
	  book buying.
	- Find commonalities between the highest selling books to focus book 
	  buying on in the future.

SQL Functions Used:
  - Clauses: GROUP BY, ORDER BY, TOP, WHERE
	- Aggregate: COUNT
===============================================================================
*/

-- What are the top 5 states that orders came from?
SELECT TOP 5
States AS Top_States, 
COUNT(*) AS sales_count
FROM gold.dim_customers
WHERE States IS NOT NULL
	AND States != ''
GROUP BY States
ORDER BY sales_count DESC;

-- What are the top 5 most frequently sold book titles?
SELECT TOP 5 
Book_Title AS Top_Books_Sold,
Author AS Author,
COUNT(*) AS book_count
FROM gold.fact_sales
GROUP BY Book_Title, Author
ORDER BY book_count DESC;

-- What are the top 5 most frequently sold authors?
SELECT TOP 5 
Author AS Top_Authors_Sold, 
COUNT(*) AS author_count
FROM gold.fact_sales
WHERE Author IS NOT NULL
	AND Author != ''
	AND Author != 'MANY'
GROUP BY Author
ORDER BY author_count DESC;

-- What are the top 20 highest priced books sold?
SELECT TOP 20 
Book_Title AS Title_Top_20,
Author AS Author,
Price AS Highest_Price_Sold 
FROM gold.fact_sales
ORDER BY Price DESC;
