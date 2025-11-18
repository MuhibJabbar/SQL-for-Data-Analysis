/*
Rules of unions

1 RULE — ORDER BY can be used only once (at the end of the final query)
2 RULE — Both queries must have the same number of columns
3 RULE — Corresponding columns must have matching or compatible data types
4 RULE — Columns must appear in the same order in both queries
5 RULE — The first query controls the column aliases for the final output
6 RULE — Ensure you are mapping the correct columns between queries 
(column 1 aligns with column 1, etc.)
*/
select * from Sales.Customers;
select * from sales.Employees;

/*
1. Union

it will help you to merge two columns from different tables and will drop duplicates.
*/
Select FirstName,LastName from Sales.Customers
union 
select FirstName,LastName from Sales.Employees;

/*
2. Union ALL
it will help you to merge two columns from different tables and will not drop duplicates.


*/
Select FirstName,LastName from Sales.Customers
union all
select FirstName,LastName from Sales.Employees
order by FirstName

/*
3. Except

it will only give from first table and if the rows are same in both tables
it will drop those rows and will only give the distinct rows 
*/

Select FirstName,LastName from Sales.Customers
except 
select FirstName,LastName from Sales.Employees

/*
4. Intersect

it will only give the duplicate rows from both tables.
*/
Select FirstName,LastName from Sales.Customers
intersect 
select FirstName,LastName from Sales.Employees

/*
Now we will merge orders and orders archive tables without duplicates 
*/

select * from Sales.Orders;
select * from sales.OrdersArchive;


select 'Orders' as Source_Table, * from Sales.Orders
union
select 'OrdersArchive', * from sales.OrdersArchive
order by OrderID