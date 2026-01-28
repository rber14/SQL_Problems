--Use AdventureWorks2022

-- CREATE DATABASE database_create_example

-- DROP DATABASE database_create_example


-- CREATE TABLE Employees_Example
--(
--	ID INT Primary KEY IDENTITY,
--	FirstName VARCHAR(50) NOT NULL,
--	LastName VARCHAR(50) NOT NULL,
--	DateOfBirth DATETIME2
--)

-- DROP TABLE Employees_Example

--CREATE TABLE JobTitles
--(
--	TITLE_ID INT PRIMARY KEY IDENTITY,
--	[name] VARCHAR(100) NOT NULL
--)

--ALTER TABLE Employees_Example
--ADD JobTitleID INT NOT NULL

--ALTER TABLE Employees_Example
--ADD FOREIGN KEY (JobTitleID) REFERENCES JobTitles(TITLE_ID)


-- unique and default constrains

-- the unique constrain, must have a unique entry will reject if not
--ALTER TABLE Employees_Example
--ADD EmployeeID VARCHAR(10) UNIQUE

-- we Assume that the date added to the database is the date hired 
-- we add specify the default to be the date not NULL  if there is none
--ALTER TABLE Employees_Example
--ADD EmploymentDate DateTime2 DEFAULT GetDate()

-- how to drop columns and constrains
--ALTER TABLE Employees_Example
--DROP COLUMN DateOfBirth
--ALTER COLUMN DateOfBirth date

-- droping constrain
--ALTER TABLE Employees_Example
----DROP CONSTRAINT UQ__Employee__7AD04FF024CDB933 

---- we can name the constrain to make it more managable
--ADD CONSTRAINT UQ__Employee__ID UNIQUE(EMPLOYEEID)

-- clean up environment
-- if it's in use then make sure all scripts are disconnected by left click then going to connections and dropping all conections
--DROP DATABASE AdventureWorks2022





------------------------------------------------------------------------------------------

-- READING DATA

--USE AdventureWorks2022

---- select all data from a table
--SELECT * FROM HumanResources.Employee

---- select top 100 records from table
--SELECT TOP 100 * FROM HumanResources.Employee

---- We can explicity choose columns
--SELECT LOGINID, Jobtitle, hiredate FROM HumanResources.Employee

---- filtering
---- only person with marketing
--SELECT * FROM HumanResources.Employee 
--WHERE JobTitle = 'Marketing Assistant' AND Gender = 'M'
----WHERE BusinessEntityID = 20

---- sorting
--SELECT * FROM HumanResources.Employee 
--ORDER BY HireDate DESC, BusinessEntityID ASC







---------------------------------------------------------------------------------
-- wildcards -> don't know the exact string but find a pattern

-- filtering with wildcards

-- select all records with work marketing in job title
--contains
--SELECT * FROM HumanResources.Employee
--WHERE JobTitle LIKE '%marketing%'

----starts
--SELECT * FROM HumanResources.Employee
--WHERE JobTitle LIKE 'manager%'

----ends
--SELECT * FROM HumanResources.Employee
--WHERE JobTitle LIKE '%manager'

---- aliasing columns
--SELECT LoginID as [sign-on id], jobtitle [job title] , hiredate as 'hire date'
--from HumanResources.Employee

---- joins
---- select all employees and the departments that they represent

---- union / union all
----select * from sales.Customer
----select * from person.person
----select * from HumanResources.Employee

---- have the same data points to make a dataset from two queries using union

---- union
---- discards duplicates, all firstnames that are discard and only bring distinct values
--select per.firstname from HumanResources.Employee emp
--inner join person.Person per on emp.BusinessEntityID = per.BusinessEntityID
--UNION
--select per.FirstName from sales.Customer cust
--inner join person.Person per on per.BusinessEntityID = cust.PersonID

---- union all 
---- brings everything back
--select per.firstname from HumanResources.Employee emp
--inner join person.Person per on emp.BusinessEntityID = per.BusinessEntityID
--UNION ALL
--select per.FirstName from sales.Customer cust
--inner join person.Person per on per.BusinessEntityID = cust.PersonID


