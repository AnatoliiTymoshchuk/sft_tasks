--1) Update the Employees table, so it contains the HireDate values from 2014 till the current (2019) year.

Select *
FROM dbo.Employees

UPDATE dbo.Employees SET HireDate = '2014-05-01 00:00:000'
WHERE EmployeeID = '1';

UPDATE dbo.Employees SET HireDate = '1992-06-10 00:00:000'
WHERE EmployeeID = '2';

UPDATE dbo.Employees SET HireDate = '2015-04-01 00:00:000'
WHERE EmployeeID = '3';

UPDATE dbo.Employees SET HireDate = '2017-05-03 00:00:000'
WHERE EmployeeID = '4';

UPDATE dbo.Employees SET HireDate = '2019-10-17 00:00:000'
WHERE EmployeeID = '5';

UPDATE dbo.Employees SET HireDate = '2018-10-17 00:00:000'
WHERE EmployeeID = '6';

UPDATE dbo.Employees SET HireDate = '2016-01-02 00:00:000'
WHERE EmployeeID = '7';

--2)Delete records from the Products table where ReorderLevel values is equal to 30. 

SELECT *
FROM dbo.Products

EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'

DELETE FROM dbo.Products
WHERE ReorderLevel = 30;

--3)Get the list of titles and corresponding employees, who are working in each department (the list of columns in the result set from the Employee table is optional).

SELECT Title, FirstName, LastName
FROM dbo.Employees
ORDER BY Title DESC

--4)Get the list of suppliers, which are located in USA and have a specified region.

SELECT SupplierID, ContactName, Country, Region
FROM dbo.Suppliers
WHERE Region IS NOT NULL AND Country = 'USA';

--5)Get the amount of products that were delivered by each supplier (company), which have a discount from the Unit Price more than 10%. (order by companyid)

SELECT COUNT(dbo.Products.ProductName) AS Quantity, dbo.Suppliers.CompanyName
FROM dbo.[Order Details] 
JOIN dbo.Products ON dbo.[Order Details].ProductID = dbo.Products.ProductID
JOIN dbo.Suppliers ON dbo.Suppliers.SupplierID = dbo.Products.SupplierID
WHERE dbo.[Order Details].Discount > 0.1
GROUP BY dbo.Suppliers.CompanyName

--6)Get the top five product categories with the list of the most buyable products in European countries.

SELECT DISTINCT top 5 C.CategoryName, P.ProductName, MAX(OD.Quantity) as Quantity, O.ShipCountry
From Categories C 
Inner Join Products P ON C.CategoryID=P.CategoryID
INNER JOIN  [Order Details] OD ON P.ProductID=OD.ProductID
INNER JOIN Orders O ON OD.OrderID=O.OrderID
Where O.ShipCountry IN ('Sweden', 'Finland', 'UK', 'Italy', 'Netherlands', 'Norway', 'France', 'Denmark', 'Spain', 'Germany')
Group by C.CategoryName, P.ProductName, O.ShipCountry
Order by MAX(OD.Quantity) Desc

--7)Get the First Name, Last Name and Title of Managers and their subordinates.

SELECT FirstName, LastName, Title
FROM Employees
WHERE Title LIKE '%Manager%'
OR ReportsTo = (SELECT EmployeeID FROM Employees WHERE Title LIKE '%Manager%')

--The next queries are optional:
--?	Get the list of data about employees: First Name, Last Name, Title, HireDate who was hired this year.


SELECT FirstName, LastName, Title, HireDate
FROM dbo.Employees
WHERE HireDate BETWEEN (Select DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) AND (SELECT  DATEADD(MS, -2, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, 0)))
--**************updated***********************