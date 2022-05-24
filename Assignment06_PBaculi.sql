--*************************************************************************--
-- Title: Assignment06
-- Author: YourNameHere
-- Desc: This file demonstrates how to use Views
-- Change Log: When,Who,What
-- 2022-05-24,PBaculi,Revised File
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_PBaculi')
	 Begin 
	  Alter Database [Assignment06DB_PBaculi] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_PBaculi;
	 End
	Create Database Assignment06DB_PBaculi;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_PBaculi;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [mOney] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL -- New Column
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count])
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10 -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, UnitsInStock + 20 -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go

-- Show the Current data in the Categories, Products, and Inventories Tables
--Select * From Categories;
--go
--Select * From Products;
--go
--Select * From Employees;
--go
--Select * From Inventories;
--go

/********************************* Questions and Answers *********************************/
print 
'NOTES------------------------------------------------------------------------------------ 
 1) You can use any name you like for you views, but be descriptive and consistent
 2) You can use your working code from assignment 5 for much of this assignment
 3) You must use the BASIC views for each table after they are created in Question 1
------------------------------------------------------------------------------------------'

-- Question 1 (5% pts): How can you create BACIC views to show data from each table in the database.
-- NOTES: 1) Do not use a *, list out each column!
--        2) Create one view per table!
--		  3) Use SchemaBinding to protect the views from being orphaned!


--Select CategoryID, CategoryName
-- from Categories;
--go
--Create or Alter
--View vCategories
--AS
--  Select CategoryID, CategoryName
--   from Categories; 
go
Create --or Alter
View vCategories
WITH SCHEMABINDING
AS
  Select CategoryID, CategoryName
  from dbo.Categories;
go
--Select * from vCategories;
--go

--Select ProductID, ProductName, CategoryID, UnitPrice
-- from Products;
--go
--Create or Alter
--View vProducts
--AS
-- Select ProductID, ProductName, CategoryID, UnitPrice
-- from Products;
go
Create --or Alter
View vProducts
WITH SCHEMABINDING
AS
 Select ProductID, ProductName, CategoryID, UnitPrice
 from dbo.Products;
go
--Select * from vProducts;
--go

--Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID
-- from Employees;
--go
--Create or Alter
--View vEmployees
--AS
-- Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID
-- from Employees;
go
Create --or Alter
View vEmployees
WITH SCHEMABINDING
AS
 Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID
 from dbo.Employees;
go
--Select * from vEmployees;
--go
--Select InventoryID, InventoryDate, EmployeeID, ProductID, Count
-- from Inventories;
--go
--Create or Alter
--View vInventories
--AS
-- Select InventoryID, InventoryDate, EmployeeID, ProductID, Count
-- from Inventories;
go
Create --or Alter
View vInventories
WITH SCHEMABINDING
AS
 Select InventoryID, InventoryDate, EmployeeID, ProductID, Count
 from dbo.Inventories;
go
--Select * from vInventories;
--go



-- Question 2 (5% pts): How can you set permissions, so that the public group CANNOT select data 
-- from each table, but can select data from each view?

Deny Select on Categories to Public;
Grant Select on vCategories to Public;

Deny Select on Products to Public;
Grant Select on vProducts to Public;

Deny Select on Employees to Public;
Grant Select on vEmployees to Public;

Deny Select on Inventories to Public;
Grant Select on vInventories to Public;

-- Question 3 (10% pts): How can you create a view to show a list of Category and Product names, 
-- and the price of each product?
-- Order the result by the Category and Product!


--Select *
-- from vCategories;
--go
--Select 
-- CategoryName
--  from vCategories;
--go
--Select *
-- from vProducts;
--go
--Select
-- ProductName
-- ,UnitPrice
--  from vProducts;
--go
--Select
-- vC.CategoryName
-- ,vP.ProductName
-- ,vP.UnitPrice
--  from vCategories as vC INNER JOIN vProducts as vP
--   on vC.CategoryID = vP.CategoryID;
--go
--Select
-- vC.CategoryName
-- ,vP.ProductName
-- ,vP.UnitPrice
--  from vCategories as vC INNER JOIN vProducts as vP
--   on vC.CategoryID = vP.CategoryID;
go
Create --or Alter 
 View vCategoryProductPrice
 As
  Select TOP 1000000
   vC.CategoryName
   ,vP.ProductName
   ,vP.UnitPrice
   from vCategories as vC INNER JOIN vProducts as vP
    on vC.CategoryID = vP.CategoryID
   order by CategoryName, ProductName;
