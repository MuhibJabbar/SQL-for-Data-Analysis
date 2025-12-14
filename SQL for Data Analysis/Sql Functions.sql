/*
SQL functions are grouped into two major categories:
1️. Single-Row Functions
(Used for row-level calculations — each row returns one result)
These include:
String Functions
Numeric Functions
Date & Time Functions
NULL Functions

2️. Multi-Row Functions
(Used for aggregations — return a single result for a group or entire table)
These include:
Aggregate Functions (Basics)
e.g., SUM, AVG, MIN, MAX, COUNT
Window Functions (Advanced)
e.g., ROW_NUMBER, RANK, LEAD, LAG
*/

/*

1. Single Row Functions 

1.1 String Functions

Manipulation Functions
Concat
*/

select first_name,country,
concat (first_name,' ',country) as name_country
from customers

/*
Upper & Lower, trim and replace
*/

select Lower(first_name), upper(first_name)from customers

select trim(first_name),LEN(first_name) from customers

select first_name from customers
replace (first_name)

/*
String Extraction
*/

/*
Left and right
*/

select first_name,
LEFT(trim(first_name),2),
RIGHT(trim(first_name),2)
from customers

/*
substrings
*/

select first_name,
SUBSTRING(TRIM(first_name),2,LEN(first_name))
from customers

/*
1.2 Numeric Functions 
*/

/*
Round Function
*/

select 4.546, 
ROUND(4.546,0),
ROUND(4.546,1),
ROUND(4.546,2)

/*
ABS 
*/

select -10,
ABS(-10),
ABS(10)

/*
1.3 Date and time function Start
*/
/*
1.3.1 Part Extraction

DAY
MONTH
YEAR
DATEPART
DATENAME
DATETRUNC
EOMONTH

*/
/*
Extraction of date month year
*/

select OrderID, CreationTime,
YEAR(CreationTime),
MONTH(CreationTime),
DAY(CreationTime)
from Sales.Orders

/*
Extraction of Date time and more with Datepart
*/

select OrderID, CreationTime,
DATEPART(YEAR,CreationTime) as year,
DATEPART(MONTH,CreationTime)as month,
DATEPART(DAY,CreationTime) as day,
DATEPART(HOUR,CreationTime) as hour ,
DATEPART(MINUTE,CreationTime)as minute,
DATEPART(SECOND,CreationTime)as second,
DATEPART(WEEK,CreationTime) as week,
DATEPART(WEEKDAY,CreationTime) weekday
from Sales.Orders

/*
Extraction of Date time names and more with Datename
*/

select OrderID, CreationTime,
DATENAME(MONTH,CreationTime) as month_name,
DATENAME(WEEKDAY,CreationTime) as weekday_name
from Sales.Orders;

/*
DateTrunc
*/

select CreationTime,
Datetrunc(minute,CreationTime) without_sec,
Datetrunc(hour,CreationTime) without_min,
Datetrunc(DAY,CreationTime)without_hour,
Datetrunc(MONTH,CreationTime)without_day,
Datetrunc(YEAR,CreationTime) without_month
from Sales.Orders;

select
Datetrunc(MONTH,CreationTime),
COUNT(*)
from Sales.Orders
group by datetrunc(MONTH,CreationTime)
;

/*
Orders in months
*/
select datename (MONTH,OrderDate) as mon,
COUNT(*)
from Sales.Orders
group by datename (MONTH,OrderDate);

/*
Orders in specific month
*/

select * from Sales.Orders
where MONTH(OrderDate) = 2 OR MONTH(OrderDate) = 3

/*
							Data Type
Date Month Year DatePart = Integar
				DateName = String
				DateTrunc = DateTime
				EOMonth = Date
*/

/*
1.3.2 Format & Casting

FORMAT
CONVERT
CAST
*/
/*
Format Funtion
*/

Select CreationTime,
FORMAT(CreationTime,'dd-MM-yyyy') as USA_time_format,
FORMAT(CreationTime,'MM-dd-yyyy') as Euro_time_format,
FORMAT(CreationTime,'dddd-MMMM-yyyy') as timedate_name_format
from Sales.Orders;

