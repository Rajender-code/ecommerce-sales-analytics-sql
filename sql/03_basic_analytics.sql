-- ============================================================
-- PROJECT: E-Commerce Sales & Business Analytics
-- FILE: 03_basic_analytics.sql
-- PURPOSE: Basic business analytics using SQL
-- ============================================================

USE ecommerce_analytics;


-- ============================================================
-- QUERY 1: TOTAL COMPLETED REVENUE
-- ============================================================

SELECT
    SUM(payment_amount) AS total_completed_revenue
FROM payments
WHERE payment_status = 'Completed';


-- ============================================================
-- QUERY 2: REVENUE BY PAYMENT METHOD
-- ============================================================

SELECT
    payment_method,
    SUM(payment_amount) AS total_revenue,
    COUNT(*) AS total_transactions
FROM payments
WHERE payment_status = 'Completed'
GROUP BY payment_method
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 3: ORDER-WISE TOTAL
-- ============================================================

SELECT
    orders.order_id,
    orders.order_date,
    orders.order_status,
    SUM(order_items.quantity * order_items.unit_price)
        AS order_total
FROM orders
INNER JOIN order_items
    ON orders.order_id = order_items.order_id
GROUP BY
    orders.order_id,
    orders.order_date,
    orders.order_status
ORDER BY order_total DESC;


-- ============================================================
-- QUERY 4: CUSTOMER ORDER REPORT
-- ============================================================

SELECT
    customers.customer_id,
    customers.customer_name,
    customers.city,
    COUNT(DISTINCT orders.order_id) AS total_orders,
    COALESCE(
        SUM(order_items.quantity * order_items.unit_price),
        0
    ) AS total_order_value
FROM customers
LEFT JOIN orders
    ON customers.customer_id = orders.customer_id
LEFT JOIN order_items
    ON orders.order_id = order_items.order_id
GROUP BY
    customers.customer_id,
    customers.customer_name,
    customers.city
ORDER BY total_order_value DESC;


-- ============================================================
-- QUERY 5: PRODUCT SALES ANALYTICS
-- ============================================================

SELECT
    products.product_id,
    products.product_name,
    SUM(order_items.quantity) AS total_quantity_sold,
    SUM(order_items.quantity * order_items.unit_price)
        AS total_sales
FROM products
INNER JOIN order_items
    ON products.product_id = order_items.product_id
GROUP BY
    products.product_id,
    products.product_name
ORDER BY total_sales DESC;


-- ============================================================
-- QUERY 6: CATEGORY SALES ANALYTICS
-- ============================================================

SELECT
    categories.category_name,
    SUM(order_items.quantity) AS total_quantity_sold,
    SUM(order_items.quantity * order_items.unit_price)
        AS category_revenue
FROM categories
INNER JOIN products
    ON categories.category_id = products.category_id
INNER JOIN order_items
    ON products.product_id = order_items.product_id
GROUP BY categories.category_id, categories.category_name
ORDER BY category_revenue DESC;


-- ============================================================
-- QUERY 7: MONTHLY COMPLETED REVENUE
-- ============================================================

SELECT
    YEAR(payment_date) AS sales_year,
    MONTH(payment_date) AS sales_month,
    MONTHNAME(payment_date) AS month_name,
    SUM(payment_amount) AS monthly_revenue,
    COUNT(*) AS completed_transactions
FROM payments
WHERE payment_status = 'Completed'
GROUP BY
    YEAR(payment_date),
    MONTH(payment_date),
    MONTHNAME(payment_date)
ORDER BY sales_year, sales_month;


-- ============================================================
-- QUERY 8: TOP CUSTOMERS BY COMPLETED PAYMENT REVENUE
-- ============================================================

SELECT
    customers.customer_id,
    customers.customer_name,
    customers.city,
    SUM(payments.payment_amount) AS total_paid
FROM customers
INNER JOIN orders
    ON customers.customer_id = orders.customer_id
INNER JOIN payments
    ON orders.order_id = payments.order_id
WHERE payments.payment_status = 'Completed'
GROUP BY
    customers.customer_id,
    customers.customer_name,
    customers.city
ORDER BY total_paid DESC
LIMIT 5;


-- ============================================================
-- QUERY 9: PENDING AND UNPAID ORDERS
-- ============================================================

SELECT
    orders.order_id,
    customers.customer_name,
    orders.order_date,
    orders.order_status,
    payments.payment_status,
    payments.payment_amount
FROM orders
INNER JOIN customers
    ON orders.customer_id = customers.customer_id
LEFT JOIN payments
    ON orders.order_id = payments.order_id
WHERE
    payments.payment_status = 'Pending'
    OR payments.payment_id IS NULL
ORDER BY orders.order_date;


-- ============================================================
-- END OF BASIC ANALYTICS
-- ============================================================