-- DISTICT versus group by 
-- elimiate all duplicates 

-- aggregate functions
-- allows us to return certain stats on our data.  
 
 SELECT COUNT(per.FirstName) from sales.Customer cust
 inner join person.person per on per.BusinessEntityID = cust.PersonID

 -- using group by 
  SELECT per.firstname, COUNT(per.FirstName) from sales.Customer cust
 inner join person.person per on per.BusinessEntityID = cust.PersonID
 group by per.FirstName
 order by per.FirstName

 -- how to see dups
 --SELECT per.firstname, COUNT(per.FirstName) from sales.Customer cust
 --inner join person.person per on per.BusinessEntityID = cust.PersonID
 --group by per.FirstName
 --having count(per.FirstName) > 1
 --order by per.FirstName

 -- aggregations
 --SELECT sum(totalDue) as sumTotal, avg(totalDue) as avgTotal, min(totalDue) as minTotal, max(totalDue) as maxTotalfrom
 --from sales.SalesOrderHeader

 -- agg part 2
 --select p.FirstName, p.LastName, sum(soh.totalDue) as totalSales, avg(soh.totalDue) as averageSales, min(soh.totalDue) as minSale, max(soh.totalDue) as maxSale
 --from sales.SalesPerson  sp
 --inner join person.person p ON sp.BusinessEntityID = p.BusinessEntityID
 --inner join sales.SalesOrderHeader soh on soh.SalesPersonID = sp.BusinessEntityID
 --group by p.FirstName, p.LastName
 --order by totalSales desc

 -- format the prev query to have full name column and currency formatted values
 --select rtrim(ltrim(concat(p.firstname, ' ', p.lastname))) as Name, Format(sum(soh.totalDue), 'c') as totalSales, format(avg(soh.totalDue), 'c') as averageSales, format(min(soh.totalDue), 'c') as minSale, max(soh.totalDue) as maxSale
 --from sales.SalesPerson  sp
 --inner join person.person p ON sp.BusinessEntityID = p.BusinessEntityID
 --inner join sales.SalesOrderHeader soh on soh.SalesPersonID = sp.BusinessEntityID
 --group by p.FirstName, p.LastName
 --order by totalSales desc

 ---------------------------------------------------
 -- exporting the data
 -- you need it in a good format
 -- click white corner left box and choose save with header

 -------------------------------------------------------------------------------
 -- SUBQUERIES

-- CTE common tables express
-- a named temporary table
-- once completed cte is not accesible

--WITH SALES_CTE as 
--(
--	select salesPersonId, salesOrderID, year(orderdate) as salesyear
--	from sales.SalesOrderHeader
--	where SalesPersonID is not null
--)
--select salespersonid, count(salesorderid) as totalSales, salesyear
--from SALES_CTE
--group by salesyear, SalesPersonID
--order by SalesPersonID, salesyear

-- window function
-- operate on a set of rows and return a single aggregates value for each row. set of rows in the database where function will operate
-- types of windowfunctions - agg, ranking, value window functions i.e LAG, LEAD, FIRSTVAlUE

-- agg window function
--select salesorderid, carriertrackingnumber, orderqty, max(unitprice) over (partition by salesorderid) as MaxUnitPrice, min(unitprice) over (partition by salesorderid) as MinUnitPrice
--from sales.SalesOrderDetail

-- rank, dense rank, row number

-- lead 'looks ahead', lag 'looks behind' , lead(column_name, offset, default_value) over (order by col1)

--select productid, name, ProductNumber, SafetyStockLevel,
--lead(safetyStockLevel, 5, 0) over (order by productID) as NExtStockLevel
--from production.product

-- isnull and coalesce

-- syntax: isnull(expression, value)  " t sql native '
--		   coalesce(expression, expression, ..., )


--select coalesce(title, 'N/A') as Title, firstname, lastname, isnull(suffix, 'N/A') as Suffix
--from person.Person


