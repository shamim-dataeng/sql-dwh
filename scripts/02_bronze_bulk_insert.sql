/* ==========================================================
   Bronze Layer - Data Load
   ========================================================== */
use datawarehouse;

-- to allow MySQL to read files locally , enable access to both client and server side 
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- CRM Customer Info
LOAD DATA LOCAL INFILE '<project_root>/datasets/crm/cust_info.csv'
INTO TABLE bronze_crm_cust_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- CRM Product Info 
LOAD DATA LOCAL INFILE '<project_root>/datasets/crm/prd_info.csv'
INTO TABLE bronze_crm_prd_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- CRM Sales Details
LOAD DATA LOCAL INFILE '<project_root>/datasets/crm/sales_details.csv'
INTO TABLE bronze_crm_sales_details
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ERP CUST_AZ12.csv
LOAD DATA LOCAL INFILE '<project_root>/datasets/erp/CUST_AZ12.csv'
INTO TABLE bronze_erp_cust_az12
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ERP LOC_A101.csv
LOAD DATA LOCAL INFILE '<project_root>/datasets/erp/LOC_A101.csv'
INTO TABLE bronze_erp_loc_a101
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ERP PX_CAT_G1V2.csv
LOAD DATA LOCAL INFILE '<project_root>/datasets/erp/PX_CAT_G1V2.csv'
INTO TABLE bronze_erp_px_cat_g1v2
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;