/*
------------------------------------------------------------------------------------
DDL Script: Creates Bronze tables
------------------------------------------------------------------------------------
Script Purpose:
	This creates tables in the 'bronze' schema. dropping existing tables if they 
	already exists.

	Run this script to re-define the DDL structure of 'bronze' tables.
------------------------------------------------------------------------------------
*/

IF OBJECT_ID ('bronze.sales_2011','U') IS NOT NULL
	DROP TABLE bronze.sales_2011;
GO

CREATE TABLE bronze.sales_2011 (
	sls_date NVARCHAR(50),
	sls_title NVARCHAR(100),
	sls_author NVARCHAR(100),
	sls_price NVARCHAR(50)
);
GO

IF OBJECT_ID ('bronze.sales_2010','U') IS NOT NULL
	DROP TABLE bronze.sales_2010;
GO

CREATE TABLE bronze.sales_2010 (
	sls_date NVARCHAR(50),
	sls_title NVARCHAR(100),
	sls_author NVARCHAR(100),
	sls_price NVARCHAR(50),
	sls_ship_fee NVARCHAR(50),
	sls_commission NVARCHAR(50),
	sls_ship_cost NVARCHAR(50),
	sls_net NVARCHAR(50),
	sls_upc NVARCHAR(50),
	sls_myprice NVARCHAR(50),
	sls_profit NVARCHAR(50),
	sls_notes NVARCHAR(100),
	sls_name NVARCHAR(50),
	sls_address NVARCHAR(150),
	sls_city NVARCHAR(150)
);
GO

IF OBJECT_ID ('bronze.stock','U') IS NOT NULL
	DROP TABLE bronze.stock;
GO

CREATE TABLE bronze.stock (
	ebay_id NVARCHAR(50),
	product_id NVARCHAR(50),
	title NVARCHAR(500),
	price NVARCHAR(50),
	condition NVARCHAR(50),
	notes NVARCHAR(500),
	ave_sold_price NVARCHAR(50),
	last_sold_price NVARCHAR(50)
);
GO

IF OBJECT_ID ('bronze.bought','U') IS NOT NULL
	DROP TABLE bronze.bought;
GO

CREATE TABLE bronze.bought (
	bought_date NVARCHAR(50),
	place NVARCHAR(50),
	title NVARCHAR(200),
	price NVARCHAR(50),
	sold NVARCHAR(50),
	shipping NVARCHAR(50),
	commission NVARCHAR(50),
	ship NVARCHAR(50),
	net NVARCHAR(50),
	notes NVARCHAR(200)

);
GO
IF OBJECT_ID ('bronze.expenses','U') IS NOT NULL
	DROP TABLE bronze.expenses;
GO

CREATE TABLE bronze.expenses (
	exp_date NVARCHAR(50),
	exp_store NVARCHAR(50),
	exp_price NVARCHAR(50),
	exp_tax NVARCHAR(50),
	exp_total NVARCHAR(50),
	exp_object NVARCHAR(50),
	exp_per_unit NVARCHAR(50)
);

GO
