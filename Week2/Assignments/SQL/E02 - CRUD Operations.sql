/*
E02 - CRUD Operations
Database Operations
*/

-- Making Database for assignment
CREATE DATABASE E02;
GO
USE E02;
GO

-- Exercise 1 - Create Table
CREATE TABLE courses (
    course_id int IDENTITY,     
    course_name VARCHAR(60) NOT NULL, 
    course_author VARCHAR(40) NOT NULL,
    course_status VARCHAR(10) NOT NULL,
    course_published_dt DATE DEFAULT getdate()
);
ALTER TABLE courses
ADD CONSTRAINT pk_courses_course_id PRIMARY KEY CLUSTERED (course_id),
	CONSTRAINT CHK_courses_course_status CHECK (course_status='published' OR course_status='draft' OR course_status='inactive');


-- Exercise 2 - Inserting Data
INSERT INTO courses
    (course_name, course_author, course_status, course_published_dt)
VALUES
    ('Programming using Python', 'Bob Dillon', 'published', '2020-09-30'),
    ('Data Engineering using Python', 'Bob Dillon', 'published', '2020-07-15'),
	('Data Engineering using Scala', 'Elvis Presley', 'draft', ''),
	('Programming using Scala', 'Elvis Presley ', 'published', '2020-05-12'),
	('Programming using Java', 'Mike Jack', 'inactive', '2020-08-10'),
	('Web Applications - Python Flask', 'Bob Dillon', 'inactive', '2020-07-20'),
	('Web Applications - Java Spring', 'Mike Jack', 'draft', ''),
	('Pipeline Orchestration - Python', 'Bob Dillon', 'draft', ''),
	('Streaming Pipelines - Python', 'Bob Dillon', 'published', '2020-10-05'),
	('Web Applications - Scala Play', 'Elvis Presley', 'inactive', '2020-09-30'),
	('Web Applications - Python Django', 'Bob Dillon', 'published', '2020-06-23'),
	('Server Automation - Ansible', 'Uncle Sam', 'published', '2020-07-05');

--DELETE FROM courses;
--TRUNCATE TABLE courses;
--DROP TABLE courses;
SELECT * FROM courses;


-- Exercise 3 - Updating Data
UPDATE courses
SET
	course_status = 'published',
	course_published_dt = GETDATE()
WHERE course_status = 'draft'
AND (course_name LIKE '%Python%' OR course_name LIKE '%Scala%');

SELECT * FROM courses;

-- Exercise 4 - Deleting Data
DELETE FROM courses 
WHERE course_status != 'draft' AND course_status != 'published';

SELECT course_author, count(1) AS course_count
FROM courses
WHERE course_status= 'published'
GROUP BY course_author

SELECT * FROM courses;

--Cleaning Up
USE master;
GO
DROP DATABASE E02;
GO
