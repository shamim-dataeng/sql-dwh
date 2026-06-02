/* ==========================================================
   Bronze Layer - Data Load
   ========================================================== */
use datawarehouse;

-- to allow MySQL to read files locally , enable access to both client and server side 
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- CRM Customer Info

SET @start_time_1 = NOW(6);
truncate table bronze_crm_cust_info;

LOAD DATA LOCAL INFILE 'C:/Users/User/Desktop/sql-dwh/datasets/crm/cust_info.csv'
INTO TABLE bronze_crm_cust_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET @end_time_1 = NOW(6);

-- CRM Product Info 
SET @start_time_2 = NOW(6);
truncate table bronze_crm_prd_info;

LOAD DATA LOCAL INFILE 'C:/Users/User/Desktop/sql-dwh/datasets/crm/prd_info.csv'
INTO TABLE bronze_crm_prd_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET @end_time_2 = NOW(6);


-- CRM Sales Details
SET @start_time_3 = NOW(6);
truncate table bronze_crm_sales_details;

LOAD DATA LOCAL INFILE 'C:/Users/User/Desktop/sql-dwh/datasets/crm/sales_details.csv'
INTO TABLE bronze_crm_sales_details
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET @end_time_3 = NOW(6);

-- ERP CUST_AZ12 
SET @start_time_4 = NOW(6);
truncate table bronze_erp_cust_az12;

LOAD DATA LOCAL INFILE 'C:/Users/User/Desktop/sql-dwh/datasets/erp/CUST_AZ12.csv'
INTO TABLE bronze_erp_cust_az12
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET @end_time_4 = NOW(6);

-- ERP LOC_A101
SET @start_time_5 = NOW(6);
truncate table bronze_erp_loc_a101;

LOAD DATA LOCAL INFILE 'C:/Users/User/Desktop/sql-dwh/datasets/erp/LOC_A101.csv'
INTO TABLE bronze_erp_loc_a101
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET @end_time_5 = NOW(6);

-- ERP PX_CAT_G1V2
SET @start_time_6 = NOW(6);
truncate table bronze_erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE 'C:/Users/User/Desktop/sql-dwh/datasets/erp/PX_CAT_G1V2.csv'
INTO TABLE bronze_erp_px_cat_g1v2
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET @end_time_6 = NOW(6);

with latency_for_loading_each_table as (
	SELECT TIMESTAMPDIFF(MICROSECOND, @start_time_1, @end_time_1)/1000 AS load_latency_ms
	UNION
	SELECT TIMESTAMPDIFF(MICROSECOND, @start_time_2, @end_time_2)/1000
	UNION
	SELECT TIMESTAMPDIFF(MICROSECOND, @start_time_3, @end_time_3)/1000
	UNION
	SELECT TIMESTAMPDIFF(MICROSECOND, @start_time_4, @end_time_4)/1000
	UNION
	SELECT TIMESTAMPDIFF(MICROSECOND, @start_time_5, @end_time_5)/1000
	UNION
	SELECT TIMESTAMPDIFF(MICROSECOND, @start_time_6, @end_time_6)/1000
)
select avg(load_latency_ms) from latency_for_loading_each_table;