--select BusinessEntityID, RATE, (select AVG(RATE) from HumanResources.EmployeePayHistory) as avgRate
--from HumanResources.EmployeePayHistory
--where rate > (select avg(rate) from HumanResources.EmployeePayHistory)



-----------------------------------------------------------------------------------------------------------------
-- INSERTING DATA
-- Full insert syntax: INSERT INTO Schema.TableName (col1, col2, col3, etc...) VALUES (val1, val2, cal3 ,etc...)
--INSERT INTO SALES.Currency 
--(
--	CurrencyCode, 
--	[name], 
--	ModifiedDate
--)
--VALUES
--(
--	'KYD',
--	'Cayman Dollar',
--	GETDATE()
--)

--select * from Sales.Currency
--where CurrencyCode = 'KYD'

-- insert new currency - bitcoin - btc
--INSERT INTO SALES.Currency VALUES ('BTC', 'Bitcoin', GETDATE()), ('XRP', 'XRP', GETDATE())

-- PARTIAL INSERT
--INSERT INTO SALES.Currency (CurrencyCode, [Name]) VALUES ('LTC', 'Litecoin')

--select * from Sales.Currency
--where CurrencyCode = 'LTC'
-----------------------------
-- RELATED DATA
-- inserting related data, inserting new country region currency - cayman islands
-- understand the keys and fk. primary key has to exist before entering the foreign key

--INSERT INTO Sales.CountryRegionCurrency ([CountryRegionCode], CurrencyCode) VALUES('KY', 'KYD')
-- check by doing a select where ky

-- sales.salesterritory
-- newid generates guid, or it is also auto generated if guid is a default value, territoy is an auto incremented value 
--INSERT INTO sales.SalesTerritory ([name], CountryRegionCode, [Group], rowguid) VALUES('Jamaica', 'JM', 'LATAM', NEWID())
--INSERT INTO sales.SalesTerritory ([name], CountryRegionCode, [Group], rowguid) VALUES('Cayman Islands', 'KY', 'LATAM', NEWID())

--select * from sales.SalesTerritory where [name] like 'Cayman%'
----------------------------------

-- select into statements
-- scenario save the data from one to another
--select * into purchasing.purchaseorderdetailbackup2023
--from Purchasing.PurchaseOrderDetail

-- what if you only want some columns
--select purchaseorderid, employeeid, orderdate, totaldue into purchasing.purchaseorders2023
--from Purchasing.PurchaseOrderHeader

-- this example: purchaseorderdetail_new takes only the structure of purchaseorderdetail but no values because of the where clause
-- good for many scenerios
--SELECT * INTO purchasing.purchaseorderdetail_new
--from Purchasing.PurchaseOrderDetail
--where 1 = 0

-----------------------------------------------
-- create a new database and select into a table from this database

--USE MASTER
--CREATE DATABASE adventureworks2023
--GO
--USE [AdventureWorks2022]

--SELECT * INTO adventureworks2023.dbo.purchaseorderdetail
--from Purchasing.PurchaseOrderDetail


-------------------------------------------------------------

--UPDATE
-- SYNTAX:
--UPDATE table_name
--SET column1 = value1, column2 = value2, ...
--WHERE condition


--SELECT TOP 100 * FROM Person.Person

--UPDATE PERSON.PERSON
--SET Title = 'Mr.'
--WHERE BusinessEntityID = 4

--UPDATE PERSON.PERSON
--SET Title = 'Mr.', MiddleName = 'B'
--WHERE BusinessEntityID = 10

------Checking what we want to update
--SELECT p.firstname, p.lastname, a.addressline1, a.city, p.emailpromotion
--FROM person.person p
--inner join person.BusinessEntityAddress be on p.BusinessEntityID = be.BusinessEntityID
--inner join person.Address a on be.AddressID = a.AddressID
--where a.city = 'Bothell'

---- now update the table according to the above join
--update person.person set EmailPromotion = 1
--FROM person.person p
--inner join person.BusinessEntityAddress be on p.BusinessEntityID = be.BusinessEntityID
--inner join person.Address a on be.AddressID = a.AddressID
--where a.city = 'Bothell'

