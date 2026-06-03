SELECT * FROM bronze_crm_prd_info;

select prd_id,count(prd_id) from bronze_crm_prd_info group by prd_id having count(prd_id)>1;
-- INFERENCE FROM ABOVE QUERY: no duplicates in the PK prd_id

select prd_nm from bronze_crm_prd_info
where length(prd_nm)!=length(trim(prd_nm));
-- INFERENCE FROM ABOVE QUERY: it is fine, there are no unnecessary leading or trailing whitespaces. no need to trim!

 select * from bronze_crm_prd_info where prd_cost <= 0 or prd_cost is null;
 -- INFERENCE FROM ABOVE QUERY: automatically null values are defaulted to 0 while bulkk loading file so not an issue!
 
select distinct prd_line from bronze_crm_prd_info;
select * from bronze_crm_prd_info where prd_line='';
-- INFERENCE FROM ABOVE QUERY: discuss with source experts for M,R,S,T abbr. and handle empty cells 

select * from bronze_crm_prd_info 
where prd_start_dt > prd_end_dt;
-- INFERENCE FROM ABOVE QUERY: SCD TYPE-2 is being used here, but start_date>end_date makes no sense so use lead and lag to clean up so that it works and consult with the source expert about the same!

select * from bronze_crm_prd_info 
where prd_end_dt ='0000-00-00';
-- INFERENCE FROM ABOVE QUERY: end_date='0000-00-00' means to current day i.e. null ( it has not ended)

update bronze_crm_prd_info
set prd_end_dt = NULL where prd_end_dt='0000-00-00';

-- brainstorm a solution to fix entries where start_dt > end_dt BY ISOLATING TWO PRD_KEYS:
select
	prd_id,
    prd_key,
    prd_nm,
    prd_start_dt,
    prd_end_dt,
    date_sub(LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt),interval 1 DAY) as test
from bronze_crm_prd_info
where prd_key in ('AC-HE-HL-U509-R','AC-HE-HL-U509')

/* SUMMARY OF QUALITY CHECKS FOR bronze_crm_prd_info:
1. No duplicates in the PK prd_id
2. prd_nm column does not have unnecessary leading or trailing whitespaces, so no need to trim
3. prd_cost column has null values defaulted to 0 during bulk loading, so it is not an issue
4. prd_line column has some empty cells and it is important to discuss with source experts about the meaning of M,R,S,T abbr. and handle empty cells accordingly
5. There are some records where prd_start_dt is greater than prd_end_dt which does not make sense. It is important to use lead and lag functions to clean up those records and consult with source experts about the same to understand the business logic behind it.
6. prd_end_dt column has '0000-00-00' value which means current day or null (it has not ended). It is important to update those values to null for better understanding and handling in the future.
*/