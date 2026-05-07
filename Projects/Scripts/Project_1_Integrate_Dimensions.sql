# ===================================================================================
# How to Integrate a Dimension table. In other words, how to look-up Foreign Key
# values FROM a dimension table and add them to new Fact table columns.
# ===================================================================================

USE classicmodels_dw;

# ==============================================================
# Add New Column(s)
# ==============================================================
# ADD NEW COLUMNS FOR DATE, CUSTOMER, PRODUCT, & EMPLOYEE

ALTER TABLE classicmodels_dw.fact_order_lines
ADD COLUMN date_key INT NOT NULL AFTER orderDate,
ADD COLUMN customer_key INT NOT NULL AFTER customerNumber,
ADD COLUMN product_key INT NOT NULL AFTER productCode,
ADD COLUMN employee_key INT AFTER salesRepEmployeeNumber;

# ==============================================================
# Update New Column(s) with value from Dimension table
# WHERE Business Keys in both tables match.
# ==============================================================

# --------------------------------------------------------------
# DATE, CUSTOMER, PRODUCT, & EMPLOYEE dimension tables.
# --------------------------------------------------------------

UPDATE classicmodels_dw.fact_order_lines AS f
JOIN classicmodels_dw.dim_date AS d
  ON f.orderDate = d.full_date
SET f.date_key = d.date_key;

UPDATE classicmodels_dw.fact_order_lines AS f
JOIN classicmodels_dw.dim_customers AS c
  ON f.customerNumber = c.customerNumber
SET f.customer_key = c.customer_key;

UPDATE classicmodels_dw.fact_order_lines AS f
JOIN classicmodels_dw.dim_products AS p
  ON f.productCode = p.productCode
SET f.product_key = p.product_key;

UPDATE classicmodels_dw.fact_order_lines AS f
JOIN classicmodels_dw.dim_employees AS e
  ON f.salesRepEmployeeNumber = e.employeeNumber
SET f.employee_key = e.employee_key;

# ==============================================================
# Step 3: Validate that newly updated columns contain valid data
# ==============================================================
SELECT 
    orderNumber,
    orderLineNumber,

    customerNumber,
    customer_key,

    productCode,
    product_key,

    salesRepEmployeeNumber,
    employee_key,

    orderDate,
    date_key
FROM classicmodels_dw.fact_order_lines
LIMIT 10;

# =============================================================
# If values are correct then drop old column(s)
# =============================================================
# DROP THE DATE, CUSTOMER, PRODUCT, & EMPLOYEE columns
ALTER TABLE classicmodels_dw.fact_order_lines
DROP COLUMN orderDate,
DROP COLUMN customerNumber,
DROP COLUMN productCode,
DROP COLUMN salesRepEmployeeNumber;


# =============================================================
# Validate Finished Fact Table.
# =============================================================
SELECT * 
FROM classicmodels_dw.fact_order_lines
LIMIT 10;