---- could update using cte
--with cte 
--as
--(
-- select businessentityid, bonus, commissionPct
-- from sales.salesperson sp
-- inner join sales.SalesTerritory st on sp.territory = st.TerritoryID
-- where countryregioncode = 'us'
--)
--UPDATE cte SET bonus -= Bonus * 0.75


-------------------------------------------------------
-- DELETE
-- syntax:
--DELETE FROM <TABLE>
--WHERE <PREDICATE>

-- create table from select statement
--DROP TABLE Person.PersonDEMO
--select * into person.personDEMO
--from person.Person

--select * from person.personDemo

---- delete all rows in a column
--delete from person.personDemo
--where emailpromotion = 2

---- delete a single record
--delete from person.persondemo
--where title = 'Mr.'

---- large deletes can cause time since it logs if the log is activated
---- if you want to delete all the data use truncate
---- truncate is all or nothing. truncate deletes faster
--TRUNCATE TABLE person.personDEMO


--with cte as 
--(
--	select top 10 * from  person.personDemo
--)
--delete from cte

-- delete using join
-- you are referencing other tables. SO if you delete one record from one table that references another table
-- you need to delete that record also.

-- use cascade delete
-- helps maintain data integrity.

--SELECT * FROM Employees;
--SELECT * FROM Departments;

--DELETE FROM Departments
--WHERE ID = 1;

--Alter table Employees drop constraint FK__Employees__Depar__267ABA7A;

--Alter table Employees
--add constraint FK__Employees__Depar__267ABA7A
--foreign key (DepartmentID) references Departments(Id) on delete cascade;

---------------------------------------------------------------------------------
-- mod10 designing and creating views and functions
-- some of the info is sourced from other tables
-- a view is simily a query, creating a view and re use going forward
--select top 100 * from humanresources.vEmployee

--USE AdventureWorks2022
--GO

--CREATE VIEW SALES.vSALESPERSONSTOTAL
--AS
--SELECT 
--	p.firstname,
--	p.lastname,
--	count(soh.totaldue) [number of sales],
--	sum(soh.totaldue) [total sales],
--	avg(totaldue)[average sales amount],
--	min(totaldue)[lowest sales amount],
--	max(totaldue)[highest sales amount]
--FROM sales.SalesPerson s
--inner join person.person p on p.BusinessEntityID = s.BusinessEntityID
--inner join sales.SalesOrderHeader soh on soh.salespersonid = s.BusinessEntityID
--group by p.FirstName, p.LastName

--select * from SALES.vSALESPERSONSTOTAL


---- MANAGING VIEW AFTER CREATION
---- create or alter view
--GO
--CREATE OR ALTER VIEW SALES.vSALESPERSONSTOTAL
--AS
--SELECT 
--	p.firstname,
--	p.lastname,
--	count(soh.totaldue) [number of sales],
--	sum(soh.totaldue) [total sales],
--	avg(totaldue)[average sale amount],
--	min(totaldue)[lowest sale amount],
--	max(totaldue)[highest sale amount]
--FROM sales.SalesPerson s
--inner join person.person p on p.BusinessEntityID = s.BusinessEntityID
--inner join sales.SalesOrderHeader soh on soh.salespersonid = s.BusinessEntityID
--group by p.FirstName, p.LastName
--GO

----check
----SELECT * FROM SALES.vSALESPERSONSTOTAL

---- DROPING A VIEW
--DROP VIEW Sales.vSALESPERSONSTOTAL

----------------------
-- variables
-- temp object used to store data during the batch execution period

--DECLARE @tempMessage AS VARCHAR(100) -- = 'Testing Variable'

----SET @tempMessage = 'Testing Variable'
----SELECT @tempMessage = 'Testing Select Varaible
--print @tempMessage

--DECLARE @HighestSaleFigure AS DECIMAL(10, 2)
--SELECT TOP 1
--	@HighestSaleFigure = MAX(totaldue) 
--FROM sales.SalesPerson s
--inner join person.person p on p.BusinessEntityID = s.BusinessEntityID
--inner join sales.SalesOrderHeader soh on soh.salesPersonID = s.BusinessEntityID
--Group by p.FirstName, p.LastName
--order by max(totaldue) desc


