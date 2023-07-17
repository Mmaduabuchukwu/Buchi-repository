--Data analysis Process
--1. Understand the problem - The condition of the sales activities within the company
--and gain insights into various trends happening in the sales volume over the 2016 
--to 2018. They want to know the revenues per region, per store, per product category
--and per brand. A lsit of the top customers and sales reps couldalso prove insightful. 
--2. collect and gather the data
--3. Clean the data
--4. Gather and analyze the data
--5. Interpret the result

-- I garthered the necesssary data from SQL
--OrderID,customer's first & last name, customer city &state,oder sate, sales volume,
--revenue product name, product category,brand name, store name and sales rep,

--OrderID & Order Date --> Sales.Order table
--Customer's Name, City & State --> Sales.Customers Table
--Revenue and Sales volume --> Sales.Orderitems Table

--queries
select * from [sales].[orders]
select * from [sales].[customers]
select * from [sales].[order_items]
select * from [production].[products]
select * from [production].[categories]
select * from [production].[brands]
select * from [sales].[stores]
select * from [sales].[staffs]
select * from [sales].[orders]

Select 
     ord.order_id,
	 concat(cus.first_name,' ',cus.last_name) as 'customers',
	 cus.city,
	 cus.state,
	 ord.order_date,
	 sum(ite.quantity) as 'total_units',
	 sum(ite.quantity * ite.list_price) as  'revenue',
	 pro.product_name,
	 category_name,
	 brand_name,
	 store_name,
	 concat(sta.first_name,' ',sta.last_name) as 'sales_rep'
from sales.orders ord
join sales.customers cus
on ord.customer_id = cus.customer_id
join sales.order_items ite
on ord.order_id = ite.order_id
join production.products pro
on ite.product_id = pro.product_id
join production.categories cat
on pro.category_id = cat.category_id
join production.brands bra
on pro.brand_id = bra.brand_id
join sales.stores sto
on ord.store_id = sto.store_id
Join sales.staffs sta
on ord.staff_id = sta.staff_id
Group by
     ord.order_id,
	 concat(cus.first_name,' ',cus.last_name),
	 cus.city,
	 cus.state,
	 ord.order_date,
	 pro.product_name,
	 category_name,
	 brand_name,
	 store_name,
	 concat(sta.first_name,' ',sta.last_name)

