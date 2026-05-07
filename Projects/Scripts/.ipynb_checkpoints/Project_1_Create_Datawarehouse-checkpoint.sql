DROP DATABASE `classicmodels_dw`;
CREATE DATABASE `classicmodels_dw` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE classicmodels_dw;

DROP TABLE IF EXISTS `dim_customers`;
CREATE TABLE `dim_customers` (
  customer_key              INT NOT NULL AUTO_INCREMENT,
  customerNumber            INT NOT NULL,          -- business key
  customerName              VARCHAR(50) NOT NULL,
  contactLastName           VARCHAR(50) NOT NULL,
  contactFirstName          VARCHAR(50) NOT NULL,
  phone                     VARCHAR(50) NOT NULL,
  addressLine1              VARCHAR(50) NOT NULL,
  addressLine2              VARCHAR(50) DEFAULT NULL,
  city                      VARCHAR(50) NOT NULL,
  state                     VARCHAR(50) DEFAULT NULL,
  postalCode                VARCHAR(15) DEFAULT NULL,
  country                   VARCHAR(50) NOT NULL,
  salesRepEmployeeNumber    INT DEFAULT NULL,
  creditLimit               DECIMAL(10,2) DEFAULT NULL,

  PRIMARY KEY (customer_key),
  KEY customerNumber (customerNumber),
  KEY city (city),
  KEY country (country),
  KEY contactLastName (contactLastName),
  KEY contactFirstName (contactFirstName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `dim_employees`;
CREATE TABLE `dim_employees` (
  employee_key    INT NOT NULL AUTO_INCREMENT,
  employeeNumber  INT NOT NULL,          -- business key
  lastName        VARCHAR(50) NOT NULL,
  firstName       VARCHAR(50) NOT NULL,
  email           VARCHAR(100) NOT NULL,
  officeCode      VARCHAR(10) NOT NULL,
  reportsTo       INT DEFAULT NULL,
  jobTitle        VARCHAR(50) NOT NULL,

  PRIMARY KEY (employee_key),
  KEY employeeNumber (employeeNumber),
  KEY lastName (lastName),
  KEY firstName (firstName),
  KEY officeCode (officeCode),
  KEY jobTitle (jobTitle)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `dim_products`;
CREATE TABLE `dim_products` (
  product_key       INT NOT NULL AUTO_INCREMENT,
  productCode       VARCHAR(15) NOT NULL,   -- business key
  productName       VARCHAR(70) NOT NULL,
  productLine       VARCHAR(50) NOT NULL,
  productScale      VARCHAR(10) NOT NULL,
  productVendor     VARCHAR(50) NOT NULL,
  productDescription TEXT NOT NULL,
  quantityInStock   SMALLINT NOT NULL,
  buyPrice          DECIMAL(10,2) NOT NULL,
  MSRP              DECIMAL(10,2) NOT NULL,

  PRIMARY KEY (product_key),
  KEY productCode (productCode),
  KEY productLine (productLine),
  KEY productName (productName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# ----------------------------------------------------------
# TODO: CREATE the `dim_shippers` dimension table ----------
# ----------------------------------------------------------
DROP TABLE IF EXISTS `dim_shippers`;

CREATE TABLE `dim_shippers` (
  `shipper_key` int NOT NULL AUTO_INCREMENT,
  `shipper_id` int NOT NULL,
  `company` varchar(50) DEFAULT NULL,
  `address` longtext,
  `city` varchar(50) DEFAULT NULL,
  `state_province` varchar(50) DEFAULT NULL,
  `zip_postal_code` varchar(15) DEFAULT NULL,
  `country_region` varchar(50) DEFAULT NULL,
  `attachments` longblob,
  PRIMARY KEY (`shipper_key`),
  KEY `shipper_id` (`shipper_id`),
  KEY `city` (`city`),
  KEY `company` (`company`),
  KEY `zip_postal_code` (`zip_postal_code`),
  KEY `state_province` (`state_province`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;


# ----------------------------------------------------------------------
# TODO: JOIN the orders, order_details, order_details_status and 
#       orders_status tables to create a new Fact Table in Northwind_DW.
# To keep things simple, don't include purchase order or inventory info
# ----------------------------------------------------------------------
DROP TABLE IF EXISTS `fact_order_lines`;

CREATE TABLE `fact_order_lines` (
  fact_order_line_key   INT NOT NULL AUTO_INCREMENT,

  -- Business identifiers from source
  orderNumber           INT NOT NULL,
  orderLineNumber       SMALLINT NOT NULL,

  -- Natural keys (optional, can be dropped later after surrogate integration)
  customerNumber        INT NOT NULL,
  productCode           VARCHAR(15) NOT NULL,
  salesRepEmployeeNumber INT DEFAULT NULL,
  orderDate             DATE NOT NULL,

  -- Surrogate keys to be populated later (like your northwind example)
  date_key              INT DEFAULT NULL,
  customer_key          INT DEFAULT NULL,
  product_key           INT DEFAULT NULL,
  employee_key          INT DEFAULT NULL,

  -- Measures
  quantityOrdered       INT NOT NULL,
  priceEach             DECIMAL(10,2) NOT NULL,
  extendedAmount        DECIMAL(10,2) NOT NULL,

  PRIMARY KEY (fact_order_line_key),
  KEY orderNumber (orderNumber),
  KEY customerNumber (customerNumber),
  KEY productCode (productCode),
  KEY salesRepEmployeeNumber (salesRepEmployeeNumber),
  KEY date_key (date_key),
  KEY customer_key (customer_key),
  KEY product_key (product_key),
  KEY employee_key (employee_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