--print @HighestSaleFigure


----- example 2
--DECLARE @multiplier as int = 10

--SELECT 
--	p.firstname,
--	p.lastname,
--	count(soh.totaldue) * @multiplier [number of sales],
--	sum(soh.totaldue) * @multiplier [total sales],
--	avg(totaldue) * @multiplier [average sale amount],
--	min(totaldue) * @multiplier [lowest sale amount],
--	max(totaldue)* @multiplier [highest sale amount]
--FROM sales.SalesPerson s
--inner join person.person p on p.BusinessEntityID = s.BusinessEntityID
--inner join sales.SalesOrderHeader soh on soh.salespersonid = s.BusinessEntityID
--group by p.FirstName, p.LastName

-------------------------------------------------------------------------
-- functions
-- there are exisitng functions in microsoft sql
-- what is a scalar function
 
--declare @dateValue as Datetime2 = getdate()

--select year(@dateValue) as [YEAR], Month(@dateValue) as [month], day(@datevalue) as [Day]
--GO 
--CREATE FUNCTION fnGetAverageSalesForYear
--(
--	-- add parameters for the function 
--	@YEAR INT 
--)
--RETURNS DECIMAL(10, 2)
--AS
--BEGIN
---- logic
---- declare the return variable here
--	DECLARE @AverageSalesAmount DECIMAL (10, 2)

--	-- add t sql statement to compute the return value
--	SELECT @AverageSalesAmount = AVG([totaldue])
--	FROM sales.SalesOrderHeader
--	where year([OrderDate]) = @YEAR

--	-- return the result of the function
--	RETURN @AverageSalesAmount
--END


-- table valued functions
-- making a select statement reusable
-- funciton creates a wrapper manipulating the data

--CREATE FUNCTION udfGetProductsWithInventoryGreaterThan(@count int)
--Returns Table
--as
--return
--	select 
--		p.name as product_name, 
--		p.ProductNumber,
--		piv.Quantity,
--		lo.Name
--	from production.[product] p 
--	inner join [production].productinventory piv on p.ProductID = piv.ProductID
--	inner join production.Location lo on piv.LocationID = lo.LocationID
--	where piv.Quantity >= @count

---- use function built
--select * from dbo.udfGetProductsWithInventoryGreaterThan(800)


-- views = a saved select query
-- materialized view / indexed view = a view that is physically stored and kept updated via an index

-- When to use which?
--✔ Use a View when:

--    You need real‑time data

--    The underlying tables are small or indexed well

--    The query is not expensive

--    You want to hide complexity

--    You don’t want to slow down inserts/updates

--Example scenario:
--A dashboard showing live order statuses that change frequently.
-- Use a Materialized View (Indexed View) when:

--    The dashboard is slow due to heavy aggregations

--    You have millions of rows and need fast summaries

--    You want to precompute totals (sales by day, counts, averages)

--    You can tolerate slightly slower writes

--Example scenario:
--A dashboard showing total sales per region, daily revenue, or inventory counts that don’t need second‑by‑second freshness.
-- Quick rule of thumb

--    If your dashboard needs fresh data every second → View

--    If your dashboard needs fast performance on heavy queries → Materialized View

--    If your dashboard needs both → consider incremental ETL or cache tables
------------------------------------------------------------------------------------------

-- CONTROL FLOW STATEMENTS
-- the begin ... end statement is used to define a statement block. A statement block consist of a set of sql statements
-- that execute together. A statement block is also know as a batch

-- example
--BEGIN
--	DECLARE @ID INT;
--	SELECT @ID = MAX(BusinessEntityID) FROM PERSON.PERSON;
--	PRINT('The person id :' + CAST(@ID as NVARCHAR));
--END

---- you can also have nested batches / statement blocks
--BEGIN
--	DECLARE @ID INT;
--	SELECT @ID = MAX(BusinessEntityID) FROM PERSON.PERSON;
--	PRINT('The max person id :' + CAST(@ID as NVARCHAR));