go
--Select * from vCategoryProductPrice;
--go

-- Here is an example of some rows selected from the view:
-- CategoryName ProductName       UnitPrice
-- Beverages    Chai              18.00
-- Beverages    Chang             19.00
-- Beverages    Chartreuse verte  18.00

-- Question 4 (10% pts): How can you create a view to show a list of Product names 
-- and Inventory Counts on each Inventory Date?
-- Order the results by the Product, Date, and Count!

--Select *
-- from vProducts;
--go
--Select ProductName
-- from vProducts;
--go
--Select *
-- from vInventories;
--go
--Select InventoryDate
--       ,Count
-- from vInventories;
--go
--Select vP.ProductName
--       ,vI.InventoryDate
--       ,vI.Count
-- from vProducts as vP INNER JOIN vInventories as vI
--  on vP.ProductID = vI.ProductID;
--go
Create --or Alter
 View vProductInventoryDateCount
 As
  Select TOP 1000000
   vP.ProductName
   ,vI.InventoryDate
   ,vI.Count
  from vProducts as vP INNER JOIN vInventories as vI
   on vP.ProductID = vI.ProductID
  order by ProductName, InventoryDate, Count;
go
--Select * from vProductInventoryDateCount;



-- Here is an example of some rows selected from the view:
-- ProductName	  InventoryDate	Count
-- Alice Mutton	  2017-01-01	  0
-- Alice Mutton	  2017-02-01	  10
-- Alice Mutton	  2017-03-01	  20
-- Aniseed Syrup	2017-01-01	  13
-- Aniseed Syrup	2017-02-01	  23
-- Aniseed Syrup	2017-03-01	  33


-- Question 5 (10% pts): How can you create a view to show a list of Inventory Dates 
-- and the Employee that took the count?
-- Order the results by the Date and return only one row per date!

--Select *
-- from vInventories;
--go
--Select 
-- InventoryDate
-- from vInventories;
--go
--Select * 
-- from vEmployees;
--go
--Select 
-- EmployeeName = CONCAT (EmployeeFirstName, ' ',EmployeeLastName)
-- from vEmployees;
--go
--Select 
-- vI.InventoryDate
-- ,EmployeeName = CONCAT (vE.EmployeeFirstName, ' ',vE.EmployeeLastName)
-- from vEmployees as vE INNER JOIN vInventories as vI
--  on vE.EmployeeID = vI.EmployeeID;
--go
Create --or Alter
 View vInventorybyEmployee
 As
  Select Distinct TOP 1000000
   vI.InventoryDate
   ,EmployeeName = CONCAT (vE.EmployeeFirstName, ' ',vE.EmployeeLastName)
   from vEmployees as vE INNER JOIN vInventories as vI
    on vE.EmployeeID = vI.EmployeeID
   order by InventoryDate;
go
--Select * from vInventorybyEmployee;
--go

-- Here is are the rows selected from the view:

-- InventoryDate	EmployeeName
-- 2017-01-01	    Steven Buchanan
-- 2017-02-01	    Robert King
-- 2017-03-01	    Anne Dodsworth

-- Question 6 (10% pts): How can you create a view show a list of Categories, Products, 
-- and the Inventory Date and Count of each product?
-- Order the results by the Category, Product, Date, and Count!

--Select * 
-- from vCategories;
--go
--Select CategoryName
-- from vCategories;
--go
--Select *
-- from vProducts;
--go
--Select ProductName
-- from vProducts;
--go
--Select 
-- vC.CategoryName
-- ,vP.ProductName
--  from vCategories as vC INNER JOIN vProducts as vP
--   on vC.CategoryID = vP.CategoryID;
--go
--Select *
-- from vInventories;
--go
--Select 
-- InventoryDate
-- ,Count
--  from vInventories;
--go
--Select 
-- vC.CategoryName
-- ,vP.ProductName
-- ,vI.InventoryDate
-- ,vI.Count
--  from vCategories as vC INNER JOIN vProducts as vP
--   on vC.CategoryID = vP.CategoryID
--    INNER JOIN vInventories as vI
--     on vP.ProductID = vI.ProductID;
--go
Create --or Alter 
 View vCategoryProductInventoryDateCount
 As
  Select TOP 1000000
  vC.CategoryName
  ,vP.ProductName
  ,vI.InventoryDate
  ,vI.Count
   from vCategories as vC INNER JOIN vProducts as vP
    on vC.CategoryID = vP.CategoryID
     INNER JOIN vInventories as vI
      on vP.ProductID = vI.ProductID
   order by CategoryName, ProductName, InventoryDate, Count;
