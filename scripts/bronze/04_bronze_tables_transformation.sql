/*
============================== 1. bronze_crm_cust_info table transformation ========================================
*/

with transformed_bronze_crm_cust_info as (
	select
		cst_id,
        cst_key,
        TRIM(cst_firstname) as trimmed_firstname,
        TRIM(cst_lastname) as trimmed_lastname,
        case
			when upper(cst_marital_status)='M' then 'Married'
            when upper(cst_marital_status)='S' then 'Single'
            else 'Unknown'
		end as cst_marital_status,
        case
			when upper(cst_gndr)='F' then 'Female'
            when upper(cst_gndr)='M' then 'Male'
            else 'Unknown'
		end as cst_gndr,
        cst_create_date
    from (
		select*,
			row_number() over(partition by cst_id order by cst_create_date desc) ranking
		from 
		bronze_crm_cust_info
	)t where ranking=1
)
select * from transformed_bronze_crm_cust_info