--	BEGIN
--	SELECT @ID = MIN(BusinessEntityID) FROM PERSON.PERSON;
--	PRINT('The min person id :' + CAST(@ID as NVARCHAR));
--	END
--END

-------------------------------------
-- IF / ELSE Statements
-- Control flow statement
-- SYNTAX
--IF boolean_expression
--BEGIN
--{statment block}
--END
--ELSE
--BEGIN
--{statement block}
--END

-- you can also do a nested IF
--BEGIN 
--	DECLARE @NUM int = 10;

--	if @num > 10
--	BEGIN
--		print('YES')
--	END
--	ELSE
--		print('NUM not Greater than')

--END

--BEGIN 
--	DECLARE @BID INT;
--	SET @BID = 11;

--	SELECT * FROM Person.Person
--	WHERE BusinessEntityID = @BID

--	if @@ROWCOUNT > 0
--	BEGIN
--		print('Record of person with buisness enitiy id ' + CAST(@BID as VARCHAR) +' has been found')
--	END
--	ELSE
--		print('Record of person with buisness enitiy id ' + CAST(@BID as VARCHAR) +' has NOT been found')

--END

------------------------------------
-- while loop
--SYNTAX:
--WHILE Expression
--	BEGIN
--		statement1
--		statement 2
--	---
--	END
---- outside statenent

--DECLARE @num INT = 1;
--DECLARE @total INT = 0

--WHILE @NUM <= 10
--BEGIN
--	SET @total = @total + @num;
--	SET @num = @num + 1;
--	print @total
--END

--PRINT @total

-------------------------------
-- break statement


--DECLARE @num INT = 1;
--DECLARE @total INT = 0

--WHILE @NUM <= 10
--BEGIN
--	SET @total = @total + @num;
--	--SET @num = @num + 1;
--	BREAK
--	print @total
--END

--PRINT @total

--------------------------------------
-- CASE
-- Case expression evaluates a set of conditions
--SYNTAX
--CASE input_expressin
--	when test_expression then result_expression
--	....
--	ELSE default_expression
--END

--SELECT jobtitle, birthdate, maritalstatus, hiredate, gender
--FROM humanResources.Employee

--SELECT jobtitle, birthdate, maritalstatus, hiredate
--	,CASE (Gender)
--		when 'M' THEN 'Male'
--		when 'F' Then 'Female'
--		ELSE 'N/A'
--	END as Gender
--FROM HumanResources.Employee

--------------------------------------------------------------------------------
-- STORED PROCEDURES 
-- TYPE of database object in microsoft sql sever that allows you to encapsulate a sequence of SQL statements
-- and procedural logic into a single unit. 

-- benefits: improved performance, makes code reusable
-- Ex:
--CREATE PROCEDURE GetCustomerByID
--	@CustomerID int
--AS
--BEGIN
--	SELECT *
--	FROM Customers	
--	WHERE CustomerID = @CustomerID
--END

---- to execute procedure
--EXEC GetCustomerByID @CustomerID = 1001

-- 

--CREATE PROC ps_MaxMin @ID INT
--AS
--BEGIN 
--	PRINT('The max Person ID id: ' + CAST(@ID as nvarchar))

--	BEGIN 
--		SELECT @ID = MIN(BusinessEntityID) FROM Person.Person
--		PRINT('The min Person ID id: ' + CAST(@ID as NVARCHAR))
--	END

--END

---- this is how you execute the procedure, so insted of sending the whole clause you just send the statement below
--EXEC ps_MaxMin @ID = 100
--EXEC ps_MaxMin 200


--ALTER PROC ps_MaxMin @ID INT
--AS
--BEGIN 
--	PRINT('The Person ID id: ' + CAST(@ID as nvarchar) + ' Altered')

--	SELECT * FROM Person.Person WHERE BusinessEntityID = @ID

--END

---- MULTIPLE PARAMS

--CREATE OR ALTER PROCEDURE sp_person @ID INT, @PT VARCHAR(5)
--AS
--BEGIN
--	SELECT * FROM Person.Person WHERE BusinessEntityID > @ID and PersonType = @PT