go
--Select *
--  from vCategoryProductInventoryDateCount;
--go

-- Here is an example of some rows selected from the view:
-- CategoryName,ProductName,InventoryDate,Count
-- CategoryName	ProductName	InventoryDate	Count
-- Beverages	  Chai	      2017-01-01	  39
-- Beverages	  Chai	      2017-02-01	  49
-- Beverages	  Chai	      2017-03-01	  59
-- Beverages	  Chang	      2017-01-01	  17
-- Beverages	  Chang	      2017-02-01	  27
-- Beverages	  Chang	      2017-03-01	  37


-- Question 7 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the EMPLOYEE who took the count?
-- Order the results by the Inventory Date, Category, Product and Employee!

--Select * 
-- from vCategories;
--go
--Select CategoryName
-- from vCategories;
--go
--Select *
-- from vProducts;
--go
--Select ProductName
-- from vProducts;
--go
--Select 
-- vC.CategoryName
-- ,vP.productName
-- from vCategories as vC INNER JOIN vProducts as vP
--  on vC.CategoryID = vP.CategoryID;
--go
--Select *
-- from vInventories;
--go
--Select 
-- InventoryDate
-- ,Count
-- from vInventories;
--go
--Select * 
-- from vEmployees;
--go
--Select 
-- EmployeeName = CONCAT (EmployeeFirstName, ' ',EmployeeLastName)
-- from vEmployees;
--go
--Select 
-- vI.InventoryDate
-- ,EmployeeName = CONCAT (vE.EmployeeFirstName, ' ',vE.EmployeeLastName)
-- from vEmployees as vE INNER JOIN vInventories as vI
--  on vE.EmployeeID = vI.EmployeeID;
--go
--Select 
-- vC.CategoryName
-- ,vP.ProductName
-- ,vI.InventoryDate
-- ,vI.Count
-- from vCategories as vC INNER JOIN vProducts as vP
--  on vC.CategoryID = vP.CategoryID
--   INNER JOIN vInventories as vI
--    on vP.ProductID = vI.ProductID;
--go
--Select 
-- vC.CategoryName
-- ,vP.ProductName
-- ,vI.InventoryDate
-- ,vI.Count
-- ,EmployeeName = CONCAT (vE.EmployeeFirstName, ' ',vE.EmployeeLastName)
-- from vCategories as vC INNER JOIN vProducts as vP
--  on vC.CategoryID = vP.CategoryID
--   INNER JOIN vInventories as vI
--    on vP.ProductID = vI.ProductID
--	 INNER JOIN vEmployees as vE
--	  on vI.EmployeeID = vE.EmployeeID;
--go
Create --or Alter
 View vCategoryProductEmployeeInventoryDateCount
 As
  Select TOP 1000000
  vC.CategoryName
  ,vP.ProductName
  ,vI.InventoryDate
  ,vI.Count
  ,EmployeeName = CONCAT (vE.EmployeeFirstName, ' ',vE.EmployeeLastName)
  from vCategories as vC INNER JOIN vProducts as vP
   on vC.CategoryID = vP.CategoryID
    INNER JOIN vInventories as vI
     on vP.ProductID = vI.ProductID
	  INNER JOIN vEmployees as vE
	   on vI.EmployeeID = vE.EmployeeID
  order by InventoryDate, CategoryName, ProductName, EmployeeName;
go
--Select * from vCategoryProductEmployeeInventoryDateCount;
--go

-- Here is an example of some rows selected from the view:
-- CategoryName	ProductName	        InventoryDate	Count	EmployeeName
-- Beverages	  Chai	              2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	              2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chartreuse verte	  2017-01-01	  69	  Steven Buchanan
-- Beverages	  Côte de Blaye	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Guaraná Fantástica	2017-01-01	  20	  Steven Buchanan
-- Beverages	  Ipoh Coffee	        2017-01-01	  17	  Steven Buchanan
-- Beverages	  Lakkalikööri	      2017-01-01	  57	  Steven Buchanan

-- Question 8 (10% pts): How can you create a view to show a list of Categories, Products, 
-- the Inventory Date and Count of each product, and the Employee who took the count
-- for the Products 'Chai' and 'Chang'? 

