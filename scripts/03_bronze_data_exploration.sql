-- Explore and Analyze data from the bronze for creating the integration diagram and understanding the data for the next steps of the project.

use datawarehouse;
select * from bronze_crm_cust_info limit 5000;
select * from bronze_crm_prd_info limit 5000;
select * from bronze_crm_sales_details limit 5000;
select * from bronze_erp_cust_az12 limit 5000;
select * from bronze_erp_loc_a101 limit 5000;
select * from bronze_erp_px_cat_g1v2 limit 5000;