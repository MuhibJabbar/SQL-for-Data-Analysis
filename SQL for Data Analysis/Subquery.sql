-- Sub Queries Categories
-- 1. Result Types 
-- 1.1 Scalar SubQuery : It will have only one row or one column in the result of query

select 
avg(Sales) Average_Sales
from sales.Orders

-- 1.2 Row SubQuery : It will have multiple rows and single column in the result of query
select 
Sales
from sales.Orders

-- 1.3 Table SubQuery : It will have multiple rows and columns in the reslut of query
select 
*
from sales.Orders

--2. Subquery Location and Clauses
--2.1 From Subquery

-- Main Query
Select *
from
--SubQuery
	(select
		ProductID,
		Product,
		Price,
		AVG(price) over() avg_price
 	from sales.Products)t
where Price>avg_price
-----
select *,
rank() over(order by total_sales desc) rank_sales
from(
select
	CustomerID,
	sum(sales) total_sales
from Sales.Orders
group by CustomerID)t


-- 2.2 Subquery in select clause

select *,
(select 
count(*) 
from Sales.Orders) total_orders
from sales.Products

-- 2.3 Subquery in Join Clause
select
sc.*,
so.total_orders
from Sales.customers sc
Left Join
(
select 
	CustomerID,
	COUNT(*) total_orders
	from Sales.Orders
	group by CustomerID
) so
ON sc.CustomerID = so.CustomerID

--2.4 Subquery in Where Clause

-- comparison operators   = , < , > , >= , <= , !=

select * from
Sales.products
where price >
(
select
avg(price) avg_price
from sales.Products)

-- Logical Operaters 
-- IN operators

select
*
from sales.Orders
where CustomerID IN( select CustomerID
					from 
					Sales.Customers
					where Country != 'Germany')

-- All , ANY operators

select * from sales.Employees
where Gender = 'F'
AND Salary > any (select Salary from Sales.Employees where Gender = 'M')

--Exsits operators

select * from sales.Orders so
where exists ( select * from Sales.Customers sc
				where Country = 'Germany'
				AND so.CustomerID = sc.CustomerID
				)