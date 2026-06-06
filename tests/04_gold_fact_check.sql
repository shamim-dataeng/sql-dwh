-- Check fact table for sales by joining it with the dimension tables for products and customers.

select *
from gold_fact_sales fs
left join gold_dim_customers dc
    on fs.customer_key = dc.customer_key
left join gold_dim_products dp
    on fs.product_key = dp.product_key;

-- 89816 rows in gold_fact_sales, which is the same as the number of rows in silver_crm_sales_details, indicating that all sales details have been included in the fact table in addition to additional attributes from the dimension tables.