create table warehouse.dim_product (
    product_key integer generated always as identity primary key,
    product_id integer NOT NULL,
    product_name varchar(200),
    category varchar(200),
    price DECIMAL(10, 2)
);

create table warehouse.dim_customer(
    customer_key integer generated always as identity primary key,
    customer_id integer not null,
    full_name varchar(200),
    email varchar(100),
    country varchar(100),
    created_at TIMESTAMP
);


create table warehouse.dim_date(
    date_key integer primary key,
    full_date date,
    year int,
    month int,
    day int
);

create table warehouse.fact_orders(
    order_key integer generated always as identity primary key,
    order_id integer NOT NULL,
    customer_key integer not null,
    product_key integer not null,
    date_key integer not null,
    quantity integer,
    unit_price decimal(10, 2),
    total_amount decimal(10, 2),
    foreign key (customer_key) REFERENCES warehouse.dim_customer(customer_key),
    foreign key (product_key) REFERENCES warehouse.dim_product(product_key),
    foreign key (date_key) REFERENCES warehouse.dim_date(date_key)
);

ALTER TABLE warehouse.dim_customer
ADD CONSTRAINT uq_customer_id UNIQUE (customer_id);

ALTER TABLE warehouse.dim_product
ADD CONSTRAINT uq_product_id UNIQUE (product_id);

ALTER TABLE warehouse.dim_date
ADD CONSTRAINT uq_date_key UNIQUE (date_key);