/*
===============================================================================
Buying Analysis
===============================================================================
Purpose:
    - To rank places to buy books based on profit or other metrics.
    - To identify top performers or laggards.
    - Tells me which places to buy books from if I decide to continue my venture
      into book selling

SQL Functions Used:
    - Conditional: CASE
    - Aggregate: COUNT, SUM, AVG
    - Scalar: ABS
    - Clauses: GROUP BY, ORDER BY
    - Data Type conversion: CAST
===============================================================================
*/

SELECT
    Place,
    COUNT(Place) AS Total_Books, -- Number of books bought from each place
    SUM(Purchase_Price) AS Total_Cost, -- Total cost for books from each place
    CAST(AVG(Purchase_Price) AS DECIMAL(6,2)) AS Cost_per_Book, -- Calculates average price per book bought from each place
    COUNT(CASE WHEN Sold_Price > 0 THEN 1 ELSE NULL END) AS Books_Sold, -- Books sold from each place
    COUNT(CASE WHEN Sold_Price = 0 THEN 1 ELSE NULL END) AS Unsold_Books, -- Books unsold from each place
    SUM(Sold_Price) AS Total_Sold_Price, -- Sum of all sale prices
    SUM(CASE WHEN Profit > 0 THEN Profit ELSE 0 END) AS Profit_from_Sales, -- Total profit for only books that sold
    SUM(CASE WHEN Profit <= 0 THEN ABS(Profit) ELSE 0 END) AS Cost_of_Unsold, -- Total cost of unsold books
    CAST(AVG(Profit) AS DECIMAL(6,2)) AS Profit_per_Book, -- Profit per book purchased
    SUM(Profit) AS Total_Profit -- Sum of profits from each sale
FROM gold.fact_book_buying
GROUP BY Place
ORDER BY Total_Profit DESC;
