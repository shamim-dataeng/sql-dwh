/*
 * This view creates the dimension table for customers in the gold layer.
 * It combines data from the silver CRM customer information, ERP customer AZ12, and ERP location A101 tables.
 * The view includes a SURROGATE KEY (customer_key) generated using row_number(), and various attributes of customers such as their ID, name, country, marital status, gender, birth date, and creation date.
 */ 

CREATE VIEW gold_dim_customers as (
	select
		row_number() over(order by cst_id) as customer_key,
		ci.cst_id as customer_id,
		ci.cst_key as customer_number,
		ci.cst_firstname as first_name,
		ci.cst_lastname as last_name,
		cloc.cntry as country,
		ci.cst_marital_status as marital_status,
		ci.cst_gndr as gender,
		caz.bdate as birth_date,
		ci.cst_create_date as creation_date
	from
	silver_crm_cust_info as ci
	left join silver_erp_cust_az12 caz on ci.cst_key = caz.cid
	left join silver_erp_loc_a101 cloc on ci.cst_key = cloc.cid
);



