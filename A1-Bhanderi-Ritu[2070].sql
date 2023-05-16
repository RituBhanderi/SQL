-- ***********************
-- Student Name: Rituben Bhanderi 
-- Student1 ID: 150287191
-- Date: 18 october
-- Purpose: Assignment 1 - DBS311
-- ***********************


-- Question 1 – Display the employee number, full employee name, job title, and hire date of all employees hired in September with the most recently hired employees displayed first. 
-- Q1 SOLUTION --

select employee_id as "Employee Number", first_name ||', '||last_name as "Full Name",job_title as "Job Title", to_char(hire_date, '[fmMonth ddth "of" yyyy]') as "Start Date"
from employees
where to_char(hire_date,'MM') = 09
order by hire_date desc ;

-- Question 2: The company wants to see the total sale amount per sales person (salesman) for all orders. Assume that online orders do not have any sales representative. For online orders (orders with no salesman ID), consider the salesman ID as 0. Display the salesman ID and the total sale amount for each employee. 
--Sort the result according to employee number.
--Q2 Solution--

SELECT nvl(a.salesman_id, 0) AS "Employee Number", '$' || + SUM(b.unit_price*b.quantity) AS "Total Sale" 
FROM orders a,order_items b 
WHERE a.order_id = b.order_id 
GROUP BY a.salesman_id,nvl(a.salesman_id, 0) 
ORDER BY nvl(a.salesman_id, 0);

--Q3: Display customer Id, customer name and total number of orders for customers that the value of their customer ID is in values from 35 to 45. Include the customers with no orders in your report if their customer ID falls in the range 35 and 45.  
--Sort the result by the value of total orders

--Q3: Solution--

SELECT c.customer_id as "Customer Id", c.name AS "Name",COUNT(o.order_id) AS "total orders" 
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id BETWEEN 35 AND 45 GROUP BY
c.customer_id,c.name 
ORDER BY COUNT(o.order_id);

-- Q4:Display customer ID, customer name, and the order ID and the order date of all orders for customer whose ID is 44.
--a.	Show also the total quantity and the total amount of each customer’s order.
--b.	Sort the result from the highest to lowest total order amount.
--Q4 solution--

select c.customer_id as "Customer Id",c.name,o.order_id as "Order Id",o.order_date as "Order Date", sum(oi.quantity) as "total items",'$'|| sum(oi.quantity * oi.unit_price) as "total amount"
from customers c
JOIN orders o
on c.customer_id = o.customer_id
JOIN
order_items oi
on o.order_id = oi.order_id
where c.customer_id = 44
group by c.customer_id, c.name, o.order_id,order_date
order by sum(quantity * unit_price) desc;



--Q5: Display customer Id, name, total number of orders, the total number of items ordered, and the total order amount for customers who have more than 30 orders. Sort the result based on the total number of orders.
--Q5 Solution--
SELECT c.customer_id as "Customer Id", c.name as "Name", count(o.order_id) As "total number of orders", sum(oi.quantity) as "Total Items", '$' || sum(oi.quantity * oi.unit_price) as "Total Amount"
from orders o,customers c,order_items oi
where c.customer_id = o.customer_id
AND o.order_id = oi.order_id
group by c.customer_id,c.name
having count(o.order_id) > 30
order by count(o.order_id) asc;

--Q6. Display Warehouse Id, warehouse name, product category Id, product category name, and the lowest product standard cost for this combination.


select w.warehouse_id as "Warehouse ID",warehouse_name as "Warehouse Name",p.category_id "Category ID",category_name as "Category Name", '$' || MIN(standard_cost) as "lowest cost"
from inventories i
join
warehouses w
on i.warehouse_id = w.warehouse_id
join products p
on i.product_id = p.product_id
join product_categories pc
on p.category_id = pc.category_id
group by w.warehouse_id, warehouse_name,p.category_id,category_name
having min(standard_cost) < 200
or min(standard_cost) > 500
order by w.warehouse_id,warehouse_name,p.category_id,category_name;

--Q7:	Display the total number of orders per month. Sort the result from January to December

select TO_CHAR(TO_DATE(EXTRACT(month from order_date), 'MM'), 'Month') AS "MONTH",
COUNT(EXTRACT(month FROM order_date)) AS "Number Of Orders"
FROM orders
group by EXTRACT(month FROM order_date)
order by EXTRACT(month from order_date);

--Q8: Display product Id, product name for products that their list price is more than any highest product standard cost per warehouse outside Americas regions.
--(You need to find the highest standard cost for each warehouse that is located outside the Americas regions. Then you need to return all products that their list price is higher than any highest standard cost of those warehouses.)
--Sort the result according to list price from highest value to the lowest
 

select product_id,product_name,'$' || list_price
from products
where list_price > 
(select MIN(MAX(p.standard_cost))
from inventories i
join
products p
on i.product_id = p.product_id
where i.warehouse_id > 4
group by i.warehouse_id);

--Q9:Write a SQL statement to display the most expensive and the cheapest product (list price). Display product ID, product name, and the list price.

select product_id, product_name, '$' || list_price
from products
where list_price = (select max(list_price) from products) 
OR list_price = (select min(list_price)
from products);

--Q10. 	Write a SQL query to display the number of customers with total order amount over the average amount of all orders, the number of customers with total order amount under the average amount of all orders, number of customers with no orders, and the total number of customers.

select "Customer Report"
from (select 'Number of customers with total purchase amount over average: ' || COUNT(*) 
AS "Customer Report",
1 SORTORDER
from (Select c.customer_id, SUM(oi.quantity * oi.unit_price) AS total_amount
from customers c
inner join
orders o
on c.customer_id = o.customer_id
inner join order_items oi
on oi.order_id = o.order_id
group by c.customer_id)
where total_amount > (select AVG (quantity * unit_price)
from order_items)
UNION ALL
select 'Number of customers with total purchase amount over average: ' || COUNT(*)
as "Customer Report",
2 SORTORDER
FROM ( SELECT c.customer_id,
SUM(oi.quantity * oi.unit_price) AS total_amount
from customers c
inner join orders o
on c.customer_id = o.customer_id
inner join order_items oi
on oi.order_id = o.order_id
group by c.customer_id)
where total_amount <
(select AVG(quantity * unit_price)
from order_items)
UNION ALL
select CONCAT('Number of customers with no orders: ', count(customers) - count(orders)) AS "Customer Report",
3 SORTORDER
from
(select customers.customer_id as customers, SUM(orders.order_id) AS orders
from
customers
left join
orders
ON
customers.customer_id = orders.customer_id
GROUP BY
customers.customer_id)
UNION ALL
select
CONCAT('Total number of customers: ' , COUNT(customers)) AS "Customer Report",
4 SORTORDER
from
(select
customers.customer_id AS customers, SUM(orders.order_id) AS orders
from
customers
left join
orders
ON customers.customer_id = orders.customer_id
GROUP BY
customers.customer_id))
order BY SORTORDER;
