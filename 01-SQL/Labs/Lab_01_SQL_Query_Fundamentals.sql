-- --------------------------------------------------------------------------------------
-- Course: DS2-2002 - Data Science Systems | Author: Jon Tupitza
-- Lab 1: SQL Query Fundamentals | 5 Points
-- --------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------
-- 1). First, How Many Rows (Products) are in the Products Table?			| 0.2 pt
-- --------------------------------------------------------------------------------------
SELECT COUNT(*) 
FROM products;
-- --------------------------------------------------------------------------------------
-- 2). Fetch Each Product Name and its Quantity per Unit					| 0.2.pt
-- --------------------------------------------------------------------------------------
SELECT product_name, quantity_per_unit 
FROM products;
-- --------------------------------------------------------------------------------------
-- 3). Fetch the Product ID and Name of Currently Available Products		| 0.2 pt
-- --------------------------------------------------------------------------------------
SELECT id, product_name
FROM products
WHERE discontinued = 0;
-- --------------------------------------------------------------------------------------
-- 4). Fetch the Product ID, Name & List Price Costing Less Than $20
--     Sort the results with the most expensive Products first.				| 0.2 pt
-- --------------------------------------------------------------------------------------
SELECT id, product_name, list_price
FROM products
WHERE list_price < 20
order by list_price desc;
-- --------------------------------------------------------------------------------------
-- 5). Fetch the Product ID, Name & List Price Costing Between $15 and $20
--     Sort the results with the most expensive Products first.				| 0.2 pt
-- --------------------------------------------------------------------------------------
select id, product_name, list_price
from products
where list_price between 15 and 20
order by list_price desc;
-- Older (Equivalent) Syntax -----


-- --------------------------------------------------------------------------------------
-- 6). Fetch the Product Name & List Price of the 10 Most Expensive Products 
--     Sort the results with the most expensive Products first.				| 0.33 pt
-- --------------------------------------------------------------------------------------
select product_name, list_price
from products
order by list_price desc
limit 10;
-- --------------------------------------------------------------------------------------
-- 7). Fetch the Name & List Price of the Most & Least Expensive Products	| 0.33 pt.
-- --------------------------------------------------------------------------------------
select product_name, list_price
from products
order by list_price desc
limit 1;

select product_name, list_price
from products
order by list_price asc
limit 1;
-- --------------------------------------------------------------------------------------
-- 8). Fetch the Product Name & List Price Costing Above Average List Price
--     Sort the results with the most expensive Products first.				| 0.33 pt.
-- --------------------------------------------------------------------------------------
select product_name, list_price
from products
where list_price > (select avg(list_price) from products)
order by list_price desc;
-- --------------------------------------------------------------------------------------
-- 9). Fetch & Label the Count of Current and Discontinued Products using
-- 	   the "CASE... WHEN" syntax to create a column named "availablity"
--     that contains the values "discontinued" and "current". 				| 0.33 pt
-- --------------------------------------------------------------------------------------
UPDATE northwind.products SET discontinued = 1 WHERE id IN (95, 96, 97);

-- TODO: Insert query here.
select
  case
    when discontinued = 1 then 'discontinued'
    else 'current'
  end as availablity,
  count(*) as product_count
from northwind.products
group by availablity;

UPDATE northwind.products SET discontinued = 0 WHERE id in (95, 96, 97);

-- --------------------------------------------------------------------------------------
-- 10). Fetch Product Name, Reorder Level, Target Level and "Reorder Threshold"
-- 	    Where Reorder Level is Less Than or Equal to 20% of Target Level	| 0.33 pt.
-- --------------------------------------------------------------------------------------
select product_name, reorder_level, target_level, (target_level * 0.2) as reorder_threshhold
from products
where reorder_level <= target_level * .2;

-- --------------------------------------------------------------------------------------
-- 11). Fetch the Number of Products per Category Priced Less Than $20.00	| 0.33 pt
-- --------------------------------------------------------------------------------------
select category, count(*) as total
from products
where list_price < 20
group by category;

-- --------------------------------------------------------------------------------------
-- 12). Fetch the Number of Products per Category With Less Than 5 Units In Stock	| 0.5 pt
-- --------------------------------------------------------------------------------------

SELECT products.category, COUNT(*) AS product_count
FROM products
GROUP BY products.category
HAVING product_count < 5;


-- --------------------------------------------------------------------------------------
-- 13). Fetch Products along with their Supplier Company & Address Info		| 0.5 pt
-- --------------------------------------------------------------------------------------
SELECT 
    p.product_name, s.company, s.address
FROM products p
JOIN suppliers s
    ON p.supplier_ids = s.id;
-- --------------------------------------------------------------------------------------
-- 14). Fetch the Customer ID and Full Name for All Customers along with
-- 		the Order ID and Order Date for Any Orders they may have			| 0.5 pt
-- --------------------------------------------------------------------------------------
SELECT 
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    o.id AS order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.id = o.customer_id;
-- --------------------------------------------------------------------------------------
-- 15). Fetch the Order ID and Order Date for All Orders along with
--   	the Customr ID and Full Name for Any Associated Customers			| 0.5 pt
-- --------------------------------------------------------------------------------------
SELECT 
    o.id AS order_id,
    o.order_date,
    c.id AS customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.id;


