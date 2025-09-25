/*
===============================================================================
Stock Analysis
===============================================================================
Purpose:
    - Find amount of books left listed on ebay when I quit selling
    - Analyze the worth of books left in stock
    - Number of books left in book_buying data
SQL Functions Used:
    - Conditional: CASE
    - Aggregate: COUNT, SUM, AVG
===============================================================================
*/

SELECT
    COUNT(Stock_Key) AS Total_Books, -- Number of books in stock
    SUM(Listed_Price) AS Total_listing_value, -- Total listing value of all books in stock
    SUM(Average_Price) AS Sum_of_Ave_Price,
    SUM(Last_Price) AS Sum_of_Last_Price
FROM gold.dim_stock

SELECT
     COUNT(CASE WHEN Sold_Price = 0 THEN 1 ELSE NULL END) AS Unsold_Books -- Books unsold from gold.fact_book_buying
FROM gold.fact_book_buying
-- Shows that many books were unaccounted for in book_buying table. At end of book business I stopped keeping track
-- of much of the data as I was working full time as a teacher. 
