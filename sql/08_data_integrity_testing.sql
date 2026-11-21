-- ============================================================
-- PROJECT: E-COMMERCE SALES ANALYTICS
-- FILE: 08_data_integrity_testing.sql
-- PURPOSE: Test database constraints and data integrity
-- ============================================================

USE ecommerce_analytics;


-- ============================================================
-- PART 1: VERIFY DATABASE AND TABLES
-- ============================================================

SELECT DATABASE();

SHOW TABLES;

DESCRIBE customers;
DESCRIBE products;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE payments;
DESCRIBE categories;


-- ============================================================
-- PART 2: CHECK PRIMARY KEYS
-- ============================================================

-- Check customer primary keys

SELECT
    customer_id,
    customer_name,
    email
FROM customers
ORDER BY customer_id;


-- Check product primary keys

SELECT
    product_id,
    product_name,
    price
FROM products
ORDER BY product_id;


-- Check order primary keys

SELECT
    order_id,
    customer_id,
    order_date,
    order_status
FROM orders
ORDER BY order_id;


-- ============================================================
-- PART 3: CHECK UNIQUE CONSTRAINTS
-- ============================================================

-- Check for duplicate customer emails

SELECT
    email,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;


-- Check for duplicate category names

SELECT
    category_name,
    COUNT(*) AS duplicate_count
FROM categories
GROUP BY category_name
HAVING COUNT(*) > 1;


-- Check for duplicate product names

SELECT
    product_name,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_name
HAVING COUNT(*) > 1;


-- ============================================================
-- PART 4: CHECK NULL VALUES
-- ============================================================

-- Check customers with missing names

SELECT *
FROM customers
WHERE customer_name IS NULL;


-- Check customers with missing emails

SELECT *
FROM customers
WHERE email IS NULL;


-- Check products with missing names

SELECT *
FROM products
WHERE product_name IS NULL;


-- Check orders with missing customer IDs

SELECT *
FROM orders
WHERE customer_id IS NULL;


-- ============================================================
-- PART 5: CHECK NEGATIVE VALUES
-- ============================================================

-- Check negative product prices

SELECT *
FROM products
WHERE price < 0;


-- Check negative product stock

SELECT *
FROM products
WHERE stock_quantity < 0;


-- Check negative order item quantities

SELECT *
FROM order_items
WHERE quantity <= 0;


-- Check negative order item prices

SELECT *
FROM order_items
WHERE unit_price < 0;


-- Check negative payment amounts

SELECT *
FROM payments
WHERE payment_amount < 0;


-- ============================================================
-- PART 6: CHECK FOREIGN KEY RELATIONSHIPS
-- ============================================================

-- Orders without existing customers

SELECT
    orders.order_id,
    orders.customer_id
FROM orders
LEFT JOIN customers
    ON orders.customer_id = customers.customer_id
WHERE customers.customer_id IS NULL;


-- Products without existing categories

SELECT
    products.product_id,
    products.product_name,
    products.category_id
FROM products
LEFT JOIN categories
    ON products.category_id = categories.category_id
WHERE categories.category_id IS NULL;


-- Order items without existing orders

SELECT
    order_items.order_item_id,
    order_items.order_id
FROM order_items
LEFT JOIN orders
    ON order_items.order_id = orders.order_id
WHERE orders.order_id IS NULL;


-- Order items without existing products

SELECT
    order_items.order_item_id,
    order_items.product_id
FROM order_items
LEFT JOIN products
    ON order_items.product_id = products.product_id
WHERE products.product_id IS NULL;


-- Payments without existing orders

SELECT
    payments.payment_id,
    payments.order_id
FROM payments
LEFT JOIN orders
    ON payments.order_id = orders.order_id
WHERE orders.order_id IS NULL;


-- ============================================================
-- PART 7: CHECK ORDER ITEM CALCULATIONS
-- ============================================================

-- Verify order item totals

SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    quantity * unit_price AS calculated_total
FROM order_items;


-- Check whether the order item values are valid

SELECT *
FROM order_items
WHERE quantity <= 0
   OR unit_price < 0;


-- ============================================================
-- PART 8: CHECK PAYMENT DATA
-- ============================================================

-- Payments grouped by payment status

SELECT
    payment_status,
    COUNT(*) AS total_payments,
    SUM(payment_amount) AS total_amount
FROM payments
GROUP BY payment_status;


-- Payments grouped by payment method

SELECT
    payment_method,
    COUNT(*) AS total_payments,
    SUM(payment_amount) AS total_amount
FROM payments
GROUP BY payment_method;


-- Check invalid payment amounts

SELECT *
FROM payments
WHERE payment_amount < 0;


