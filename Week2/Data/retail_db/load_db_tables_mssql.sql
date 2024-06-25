Use retail_db;

BULK INSERT dbo.categories FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\Week2\Data\retail_db\data\categories.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.customers FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\Week2\Data\retail_db\data\customers.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.departments FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\Week2\Data\retail_db\data\departments.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.order_items FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\Week2\Data\retail_db\data\order_items.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.orders FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\Week2\Data\retail_db\data\orders.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.products FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\Week2\Data\retail_db\data\products.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;