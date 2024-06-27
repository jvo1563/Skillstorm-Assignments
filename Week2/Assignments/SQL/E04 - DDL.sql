/*
E04 - DDL
Managing Database Objects
*/

-- Creating Database
CREATE DATABASE retail_db;
GO

USE retail_db;
GO

-- Creating Tables
CREATE TABLE departments (
  department_id INT NOT NULL,
  department_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (department_id)
);
CREATE TABLE categories (
  category_id INT NOT NULL,
  category_department_id INT NOT NULL,
  category_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (category_id)
); 
CREATE TABLE products (
  product_id INT NOT NULL,
  product_category_id INT NOT NULL,
  product_name VARCHAR(45) NOT NULL,
  product_description VARCHAR(255) NOT NULL,
  product_price FLOAT NOT NULL,
  product_image VARCHAR(255) NOT NULL,
  PRIMARY KEY (product_id)
);
CREATE TABLE customers (
  customer_id INT NOT NULL,
  customer_fname VARCHAR(45) NOT NULL,
  customer_lname VARCHAR(45) NOT NULL,
  customer_email VARCHAR(45) NOT NULL,
  customer_password VARCHAR(45) NOT NULL,
  customer_street VARCHAR(255) NOT NULL,
  customer_city VARCHAR(45) NOT NULL,
  customer_state VARCHAR(45) NOT NULL,
  customer_zipcode VARCHAR(45) NOT NULL,
  PRIMARY KEY (customer_id)
); 
CREATE TABLE orders (
  order_id INT NOT NULL,
  order_date TIMESTAMP NOT NULL,
  order_customer_id INT NOT NULL,
  order_status VARCHAR(45) NOT NULL,
  PRIMARY KEY (order_id)
);
CREATE TABLE order_items (
  order_item_id INT NOT NULL,
  order_item_order_id INT NOT NULL,
  order_item_product_id INT NOT NULL,
  order_item_quantity INT NOT NULL,
  order_item_subtotal FLOAT NOT NULL,
  order_item_product_price FLOAT NOT NULL,
  PRIMARY KEY (order_item_id)
);
GO

-- Loading Data
BULK INSERT dbo.categories FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\Week2\Data\retail_db\data\categories.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.customers FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\Week2\Data\retail_db\data\customers.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.departments FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\Week2\Data\retail_db\data\departments.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.order_items FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\Week2\Data\retail_db\data\order_items.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.orders FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\Week2\Data\retail_db\data\orders.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.products FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\Week2\Data\retail_db\data\products.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
GO

USE retail_db
GO

-- Exercise 1
SELECT MAX(order_id) AS max_id
FROM orders;

SELECT MAX(category_id) AS max_id
FROM categories;

SELECT MAX(customer_id) AS max_id
FROM customers;

SELECT MAX(department_id) AS max_id
FROM departments;

SELECT MAX(order_item_id) AS max_id
FROM order_items;

SELECT MAX(product_id) AS max_id
FROM products;


-- Exercise 2

-- orders.order_customer_id to customers.customer_id
ALTER TABLE orders
ADD CONSTRAINT FK_orders_customers
FOREIGN KEY (order_customer_id)
REFERENCES customers (customer_id);

-- order_items.order_item_order_id to orders.order_id
ALTER TABLE order_items
ADD CONSTRAINT FK_orders_items_orders
FOREIGN KEY (order_item_order_id)
REFERENCES orders (order_id);

-- order_items.order_item_product_id to products.product_id
ALTER TABLE order_items
ADD CONSTRAINT FK_orders_items_products
FOREIGN KEY (order_item_product_id)
REFERENCES products (product_id);

-- products.product_category_id to categories.category_id
-- There are products with categories that dont exist in the categories table so we need to delete those
-- Finding all products that violate foreign key constraints
SELECT * FROM products p
LEFT JOIN categories c on p.product_category_id = c.category_id
WHERE c.category_id is NULL;
-- Deleting them
DELETE FROM products
WHERE product_category_id NOT IN (SELECT category_id from categories);
-- Adding the constraints now that the bad products are gone
ALTER TABLE products
ADD CONSTRAINT FK_products_categories
FOREIGN KEY (product_category_id)
REFERENCES categories (category_id);

-- categories.category_department_id to departments.department_id
-- There are categories with departments that don't exist in the departments table 
-- This time we will try adding the missing departments
SELECT * FROM categories c
LEFT JOIN departments d on c.category_department_id = d.department_id
WHERE d.department_id is NULL;
-- WE see that department 8 exist in category and not in the departments table so lets add it
INSERT INTO departments
VALUES(8,'Sports');
-- Adding constraints now that we have a department for that category
ALTER TABLE categories
ADD CONSTRAINT FK_categories_departments
FOREIGN KEY (category_department_id)
REFERENCES departments (department_id);


-- Exercise 3
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'
AND TABLE_NAME in ('orders','order_items','products','categories');

