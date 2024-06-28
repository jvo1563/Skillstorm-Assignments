/*
E07 - Subqueries and CTEs
*/

USE retail_db;


-- Exercise 1
SELECT category_name
FROM categories
WHERE category_id IN (
	-- Subquery find all category_ids with more than 5 counts
	SELECT product_category_id as category_id
	FROM products
	GROUP BY product_category_id
	HAVING COUNT(1) > 5
);


-- Exercise 2
WITH customer_ten AS (
	SELECT order_customer_id
	FROM orders
	GROUP BY order_customer_id
	HAVING COUNT(1) > 10
)
SELECT 
	order_id,
	o.order_customer_id as customer_id
FROM orders o
JOIN customer_ten c10 ON c10.order_customer_id = o.order_customer_id
ORDER BY o.order_customer_id


-- Exercise 3

-- Find all orders in oct 2013
WITH orders_oct_13 AS (
	SELECT order_id
	FROM orders
	WHERE YEAR(order_date)=2013 AND MONTH(order_date)=10
)

SELECT
	p.product_id,
	p.product_name,
	CAST(SUM(o.order_item_subtotal) / SUM(o.order_item_quantity) AS DECIMAL(18,2)) AS average_price_sold
FROM (
	SELECT 
		order_item_product_id,
		order_item_quantity,
		order_item_subtotal
	FROM orders_oct_13 o13
	JOIN order_items oi ON oi.order_item_order_id = o13.order_id
) as o
JOIN products p ON p.product_id = o.order_item_product_id
GROUP BY p.product_id, p.product_name
ORDER BY p.product_id;

-- Exercise 4

-- Sums up the cost of every order_id from order_items
with order_sum AS (
	SELECT
		order_item_order_id,
		SUM(order_item_subtotal) as total_order_cost
	FROM order_items
	GROUP BY order_item_order_id
)

-- Filter out the orders that are less than the avg total_order_cost
SELECT
	order_item_order_id order_id,
	total_order_cost
FROM order_sum
WHERE total_order_cost > (
	SELECT AVG(os.total_order_cost)
	FROM order_sum os
)
ORDER BY order_id;


-- Exercise 5
WITH product_count AS (
	SELECT 
		product_category_id,
		COUNT(1) as product_count
	FROM products
	GROUP BY product_category_id
)
SELECT TOP 3
	category_id,
	category_name,
	p.product_count
FROM categories c
JOIN product_count p ON p.product_category_id = c.category_id
ORDER BY p.product_count DESC; 

-- Exercise 6
-- Gets all orders and their total made in the month of dec
WITH order_total AS (
	SELECT
		o.order_customer_id,
		SUM(order_item_subtotal) as total
	FROM order_items oi
	JOIN orders o ON o.order_id = oi.order_item_order_id
	WHERE MONTH(o.order_date) = 12
	GROUP BY o.order_customer_id
)
SELECT
	c.customer_id,
	c.customer_fname,
	c.customer_lname,
	CAST(ot.total as DECIMAL(18,2)) AS total_spending
FROM customers c
JOIN order_total ot ON c.customer_id = ot.order_customer_id
WHERE ot.total > (
	SELECT AVG(ot2.total)
	FROM order_total ot2
)
ORDER BY customer_id