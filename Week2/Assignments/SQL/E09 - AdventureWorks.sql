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