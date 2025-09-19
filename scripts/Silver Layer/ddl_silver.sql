
/*
------------------------------------------------------------------------------------
DDL Script: Creates Silver tables
------------------------------------------------------------------------------------
Script Purpose:
	This creates tables in the 'silver' schema. dropping existing tables if they 
	already exists.

	Run this script to re-define the DDL structure of 'silver' tables.
------------------------------------------------------------------------------------
*/
USE BookBiz
IF OBJECT_ID ('silver.sales_2011','U') IS NOT NULL
	DROP TABLE silver.sales_2011;
GO

CREATE TABLE silver.sales_2011 (
	sls_date DATE,
	sls_title NVARCHAR(400),
	sls_author NVARCHAR(100),
	sls_price DECIMAL(10,2),
	sls_ship_fee DECIMAL(10,2),
	sls_commission DECIMAL(10,2),
	sls_ship_cost DECIMAL(10,2),
	sls_net DECIMAL(10,2)
);
GO

IF OBJECT_ID ('silver.sales_2010','U') IS NOT NULL
	DROP TABLE silver.sales_2010;
GO

CREATE TABLE silver.sales_2010 (
	sls_date DATE,
	sls_title NVARCHAR(100),
	sls_author NVARCHAR(100),
	sls_price DECIMAL(10,2),
	sls_ship_fee DECIMAL(10,2),
	sls_commission DECIMAL(10,2),
	sls_ship_cost DECIMAL(10,2),
	sls_net DECIMAL(10,2),
	sls_upc NVARCHAR(50),
	sls_myprice DECIMAL(10,2),
	sls_profit DECIMAL(10,2),
	sls_notes NVARCHAR(100),
	cst_name NVARCHAR(50),
	cst_address NVARCHAR(150),
	cst_city NVARCHAR(150),
	cst_state NVARCHAR(4),
	cst_zip NVARCHAR(15)
);
GO

IF OBJECT_ID ('silver.stock','U') IS NOT NULL
	DROP TABLE silver.stock;
GO

CREATE TABLE silver.stock (
	ebay_id INT,
	product_id NVARCHAR(50),
	title NVARCHAR(500),
	price DECIMAL(10,2),
	condition NVARCHAR(50),
	notes NVARCHAR(500),
	ave_sold_price DECIMAL(10,2),
	last_sold_price DECIMAL(10,2)
);
GO

IF OBJECT_ID ('silver.bought','U') IS NOT NULL
	DROP TABLE silver.bought;
GO

CREATE TABLE silver.bought (
	bought_date DATE,
	place NVARCHAR(50),
	title NVARCHAR(200),
	price DECIMAL(10,2),
	sold DECIMAL(10,2),
	shipping DECIMAL(10,2),
	commission DECIMAL(10,2),
	ship DECIMAL(10,2),
	net DECIMAL(10,2),
	notes NVARCHAR(200)

);
GO
IF OBJECT_ID ('silver.expenses','U') IS NOT NULL
	DROP TABLE silver.expenses;
GO

CREATE TABLE silver.expenses (
	exp_date DATE,
	exp_store NVARCHAR(50),
	exp_price DECIMAL(10,2),
	exp_tax DECIMAL(10,2),
	exp_total DECIMAL(10,2),
	exp_object NVARCHAR(50),
	exp_per_unit DECIMAL(10,2)
);

GO


