-- Non Recursive CTE's

--Standalone , multiple , Nested CTE 
-- Step 1 : Find total sales per customer (Standalone CTE)
With CTE_Total_Sales As 
(
Select CustomerID,
SUM(Sales) total_sales
from SalesDB.Sales.Orders
group by CustomerID)

-- Step 2: last order of each customer (Standalone CTE)
, CTE_last_order as 
(
select CustomerID,
	max(OrderDate) last_order
from Sales.Orders
group by CustomerID
)

-- Step 3: Rank customers by their total sales (Nested CTE)
,CTE_Customer_Rank as
(
	select CustomerID,
	total_sales,
	rank() over(order by total_Sales desc) as CustomerRank
	from CTE_Total_Sales
)
-- Step 4: Customer Segment by their total sales (Nested CTE)
, CTE_Customer_Segment as (
	select 
		CustomerID,
		total_sales,
	Case 
		when total_sales > 100 then 'High'
		when total_sales > 80  then 'Medium'
		ELSE 'Low'
	End Customer_Segment
	from CTE_Total_Sales
		
)
-- Main Query 
Select c.CustomerID,
	c.FirstName,
	c.LastName,
	cts.total_sales,
	clo.last_order,
	ccr.CustomerRank,
	ccs.Customer_Segment
from Sales.Customers c
Left Join CTE_Total_Sales as cts
on cts.CustomerID = c.CustomerID
Left Join CTE_last_order as clo
on clo.CustomerID = c.CustomerID
Left Join CTE_Customer_Rank as ccr
on ccr.CustomerID = c.CustomerID
Left Join CTE_Customer_Segment as ccs
On ccs.CustomerID = c.CustomerID


-- Recursive CTE

-- Generating numbers from 1 to 20 with CTE

With series as (              --Anchor Query
	select 1 as mynumber
	union all 
	select mynumber +1
	from series
	where mynumber < 50
)

select * from series           -- Recursive Query
Option (maxrecursion 50)