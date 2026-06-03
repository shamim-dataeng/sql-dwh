-- 1. customer information table (bronze_crm_cust_info) quality analysis

-- fetch the rows to check for quality issues 
select * from bronze_crm_cust_info;

-- to check the quality of the data in the bronze_crm_cust_info table, we can perform the following checks:
-- i) Null check for all columns 
-- ii) PK - cst_id must be unique i.e. no duplicacies check 
-- iii) Check for unwanted spaces in varchar/string values
-- iv) Date sanity check - no date > NOW() 

SELECT 'cst_id' AS column_name,
       CASE 
			WHEN COUNT(cst_id) = COUNT(*) THEN 'no nulls'
            ELSE 'nulls exist'
       END AS status
FROM bronze_crm_cust_info

UNION ALL

SELECT 'cst_key',
       CASE 
			WHEN COUNT(cst_key) = COUNT(*) THEN 'no nulls'
            ELSE 'nulls exist'
       END
FROM bronze_crm_cust_info

UNION ALL

SELECT 'cst_firstname',
       CASE 
			WHEN COUNT(cst_firstname) = COUNT(*) THEN 'no nulls'
            ELSE 'nulls exist'
       END
FROM bronze_crm_cust_info

UNION ALL

SELECT 'cst_lastname',
       CASE 
			WHEN COUNT(cst_lastname) = COUNT(*) THEN 'no nulls'
            ELSE 'nulls exist'
       END
FROM bronze_crm_cust_info

UNION ALL

SELECT 'cst_marital_status',
       CASE 
			WHEN COUNT(cst_marital_status) = COUNT(*) THEN 'no nulls'
            ELSE 'nulls exist'
       END
FROM bronze_crm_cust_info

UNION ALL

SELECT 'cst_gndr',
       CASE 
			WHEN COUNT(cst_gndr) = COUNT(*) THEN 'no nulls'
            ELSE 'nulls exist'
       END
FROM bronze_crm_cust_info

UNION ALL

SELECT 'cst_create_date',
       CASE 
			WHEN COUNT(cst_create_date) = COUNT(*) THEN 'no nulls'
            ELSE 'nulls exist'
       END
FROM bronze_crm_cust_info;
-- INFERENCE FROM ABOVE QUERY: null values exist in cst_create_date

select 
	cst_id,
    count(cst_id) as cnt
from bronze_crm_cust_info
group by cst_id
having cnt>1;
-- INFERENCE FROM ABOVE QUERY: There are multiple duplicates in cst_id (PK) col of bronze_crm_cust_info

select count(*) from bronze_crm_cust_info where length(cst_firstname)!=length(trim(cst_firstname));
-- INFERENCE FROM ABOVE QUERY: cst_firstname needs trimming 

select count(*) from bronze_crm_cust_info where length(cst_lastname)!=length(trim(cst_lastname));
-- INFERENCE FROM ABOVE QUERY: cst_lastname needs trimming 

select count(*) from bronze_crm_cust_info where length(cst_marital_status)!=length(trim(cst_marital_status));
select count(*) from bronze_crm_cust_info where length(cst_gndr)!=length(trim(cst_gndr));
-- INFERENCE FROM ABOVE QUERIES: both marital status and gender fields do not need trimming  

SELECT *
FROM bronze_crm_cust_info
WHERE cst_create_date > NOW();
-- INFERENCE FROM ABOVE QUERY: date is sanitized 

select distinct cst_gndr from bronze_crm_cust_info;
-- INFERENCE FROM ABOVE QUERY: gender column does not have any garbage value

SET sql_mode = '';
SET SQL_SAFE_UPDATES =0;
delete from bronze_crm_cust_info where cst_create_date='0000-00-00';
select distinct cst_create_date from bronze_crm_cust_info;

/* SUMMARY OF QUALITY CHECKS FOR bronze_crm_cust_info:

1. Null values exist in cst_create_date column which needs to be handled before loading into silver layer. We can either drop those records or impute with a default value based on the business requirement. 
2. There are multiple duplicates in cst_id (PK) column which needs to be handled before loading into silver layer. We can either drop those records or assign a new unique id to those records based on the business requirement. 
3. cst_firstname and cst_lastname columns need trimming to remove unwanted spaces. We can use TRIM function to handle this before loading into silver layer. 
4. Date is sanitized and does not have any future date which is good.   
5. Gender column does not have any garbage value and looks good.
*/