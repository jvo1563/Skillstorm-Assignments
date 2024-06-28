/*
E08 - Analytics Queries
Analytics Functions
*/

USE hr_db;

-- Exercise 1 - Get all the employees who is making more than average salary with in each department
with employee_avg AS (
	SELECT
		employee_id,
		department_id,
		salary,
		AVG(salary) OVER (
			PARTITION BY department_id
		) avg_salary_expense
	FROM employees
)

SELECT
	employee_id,
	d.department_name,
	salary,
	CAST(avg_salary_expense AS DECIMAL(18,2)) avg_salary_expense
FROM employee_avg e
JOIN departments d ON d.department_id = e.department_id
WHERE e.salary > e.avg_salary_expense
ORDER BY e.department_id, e.salary desc;


-- Exercise 2 - Get cumulative salary for one of the department along with department name.
SELECT
	e.employee_id,
	d.department_name,
	e.salary,
	SUM(e.salary) OVER (
		PARTITION BY e.department_id
		ORDER BY salary
	) cum_salary_expense
FROM employees e
JOIN departments d ON d.department_id = e.department_id
WHERE d.department_name in ('Finance', 'IT')
ORDER BY department_name, salary;


-- Exercise 3 - Get top 3 paid employees with in each department by salary (use dense_rank)
SELECT * FROM (
	SELECT
		employee_id,
		e.department_id,
		department_name,
		salary,
		DENSE_RANK() OVER (
			PARTITION BY e.department_id
			ORDER BY salary DESC
		) employee_rank
	FROM employees e
	JOIN departments d ON d.department_id = e.department_id
) nq
WHERE nq.employee_rank <= 3
ORDER BY department_id, salary desc;

-- Exercise 4 - Get top 3 products sold in the month of 2014 January by revenue.
USE retail_db;

SELECT TOP 3
	nq.*,
	RANK() OVER (
		ORDER BY revenue DESC
	) product_rank
FROM (
	SELECT 
		p.product_id,
		p.product_name,
		CAST(SUM(oi.order_item_subtotal) AS DECIMAL(18,2)) revenue
	FROM orders o
	JOIN order_items oi ON oi.order_item_order_id = o.order_id
	JOIN products p ON p.product_id = oi.order_item_product_id
	WHERE MONTH(order_date) = 1 AND YEAR(order_date)=2014
		AND order_status in ('COMPLETE','CLOSED')
	GROUP BY p.product_id, p.product_name
) nq;


-- Exercise 5 - Get top 3 products in each category sold in the month of 2014 January by revenue.
SELECT * FROM employees;
SELECT * FROM departments;

WITH product_rev AS (
	SELECT
		c.category_id,
		c.category_name,
		p.product_id,
		p.product_name,
		CAST(SUM(oi.order_item_subtotal) AS DECIMAL(18,2)) revenue
	FROM orders o
	JOIN order_items oi ON oi.order_item_order_id = o.order_id
	JOIN products p ON p.product_id = oi.order_item_product_id
	JOIN categories c ON c.category_id = p.product_category_id
	WHERE MONTH(order_date) = 1 AND YEAR(order_date)=2014
		AND order_status in ('COMPLETE','CLOSED')
		AND category_id in (9,10)
	GROUP BY c.category_id, c.category_name, p.product_id, p.product_name
)
SELECT 
	*,
	RANK() OVER (
		PARTITION BY category_id
		ORDER BY revenue DESC
	) product_rank
FROM product_rev
ORDER BY category_id, revenue DESC;