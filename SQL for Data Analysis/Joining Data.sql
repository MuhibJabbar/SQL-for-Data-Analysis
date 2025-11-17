select * from customers;
select * from orders;

/*
Joins
1. Inner Join
*/

select * from customers as c
Join orders as o
On c.id = o.customer_id;

/*
2. Left Join
*/

Select * from customers
Left Join orders
ON id = customer_id

/*
3. Right Join
*/

Select * from customers
Right Join orders
On id = customer_id

/*
4. Full Join
*/
Select * from customers
Full Join orders
On id = customer_id

/*
5. Left Anti Join
*/

Select * from customers
Left Join orders
ON id = customer_id
where customer_id is null

/*
6. Right Anti Join
*/

Select * from customers
Right Join orders
ON id = customer_id
where id is null

/*
7. Full Anti Join
*/
Select * from customers
Full Join orders
ON id = customer_id
where order_id is not null and id is not null

/*
8.Cross Join
*/

Select * from customers
cross join orders

/*
How to choose Joins for the tasks

1️ Do you want only matching rows?

If yes → INNER JOIN

Returns rows where both tables match.

Think of it as: “Give me the overlap only.”

Venn diagram: only the intersection is shaded.

2️ Do you want all rows?

If yes → choose which sides matter:

➡️ One side is the ‘master table’

Use LEFT JOIN

Returns all rows from the left table.

Matching rows from the right table are included.

Non-matching rows become NULL.

➡️ Both sides matter

Use FULL JOIN

Returns all rows from both tables.

Matching rows combine; non-matching rows show NULL on the missing side.

3️. Do you want only unmatching rows?

This means rows without a match.

➡️ Only keep unmatches from one side

Use LEFT ANTI JOIN

Returns rows from the left table that have no match in the right table.

➡️ Only keep unmatches from both sides

Use FULL ANTI JOIN

Returns rows from both tables that do not have a match in the other.
*/



/*
 Join Multiple Tables
*/

select * from Sales.Customers;
select * from Sales.Orders;
select * from Sales.Products;
select * from Sales.Employees;

/*
This query pulls together order information from multiple tables within the Sales schema. 
It uses LEFT JOINs to ensure all orders appear—even if some related customer, product, 
or employee details are missing.

Specifically, it retrieves:

Order details from Sales.Orders

Customer info (first + last name) from Sales.Customers

Product info (name + price) from Sales.Products

Salesperson info (first + last name) from Sales.Employees

The sales amount from the orders table

Each join connects the Orders table to the others using matching IDs:

Customer via CustomerID

Product via ProductID

Employee via SalesPersonID

End result:
A combined dataset showing each order, who bought it, 
what product was sold, its price, and which employee handled the sale 
even when some of those details don’t exist (because of the left joins).

*/


select 
so.OrderID,
sc.CustomerID,
sc.FirstName as Customer_First_Name,
sc.LastName as Customer_Last_Name, 
sp.Product as Product_Name,
sp.Price as product_Price,
se.EmployeeID,
se.FirstName as Employee_First_Name,
se.LastName as Employee_Last_Name,
so.Sales as Product_Sales
from Sales.Orders as so
left join Sales.Customers as sc on so.CustomerID = sc.CustomerID
left join Sales.Products as sp on so.ProductID = sp.ProductID
left join Sales.Employees as se on so.SalesPersonID = se.EmployeeID
