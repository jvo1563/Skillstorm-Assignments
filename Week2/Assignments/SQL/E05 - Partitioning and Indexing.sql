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

-- Exercise 1 - Create table orders_part with the same columns as orders.
CREATE PARTITION FUNCTION pf_OrderDate (DATETIME)
	AS RANGE RIGHT FOR VALUES
	('2013-07-01T00:00:00', '2013-08-01T00:00:00', '2013-09-01T00:00:00', '2013-10-01T00:00:00', 
	 '2013-11-01T00:00:00', '2013-12-01T00:00:00', '2014-01-01T00:00:00', '2014-02-01T00:00:00', 
	 '2014-03-01T00:00:00', '2014-04-01T00:00:00', '2014-05-01T00:00:00', '2014-06-01T00:00:00', 
	 '2014-07-01T00:00:00');
 GO

CREATE PARTITION SCHEME ps_OrderDate
	AS PARTITION pf_OrderDate
	ALL TO ('PRIMARY');
GO

CREATE TABLE orders_part (
  order_id INT IDENTITY NOT NULL,
  order_date DATETIME NOT NULL,
  order_customer_id INT NOT NULL,
  order_status VARCHAR(45) NOT NULL,
  PRIMARY KEY (order_id, order_date)
)
ON ps_OrderDate(order_date);
GO


SELECT SCHEMA_NAME(t.schema_id) AS SchemaName, t.name AS TableName, i.name AS IndexName, 
    p.partition_number, p.partition_id, i.data_space_id, f.function_id, f.type_desc, 
    r.boundary_id, r.value AS BoundaryValue   
FROM sys.tables AS t  
JOIN sys.indexes AS i  
    ON t.object_id = i.object_id  
JOIN sys.partitions AS p  
    ON i.object_id = p.object_id AND i.index_id = p.index_id   
JOIN  sys.partition_schemes AS s   
    ON i.data_space_id = s.data_space_id  
JOIN sys.partition_functions AS f   
    ON s.function_id = f.function_id  
LEFT JOIN sys.partition_range_values AS r   
    ON f.function_id = r.function_id and r.boundary_id = p.partition_number  
WHERE 
    t.name = 'orders_part' 
    AND i.type <= 1  
ORDER BY SchemaName, t.name, i.name, p.partition_number; 
GO


-- Exercise 2
SET IDENTITY_INSERT orders_part ON
INSERT INTO orders_part (order_id,order_date,order_customer_id,order_status)
SELECT * FROM orders
SET IDENTITY_INSERT orders_part OFF
GO

SELECT * FROM orders_part;

--SELECT 
--    $partition.pf_OrderDate(order_date) AS PartitionNumber, 
--    COUNT(1) AS row_count
--FROM 
--    orders_part
--GROUP BY 
--    $partition.pf_OrderDate(order_date);


-- CTE to get all partition numbers
WITH AllPartitions AS (
    SELECT 
        partition_number
    FROM 
        sys.partitions
    WHERE 
        object_id = OBJECT_ID('orders_part')
        AND index_id IN (0, 1) -- 0 = Heap, 1 = Clustered Index
)
-- CTE to get row counts per partition
, PartitionCounts AS (
    SELECT 
        $partition.pf_OrderDate(order_date) AS PartitionNumber, 
        COUNT(1) AS row_count
    FROM 
        orders_part
    GROUP BY 
        $partition.pf_OrderDate(order_date)
)
-- Combining Both
SELECT 
    ap.partition_number AS PartitionNumber, 
    ISNULL(pc.row_count, 0) AS row_count
FROM 
    AllPartitions ap
LEFT JOIN 
    PartitionCounts pc ON ap.partition_number = pc.PartitionNumber
ORDER BY 
    ap.partition_number;