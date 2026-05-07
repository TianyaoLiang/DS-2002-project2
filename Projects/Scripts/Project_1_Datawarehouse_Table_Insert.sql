-- --------------------------------------------------------------------------------------------------------------
-- Extract the appropriate data from the classicmodels database, and INSERT it into the classicmodels_dw database.
-- --------------------------------------------------------------------------------------------------------------

-- ----------------------------------------------
-- Populate dim_customers
-- ----------------------------------------------
TRUNCATE TABLE classicmodels_dw.dim_customers;

INSERT INTO classicmodels_dw.dim_customers
(
  customerNumber,
  customerName,
  contactLastName,
  contactFirstName,
  phone,
  addressLine1,
  addressLine2,
  city,
  state,
  postalCode,
  country,
  salesRepEmployeeNumber,
  creditLimit
)
SELECT 
  customerNumber,
  customerName,
  contactLastName,
  contactFirstName,
  phone,
  addressLine1,
  addressLine2,
  city,
  state,
  postalCode,
  country,
  salesRepEmployeeNumber,
  creditLimit
FROM classicmodels.customers;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM classicmodels_dw.dim_customers LIMIT 10;


-- ----------------------------------------------
-- Populate dim_employees
-- ----------------------------------------------
TRUNCATE TABLE classicmodels_dw.dim_employees;

INSERT INTO classicmodels_dw.dim_employees
(
  employeeNumber,
  lastName,
  firstName,
  email,
  officeCode,
  reportsTo,
  jobTitle
)
SELECT
  employeeNumber,
  lastName,
  firstName,
  email,
  officeCode,
  reportsTo,
  jobTitle
FROM classicmodels.employees;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM classicmodels_dw.dim_employees LIMIT 10;

-- ----------------------------------------------
-- Populate dim_products
-- ----------------------------------------------
TRUNCATE TABLE classicmodels_dw.dim_products;

INSERT INTO classicmodels_dw.dim_products
(
  productCode,
  productName,
  productLine,
  productScale,
  productVendor,
  productDescription,
  quantityInStock,
  buyPrice,
  MSRP
)
SELECT
  productCode,
  productName,
  productLine,
  productScale,
  productVendor,
  productDescription,
  quantityInStock,
  buyPrice,
  MSRP
FROM classicmodels.products;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM classicmodels_dw.dim_products LIMIT 10;

-- ----------------------------------------------
-- Populate fact_orders
-- ----------------------------------------------
TRUNCATE TABLE classicmodels_dw.fact_order_lines;

INSERT INTO classicmodels_dw.fact_order_lines
(
  orderNumber,
  orderLineNumber,
  customerNumber,
  productCode,
  salesRepEmployeeNumber,
  orderDate,
  quantityOrdered,
  priceEach,
  extendedAmount
)


-- It joins the `orders` table with `orderdetails` to produce one row per order line
-- It also joins to `customers` brings in the salesRepEmployeeNumber needed for the employee dimension. 

SELECT
  o.orderNumber,
  od.orderLineNumber,
  o.customerNumber,
  od.productCode,
  c.salesRepEmployeeNumber,
  o.orderDate,
  od.quantityOrdered,
  od.priceEach,
  (od.quantityOrdered * od.priceEach) AS extendedAmount
FROM classicmodels.orders AS o
JOIN classicmodels.orderdetails AS od
  ON o.orderNumber = od.orderNumber
JOIN classicmodels.customers AS c
  ON o.customerNumber = c.customerNumber;
  
-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM classicmodels_dw.fact_order_lines LIMIT 20;