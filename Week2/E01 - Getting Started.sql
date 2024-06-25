/*
E01 - Getting Started
Loading Data
*/

CREATE DATABASE e01;
GO
USE e01;
GO

CREATE TABLE users (
    user_id INT IDENTITY PRIMARY KEY,
    user_first_name VARCHAR(30) NOT NULL,
    user_last_name VARCHAR(30) NOT NULL,
    user_email_id VARCHAR(50) NOT NULL,
    user_email_validated BIT DEFAULT 0,
    user_password VARCHAR(200),
    user_role VARCHAR(1) NOT NULL DEFAULT 'U', --U and A
    is_active BIT DEFAULT 0,
    created_dt DATE DEFAULT GETDATE()
);

SELECT * FROM users;

-- Cleaning up
USE master;
GO
DROP DATABASE e01;
GO