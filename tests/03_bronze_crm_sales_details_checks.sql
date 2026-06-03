select* from bronze_crm_sales_details;
select* from bronze_crm_sales_details where sls_ord_num!=trim(sls_ord_num);
-- INFERENCE FROM ABOVE QUERY: no need to trim sls_ord_num col

select* from bronze_crm_sales_details where sls_prd_key not in (
	select prd_key from silver_crm_prd_info
);
-- INFERENCE FROM ABOVE QUERY: all prd_key values from silver_crm_prd_info can be connected with future silver_crm_sales_details sls_prd_key values as required

select * from bronze_crm_sales_details where sls_cust_id not in (
	select cst_id from silver_crm_cust_info
);
-- INFERENCE FROM ABOVE QUERY: all cst_id values from silver_crm_cust_info can be connected with future silver_crm_sales_details sls_cust_id values as required

-- sls_ship_dt,sls_due_dt and sls_order_dt are all int , need to cast them to date datatype
 select* from bronze_crm_sales_details where sls_order_dt=0;
 update bronze_crm_sales_details
 set sls_order_dt=null where sls_order_dt=0;

select* from bronze_crm_sales_details where sls_ship_dt=0;
select* from bronze_crm_sales_details where sls_due_dt=0;

-- length of int for three cols must be exactly 8 : year(4)-month(2)-date(2)
delete from bronze_crm_sales_details where length(sls_order_dt) !=8;
delete from bronze_crm_sales_details where length(sls_ship_dt) !=8;
delete from bronze_crm_sales_details where length(sls_due_dt) !=8;

-- business rule : sales = qty* price
select* from bronze_crm_sales_details where sls_sales!=sls_quantity*sls_price; 