/*
Below for the practice 
we are just try to create this format
Day Weekday Month Q1 Year hour:minute:second am/pm 
*/
select OrderID, CreationTime,
'Day ' + FORMAT(CreationTime, 'ddd MMM ') + 
'Q' + DATENAME(QUARTER, CreationTime) + FORMAT(CreationTime, ' yyyy')+
FORMAT(CreationTime, ' hh:mm:ss tt')
from Sales.Orders;

select
	format(OrderDate, 'MMM yy'),
	COUNT(*)
from Sales.Orders
group by format(OrderDate, 'MMM yy');


/*
Convert
*/

select CreationTime,
CONVERT(Date, CreationTime),
CONVERT(varchar, CreationTime, 32),
CONVERT(varchar, CreationTime, 34)
from Sales.Orders

/*
casting
*/

select CreationTime,
cast(CreationTime as date),
cast(CreationTime as datetime),
cast(CreationTime as datetimeoffset),
cast(CreationTime as smalldatetime)
from Sales.Orders

/*
1.3.3. Calculations
DATEADD
DATEDIFF
*/

/*
DateAdd
*/

select OrderDate,
DATEADD(YEAR,2,OrderDate),
DATEADD(MONTH,5,OrderDate),
DATEADD(DAY,-10,OrderDate)
from Sales.Orders;

/*
DateDiff
*/

select 
EmployeeID,
BirthDate,
DATEDIFF(year,BirthDate,GETDATE()) age
from sales.Employees;

select 
format (OrderDate, 'MM-yyyy') Month,
avg(DATEDIFF(DAY,OrderDate,ShipDate)) avg_ship
from Sales.Orders
group by format (OrderDate, 'MM-yyyy');

select OrderID,
OrderDate Cr_date,
LAG(OrderDate) Over (Order By OrderDate) pr_date,
DATEDIFF(DAY,Lag(OrderDate) Over (Order By OrderDate),OrderDate)
from Sales.Orders;

/*
1.3.4. Validation

ISDATE
*/

select OrderDate,
ISDATE(OrderDate),
Case when ISDATE(OrderDate) = 1 then cast(OrderDate as date)
End
from(
	select '2025-08-20' as OrderDate union
	select '2025-07-29' union
	select '2025-08' 
)t
/*
Date and Time Function End
*/

/*
1.4 Null Functions 
*/

--ISNULL
select ShipAddress,BillAddress,
ISNULL(BillAddress,ShipAddress)
from Sales.Orders

--COALESCE
select ShipAddress,BillAddress,OrderStatus,
COAlESCE(ShipAddress,BillAddress,OrderStatus)
from Sales.Orders

--Handling Nulls 

select score, 
avg(score) over () avgscore
from customers;

-- displaying full names and adding 10 bonus points in score

select CustomerID, 
FirstName,
LastName,
Score,
FirstName + ' ' + coalesce( LastName,'') as Full_Name,
coalesce( Score, 0) + 10 as Score_w_Bonus
from Sales.Customers;

-- Handling null with joining tables

select * from sales.Customers;
select * from sales.Orders;

select sc.CustomerID,
so.ShipAddress,
so.BillAddress
from Sales.Customers as sc
join Sales.Orders as so
on sc.CustomerID = so.CustomerID;

--sort customers low to high nulls apperaing last

select id,score,
case when score = 0 then 1 else 0 end
from customers
order by case when score = 0 then 1 else 0 end; 

-- NullIF

select Quantity,Sales,
Sales / nullif(Quantity,0) as price
from Sales.Orders

--ISNuLL with with two tables

select sc.*,
OrderID
from Sales.Customers as sc
left join Sales.Orders so
On sc.CustomerID = so.CustomerID
where OrderID is null

--Null vs Empty String
WITH Orders as (
select 1 Id, 'A' category union
select 2, Null union
select 3, '' union
select 4, ' ' 
)
select *,
TRIM(category) policy1,
nullif(category,'') policy2,
coalesce (nullif(category,''),'unknown') policy3
from Orders;

-- Use Case Categorization
select category,
sum(Sales) as total_sales
from(
select OrderID,
Sales,
case 
when Sales > 50 then 'High'
when Sales > 20 and Sales < 51 then 'medium'
when sales < 21 then 'low' 
End category
from sales.Orders
)t
group by category
order by total_sales desc

--Mapping

