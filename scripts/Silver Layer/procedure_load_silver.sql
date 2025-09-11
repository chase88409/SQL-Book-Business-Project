/*
-------------------------------------------------------------------------------
Stored Procedure: Load Silver Layer from Bronze Layer
-------------------------------------------------------------------------------
Script Purpose:
	This stored procedure performs ETL process (Extract, Transform, Load)
	process to insert 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		+ Truncates Silver tables
		+ Insert transformed and cleaned data from Bronze into Silver tables.

Parameters: None

Execution Example:
	EXEC silver.load_silver;
-------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start DATETIME, @batch_end DATETIME;
	BEGIN TRY
		SET @batch_start = GETDATE();
		PRINT '****************************************************************';
		PRINT '                   LOADING SILVER LAYER';
		PRINT '****************************************************************';

-- Loading silver.bought
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.bought';
		TRUNCATE TABLE silver.bought;
		PRINT '>> Inserting Data Into: silver.bought';
		INSERT INTO silver.bought (
			bought_date,
			place,
			title,
			price,
			sold,
			shipping,
			commission,
			ship,
			net,
			notes
		)
		SELECT 
			CAST(bought_date AS DATE) AS bought_date,
			REPLACE(place,'60','59') AS place,
			UPPER(TRIM(title)) AS title,
			CAST(REPLACE(price,'$','') AS DECIMAL(10,2)) AS price,
			COALESCE(CAST(REPLACE(sold,'$','') AS DECIMAL(10,2)), 0.00) AS sold,
			COALESCE(
				CASE
					WHEN shipping LIKE '(%' THEN
						CAST(REPLACE(REPLACE(REPLACE(shipping,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
					ELSE
						CAST(REPLACE(shipping, '$','') AS DECIMAL(10,2))
				END,
				0.00
				) AS shipping, -- Changing shipping amounts without $ and (), while changing () values to negatives
			COALESCE(CAST(REPLACE(commission,'$','') AS DECIMAL(10,2)), 0.00) AS commission,
			COALESCE(CAST(REPLACE(ship,'$','') AS DECIMAL(10,2)), 0.00) AS ship,
			CASE
				WHEN net LIKE '(%' THEN
					CAST(REPLACE(REPLACE(REPLACE(net,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
				ELSE
					CAST(REPLACE(net, '$','') AS DECIMAL(10,2))
			END AS net,
			COALESCE(notes, '')
		FROM bronze.bought;
		DELETE FROM silver.bought
		WHERE bought_date IS NULL; -- Deletes subtotals so they are not included in table

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------------------------';

		--Loading silver.expenses
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.expenses';
		TRUNCATE TABLE silver.expenses;
		PRINT '>> Inserting Data Into: silver.expenses';
		INSERT INTO silver.expenses (
			exp_date,
			exp_store,
			exp_price,
			exp_tax,
			exp_total,
			exp_object,
			exp_per_unit
		)
		SELECT 
		CAST(exp_date as DATE) as exp_date,
		exp_store,
		CAST(REPLACE(exp_price,'$','') AS DECIMAL(10,2)) AS exp_price,
		CAST(REPLACE(exp_tax,'$','') AS DECIMAL(10,2)) AS exp_tax,
		CAST(REPLACE(exp_total,'$','') AS DECIMAL(10,2)) AS exp_total,
		exp_object,
		CASE WHEN exp_per_unit IS NOT NULL THEN CAST(REPLACE(exp_per_unit,'$','') AS DECIMAL(10,2))
			ELSE '0'
		END exp_per_unit
		FROM bronze.expenses;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------------------------';

		-- Loading silver.sales_2010
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.sales_2010';
		TRUNCATE TABLE silver.sales_2010;
		PRINT '>> Inserting Data Into: silver.sales_2010';
		INSERT INTO silver.sales_2010 (	
			sls_date,
			sls_title,
			sls_author,
			sls_price,
			sls_ship_fee,
			sls_commission,
			sls_ship_cost,
			sls_net,
			sls_upc,
			sls_myprice,
			sls_profit,
			sls_notes,
			cst_name,
			cst_address,
			cst_city,
			cst_state,
			cst_zip
		)
		SELECT 
			CAST(sls_date AS DATE) AS sls_date,
			UPPER(TRIM(sls_title)) AS sls_title,	
			COALESCE(UPPER(TRIM(sls_author)),'') AS sls_author,
			COALESCE(
				CASE
					WHEN sls_price LIKE '(%' THEN
						CAST(REPLACE(REPLACE(REPLACE(sls_price,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
					ELSE
						CAST(REPLACE(sls_price, '$','') AS DECIMAL(10,2))
				END,
				0.00
				) AS sls_price,
			COALESCE(
				CASE
					WHEN sls_ship_fee LIKE '(%' THEN
						CAST(REPLACE(REPLACE(REPLACE(sls_ship_fee,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
					ELSE
						CAST(REPLACE(sls_ship_fee, '$','') AS DECIMAL(10,2))
				END,
				0.00
				) AS sls_ship_fee,
			COALESCE(
				CASE
					WHEN sls_commission LIKE '(%' THEN
						CAST(REPLACE(REPLACE(REPLACE(sls_commission,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
					ELSE
						CAST(REPLACE(sls_commission, '$','') AS DECIMAL(10,2))
				END,
				0.00
				) AS sls_commission,
			COALESCE(
				CASE
					WHEN sls_ship_cost LIKE '(%' THEN
						CAST(REPLACE(REPLACE(REPLACE(sls_ship_cost,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
					ELSE
						CAST(REPLACE(sls_ship_cost, '$','') AS DECIMAL(10,2))
				END,
				0.00
				) AS sls_ship_cost,
			COALESCE(
				CASE
					WHEN sls_net LIKE '(%' THEN
						CAST(REPLACE(REPLACE(REPLACE(sls_net,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
					ELSE
						CAST(REPLACE(sls_net, '$','') AS DECIMAL(10,2))
				END,
				0.00
				) AS sls_net,
			COALESCE(sls_upc,'') AS sls_upc,
			CAST(REPLACE(sls_myprice, '$','') AS DECIMAL(10,2)) AS sls_myprice,
			COALESCE(
				CASE
					WHEN sls_profit LIKE '(%' THEN
						CAST(REPLACE(REPLACE(REPLACE(sls_profit,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
					ELSE
						CAST(REPLACE(sls_profit, '$','') AS DECIMAL(10,2))
				END,
				0.00
				) AS sls_profit,
			COALESCE(sls_notes,'') AS sls_notes,
			COALESCE(UPPER(TRIM(sls_name)),'') AS cst_name,
			COALESCE(UPPER(TRIM(sls_address)),'') AS cst_address,
			COALESCE(REPLACE(TRIM('"' FROM LEFT(sls_city, CHARINDEX(',', sls_city))),',',''),'') AS cst_city,
			UPPER(COALESCE(LTRIM(SUBSTRING(sls_city, CHARINDEX(',', sls_city) + 2, 2)),'')) AS cst_state,
			COALESCE(REPLACE(SUBSTRING(sls_city, PATINDEX('%[0-9]%', sls_city), LEN(sls_city)),'"',''),'') AS cst_zip
-- The above 3 lines takes city, state zipcode format and separates it into 3 different columns
		FROM bronze.sales_2010;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------------------------';

		--Loading silver.sales_2011
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.sales_2011';
		TRUNCATE TABLE silver.sales_2011;
		PRINT '>> Inserting Data Into: silver.sales_2011';
		INSERT INTO silver.sales_2011 (
			sls_date,
			sls_title,
			sls_author,
			sls_price,
			sls_ship_fee,
			sls_commission,
			sls_ship_cost,
			sls_net
			)
		SELECT
			CAST(sls_date AS DATE) AS sls_date,
			UPPER(TRIM(sls_title)) AS sls_title,
			COALESCE(UPPER(TRIM(sls_author)),'') AS sls_author,
			COALESCE(
					CASE
						WHEN sls_price LIKE '(%' THEN
							CAST(REPLACE(REPLACE(REPLACE(sls_price,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
						ELSE
							CAST(REPLACE(sls_price, '$','') AS DECIMAL(10,2))
					END,
					0.00
					) AS sls_price,
			COALESCE(
					CASE
						WHEN sls_ship_fee LIKE '(%' THEN
							CAST(REPLACE(REPLACE(REPLACE(sls_ship_fee,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
						ELSE
							CAST(REPLACE(sls_ship_fee, '$','') AS DECIMAL(10,2))
					END,
					0.00
					) AS sls_ship_fee,
			COALESCE(
					CASE
						WHEN sls_commission LIKE '(%' THEN
							CAST(REPLACE(REPLACE(REPLACE(sls_commission,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
						ELSE
							CAST(REPLACE(sls_commission, '$','') AS DECIMAL(10,2))
					END,
					0.00
					) AS sls_commission,
			COALESCE(
					CASE
						WHEN sls_ship_cost LIKE '(%' THEN
							CAST(REPLACE(REPLACE(REPLACE(sls_ship_cost,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
						ELSE
							CAST(REPLACE(sls_ship_cost, '$','') AS DECIMAL(10,2))
					END,
					0.00
					) AS sls_ship_cost,
			COALESCE(
					CASE
						WHEN sls_net LIKE '(%' THEN
							CAST(REPLACE(REPLACE(REPLACE(sls_net,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
						ELSE
							CAST(REPLACE(sls_net, '$','') AS DECIMAL(10,2))
					END,
					0.00
					) AS sls_net
		FROM bronze.sales_2011
		UNION ALL -- Combines sales information from 2010 and 2011 into one table
		SELECT
			CAST(sls_date AS DATE) AS sls_date,
			UPPER(TRIM(sls_title)) AS sls_title,
			COALESCE(UPPER(TRIM(sls_author)),'') AS sls_author,
			COALESCE(
					CASE
						WHEN sls_price LIKE '(%' THEN
							CAST(REPLACE(REPLACE(REPLACE(sls_price,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
						ELSE
							CAST(REPLACE(sls_price, '$','') AS DECIMAL(10,2))
					END,
					0.00
					) AS sls_price,
			COALESCE(
					CASE
						WHEN sls_ship_fee LIKE '(%' THEN
							CAST(REPLACE(REPLACE(REPLACE(sls_ship_fee,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
						ELSE
							CAST(REPLACE(sls_ship_fee, '$','') AS DECIMAL(10,2))
					END,
					0.00
					) AS sls_ship_fee,
			COALESCE(
					CASE
						WHEN sls_commission LIKE '(%' THEN
							CAST(REPLACE(REPLACE(REPLACE(sls_commission,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
						ELSE
							CAST(REPLACE(sls_commission, '$','') AS DECIMAL(10,2))
					END,
					0.00
					) AS sls_commission,
			COALESCE(
					CASE
						WHEN sls_ship_cost LIKE '(%' THEN
							CAST(REPLACE(REPLACE(REPLACE(sls_ship_cost,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
						ELSE
							CAST(REPLACE(sls_ship_cost, '$','') AS DECIMAL(10,2))
					END,
					0.00
					) AS sls_ship_cost,
			COALESCE(
					CASE
						WHEN sls_net LIKE '(%' THEN
							CAST(REPLACE(REPLACE(REPLACE(sls_net,'(',''), ')',''), '$', '') AS DECIMAL(10,2)) * -1
						ELSE
							CAST(REPLACE(sls_net, '$','') AS DECIMAL(10,2))
					END,
					0.00
					) AS sls_net
		FROM bronze.sales_2010
		ORDER BY sls_date

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------------------------';

		-- Loading silver.stock
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.stock';
		TRUNCATE TABLE silver.stock;
		PRINT '>> Inserting Data Into: silver.stock';
		INSERT INTO silver.stock(
			ebay_id,
			product_id,
			title,
			price,
			condition,
			notes,
			ave_sold_price,
			last_sold_price
		)
		SELECT 
			CAST(ebay_id AS INT) AS ebay_id,
			COALESCE(UPPER(product_id),'') AS product_id,
			REPLACE(UPPER(title),'"','') AS title,
			CAST(price AS DECIMAL(10,2)) AS price,
			condition,
			COALESCE(notes,'') AS notes,
			CAST(ave_sold_price AS DECIMAL(10,2)) AS ave_sold_price,
			CAST(last_sold_price AS DECIMAL(10,2)) AS last_sold_price
		FROM bronze.stock;
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> --------------------------------';

		SET @batch_end = GETDATE();
		PRINT '====================================';
		PRINT 'Loading Silver Layer is complete';
		PRINT '  - Total Load time: ' + CAST(DATEDIFF(SECOND, @batch_start, @batch_end) AS NVARCHAR) + ' seconds';
		PRINT '===================================='
	END TRY
	BEGIN CATCH
		PRINT '*******************************************'
		PRINT 'ERROR OCCCURED DURING LOADING SILVER LAYER'
		PRINT 'Error message' + ERROR_MESSAGE();
		PRINT 'Error message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '*******************************************';
	END CATCH
END



