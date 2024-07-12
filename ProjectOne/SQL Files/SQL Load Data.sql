CREATE DATABASE investment_db;
GO

USE investment_db;
GO

CREATE TABLE investment_name (
  investment_name_id INT IDENTITY NOT NULL,
  investment_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (investment_name_id)
);

CREATE TABLE investment_sector (
  investment_sector_id INT IDENTITY NOT NULL,
  investment_sector VARCHAR(45) NOT NULL,
  PRIMARY KEY (investment_sector_id)
);

CREATE TABLE investment_type (
  investment_type_id INT IDENTITY NOT NULL,
  investment_type VARCHAR(45) NOT NULL,
  PRIMARY KEY (investment_type_id)
);

CREATE TABLE investment_time (
  time_id INT IDENTITY NOT NULL,
  investment_date DATETIME NOT NULL,
  investment_month INT NOT NULL,
  investment_quarter INT NOT NULL,
  investment_year INT NOT NULL,
  PRIMARY KEY (time_id)
);
GO

CREATE TABLE investment (
  investment_id INT IDENTITY NOT NULL,
  investment_name_id int FOREIGN KEY REFERENCES investment_name(investment_name_id),
  investment_type_id int FOREIGN KEY REFERENCES investment_type(investment_type_id),
  investment_sector_id int FOREIGN KEY REFERENCES investment_sector(investment_sector_id),
  time_id int FOREIGN KEY REFERENCES investment_time(time_id),
  closing_price FLOAT NOT NULL,
  daily_return FLOAT NOT NULL,
  cumulative_return FLOAT NOT NULL,
  _10_day_ma FLOAT NOT NULL,
  _100_day_ma FLOAT NOT NULL,
  volatility FLOAT NOT NULL,
  sharpe_ratio FLOAT NOT NULL,
  beta FLOAT NOT NULL,
  PRIMARY KEY (investment_id)
);
GO


BULK INSERT dbo.investment_name FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\ProjectOne\Data\Star\investment_name.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.investment_sector FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\ProjectOne\Data\Star\investment_sector.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.investment_type FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\ProjectOne\Data\Star\investment_type.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.investment_time FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\ProjectOne\Data\Star\investment_time.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;
BULK INSERT dbo.investment FROM 'C:\Users\Joeny\Desktop\Skillstorm\Skillstorm-Assignments\ProjectOne\Data\Star\investments.csv' WITH (FORMAT='CSV', ROWTERMINATOR = '0x0a', FIRSTROW=2) ;

UPDATE investment_name
SET investment_name = REPLACE(investment_name, CHAR(13), '')

UPDATE investment_sector
SET investment_sector = REPLACE(investment_sector, CHAR(13), '')

UPDATE investment_type
SET investment_type = REPLACE(investment_type, CHAR(13), '')
GO