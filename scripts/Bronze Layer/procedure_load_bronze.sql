/*
-------------------------------------------------------------------------------------------------------
Stored Procedure: Load Bronze Layer (Source -> Bronze)
-------------------------------------------------------------------------------------------------------
Script Purpose:  
	This stored procedure will load data into the 'bronze' Schema from an external .csv file.
	Performs the following actions:
	- Truncates the bronze tables for loading data.
	- Uses the 'BULK INSERT' command to load data from csv files to bronze tables.
	- Prints out load times for each table and total time for all tables.
Parameters:
	This stored procedure does not accept any parameters or return any values.
Usage Example:
	EXEC bronze.load_bronze;
-------------------------------------------------------------------------------------------------------
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '==============================================';
		PRINT 'Loading Bronze Layer';
		PRINT '==============================================';
	
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.bought';
		TRUNCATE TABLE bronze.bought;
		
		PRINT '>> Inserting data into Table: bronze.bought';
		BULK INSERT bronze.bought
		FROM 'C:\Users\marta\OneDrive\Escritorio\sql-book-biz-project\datasets\book_buying.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.expenses';
		TRUNCATE TABLE bronze.expenses;
	
		PRINT '>> Inserting data into Table: bronze.expenses';
		BULK INSERT bronze.expenses
		FROM 'C:\Users\marta\OneDrive\Escritorio\sql-book-biz-project\datasets\packaging_expenses.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------';
	
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.sales_2010';
		TRUNCATE TABLE bronze.sales_2010;

		PRINT '>> Inserting data into Table: bronze.sales_2010';
		BULK INSERT bronze.sales_2010
		FROM 'C:\Users\marta\OneDrive\Escritorio\sql-book-biz-project\datasets\sales_2010.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.sales_2011';
		TRUNCATE TABLE bronze.sales_2011
	
		PRINT '>> Inserting Data into Table: bronze.sales_2011';
		BULK INSERT bronze.sales_2011
		FROM 'C:\Users\marta\OneDrive\Escritorio\sql-book-biz-project\datasets\sales_2011.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.stock';
		TRUNCATE TABLE bronze.stock
	
		PRINT '>> Inserting Data into Table: bronze.stock';
		BULK INSERT bronze.stock
		FROM 'C:\Users\marta\OneDrive\Escritorio\sql-book-biz-project\datasets\remaining_stock.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> ---------------------------';


		SET @batch_end_time = GETDATE();
		PRINT '================================';
		PRINT 'Loading Bronze Layer is Complete';
		PRINT '  - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=================================';

	END TRY
	BEGIN CATCH
		PRINT '=================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
	END CATCH
END