-- ============================================================
-- PART 9: TEST UNIQUE CONSTRAINT
-- ============================================================

-- TEST: Duplicate email
--
-- The email raj@gmail.com already exists in the customers table.
-- Execute this statement separately.
--
-- EXPECTED RESULT:
-- Error Code 1062: Duplicate entry
--
-- This error confirms that the UNIQUE constraint is working.

-- INSERT INTO customers
-- (
--     customer_name,
--     email,
--     phone,
--     city,
--     registration_date
-- )
-- VALUES
-- (
--     'Duplicate Test Customer',
--     'raj@gmail.com',
--     '9999999999',
--     'Hyderabad',
--     '2025-05-01'
-- );


-- ============================================================
-- PART 10: TEST CHECK CONSTRAINT
-- ============================================================

-- TEST: Negative product price
--
-- EXPECTED RESULT:
-- Error because price cannot be negative.

-- INSERT INTO products
-- (
--     product_name,
--     category_id,
--     price,
--     stock_quantity
-- )
-- VALUES
-- (
--     'Invalid Price Product',
--     1,
--     -500,
--     10
-- );


-- TEST: Negative stock quantity
--
-- EXPECTED RESULT:
-- Error because stock_quantity cannot be negative.

-- INSERT INTO products
-- (
--     product_name,
--     category_id,
--     price,
--     stock_quantity
-- )
-- VALUES
-- (
--     'Invalid Stock Product',
--     1,
--     500,
--     -10
-- );


-- ============================================================
-- PART 11: TEST ENUM CONSTRAINT
-- ============================================================

-- TEST: Invalid order status
--
-- EXPECTED RESULT:
-- Error Code 1265 or an invalid ENUM value error.
--
-- Your order_status column only accepts the predefined values.

-- INSERT INTO orders
-- (
--     customer_id,
--     order_date,
--     order_status
-- )
-- VALUES
-- (
--     1,
--     '2025-05-30',
--     'InvalidStatus'
-- );


-- ============================================================
-- PART 12: TEST FOREIGN KEY CONSTRAINT
-- ============================================================

-- TEST: Insert an order item with a nonexistent product ID
--
-- EXPECTED RESULT:
-- Foreign key constraint error.
--
-- product_id = 999999 should not exist.

-- INSERT INTO order_items
-- (
--     order_id,
--     product_id,
--     quantity,
--     unit_price
-- )
-- VALUES
-- (
--     1,
--     999999,
--     1,
--     500
-- );


-- ============================================================
-- PART 13: TEST STOCK VALIDATION TRIGGER
-- ============================================================

-- Check current stock of products

SELECT
    product_id,
    product_name,
    stock_quantity
FROM products
ORDER BY product_id;


-- TEST: Attempt to order more stock than available
--
-- Your BEFORE INSERT trigger should prevent this.
--
-- EXPECTED RESULT:
-- An error message indicating insufficient stock.
--
-- IMPORTANT:
-- Execute this test separately.
-- Replace order_id and product_id with valid IDs if necessary.

-- INSERT INTO order_items
-- (
--     order_id,
--     product_id,
--     quantity,
--     unit_price
-- )
-- VALUES
-- (
--     1,
--     1,
--     999999,
--     100
-- );


-- ============================================================
-- PART 14: TEST TRANSACTION AND ROLLBACK
-- ============================================================

-- Start transaction

START TRANSACTION;


-- Insert a temporary test customer

INSERT INTO customers
(
    customer_name,
    email,
    phone,
    city,
    registration_date
)
VALUES
(
    'Transaction Test Customer',
    'transaction_test@example.com',
    '9000000000',
    'Hyderabad',
    '2025-05-30'
);


-- Verify inserted temporary customer

SELECT *
FROM customers
WHERE email = 'transaction_test@example.com';


-- Roll back the transaction

ROLLBACK;


-- Verify customer was removed

SELECT *
FROM customers
WHERE email = 'transaction_test@example.com';


-- Expected result:
-- Empty result set


-- ============================================================
-- PART 15: FINAL DATA INTEGRITY SUMMARY
-- ============================================================

-- Total customers

SELECT COUNT(*) AS total_customers
FROM customers;


-- Total products

SELECT COUNT(*) AS total_products
FROM products;


-- Total categories

SELECT COUNT(*) AS total_categories
FROM categories;


-- Total orders

SELECT COUNT(*) AS total_orders
FROM orders;


-- Total order items

SELECT COUNT(*) AS total_order_items
FROM order_items;


-- Total payments

SELECT COUNT(*) AS total_payments
FROM payments;


-- ============================================================
-- PROJECT DATA INTEGRITY TESTING COMPLETED
-- ============================================================