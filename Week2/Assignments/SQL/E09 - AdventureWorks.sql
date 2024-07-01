/*
E09 - AdventureWorks
AdventureWorks Exercises
*/

USE AdventureWorks2022;
GO

-- Basic Queries

-- Select all Products
SELECT * FROM Production.Product;

-- Select all employees and their job titles
SELECT JobTitle FROM HumanResources.Employee;

-- List all sales orders from a specific customer
SELECT * FROM Sales.SalesOrderHeader
WHERE CustomerID = 30084;

-- Find the total due by each customer
SELECT
	CustomerID,
	SUM(TotalDue) TotalDue
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;

-- Find all suppliers (vendors and their contact information)
SELECT
	v.BusinessEntityID,
	c.PersonID,
	c.ContactTypeID
FROM Purchasing.Vendor v
JOIN Person.BusinessEntityContact c ON v.BusinessEntityID = c.BusinessEntityID

-- List all product categories and their subcategories
SELECT
	c.Name Category,
	s.Name Subcategory
FROM Production.ProductCategory c
JOIN Production.ProductSubcategory s ON c.ProductCategoryID = s.ProductCategoryID

-- Find all products that have been discontinued
SELECT * FROM Production.Product
WHERE DiscontinuedDate is not null;

-- Get total quantity ordered for each product
SELECT
	ProductID,
	SUM(OrderQty) total_quantity
FROM Sales.SalesOrderDetail
GROUP BY ProductID

-- List all addresses associated with a specific customer
SELECT * FROM Sales.Customer
-- Can't find what table has the address tha matches up with this table

-- Find the top 5 products by quantity sold
SELECT TOP 5
	ProductID,
	SUM(OrderQty) total_quantity
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY total_quantity DESC


-- Challenging Queries with Built-in Functions

-- Get the number of employees hired each year
SELECT
	YEAR(HireDate) AS HireYear,
	COUNT(1) AS NumberOfEmployees
FROM HumanResources.Employee
GROUP BY YEAR(HireDate)
ORDER BY HireYear


-- Find the average order amount for each product
SELECT 
	ProductId,
	AVG(OrderQty) AS AverageOrderNum
FROM Purchasing.PurchaseOrderDetail
GROUP BY ProductId;

-- Determine the month with the higest sales in a specific year
SELECT 
	MONTH(ShipDate) as [Month],
	COUNT(1) as [Number of Sales]
FROM Purchasing.PurchaseOrderHeader
WHERE YEAR(ShipDate) = 2014
GROUP BY MONTH(ShipDate)
ORDER BY [Month];

-- Retrieve Products that have a naem length greater than the average product name length
SELECT
	Name
FROM Production.Product
WHERE LEN(Name) > (
	SELECT AVG(LEN(Name)) FROM Production.Product
)

-- Get the next day of the week for all order dates in a table.
SELECT 
	PurchaseOrderID,
	OrderDate,
	DATEADD(day,1,OrderDate) AS NextDay
FROM Purchasing.PurchaseOrderHeader

-- Calculate the age of each employee
SELECT
	BusinessEntityID,
	BirthDate,
	DATEDIFF(year,BirthDate, GETDATE()) as Age
FROM HumanResources.Employee

-- Find the most recent sales order for each customer
SELECT
	s.CustomerID,
	s.OrderDate as [Most Recent Order]
FROM Sales.SalesOrderHeader s
WHERE s.OrderDate = (
	SELECT MAX(OrderDate)
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = s.CustomerID
);

--Get the total number of orders placed on the last day of each month
SELECT
	YEAR(OrderDate) as [Year],
	MONTH(OrderDate) as [Month],
	COUNT(1) as [Orders on Last Day] 
FROM Sales.SalesOrderHeader
WHERE OrderDate = EOMONTH(OrderDate)
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY [Year],[Month];

-- Retrieve the list of products with names that start with vowels
SELECT Name
FROM Production.Product
WHERE CHARINDEX(LEFT(Name, 1), 'AEIOUaeiou') > 0;

-- Calculate the percentage of total sales each salespesron compared to overrall sales
WITH SalesByPerson AS (
    SELECT 
        SalesPersonID,
        COUNT(*) AS TotalSales
    FROM Sales.SalesOrderHeader
	WHERE SalesPersonID is not NULL
    GROUP BY SalesPersonID
), TotalSales AS (
	SELECT 
		SUM(TotalSales) AS OverallTotalSales
	FROM SalesByPerson
)
SELECT
	s.SalesPersonID,
	s.TotalSales,
	(s.TotalSales*100 / t.OverallTotalSales) AS SalesPercantage
FROM SalesByPerson s 
CROSS JOIN TotalSales t



-- Basic Queries with Analytics Functions

-- Calculate the row number of all orders in June of 2011 sorted by SalesOrderID
SELECT
	SalesOrderID,
	OrderDate,
	ROW_NUMBER() OVER (ORDER BY SalesOrderID) AS RowNumber
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011 AND MONTH(OrderDate) = 6
ORDER BY SalesOrderID;


-- Compare information for the current sales order to the total amount due for the day the order was placed
SELECT
	SalesOrderID,
	OrderDate,
	SubTotal as OrderCost,
	SUM(SubTotal) OVER (PARTITION BY OrderDate) AS [Total Daily Cost],
	SubTotal * 100.0 / SUM(SubTotal) OVER (PARTITION BY OrderDate) AS [Percentage of Day]
FROM Sales.SalesOrderHeader

-- Calculate the 3 day moving average for orders totals in SalesOrderHeader table
SELECT
	SalesOrderID,
	OrderDate,
	SubTotal as OrderCost,
	AVG(SubTotal) OVER (
		ORDER BY OrderDate
		ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
	) AS [3 Days Average]
FROM Sales.SalesOrderHeader

-- For each product, rank each order by which has the highest quantiy of that product ordered
SELECT
	ProductID,
	SUM(OrderQty) AS TotalOrders,
	RANK() OVER (
		ORDER BY SUM(OrderQty) DESC
	) as [Rank]
FROM Sales.SalesOrderDetail
GROUP BY ProductID

-- Compare the date an order was placed on to the previous and next time that someone witht he same account placed an order
SELECT
	SalesOrderID,
	AccountNumber,
	OrderDate,
	LAG(OrderDate) OVER (
		PARTITION BY AccountNumber
		ORDER BY OrderDate
	) AS PreviousOrderDate,
	LEAD(OrderDate) OVER (
		PARTITION BY AccountNumber
		ORDER BY OrderDate
	) AS NextOrderDate
FROM Sales.SalesOrderHeader


-- Challenging Queries With Analytics Funtions