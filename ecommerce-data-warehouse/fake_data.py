from faker import Faker 
import random
import psycopg2
from datetime import datetime, timedelta

fake = Faker()

conn = psycopg2.connect(host="localhost", database="ecommerce_dw" ,user="admin" , password="admin")

cursor = conn.cursor()

for i in range(1, 21):
    cursor.execute(
        """insert into staging.customers(customer_id, first_name, last_name, email, country, created_at)
        values(%s, %s, %s, %s, %s, %s)"""
        ,
        (
            i, fake.first_name(), fake.last_name(), fake.email(), fake.country(), fake.date_time_between(start_date='-2y', end_date='now')
        )
    )

categories = ['Electronics', 'Clothing', 'Toys', 'Books', 'Home']
for i in range(1, 11):
    cursor.execute(
        """insert into staging.products(product_id, product_name, category, price)
        values(%s, %s, %s, %s)"""
        ,
        (
            i, fake.word().capitalize(), random.choice(categories), round(random.uniform(10, 500), 2)
        )
    )

for i in range(1, 51):
    customer_id = random.randint(1, 20)
    product_id = random.randint(1, 10)
    quantity = random.randint(1, 5)
    unit_price = round(random.uniform(10, 500), 2)
    total_amount = round(quantity * unit_price, 2)
    order_date = fake.date_time_between(start_date='-1y', end_date='now')
    cursor.execute(
        """
        insert into staging.orders (order_id, customer_id, product_id, order_date, quantity, unit_price, total_amount)
        values (%s, %s, %s, %s, %s, %s, %s)
        """,
        (i, customer_id, product_id, order_date, quantity, unit_price, total_amount)
    )

conn.commit()
cursor.close()
conn.close()
print("Data succesfully inserted!")