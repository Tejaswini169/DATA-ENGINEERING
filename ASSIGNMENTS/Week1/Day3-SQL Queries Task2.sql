--Sub Queries
CREATE TABLE SalesList
(
    SalesMonth NVARCHAR(20), 
    SalesQuartes VARCHAR(5), 
    SalesYear SMALLINT, 
    SalesTotal MONEY
);

INSERT INTO SalesList(SalesMonth, SalesQuartes, SalesYear, SalesTotal) VALUES 
(N'March', 'Q1', 2019, 60),
(N'March', 'Q1', 2020, 50),
(N'May', 'Q2', 2019, 30),
(N'July', 'Q3', 2020, 10),
(N'November', 'Q4', 2019, 120),
(N'October', 'Q4', 2019, 150),
(N'November', 'Q4', 2019, 180),
(N'November', 'Q4', 2020, 120),
(N'July', 'Q3', 2019, 160),
(N'March', 'Q1', 2020, 170);

--Using ROLLUP for Subtotals

--Single Column ROLLUP:

SELECT SalesYear, SUM(SalesTotal) AS SalesTotal 
FROM SalesList 
GROUP BY ROLLUP(SalesYear);

--Multiple Columns with ROLLUP:

SELECT SalesYear, SalesQuartes, SUM(SalesTotal) AS SalesTotal 
FROM SalesList 
GROUP BY ROLLUP(SalesYear, SalesQuartes);

--Three-Level ROLLUP:

SELECT SalesYear, SalesQuartes, SalesMonth, SUM(SalesTotal) AS SalesTotal 
FROM SalesList 
GROUP BY ROLLUP(SalesYear, SalesQuartes, SalesMonth);

--Using the GROUPING Function for NULLs in Subtotals

SELECT 
    CASE 
        WHEN GROUPING(SalesQuartes) = 1 AND GROUPING(SalesYear) = 0 THEN 'SubTotal'
        WHEN GROUPING(SalesQuartes) = 1 AND GROUPING(SalesYear) = 1 THEN 'Grand Total'
        ELSE CAST(SalesYear AS VARCHAR(10)) 
    END AS SalesYear,
    SalesQuartes,
    SUM(SalesTotal) AS SalesTotal
FROM SalesList
GROUP BY ROLLUP(SalesYear, SalesQuartes);

--Calculating Subtotals for a Single Column with ROW_NUMBER

WITH CTE AS (
    SELECT SalesMonth, SalesTotal, ROW_NUMBER() OVER (ORDER BY NEWID()) AS RowNumber 
    FROM SalesList
)
SELECT 
    CASE WHEN GROUPING(RowNumber) = 1 THEN 'SubTotal' ELSE SalesMonth END AS SalesMonth,
    SUM(SalesTotal) AS SalesTotal
FROM CTE
GROUP BY ROLLUP(SalesMonth, RowNumber)
HAVING GROUPING(SalesMonth) = 0;

 --Using GROUPING SETS as an Alternative Method

 SELECT 
    CASE 
        WHEN GROUPING(SalesQuartes) = 1 AND GROUPING(SalesYear) = 0 THEN 'SubTotal'
        WHEN GROUPING(SalesQuartes) = 1 AND GROUPING(SalesYear) = 1 THEN 'Grand Total'
        ELSE CAST(SalesYear AS VARCHAR(10)) 
    END AS SalesYear,
    SalesQuartes,
    SUM(SalesTotal) AS SalesTotal
FROM SalesList
GROUP BY GROUPING SETS(SalesYear, (SalesYear, SalesQuartes), ());