select * , 
case when Gender = 'M' then 'Male'
else 'Female' 
end Gender
from sales.Employees

select distinct Country,
case when Country = 'Germany' then 'De'
else 'US' end
from Sales.Customers

-- Handling Nulls

select CustomerID,
FirstName,
LastName,
Score,
AVG(Score) over() AvgScore,
case 
	when score is null then 0
	else score
end CleanScore ,
avg(
	case 
	when score is null then 0
	else score
end 
) over () AvgCleanScore

from sales.Customers;

-- Conditional Aggregation

select 
CustomerID,
Sum (case
	when Sales > 30 then 1
	else 0
end) totalordershighsales,
COUNT(*) totalorders
from Sales.Orders
group by CustomerID


-- 2️. Multi-Row Functions

-- 2.1 Aggregate Functions

-- Total number of orders

select 
count(*) total_orders
from orders;

--Total number of sales

Select 
sum(sales) total_sales
from orders

-- avg sale of orders
Select 
avg(sales) avg_sale
from orders

--highest sales 

select max(sales) from orders


-- 2.2 Window Functions

-- Group By vs Window Functions

select
	ProductId,
	OrderId,
	OrderDate,
	sum(Sales) Nr_of_sales,
	COUNT(*) Nr_of_orders
from Sales.Orders
group by ProductID,OrderDate,OrderID;

select
	ProductId,
	OrderId,
	OrderStatus,
	Sales,
	sum(Sales) over(partition by ProductID order by OrderDate
	Rows between current row and 2 following
	) Nr_of_sales_1,
	-- order by always uses a frame unbounded preceding and current row
	sum(Sales) over(partition by ProductID order by OrderDate
	Rows between 2 preceding and current row
	) Nr_of_sales_2
from Sales.Orders

--Total sales for each order status only for two products 101 and 102

select 
ProductID,
OrderStatus,
Sales,
sum(Sales) over (partition by orderstatus)
from Sales.Orders
where ProductID = 101 or ProductID = 102

--Ranking Customers by total sales

Select 
CustomerID,
SUM(Sales),
RANK() over(order by sum(sales) desc)
from Sales.Orders
Group by CustomerID

--Aggregate Functions in window
--Count
Select
ProductID,
Sales,
COUNT(Sales) over(partition by productid )
from Sales.Orders

-- total number of customers and details

select
*,
COUNT(*) over (),
COUNT(Score) over(),
COUNT(LastName) over(),
COUNT(Country) over()
from Sales.Customers

--checking duplicates through count
select * from (
select OrderID,
ProductID,
Count(OrderID) over(partition by OrderID) dup_orderid,
Count(ProductID) over(partition by ProductID) dup_productid
from Sales.OrdersArchive) t
where dup_orderid > 1 and dup_productid > 1

--Aggregate function 
--SUM

select OrderID,
OrderDate,
ProductId,
Sum(Sales) over() total_sales,
Sum(Sales) over(partition by ProductId ) totalsalesbyeachproduct
from Sales.Orders

-- contribuation of each product sale into total sales
select 
OrderID,
Sales,
productid,
SUM(Sales) over () total_sales,
round(cast (sales as float) /SUM(Sales) over ()*100, 2 )
from Sales.Orders

--Aggregate function 
--AVG

select
OrderID,
OrderDate,
ProductID,
Sales,
AVG(Sales) over() avg_sal_all_orders,
AVG(Sales) over(partition by productid) avg_sal_each_prod
from Sales.Orders;

-----

Select CustomerID,
LastName,
Score,
avg(Score) over() avgscore,
coalesce(score, 0) scorewithoutnull,
AVG(coalesce(score, 0)) over() avgscorewithoutnull
from sales.Customers

----
select * from(
select 
	OrderID,
	ProductID,
	Sales,
	avg(sales) over() avgsales
from Sales.Orders)t
where sales > avgsales

--Aggregate function
--Min Max

Select
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	Max(Sales) over(),
	MIN(Sales) over(),
	Max(Sales) over(partition by productid),
	MIN(Sales) over(partition by productid)
from Sales.Orders

-------
select * from(
select EmployeeID,
FirstName,
Salary,
MAX(salary) over() highsalary
from Sales.Employees)t
where salary = highsalary

