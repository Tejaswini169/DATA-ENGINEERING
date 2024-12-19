--Data Cleaning Techniques
--Removing Duplicates
WITH CTE AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY FirstName, LastName, Age ORDER BY EmployeeID) AS row_num
    FROM Employees
)
DELETE FROM CTE WHERE row_num > 1;
--Handling Missing Values
UPDATE Employees
SET Department = 'Unknown'
WHERE Department IS NULL;

--Correcting Inconsistent Data
--Standardizing the case of names (making all FirstName values uppercase):
UPDATE Employees
SET FirstName = UPPER(FirstName);
--Removing leading/trailing spaces from LastName:
UPDATE Employees
SET LastName = LTRIM(RTRIM(LastName));
--Data Normalization
DELETE FROM Employees
WHERE Age < 18 OR Age > 65;
--Handling Outliers
DECLARE @avgAge FLOAT;
SET @avgAge = (SELECT AVG(Age) FROM Employees);

DELETE FROM Employees
WHERE Age > @avgAge * 1.5; 
--Data Manipulation Examples
--Inserting New Records
INSERT INTO Employees (EmployeeID, FirstName, LastName, Age, Department)
VALUES (6, 'Rahul', 'Singh', 29, 'Finance');
--Updating Data
UPDATE Employees
SET Department = 'Operations'
WHERE EmployeeID = 5;
--Deleting Data
DELETE FROM Employees
WHERE Department = 'Marketing';

--Selecting Data
SELECT FirstName, LastName, Age
FROM Employees
WHERE Age > 30
ORDER BY Age DESC;
--Filtering Data with Additional Conditions
SELECT FirstName, LastName, Department
FROM Employees
WHERE Department IN ('HR', 'Sales') AND Age BETWEEN 25 AND 45
ORDER BY Department, Age;








