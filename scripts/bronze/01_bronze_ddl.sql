/* MySQL does not support this hierarchy ( DB -> Schema -> Tables )
dwh
  ├── bronze
  ├── silver
  ├── gold
  Workaround : create the datawarehouse but instead of schema's create tables to simulate the medallion architecture
*/

drop database if exists datawarehouse;
create database datawarehouse;
use datawarehouse;

-- Bronze layer(6 tables):

-- CRM source tables  

drop table if exists bronze_crm_cust_info;
create table bronze_crm_cust_info(
	cst_id int,
    cst_key varchar(50),
    cst_firstname varchar(50),
    cst_lastname varchar(50),
    cst_marital_status varchar(50),
    cst_gndr varchar(50),
    cst_create_date date
);
drop table if exists bronze_crm_prd_info;
create table bronze_crm_prd_info(
	prd_id int,
    prd_key varchar(50),
    prd_nm varchar(50),
    prd_cost int,
    prd_line varchar(50),
    prd_start_dt date,
    prd_end_dt date
);

drop table if exists bronze_crm_sales_details;
create table bronze_crm_sales_details(
	sls_ord_num varchar(50),
    sls_prd_key varchar(50),
    sls_cust_id int,
    sls_order_dt int,
    sls_ship_dt int,
    sls_due_dt int,
    sls_sales int,
    sls_quantity int,
    sls_price int
);

-- ERP source tables  

drop table if exists bronze_erp_cust_az12;
create table bronze_erp_cust_az12(
	cid varchar(50),
    bdate date,
    gen varchar(50)
);

drop table if exists bronze_erp_loc_a101;
create table bronze_erp_loc_a101(
	cid varchar(50),
    cntry varchar(50)
);

drop table if exists bronze_erp_px_cat_g1v2;
create table bronze_erp_px_cat_g1v2(
	id varchar(50),
    cat varchar(50),
    subcat varchar(50),
    maintenance varchar(50)
);