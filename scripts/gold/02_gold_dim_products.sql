/*
 This view is the dimension table for products. 
 It contains all the attributes related to products, including product ID, category ID, product number, product name, product category, product subcategory, product maintenance status, product line, cost, start date, end date, and a flag indicating whether the product is current or not. 
 The product key is generated using the row_number() function, which assigns a unique sequential integer to rows in the result set. 
 The view combines data from the silver CRM product information table and the silver ERP product category table using a left join on the category ID.
*/
CREATE VIEW gold_dim_products as (
	select
		row_number() over(order by prd_id) as product_key,
		pi.prd_id as product_id,
		pi.cat_id as category_id,
		pi.prd_key as product_number,
		pi.prd_nm as product_name,
		px.cat as product_category,
		px.subcat as product_subcat,
		px.maintenance as product_maintenance,
		pi.prd_line as product_line,
		pi.prd_cost as cost,
		pi.prd_start_dt as start_date,
		pi.prd_end_dt as end_date,
		case
			when pi.prd_end_dt is null then 'Y'
			else 'N'
		end as is_current
	from silver_crm_prd_info as pi left join silver_erp_px_cat_g1v2 px 
	on pi.cat_id=px.id
);