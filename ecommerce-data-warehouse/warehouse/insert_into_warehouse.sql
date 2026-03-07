insert into warehouse.dim_customer (customer_id, full_name, email, country, created_at)
select customer_id, first_name || ' ' || last_name as full_name, email, country, created_at
from staging.customers on conflict(customer_id) do nothing;

insert into warehouse.dim_product (product_id, product_name, category, price)
select product_id, product_name, category, price 
from staging.products on conflict(product_id) do nothing;



insert into warehouse.dim_date (date_key, full_date, year, month, day)
select
    TO_CHAR(order_date, 'YYYYMMDD')::int as date_key,
    order_date::DATE as full_date,
    extract(year from order_date)::int as year,
    extract(month from order_date)::int as month,
    extract(day from order_date)::int as day
from staging.orders
group by order_date
on conflict (date_key) do nothing;


insert into warehouse.fact_orders(
    order_id, customer_key, product_key, date_key, quantity, total_amount)
select o.order_id, wc.customer_key, wp.product_key, to_char(o.order_date::date, 'yyyymmdd')::int as date_key,
 o.quantity, o.quantity * wp.price as total_amount 
from staging.orders o join warehouse.dim_customer wc on o.customer_id = wc.customer_id 
join warehouse.dim_product as wp on o.product_id = wp.product_id
on conflict do nothing;


INSERT INTO warehouse.dim_date (date_key, full_date, year, month, day)
SELECT DISTINCT
    TO_CHAR(order_date::date,'YYYYMMDD')::int AS date_key,
    order_date::date,
    EXTRACT(YEAR FROM order_date::date)::int,
    EXTRACT(MONTH FROM order_date::date)::int,
    EXTRACT(DAY FROM order_date::date)::int
FROM staging.orders
ON CONFLICT (date_key) DO NOTHING;

create index indx_fact_customer
on warehouse.fact_orders(customer_key);

create index indx_fact_product
on warehouse.fact_orders(product_key);

create index indx_fact_date
on warehouse.fact_orders(date_key);