--	IF @@ROWCOUNT = 0
--		PRINT('NO RECORD FOUND')
--END
--GO

--EXEC sp_person 200, 'em'

--CREATE OR ALTER PROCEDURE SP_FindMaxPerson(@max int output)
--AS
--BEGIN
--	SELECT MAX(businessEntityID) FROM Person.Person
--END

--DECLARE @max INT

--EXEC sp_findmaxperson @max OUTPUT

--print(@max)

-- stored procedure help encapusulate complex logic and improve security granting permissons on 
-- procedures rather than specific tables or views, common used to manipulate data, business logic implementation and report regeneration


---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Triggers
-- A trigger is a special type of stored procedure that is automatically executed in respinse to a specific database event,
-- such as insert, update, or delete operations on a table
-- 2 types of triggers
-- after triggers: After the sql operation insert update or delete has SUCESSFULLY completed
-- WHEN TO USE:
--    You need auditing (logging inserts/updates/deletes)
--    You want to cascade actions after a change
--    You need to validate results after the DML succeeds
--    You want to enforce business rules after data is written
--Examples:
--    audit trails
--    logging user activity
--    sending notifications after inserts
--    maintaining history tables

--instead of triggers: replace the original action and let you control what hapens
--                   Custom override logic, used on views that arn't normally updateable, lets you validate or transform data before writing
-- WHEN TO USE:
--    You need to make a non‑updatable view updatable
--    You want to override what INSERT/UPDATE/DELETE actually do
--    You need complex validation before allowing the operation
--    You want to redirect writes to multiple tables
--Examples:
--    updating complex views
--    splitting inserts across multiple tables
--    blocking certain operations with custom logic
--    validating data before allowing writes

-- DDL Triggers
-- LOG on Triggers

--------

--CREATE DATABASE DEMO

--CREATE TABLE Orders(
--	OrderID PRIMARY KEY,
--	CustomerName VARCHAR(50),
--	OrderDate DATE,
--	TotalAmount DECIMAL(10, 2)
--)
--GO

--CREATE TABLE OrderHistory (
--	HistoryID INT PRIMARY KEY,
--	OrderID INT,
--	Action VARCHAR(10),
--	ActionDate DATETIME,
--	CustomerName VARCHAR(50)
--)
--GO

--AFTER INSERT, UPDATE, DELETE
--AS
--BEGIN
--	SET NOCOUNT ON

--	IF EXISTS (SELECT * FROM inserted)
--	BEGIN
--		-- insert or update action
--		IF EXISTS (SELECT * FROM deleted)
--		BEGIN
--			--update action
--	END
--	ELSE
--	BEGIN
--			-- insert action
--    END
--END
--ELSE
--BEGIN

-- CURSORs
-- A database cursor is an object that enables traversal over the rows of a result set.
-- It allows you to process individual row returned by a query. 
-- Types of cursor:
-- forward only 
-- static curson
-- dynamic cursor
-- keyset cursor
-- resource intensive
-- fetch only necessary columns

-- syntax

--declare productscr cursor static
--	for
--	select top 10
--	col
--	col
--	col
--	...
--	col
--	FROM prod.prod
--open productscr
--fetch next from productcr -- only one record is returned
--close productscr
--deallocate productscr

-- you need a while loop 

--SET NOCOUNT ON
-- declare vars
------------------------------------------------------------------------------------
-- transaction and concurrency

-- a transaction is a logical unit of work. Either all the work completes as a whole or none.
-- ex. all dml is treated as a transaction

-- commit
-- roleback

-- ACID PROPERTIES
-- automicity, consistency, isolation, durability

-- database transaction log

-- transaction modes
-- implicit transaction
	-- set implicit_transaction on
-- autocommit

-- BASIC LOCKING
-- shared locks
-- exclusive locks

----------------------------------------------------------------
-- Autocommit, implicit, explicit transations
-- Autocommit : every individual statement is its own transaction
-- Implicit : sql automatically starts a transaction but does not commit it.
-- Explicit: You manually control everything


