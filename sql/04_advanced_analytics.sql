-- ============================================================
-- PROJECT: E-Commerce Sales & Business Analytics
-- DATABASE: ecommerce_analytics
-- FILE: 04_advanced_analytics.sql
-- PURPOSE: Advanced SQL Business Analytics
-- ============================================================

USE ecommerce_analytics;


-- ============================================================
-- QUERY 1: CUSTOMER PURCHASE HISTORY
-- ============================================================

SELECT
    customers.customer_id,
    customers.customer_name,
    orders.order_id,
    orders.order_date,
    orders.order_status,
    products.product_name,
    order_items.quantity,
    order_items.unit_price,
    order_items.quantity * order_items.unit_price AS item_total,
    payments.payment_method,
    payments.payment_status

FROM customers

INNER JOIN orders
    ON customers.customer_id = orders.customer_id

INNER JOIN order_items
    ON orders.order_id = order_items.order_id

INNER JOIN products
    ON order_items.product_id = products.product_id

LEFT JOIN payments
    ON orders.order_id = payments.order_id

ORDER BY
    customers.customer_id,
    orders.order_date,
    orders.order_id;


-- ============================================================
-- QUERY 2: PRODUCT SALES RANKING
-- ============================================================

SELECT
    products.product_id,
    products.product_name,

    SUM(order_items.quantity) AS total_quantity_sold,

    SUM(order_items.quantity * order_items.unit_price)
        AS total_sales,

    RANK() OVER (
        ORDER BY SUM(order_items.quantity * order_items.unit_price) DESC
    ) AS sales_rank,

    DENSE_RANK() OVER (
        ORDER BY SUM(order_items.quantity * order_items.unit_price) DESC
    ) AS dense_sales_rank

FROM products

INNER JOIN order_items
    ON products.product_id = order_items.product_id

GROUP BY
    products.product_id,
    products.product_name

ORDER BY sales_rank;


-- ============================================================
-- QUERY 3: CUSTOMER SEGMENTATION
-- ============================================================

WITH customer_sales AS (

    SELECT
        customers.customer_id,
        customers.customer_name,

        COUNT(DISTINCT orders.order_id) AS total_orders,

        COALESCE(
            SUM(order_items.quantity * order_items.unit_price),
            0
        ) AS total_spent

    FROM customers

    LEFT JOIN orders
        ON customers.customer_id = orders.customer_id

    LEFT JOIN order_items
        ON orders.order_id = order_items.order_id

    GROUP BY
        customers.customer_id,
        customers.customer_name
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    total_spent,

    CASE
        WHEN total_spent >= 100000
            THEN 'VIP Customer'

        WHEN total_spent >= 50000
            THEN 'Premium Customer'

        WHEN total_spent > 0
            THEN 'Regular Customer'

        ELSE 'No Purchase'
    END AS customer_segment

FROM customer_sales

ORDER BY total_spent DESC;


-- ============================================================
-- QUERY 4: CUSTOMER SEGMENT SUMMARY
-- ============================================================

WITH customer_sales AS (

    SELECT
        customers.customer_id,
        customers.customer_name,

        COUNT(DISTINCT orders.order_id) AS total_orders,

        COALESCE(
            SUM(order_items.quantity * order_items.unit_price),
            0
        ) AS total_spent

    FROM customers

    LEFT JOIN orders
        ON customers.customer_id = orders.customer_id

    LEFT JOIN order_items
        ON orders.order_id = order_items.order_id

    GROUP BY
        customers.customer_id,
        customers.customer_name
),

segmented_customers AS (

    SELECT
        customer_id,
        customer_name,
        total_orders,
        total_spent,

        CASE
            WHEN total_spent >= 100000
                THEN 'VIP Customer'

            WHEN total_spent >= 50000
                THEN 'Premium Customer'

            WHEN total_spent > 0
                THEN 'Regular Customer'

            ELSE 'No Purchase'
        END AS customer_segment

    FROM customer_sales
)

SELECT
    customer_segment,

    COUNT(*) AS total_customers,

    SUM(total_orders) AS total_orders,

    SUM(total_spent) AS total_revenue,

    AVG(total_spent) AS average_customer_spending

FROM segmented_customers

GROUP BY customer_segment

ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 5: INVENTORY ANALYSIS
-- ============================================================

SELECT
    products.product_id,
    products.product_name,
    categories.category_name,
    products.price,
    products.stock_quantity,

    CASE
        WHEN products.stock_quantity = 0
            THEN 'Out of Stock'

        WHEN products.stock_quantity <= 5
            THEN 'Low Stock'

        WHEN products.stock_quantity <= 15
            THEN 'Moderate Stock'

        ELSE 'Healthy Stock'
    END AS stock_status,

    products.stock_quantity * products.price
        AS inventory_value

FROM products

LEFT JOIN categories
    ON products.category_id = categories.category_id

ORDER BY products.stock_quantity ASC;


-- ============================================================
-- QUERY 6: CUSTOMER RETENTION ANALYSIS
-- ============================================================

SELECT
    customers.customer_id,
    customers.customer_name,

    COUNT(orders.order_id) AS total_orders,

    MIN(orders.order_date) AS first_order_date,

    MAX(orders.order_date) AS latest_order_date,

    DATEDIFF(
        MAX(orders.order_date),
        MIN(orders.order_date)
    ) AS days_between_first_and_last_order,

    CASE
        WHEN COUNT(orders.order_id) > 1
            THEN 'Repeat Customer'

        WHEN COUNT(orders.order_id) = 1
            THEN 'One-Time Customer'

        ELSE 'No Orders'
    END AS customer_retention_status

FROM customers

LEFT JOIN orders
    ON customers.customer_id = orders.customer_id

GROUP BY
    customers.customer_id,
    customers.customer_name

ORDER BY total_orders DESC;


-- ============================================================
-- QUERY 7: ADVANCED SALES DASHBOARD
-- ============================================================

WITH sales_summary AS (

    SELECT
        SUM(order_items.quantity * order_items.unit_price)
            AS total_order_value,

        COUNT(DISTINCT orders.order_id)
            AS total_orders,

        SUM(order_items.quantity)
            AS total_products_sold

    FROM orders

    INNER JOIN order_items
        ON orders.order_id = order_items.order_id
),

payment_summary AS (

    SELECT

        SUM(
            CASE
                WHEN payment_status = 'Completed'
                    THEN payment_amount

                ELSE 0
            END
        ) AS completed_revenue,

        SUM(
            CASE
                WHEN payment_status = 'Pending'
                    THEN payment_amount

                ELSE 0
            END
        ) AS pending_payment_amount,

        COUNT(
            CASE
                WHEN payment_status = 'Completed'
                    THEN 1
            END
        ) AS completed_transactions

    FROM payments
),

customer_summary AS (

    SELECT
        COUNT(*) AS total_customers

    FROM customers
),

product_summary AS (

    SELECT
        COUNT(*) AS total_products,

        SUM(stock_quantity) AS total_stock

    FROM products
)

SELECT
    sales_summary.total_order_value,
    payment_summary.completed_revenue,
    payment_summary.pending_payment_amount,
    sales_summary.total_orders,
    payment_summary.completed_transactions,
    sales_summary.total_products_sold,
    customer_summary.total_customers,
    product_summary.total_products,
    product_summary.total_stock

FROM sales_summary

CROSS JOIN payment_summary

CROSS JOIN customer_summary

CROSS JOIN product_summary;


-- ============================================================
-- END OF ADVANCED ANALYTICS
-- ============================================================