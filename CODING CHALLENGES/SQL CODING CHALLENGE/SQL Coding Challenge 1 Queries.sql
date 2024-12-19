CREATE DATABASE Companydatabase

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT,
    Department VARCHAR(50)
);

INSERT INTO Employees (FirstName, LastName, Age, Department)
VALUES 
('Amit', 'Sharma', 30, 'HR'),
('Priya', 'Verma', 25, 'Engineering'),
('Ravi', 'Patel', 40, 'Marketing'),
('Neha', 'Reddy', 35, 'Engineering'),
('Suresh', 'Kumar', 50, 'HR');

CREATE TABLE Departments (
    DepartmentName VARCHAR(50) PRIMARY KEY,
    Manager VARCHAR(50)
);

INSERT INTO Departments (DepartmentName, Manager)
VALUES
('HR', 'Anil Kumar'),
('Engineering', 'Rajesh Gupta'),
('Marketing', 'Nisha Mehta'),
('Sales', 'Sunil Desai');

-- Question 1: Querying Data Using Joins and Subqueries, with a focus on Subtotals

-- Inner Join - Retrieve a list of employees along with the department name, using an inner join.
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Age, e.Department
FROM Employees e
INNER JOIN Departments d ON e.Department = d.DepartmentName;

-- Left Join - Retrieve a list of all employees, and include department details if available.
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Age, e.Department, d.Manager
FROM Employees e
LEFT JOIN Departments d ON e.Department = d.DepartmentName;

-- Right Join - Show all departments, even if there are no employees in some departments.
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Department, d.DepartmentName
FROM Employees e
RIGHT JOIN Departments d ON e.Department = d.DepartmentName;

-- Subquery with Employee Age - Retrieve employees who are older than the average age.
SELECT FirstName, LastName, Age, Department
FROM Employees
WHERE Age > (SELECT AVG(Age) FROM Employees);

-- Calculate Subtotal - Total age by department.
SELECT Department, SUM(Age) AS TotalAge
FROM Employees
GROUP BY Department;

--  List all employees and departments, showing all departments and all employees, even if some employees don’t belong to a department or some departments have no employees


SELECT e.EmployeeID, e.FirstName, e.LastName, e.Department AS EmployeeDepartment,
       d.DepartmentName AS DepartmentName
FROM Employees e
FULL OUTER JOIN Departments d ON e.Department = d.DepartmentName;


-- Question 2: Manipulate Data Using SQL Commands with GROUP BY and HAVING Clauses

-- Group By and Count - Count the number of employees in each department.
SELECT Department, COUNT(EmployeeID) AS NumberOfEmployees
FROM Employees
GROUP BY Department;

-- Group By with HAVING Clause - Retrieve departments with an average employee age greater than 35.
SELECT Department, AVG(Age) AS AverageAge
FROM Employees
GROUP BY Department
HAVING AVG(Age) > 35;

-- Group By with SUM and HAVING Clause - Find departments where the total age of employees is over 70.
SELECT Department, SUM(Age) AS TotalAge
FROM Employees
GROUP BY Department
HAVING SUM(Age) > 70;

-- Retrieve each department’s total number of employees, the average employee age, and the manager’s name. Only show departments where the average employee age is greater than the company-wide average age. Additionally, include departments even if they have no employees.


SELECT d.DepartmentName,
       d.Manager,
       COUNT(e.EmployeeID) AS NumberOfEmployees,
       AVG(e.Age) AS AverageAge
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentName = e.Department
GROUP BY d.DepartmentName, d.Manager
HAVING AVG(ISNULL(e.Age, 0)) > (SELECT AVG(Age) FROM Employees);

