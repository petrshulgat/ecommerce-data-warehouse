create table staging.customers(
    customer_id integer,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    country varchar(100),
    created_at TIMESTAMP
);

create table staging.products(
    product_id integer,
    product_name varchar(200),
    category varchar(200),
    price decimal(10, 2)
);

create table staging.orders(
    order_id integer,
    customer_id integer,
    product_id integer,
    order_date TIMESTAMP,
    quantity INTEGER,
    unit_price decimal(10, 2),
    total_amount decimal(10, 2)
);
