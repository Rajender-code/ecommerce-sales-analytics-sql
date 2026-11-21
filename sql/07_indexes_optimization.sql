-- ============================================================
-- PROJECT: E-Commerce Sales & Business Analytics
-- DATABASE: ecommerce_analytics
-- FILE: 07_indexes_optimization.sql
-- PURPOSE: Indexing and Query Performance Optimization
-- ============================================================

USE ecommerce_analytics;


-- ============================================================
-- SECTION 1: CREATE INDEXES
-- ============================================================


-- ------------------------------------------------------------
-- INDEX 1: CUSTOMER CITY
-- ------------------------------------------------------------

DROP INDEX IF EXISTS idx_customers_city
ON customers;

CREATE INDEX idx_customers_city
ON customers(city);


-- ------------------------------------------------------------
-- INDEX 2: CUSTOMER REGISTRATION DATE
-- ------------------------------------------------------------

DROP INDEX IF EXISTS idx_customers_registration_date
ON customers;

CREATE INDEX idx_customers_registration_date
ON customers(registration_date);


-- ------------------------------------------------------------
-- INDEX 3: PRODUCT NAME
-- ------------------------------------------------------------

DROP INDEX IF EXISTS idx_products_product_name
ON products;

CREATE INDEX idx_products_product_name
ON products(product_name);


-- ------------------------------------------------------------
-- INDEX 4: ORDER DATE
-- ------------------------------------------------------------

DROP INDEX IF EXISTS idx_orders_order_date
ON orders;

CREATE INDEX idx_orders_order_date
ON orders(order_date);


-- ------------------------------------------------------------
-- INDEX 5: ORDER STATUS
-- ------------------------------------------------------------

DROP INDEX IF EXISTS idx_orders_order_status
ON orders(order_status);

CREATE INDEX idx_orders_order_status
ON orders(order_status);


-- ------------------------------------------------------------
-- INDEX 6: COMPOSITE INDEX FOR ORDERS
-- ------------------------------------------------------------

DROP INDEX IF EXISTS idx_orders_status_date
ON orders;

CREATE INDEX idx_orders_status_date
ON orders(order_status, order_date);


-- ------------------------------------------------------------
-- INDEX 7: PAYMENT STATUS
-- ------------------------------------------------------------

DROP INDEX IF EXISTS idx_payments_payment_status
ON payments;

CREATE INDEX idx_payments_payment_status
ON payments(payment_status);


-- ------------------------------------------------------------
-- INDEX 8: PAYMENT METHOD
-- ------------------------------------------------------------

DROP INDEX IF EXISTS idx_payments_payment_method
ON payments;

CREATE INDEX idx_payments_payment_method
ON payments(payment_method);


-- ------------------------------------------------------------
-- INDEX 9: PAYMENT DATE
-- ------------------------------------------------------------

DROP INDEX IF EXISTS idx_payments_payment_date
ON payments;

CREATE INDEX idx_payments_payment_date
ON payments(payment_date);


-- ============================================================
-- SECTION 2: VERIFY CREATED INDEXES
-- ============================================================


-- CHECK CUSTOMER INDEXES

SHOW INDEX FROM customers;


-- CHECK PRODUCT INDEXES

SHOW INDEX FROM products;


-- CHECK ORDER INDEXES

SHOW INDEX FROM orders;


-- CHECK PAYMENT INDEXES

SHOW INDEX FROM payments;


-- ============================================================
-- SECTION 3: QUERY PERFORMANCE ANALYSIS
-- ============================================================


-- ------------------------------------------------------------
-- QUERY 1: SEARCH CUSTOMERS BY CITY
-- ------------------------------------------------------------

EXPLAIN

SELECT
    customer_id,
    customer_name,
    email,
    city

FROM customers

WHERE city = 'Hyderabad';


-- ------------------------------------------------------------
-- QUERY 2: SEARCH PRODUCTS BY PRODUCT NAME
-- ------------------------------------------------------------

EXPLAIN

SELECT
    product_id,
    product_name,
    price,
    stock_quantity

FROM products

WHERE product_name = 'Samsung Galaxy S24';


-- ------------------------------------------------------------
-- QUERY 3: SEARCH ORDERS BY ORDER DATE
-- ------------------------------------------------------------

EXPLAIN

SELECT
    order_id,
    customer_id,
    order_date,
    order_status

FROM orders

WHERE order_date >= '2025-05-01'

AND order_date < '2025-06-01';


-- ------------------------------------------------------------
-- QUERY 4: SEARCH ORDERS BY STATUS
-- ------------------------------------------------------------

EXPLAIN

SELECT
    order_id,
    customer_id,
    order_date,
    order_status

FROM orders

WHERE order_status = 'Delivered';


-- ------------------------------------------------------------
-- QUERY 5: SEARCH ORDERS USING COMPOSITE INDEX
-- ------------------------------------------------------------

EXPLAIN

SELECT
    order_id,
    customer_id,
    order_date,
    order_status

FROM orders

WHERE order_status = 'Delivered'

AND order_date >= '2025-05-01'

AND order_date < '2025-06-01';


-- ------------------------------------------------------------
-- QUERY 6: SEARCH COMPLETED PAYMENTS
-- ------------------------------------------------------------

EXPLAIN

SELECT
    payment_id,
    order_id,
    payment_date,
    payment_method,
    payment_amount

FROM payments

WHERE payment_status = 'Completed';


-- ------------------------------------------------------------
-- QUERY 7: SEARCH PAYMENTS BY PAYMENT METHOD
-- ------------------------------------------------------------

EXPLAIN

SELECT
    payment_id,
    order_id,
    payment_date,
    payment_amount,
    payment_status

FROM payments

WHERE payment_method = 'UPI';


-- ------------------------------------------------------------
-- QUERY 8: SEARCH PAYMENTS BY DATE
-- ------------------------------------------------------------

EXPLAIN

SELECT
    payment_id,
    order_id,
    payment_date,
    payment_amount,
    payment_status

FROM payments

WHERE payment_date >= '2025-05-01'

AND payment_date < '2025-06-01';


-- ============================================================
-- SECTION 4: ANALYZE TABLES
-- ============================================================


ANALYZE TABLE customers;

ANALYZE TABLE products;

ANALYZE TABLE orders;

ANALYZE TABLE payments;


-- ============================================================
-- SECTION 5: FINAL INDEX VERIFICATION
-- ============================================================


SELECT
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    SEQ_IN_INDEX,
    NON_UNIQUE

FROM INFORMATION_SCHEMA.STATISTICS

WHERE TABLE_SCHEMA = 'ecommerce_analytics'

ORDER BY
    TABLE_NAME,
    INDEX_NAME,
    SEQ_IN_INDEX;


-- ============================================================
-- END OF INDEXING AND OPTIMIZATION
-- ============================================================