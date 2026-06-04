-- 1. Load data into silver_crm_cust_info table from transformed bronze_crm_cust_info table. Similar insert statements will be created for other 5 tables in silver layer.

-- CRM tables loading

insert into silver_crm_cust_info(
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
select
		cst_id,
        cst_key,
        TRIM(cst_firstname) as firstname,
        TRIM(cst_lastname) as lastname,
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

insert into silver_crm_prd_info(
	prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
select 
	prd_id,
    replace(left(prd_key,5),'-','_')as cat_id,
    substring(prd_key,7,length(prd_key)) as prd_key,
    prd_nm,
    prd_cost,
    case
		when upper(trim(prd_line))='M' then 'Mountain'
		when upper(trim(prd_line))='R' then 'Road'
        when upper(trim(prd_line))='S' then 'Other Sales'
        when upper(trim(prd_line))='T' then 'Touring'
        else 'Unknown'
	end as prd_line,
    prd_start_dt,
    case
		when date_sub(LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt),interval 1 DAY)='0000-00-00' then null
		else date_sub(LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt),interval 1 DAY)
    end as prd_end_dt
from bronze_crm_prd_info;

-- ERP Tables loading 

insert into silver_crm_sales_details(
	sls_ord_num, 
	sls_prd_key,  
	sls_cust_id, 
	sls_order_dt, 
	sls_ship_dt, 
	sls_due_dt, 
	sls_sales,
	sls_quantity, 
	sls_price
)
select 
	sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    cast(cast(sls_order_dt as char) as date) as sls_order_date,
	cast(cast(sls_ship_dt as char) as date) as sls_ship_date,
    cast(cast(sls_due_dt as char) as date) as sls_due_date,
    case 
		when sls_sales <= 0 or sls_sales!=sls_quantity*abs(sls_price)
        then sls_quantity*abs(sls_price)
        else sls_sales
	end as sls_sales,
    sls_quantity,
    case
		when sls_price <=0 then sls_sales/nullif(sls_quantity,0)
		else sls_price
	end as sls_price
from bronze_crm_sales_details;


insert into silver_erp_cust_az12(
	cid,
    bdate,
    gen
)
select
	case 
		when cid like 'NAS%' then substring(cid,4,length(cid))
        else cid
	end as cid,
    case
		when bdate>now() then null
        else bdate
	end as bdate,
    case 
		when upper(trim(gen))='M' then 'Male'
        when upper(trim(gen))='F' then 'Female'
        when trim(gen)='' or gen is null then 'Unknown'
        else trim(gen)
	end as gen
from bronze_erp_cust_az12;

insert into silver_erp_loc_a101(
	cid,
    cntry
)
select
	replace(cid,'-','')as cid,
    case 
		when trim(cntry)='' then 'Unknown'
		else trim(cntry)
    end as cntry
from
bronze_erp_loc_a101;

insert into silver_erp_px_cat_g1v2(
	id,
    cat,
    subcat,
    maintenance
)
SELECT 
	id,
    cat,
    subcat,
    maintenance
FROM datawarehouse.bronze_erp_px_cat_g1v2;
