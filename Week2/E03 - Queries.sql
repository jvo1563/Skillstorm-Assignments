/*
E03 - Queries
Basic SQL Queries
*/

Use retail_db;
SELECT * from categories;
SELECT * from customers;
SELECT * from departments;
SELECT * from order_items;
SELECT * from orders;
SELECT * from products;

-- Exercise 1 - Customer order count
SELECT
	c.customer_id,
	c.customer_fname,
	c.customer_lname,
	COUNT(o.order_id) as order_count
FROM
	customers c
JOIN
	orders o ON c.customer_id = o.order_customer_id
WHERE
	YEAR(o.order_date) = 2014
	AND MONTH(o.order_date) = 1
GROUP BY
	c.customer_id,
	c.customer_fname,
	c.customer_lname
ORDER BY
	order_count DESC,
	customer_id ASC;


--SELECT
--	customer_id,
--	customer_fname,
--	customer_lname,
--	COUNT(orders.order_id) as order_count
--FROM
--	customers
--JOIN
--	orders ON customer_id = orders.order_customer_id
--WHERE
--	YEAR(orders.order_date) = 2014
--	AND MONTH(orders.order_date) = 1
--GROUP BY
--	customer_id,
--	customer_fname,
--	customer_lname
--ORDER BY
--	order_count DESC,
--	customer_id ASC;



-- Exercise 2 - Dormant Customers
SELECT
    c.*
FROM
    customers c
LEFT JOIN
    orders o ON c.customer_id = o.order_customer_id
    AND YEAR(o.order_date) = 2014
    AND MONTH(o.order_date) = 1
WHERE
    o.order_id IS NULL;

-- Exercise 3 - Revenue Per Customer
SELECT
	c.customer_id,
	c.customer_fname,
	c.customer_lname,
    COALESCE(SUM(oi.order_item_subtotal), 0) AS customer_revenue
FROM
    customers c
LEFT JOIN
    orders o ON c.customer_id = o.order_customer_id
JOIN
    order_items oi ON o.order_id = oi.order_item_order_id
WHERE
    YEAR(o.order_date) = 2014
    AND MONTH(o.order_date) = 1
	AND (order_status LIKE '%COMPLETE%' OR order_status LIKE '%CLOSED%')
GROUP BY
    c.customer_id, 	
	c.customer_fname,
	c.customer_lname
ORDER BY
    customer_revenue DESC,
	c.customer_id ASC;
