/*
E03 - Queries
Basic SQL Queries
*/

Use retail_db;

-- Validating
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

-- This for some reason only includes some customers with 0 rev
-- It probably filters out all customers who did not pass the WHERE clause me thinks
--SELECT
--	c.customer_id,
--	c.customer_fname AS [First Name],
--	c.customer_lname AS [Last Name] ,
--    COALESCE(SUM(oi.order_item_subtotal), 0) AS [Customer Revenue]
--FROM
--    customers c
--LEFT JOIN
--    orders o ON c.customer_id = o.order_customer_id
--LEFT JOIN
--    order_items oi ON o.order_id = oi.order_item_order_id         
--WHERE
--    format(o.order_date, 'yyyy-MM') = '2014-01'
--	AND (order_status LIKE '%COMPLETE%' OR order_status LIKE '%CLOSED%')
--GROUP BY
--    c.customer_id, 	
--	c.customer_fname,
--	c.customer_lname
--ORDER BY
--    [Customer Revenue] DESC,
--	c.customer_id ASC;

-- Using nested joins fixes it
SELECT
	c.customer_id,
	c.customer_fname AS [First Name],
	c.customer_lname AS [Last Name] ,
    COALESCE(SUM(order_revenue.order_item_subtotal), 0) AS [Customer Revenue]
FROM
    customers c
LEFT JOIN
    (SELECT
        o.order_customer_id,
        oi.order_item_subtotal
     FROM
        orders o
     INNER JOIN
        order_items oi ON o.order_id = oi.order_item_order_id
     WHERE
		format(o.order_date, 'yyyy-MM') = '2014-01'
		AND (order_status LIKE '%COMPLETE%' OR order_status LIKE '%CLOSED%')
    ) AS order_revenue ON c.customer_id = order_revenue.order_customer_id
GROUP BY
    c.customer_id, 	
	c.customer_fname,
	c.customer_lname
ORDER BY
    [Customer Revenue] DESC,
	c.customer_id ASC;


-- Exercise 4 - Revenue Per Category

-- This one does not include the categories with 0 rev similar to the previous exercise
-- WHERE clause is probably filtering them out somehow
--SELECT
--	c.*,
--	COALESCE(SUM(oi.order_item_subtotal), 0) AS category_revenue
--FROM
--	categories c
--LEFT JOIN
--	products p ON p.product_category_id = c.category_id
--LEFT JOIN
--	order_items oi ON oi.order_item_product_id = p.product_id
--LEFT JOIN
--	orders o ON o.order_id = oi.order_item_order_id
--WHERE
--    format(o.order_date, 'yyyy-MM') = '2014-01'
--	AND (o.order_status LIKE '%COMPLETE%' OR o.order_status LIKE '%CLOSED%')
--GROUP BY
--	c.category_id,
--	c.category_department_id,
--	c.category_name
--ORDER BY
--    c.category_id;

SELECT
	c.*,
	COALESCE(SUM(product_category_rev.order_item_subtotal), 0) AS category_revenue
FROM
	categories c
LEFT JOIN
	(
	SELECT
		p.product_category_id,
		oi.order_item_subtotal
	FROM
		products p
	JOIN
		order_items oi ON oi.order_item_product_id = p.product_id
	JOIN
		orders o ON o.order_id = oi.order_item_order_id
	WHERE
		format(o.order_date, 'yyyy-MM') = '2014-01'
		AND (o.order_status LIKE '%COMPLETE%' OR o.order_status LIKE '%CLOSED%')
	) AS product_category_rev ON product_category_rev.product_category_id = c.category_id
GROUP BY
	c.category_id,
	c.category_department_id,
	c.category_name
ORDER BY
    c.category_id;



-- Exercise 5 - Product Count Per Department
SELECT
	d.*,
	COUNT(p.product_id) AS product_count
FROM
	departments d
LEFT JOIN
	categories c ON c.category_department_id = d.department_id
LEFT JOIN
	products p ON p.product_category_id = c.category_id
GROUP BY
	d.department_id,
	d.department_name
ORDER BY
	d.department_id;
	