--Select ProductName
-- From vProducts
--  Where ProductID <= 2;
--go
--Select 
-- vC.CategoryName
-- ,vP.ProductName
-- ,vI.InventoryDate
-- ,vI.Count
-- ,EmployeeName = CONCAT (vE.EmployeeFirstName, ' ',vE.EmployeeLastName)
--  from vCategories as vC INNER JOIN vProducts as vP
--   on vC.CategoryID = vP.CategoryID
--    INNER JOIN vInventories as vI
--     on vP.ProductID = vI.ProductID
--	 INNER JOIN vEmployees as vE
--	  on vI.EmployeeID = vE.EmployeeID
--	   where vP.ProductName IN (Select ProductName
--			                     from vProducts
--				                 where ProductID <= 2);
--go
Create --or Alter
 View vChaiChangEmployeeInventoryDateCount
 As
  Select TOP 1000000
   vC.CategoryName
   ,vP.ProductName
   ,vI.InventoryDate
   ,vI.Count
   ,EmployeeName = CONCAT (vE.EmployeeFirstName, ' ',vE.EmployeeLastName)
    from vCategories as vC INNER JOIN vProducts as vP
     on vC.CategoryID = vP.CategoryID
      INNER JOIN vInventories as vI
       on vP.ProductID = vI.ProductID
	   INNER JOIN vEmployees as vE
	    on vI.EmployeeID = vE.EmployeeID
	     where vP.ProductName IN (Select ProductName
			                       from vProducts
				                   where ProductID <= 2)
	order by InventoryDate, ProductName;
go
--Select * from vChaiChangEmployeeInventoryDateCount;
--go

-- Here are the rows selected from the view:

-- CategoryName	ProductName	InventoryDate	Count	EmployeeName
-- Beverages	  Chai	      2017-01-01	  39	  Steven Buchanan
-- Beverages	  Chang	      2017-01-01	  17	  Steven Buchanan
-- Beverages	  Chai	      2017-02-01	  49	  Robert King
-- Beverages	  Chang	      2017-02-01	  27	  Robert King
-- Beverages	  Chai	      2017-03-01	  59	  Anne Dodsworth
-- Beverages	  Chang	      2017-03-01	  37	  Anne Dodsworth


-- Question 9 (10% pts): How can you create a view to show a list of Employees and the Manager who manages them?
-- Order the results by the Manager's name!

--Select *
-- from vEmployees;
--go
--Select 
-- EmployeeName = CONCAT (EmployeeFirstName, ' ',EmployeeLastName)
-- from vEmployees;
--go
--Select ManagerID
-- from vEmployees;
--go
--Select 
-- ManagerName = CONCAT (vM.EmployeeFirstName, ' ',vM.EmployeeLastName) 
-- ,EmployeeName = CONCAT (vE.EmployeeFirstName, ' ',vE.EmployeeLastName)
--  from vEmployees as vE INNER JOIN vEmployees as vM
--   on vE.ManagerID = vM.EmployeeID;
--go
Create --or Alter
 View vEmployeeListwManager
 As 
  Select TOP 1000000
   ManagerName = CONCAT (vM.EmployeeFirstName, ' ',vM.EmployeeLastName) 
   ,EmployeeName = CONCAT (vE.EmployeeFirstName, ' ',vE.EmployeeLastName)
  from vEmployees as vE INNER JOIN vEmployees as vM
   on vE.ManagerID = vM.EmployeeID
  order by ManagerName, EmployeeName;
go
--Select * from vEmployeeListwManager;
--go
-- Here are teh rows selected from the view:
-- Manager	        Employee
-- Andrew Fuller	  Andrew Fuller
-- Andrew Fuller	  Janet Leverling
-- Andrew Fuller	  Laura Callahan
-- Andrew Fuller	  Margaret Peacock
-- Andrew Fuller	  Nancy Davolio
-- Andrew Fuller	  Steven Buchanan
-- Steven Buchanan	Anne Dodsworth
-- Steven Buchanan	Michael Suyama
-- Steven Buchanan	Robert King


-- Question 10 (20% pts): How can you create one view to show all the data from all four 
-- BASIC Views? Also show the Employee's Manager Name and order the data by 
-- Category, Product, InventoryID, and Employee.

