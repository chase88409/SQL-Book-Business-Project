/*
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    DDL Script: Create Gold Layer Views
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Purpose: 
    This script creates the views for the Gold Layer in the data warehouse.
    Gold Layer represents the final dimension and fact tables for Star Schema.

    Each view performs transformations and combines data from the Silver layer
    to produce business-ready datasets that has been cleaned and enriched.

Usage: 
	Views can be queried directly for analytics and reporting.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

-- ============================================================================
-- Create Dimension named: gold.fact_book_buying
-- ============================================================================
IF OBJECT_ID('gold.fact_book_buying', 'V') IS NOT NULL
    DROP VIEW gold.fact_book_buying;
GO

CREATE VIEW gold.fact_book_buying AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY bought_date) AS buy_key, --Surrogate Key
	bought_date AS Date_Bought,
	UPPER(place) AS Place,
	title AS Book_Title,
	price AS Purchase_Price,
	sold AS Sold_Price,
	shipping AS Shipping_Fee,
	commission AS EBay_Commission,
	ship AS Shipping_Cost,
	net AS Profit
FROM silver.bought
GO

-- ============================================================================
-- Create Dimension named: gold.fact_expenses
-- ============================================================================
IF OBJECT_ID('gold.fact_expenses', 'V') IS NOT NULL
    DROP VIEW gold.fact_expenses;
GO

CREATE VIEW gold.fact_expenses AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY exp_date) AS expense_key, --Surrogate Key
	exp_date AS Buy_Date,
	UPPER(exp_store) AS Store,
	exp_price AS Price,
	exp_tax AS Tax,
	exp_total AS Total,
	exp_object AS Object,
	exp_per_unit AS Price_per_unit
FROM silver.expenses
GO

-- ============================================================================
-- Create Dimension named: gold.dim_customers
-- ============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY sls_date) AS customer_key, --Surrogate Key
	sls_date AS Order_Date,
	cst_name AS Full_Name,
	cst_address AS Street_Address,
	UPPER(cst_city) AS City,
	cst_state AS 'State',
	cst_zip as Zip_Code
FROM silver.sales_2010
WHERE cst_state IS NOT NULL
	AND cst_state != '' -- Removes sales where customer info was not recorded
GO

-- ============================================================================
-- Create Dimension named: gold.fact_sales
-- ============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY sls_date) AS sale_key, --Surrogate Key
	sls_date AS Sales_Date,
	sls_title AS Book_Title,
	sls_author AS Author,
	sls_price AS Price,
	sls_ship_fee AS Shipping_Fee,
	sls_commission AS Ebay_Commission,
	sls_ship_cost AS Shipping_Cost,
	sls_net as Profit
FROM silver.sales_2011
GO

-- ============================================================================
-- Create Dimension named: gold.dim_stock
-- ============================================================================
IF OBJECT_ID('gold.dim_stock', 'V') IS NOT NULL
    DROP VIEW gold.dim_stock;
GO

CREATE VIEW gold.dim_stock AS
SELECT
	ROW_NUMBER() OVER (ORDER BY ebay_id) AS stock_key, --Surrogate Key
	ebay_id AS 'E-bay_ID',
	product_id as UPC_or_ISBN,
	title AS Title_and_Author,
	price AS Listed_Price,
	condition AS Condition_of_Book,
	notes AS Notes_on_Book,
	ave_sold_price AS Average_Price,
	last_sold_price AS Last_Price
FROM silver.stock

GO

