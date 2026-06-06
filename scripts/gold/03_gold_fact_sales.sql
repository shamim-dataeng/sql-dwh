SHOW COLUMNS FROM silver_crm_sales_details; -- useful command to get the columns of a table 
-- flow: DIMENSION KEYS -> DATES -> MEASURES
CREATE VIEW gold_fact_sales AS(
	select 
		sd.sls_ord_num as order_number,
		dp.product_key, -- use the surrogate key from dim_products
		dc.customer_key, -- use the surrogate key from dim_customers
		sd.sls_order_dt as order_date,
		sd.sls_ship_dt as ship_date,
		sd.sls_due_dt as due_date,
		sd.sls_sales as sales,
		sd.sls_quantity as quantity,
		sd.sls_price as price
	from silver_crm_sales_details sd
	left join gold_dim_products dp on sd.sls_prd_key=dp.product_number
	left join gold_dim_customers dc on sd.sls_cust_id=dc.customer_id
);
/*
 * This view creates the fact table for sales in the gold layer.
 * It combines data from the silver CRM sales details table with the dimension tables for products and customers.
 * The view includes the order number, surrogate keys for product and customer, order date, ship date, due date, sales amount, quantity, and price.
 * The surrogate keys are obtained by joining the sales details with the dimension tables on the appropriate keys (product number and customer ID).
 */