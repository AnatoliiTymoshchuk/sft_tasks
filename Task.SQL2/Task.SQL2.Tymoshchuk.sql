 --1) Clone data from the Shippers table to the NewShippers table.

SELECT *
INTO NewShippers
FROM Shippers

Select * FROM NewShippers

Select * FROM Shippers

 --2) Find the set of products (Product Name) and maximum value of units in stock for each one,
 --which is in the range from 25 to 50. Represent records from the min to max value of units in stock.
 --*************************updated

Select ProductName, Products.UnitsInStock
From Products
Where UnitsInStock >= 25 AND UnitsInStock <= 50
Order by UnitsInStock ASC

  --3) Get the list of total quantities of ordered products which consists of:
  --total quantity ordered in Germany and the total quantiy* 0.7% of products ordered in Sweden.
  --(Result should contain 2 rows)+
  --************************updated

  Select *
  From Products

Select SUM([Order Details].Quantity)*0.007 AS TotalQuantity,  Suppliers.Country
From Products
inner join [Order Details] ON Products.ProductID = [Order Details].ProductID
inner join Suppliers ON Products.SupplierID = Suppliers.SupplierID
Where Country = 'Sweden'
GROUP BY Country
UNION
Select SUM([Order Details].Quantity) AS TotalQuantity,  Suppliers.Country
From Products
inner join [Order Details] ON Products.CategoryID = [Order Details].ProductID
inner join Suppliers ON Products.ProductID = Suppliers.SupplierID
Where Country LIKE '%Germany%'
GROUP BY Country


 -- 4) Find the list of different countries in Employees and Customers tables.
 -----------*********************updated

SELECT Country
From Employees
EXCEPT
SELECT Country
From Customers
UNION
SELECT Country
From Customers
EXCEPT
SELECT Country
From Employees

 -- 5) Find the list of the same Postal Codes between Suppliers and Employees tables.

Select PostalCode From Suppliers
INTERSECT
Select PostalCode From Employees

  --6) Find the top region from which sales specialists were hired.
--****************************UPDATED

Select *
from Employees

  Select top(1) Region, Count(*) as RegionCount
  From Employees
  Where Title Like '%Sales%'
  Group BY Region
  Order BY RegionCount DESC
  

--  7) Get two lists of products: with a price < 50.00 with a discountinued flag and < 50  without a discountinued flag.

select * from Products
Where UnitPrice < 50 AND Discontinued = 0;

select * from Products
Where UnitPrice < 50 AND Discontinued = 1;

  --8) Create new table NewProducts based on the Products table with only discountinued products. 
  --Compare data sets between Products and NewProducts tables. (Check that only discountinued products are inserted).

CREATE TABLE NewProducts (
ProductID INT NOT NULL,
ProductName nvarchar(40) NOT NULL,
SupplierID INT NULL,
CategoryID INT NULL,
QuantityPerUnit nvarchar(40) NULL,
UnitPrice MONEY NULL,
UnitsInStock SMALLINT NULL,
UnitsOnOrder SMALLINT NULL,
ReorderLevel SMALLINT NULL,
Discontinued BIT NOT NULL,
PRIMARY KEY (ProductID),
FOREIGN KEY (SupplierID) REFERENCES Suppliers (SupplierID),
FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID)
); 

INSERT INTO NewProducts
SELECT *
FROM Products
WHERE Discontinued = 1

Select * FROM NewProducts

SELECT Discontinued From Products
INTERSECT
SELECT Discontinued From NewProducts

--*******************************************************************************************

SELECT *
INTO NewProducts
FROM Products
WHERE Discontinued = 1;


Select Discontinued From Products
INTERSECT
Select Discontinued From NewProducts


--The 9th query is optional 
--  Get the list of orders, where a required date is bigger than the Shipped date 
--   (compare in days) and Ship Region is not specified.

select * from Orders

Select *
FROM Orders
Where Datediff(day, ShippedDate,RequiredDate) != 0 AND ShipRegion IS NULL;


SELECT OrderID, CustomerID, ShipName, ShippedDate, RequiredDate, Datediff (day, RequiredDate,ShippedDate) as Differences
FROM Orders
WHERE RequiredDate > 0 AND ShipRegion IS NULL