--Select *
-- from vCategories;
--go
--Select *
-- from vProducts;
--go
--Select *
-- from vEmployees;
--go
--Select *
-- from vInventories;
--go
--Select
-- vC.CategoryID
-- ,vC.CategoryName
-- ,vP.ProductID
-- ,vP.ProductName
-- ,vP.UnitPrice
-- ,vI.InventoryID
-- ,vI.InventoryDate
-- ,vI.Count
-- ,vE.EmployeeID
-- ,EmployeeName = CONCAT(vE.EmployeeFirstName, ' ',vE.EmployeeLastName)
-- ,ManagerName = CONCAT (vM.EmployeeFirstName, ' ',vM.EmployeeLastName)
-- from vCategories as vC INNER JOIN vProducts as vP
--     on vC.CategoryID = vP.CategoryID
--      INNER JOIN vInventories as vI
--       on vP.ProductID = vI.ProductID
--	   INNER JOIN vEmployees as vE
--	    on vI.EmployeeID = vE.EmployeeID
--		INNER Join vEmployees as vM
--         on vE.ManagerID = vM.EmployeeID;
--go
Create --or Alter
 View vCategoryProductInventoryEmployeeManager
 As 
  Select TOP 1000000
   vC.CategoryID
   ,vC.CategoryName
   ,vP.ProductID
   ,vP.ProductName
   ,vP.UnitPrice
   ,vI.InventoryID
   ,vI.InventoryDate
   ,vI.Count
   ,vE.EmployeeID
   ,EmployeeName = CONCAT(vE.EmployeeFirstName, ' ',vE.EmployeeLastName)
   ,ManagerName = CONCAT (vM.EmployeeFirstName, ' ',vM.EmployeeLastName)
  from vCategories as vC INNER JOIN vProducts as vP
   on vC.CategoryID = vP.CategoryID
    INNER JOIN vInventories as vI
     on vP.ProductID = vI.ProductID
	  INNER JOIN vEmployees as vE
	   on vI.EmployeeID = vE.EmployeeID
		INNER Join vEmployees as vM
         on vE.ManagerID = vM.EmployeeID
   order by CategoryName, ProductName, InventoryID, EmployeeName;
go
--Select * from vCategoryProductInventoryEmployeeManager;
--go
-- Here is an example of some rows selected from the view:
-- CategoryID	  CategoryName	ProductID	ProductName	        UnitPrice	InventoryID	InventoryDate	Count	EmployeeID	Employee
-- 1	          Beverages	    1	        Chai	              18.00	    1	          2017-01-01	  39	  5	          Steven Buchanan
-- 1	          Beverages	    1	        Chai	              18.00	    78	        2017-02-01	  49	  7	          Robert King
-- 1	          Beverages	    1	        Chai	              18.00	    155	        2017-03-01	  59	  9	          Anne Dodsworth
-- 1	          Beverages	    2	        Chang	              19.00	    2	          2017-01-01	  17	  5	          Steven Buchanan
-- 1	          Beverages	    2	        Chang	              19.00	    79	        2017-02-01	  27	  7	          Robert King
-- 1	          Beverages	    2	        Chang	              19.00	    156	        2017-03-01	  37	  9	          Anne Dodsworth
-- 1	          Beverages	    24	      Guaraná Fantástica	4.50	    24	        2017-01-01	  20	  5	          Steven Buchanan
-- 1	          Beverages	    24	      Guaraná Fantástica	4.50	    101	        2017-02-01	  30	  7	          Robert King
-- 1	          Beverages	    24	      Guaraná Fantástica	4.50	    178	        2017-03-01	  40	  9	          Anne Dodsworth
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    34	        2017-01-01	  111	  5	          Steven Buchanan
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    111	        2017-02-01	  121	  7	          Robert King
-- 1	          Beverages	    34	      Sasquatch Ale	      14.00	    188	        2017-03-01	  131	  9	          Anne Dodsworth


-- Test your Views (NOTE: You must change the names to match yours as needed!)
Print 'Note: You will get an error until the views are created!'
Select * From [dbo].[vCategories]
Select * From [dbo].[vProducts]
Select * From [dbo].[vInventories]
Select * From [dbo].[vEmployees]

Select * From [dbo].[vCategoryProductPrice]
Select * From [dbo].[vProductInventoryDateCount]
Select * From [dbo].[vInventorybyEmployee]
Select * From [dbo].[vCategoryProductInventoryDateCount]
Select * From [dbo].[vCategoryProductEmployeeInventoryDateCount]
Select * From [dbo].[vChaiChangEmployeeInventoryDateCount]
Select * From [dbo].[vEmployeeListwManager]
Select * From [dbo].[vCategoryProductInventoryEmployeeManager]

/***************************************************************************************/