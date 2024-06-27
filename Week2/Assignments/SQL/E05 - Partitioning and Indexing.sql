/*
E05 - Partitioning and Indexing
Partitioning Tables
*/

Use retail_db;

-- Validating
SELECT * from categories;
SELECT * from customers;
SELECT * from departments;
SELECT * from order_items;
SELECT * from orders;
SELECT * from products;

SELECT format(order_date, 'yyyy-MM') from orders
ORDER BY
order_date

-- Exercise 1 - Create table **orders_part** with the same columns as orders.
CREATE PARTITION FUNCTION pf_OrderDate (DATETIME)
AS RANGE LEFT FOR VALUES
('2013-07-01T00:00:00', '2013-08-01T00:00:00', '2013-09-01T00:00:00', '2013-10-01T00:00:00', 
 '2013-11-01T00:00:00', '2013-12-01T00:00:00', '2014-01-01T00:00:00', '2014-02-01T00:00:00', 
 '2014-03-01T00:00:00', '2014-04-01T00:00:00', '2014-05-01T00:00:00', '2014-06-01T00:00:00', 
 '2014-07-01T00:00:00');