-- Moving Average

select 
OrderID,
OrderDate,
ProductID,
Sales,
Avg(Sales) over(partition by productid) avgsale,
Avg(Sales) over(partition by productid order by orderdate) movingavg,
Avg(Sales) over(partition by productid order by orderdate rows between current row and 
1 following) rollingavg
from Sales.Orders

-- 2.2 6x Rank Window Functions
--Row Number  this function will accept duplicate value as a single row as well

--Rank       this function will not accept duplicate value as single like if you have duplicate 
-- values it will assign same rank to both values and there will be gaps in ranking

-- Dense Rank     this function will not accept duplicate value as single like if you have duplicate 
-- values it will assign same rank to both values and there will be no gaps in ranking

select 
Sales,
Row_Number() over(order by sales desc),
Rank() over(order by sales desc),
dense_rank() over(order by sales desc)
from Sales.Orders

-- Row number use cases 
-- Highest sales each product 

select * from(
select 
OrderID,
ProductID,
Sales,
ROW_NUMBER() over(partition by productid order by sales) rank_RN
from Sales.Orders)t
where rank_RN = 1

-- lowest two customers based on sales

select * from (
select
CustomerID,
sum(Sales) totalsales,
ROW_NUMBER() over(order by sum(Sales)) rank_customers
from sales.Orders
group by CustomerID
)t
where rank_customers <= 2

-- Assigning uniques ID's to Archive Orders

select 
ROW_NUMBER() over(order by OrderID) Unique_Identifier,
*
from Sales.OrdersArchive

-- identify duplicates.
select * from(
select 
ROW_NUMBER() over(partition by orderid order by creationtime) RN,
*
from Sales.OrdersArchive)t
where RN >1

-- NTILE Function

select
OrderID,
Sales,
NTILE(1) over(order by sales) onebucket,
NTILE(2) over(order by sales) twobucket,
NTILE(3) over(order by sales) threeebucket,
NTILE(4) over(order by sales) fourbucket,
NTILE(5) over(order by sales) fivebucket
from Sales.Orders

--NTILE Use Case
select *,
Case 
	when Bucket = 1 then 'High'
	when bucket = 2 then 'Medium'
	when bucket = 3 then 'low'
end salesegmentation
from (
select
OrderID,
Sales,
NTILE(3) over (order by sales) bucket
from Sales.Orders)t

--NTILE equalizing load

select
NTILE(2) over (order by sales) bucket,
*
from Sales.Orders

--Percentage Based Ranking
--Cume_Dist and Percent_Rank
-- Both handles the ties mean if there will be two same row values they gonna consider it one.

Select OrderID,
ProductID,
Sales,
concat(round (PERCENT_RANK() over(order by sales)*100,2),'%')
from Sales.Orders

--

select * from(
select Product,
Price,
CUME_DIST() over(order by price desc) distrank
from Sales.Products)t
where distrank <= 0.4

-- Value Functions

-- Lead & Lag

-- Month over Month Sales

select *,
currentmonthsales-previousmonthsales as mom_change,
round (cast((currentmonthsales-previousmonthsales) as float)/previousmonthsales*100,2) mom_perc
from (
select
MONTH(OrderDate) ordermonth,
SUM(Sales) currentmonthsales,
lag(SUM(Sales)) over(order by month(orderdate)) previousmonthsales
from Sales.Orders
group by month(OrderDate))t

--customer rentention analysis on avaerge days between theor orders

select
CustomerID,
avg(daysuntilnextorder) avgdays,
RANK() over(order by coalesce (avg(daysuntilnextorder), 999999)) Rankavg
from (
select
	OrderID,
	CustomerID,
	OrderDate currentorder,
	LEAD(OrderDate) over(partition by customerid order by orderdate) nextorder,
	datediff(day,orderdate,LEAD(OrderDate) over(partition by customerid order by orderdate)) daysuntilnextorder
from sales.Orders)t
group by CustomerID

-- Last_Value and First_Value Functions

--Highest and lowest sales of each product

select ProductID,
Sales,
FIRST_VALUE(Sales) over(partition by productid order by sales) lowest_value,
LAST_VALUE(Sales) over (partition by productid order by sales 
rows between current row and unbounded following)highest_value
from Sales.Orders


