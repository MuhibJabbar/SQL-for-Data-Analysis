/*
delete query */

truncate table persons; 

/*
Where Operators

1.Comparison Operators = , <= , >= , != , < , >
*/

select * from customers
where country = 'Germany';

select * from customers
where country != 'Germany';

select * from customers
where score > 500;

select * from customers
where score >= 500;

select * from customers
where score < 500;

select * from customers
where score <= 500;

/*
2. Logical Operators AND , OR , NOT
*/

Select * from customers
where country = 'USA'
AND score > 500;

Select * from customers
where country = 'USA'
OR score > 500;

Select * from customers
where NOT score < 500;

/*
3. Range Operators Between
*/

Select * from customers
where score Between 100 and 500;

/*
4. Membership operators IN , NOT IN
*/

Select * from customers
where country in('germany' , 'usa');

Select * from customers
where country not in('germany' , 'usa');

/*
5. Search operator Like
*/

Select * from customers
where first_name like '%r%';
