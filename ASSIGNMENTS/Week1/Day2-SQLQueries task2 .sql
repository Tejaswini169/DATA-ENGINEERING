-- Implementing Data Integrity
ALTER TABLE Employees
ADD CONSTRAINT chk_Age CHECK (Age >= 18);

--Using Functions to Customize the Result Set
--Using String Fucntion:
-- CONCAT: Combine first name and last name
SELECT CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employees;

-- UPPER/LOWER: Convert text to uppercase or lowercase
SELECT UPPER(FirstName) AS UpperFirstName, LOWER(LastName) AS LowerLastName
FROM Employees;
--Using Date Functions:
-- Assume we are adding a HireDate column for this example
ALTER TABLE Employees ADD HireDate DATE;

-- Now we can work with date functions. Let's say we have some dates and we want to extract the year of hire.
SELECT YEAR(HireDate) AS YearHired
FROM Employees;
UPDATE Employees
SET HireDate = '2020-01-15'
WHERE EmployeeID = 1;

UPDATE Employees
SET HireDate = '2019-05-10'
WHERE EmployeeID = 2;

UPDATE Employees
SET HireDate = '2018-07-23'
WHERE EmployeeID = 3;

UPDATE Employees
SET HireDate = '2021-03-08'
WHERE EmployeeID = 4;

UPDATE Employees
SET HireDate = '2017-11-30'
WHERE EmployeeID = 5;
--Using Mathematical Functions:
-- ROUND: Round the age of employees to the nearest integer
SELECT ROUND(Age, 0) AS RoundedAge
FROM Employees;
--Using System Functions:
-- Get the current date (without time)
SELECT CAST(GETDATE() AS DATE) AS CurrentDate;

-- Get the current user
SELECT USER_NAME() AS CurrentUser;
--Summarizing and Grouping Data
--Summarizing Data by Using Aggregate Functions
-- Counting the number of employees
SELECT COUNT(*) AS TotalEmployees
FROM Employees;

-- Calculating the average age of employees
SELECT AVG(Age) AS AverageAge
FROM Employees;
--Grouping Data
-- Grouping by department and counting the number of employees per department
SELECT Department, COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY Department;

--Hands-on Exercises : Filtering Data using SQL Queries
-- Filtering employees whose age is greater than 30
SELECT * 
FROM Employees 
WHERE Age > 30;

--Total Aggregations using SQL Queries
-- Summing the ages of all employees
SELECT SUM(Age) AS TotalAge
FROM Employees;

--Group By Aggregations using SQL Queries
-- Grouping by department and getting the average age of employees in each department
SELECT Department, AVG(Age) AS AverageAge
FROM Employees
GROUP BY Department;
--Order of Execution of SQL Queries
SELECT Department, AVG(Age) AS AverageAge
FROM Employees
WHERE Age > 30
GROUP BY Department
HAVING AVG(Age) > 35
ORDER BY AverageAge DESC;
--Rules and Restrictions to Group and Filter Data in SQL Queries
SELECT Department, COUNT(*) 
FROM Employees
GROUP BY Department;
--invalid example
SELECT Department, Age 
FROM Employees
GROUP BY Department;
--Filter Data Based on Aggregated Results using Group By and Having
-- Getting departments where the average age is greater than 30
SELECT Department, AVG(Age) AS AverageAge
FROM Employees
GROUP BY Department
HAVING AVG(Age) > 30;












