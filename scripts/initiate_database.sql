/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'BookBiz' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'BookBiz' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'BookBiz' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'BookBiz')
BEGIN
    ALTER DATABASE BookBiz SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BookBiz;
END;
GO

-- Create the 'BookBiz' database
CREATE DATABASE BookBiz;
GO

USE BookBiz;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
