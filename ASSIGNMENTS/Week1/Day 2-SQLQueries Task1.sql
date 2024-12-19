CREATE DATABASE CompanyDB;
USE CompanyDB;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT,
    Department VARCHAR(50)
);
--storing data in the data 

INSERT INTO Employees (EmployeeID, FirstName, LastName, Age, Department)
VALUES 
(1, 'Amit', 'Sharma', 30, 'HR'),
(2, 'Priya', 'Verma', 25, 'Engineering'),
(3, 'Ravi', 'Patel', 40, 'Marketing'),
(4, 'Neha', 'Reddy', 35, 'Engineering'),
(5, 'Suresh', 'Kumar', 50, 'HR');
select*from Employees

--Updating data in the table
UPDATE Employees
SET Department = 'Sales'
WHERE EmployeeID = 3;
--Deleting data from the table
DELETE FROM Employees
WHERE EmployeeID = 2;
--Retrieving Specific Attributes 
SELECT FirstName, LastName
FROM Employees;
--Retrieving Selected Rows 
SELECT * FROM Employees
WHERE Age > 30;

--Filtering Data: WHERE Clauses
SELECT * FROM Employees
WHERE Department = 'HR';
--Filtering Data: IN, DISTINCT, AND, OR, BETWEEN, LIKE, Column & Table Aliases
--In example
SELECT * FROM Employees
WHERE Department IN ('HR', 'Engineering');
--Distinct example
SELECT DISTINCT Age
FROM Employees;
--AND /OR example
SELECT * FROM Employees
WHERE (Age > 30 AND Department = 'HR') OR Age < 30;
--Between example
SELECT * FROM Employees
WHERE Age BETWEEN 30 AND 40;
--Like Example
SELECT * FROM Employees
WHERE FirstName LIKE 'A%';
--Column and table aliases
SELECT e.FirstName, e.LastName, e.Age
FROM Employees e
WHERE e.Department = 'HR';







