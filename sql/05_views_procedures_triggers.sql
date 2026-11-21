-- ============================================================
-- PROJECT: E-Commerce Sales & Business Analytics
-- DATABASE: ecommerce_analytics
-- FILE: 05_views_procedures_triggers.sql
-- PURPOSE: Views, Stored Procedures and Triggers
-- ============================================================

USE ecommerce_analytics;


-- ============================================================
-- SECTION 1: VIEWS
-- ============================================================


-- ------------------------------------------------------------
-- VIEW 1: CUSTOMER ORDER VIEW
-- ------------------------------------------------------------

DROP VIEW IF EXISTS customer_order_view;

CREATE VIEW customer_order_view AS

SELECT
    customers.customer_id,
    customers.customer_name,
    customers.email,
    customers.city,

    orders.order_id,
    orders.order_date,
    orders.order_status,

    COALESCE(
        SUM(order_items.quantity * order_items.unit_price),
        0
    ) AS order_total

FROM customers

LEFT JOIN orders
    ON customers.customer_id = orders.customer_id

LEFT JOIN order_items
    ON orders.order_id = order_items.order_id

GROUP BY
    customers.customer_id,
    customers.customer_name,
    customers.email,
    customers.city,
    orders.order_id,
    orders.order_date,
    orders.order_status;


-- TEST CUSTOMER ORDER VIEW

SELECT *
FROM customer_order_view;


-- ------------------------------------------------------------
-- VIEW 2: PRODUCT SALES VIEW
-- ------------------------------------------------------------

DROP VIEW IF EXISTS product_sales_view;

CREATE VIEW product_sales_view AS

SELECT
    products.product_id,
    products.product_name,
    categories.category_name,
    products.price,

    COALESCE(
        SUM(order_items.quantity),
        0
    ) AS total_quantity_sold,

    COALESCE(
        SUM(order_items.quantity * order_items.unit_price),
        0
    ) AS total_revenue

FROM products

LEFT JOIN categories
    ON products.category_id = categories.category_id

LEFT JOIN order_items
    ON products.product_id = order_items.product_id

GROUP BY
    products.product_id,
    products.product_name,
    categories.category_name,
    products.price;


-- TEST PRODUCT SALES VIEW

SELECT *
FROM product_sales_view

ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- VIEW 3: COMPLETED PAYMENTS VIEW
-- ------------------------------------------------------------

DROP VIEW IF EXISTS completed_payments_view;

CREATE VIEW completed_payments_view AS

SELECT
    payments.payment_id,
    payments.order_id,
    payments.payment_date,
    payments.payment_method,
    payments.payment_amount,
    payments.payment_status,

    customers.customer_id,
    customers.customer_name

FROM payments

INNER JOIN orders
    ON payments.order_id = orders.order_id

INNER JOIN customers
    ON orders.customer_id = customers.customer_id

WHERE payments.payment_status = 'Completed';


-- TEST COMPLETED PAYMENTS VIEW

SELECT *
FROM completed_payments_view

ORDER BY payment_date DESC;


-- ============================================================
-- SECTION 2: STORED PROCEDURES
-- ============================================================


-- ------------------------------------------------------------
-- PROCEDURE 1: GET ALL CUSTOMER ORDERS
-- ------------------------------------------------------------

DROP PROCEDURE IF EXISTS get_all_customer_orders;

DELIMITER $$

CREATE PROCEDURE get_all_customer_orders()

BEGIN

    SELECT
        customers.customer_id,
        customers.customer_name,
        orders.order_id,
        orders.order_date,
        orders.order_status,

        COALESCE(
            SUM(order_items.quantity * order_items.unit_price),
            0
        ) AS order_total

    FROM customers

    LEFT JOIN orders
        ON customers.customer_id = orders.customer_id

    LEFT JOIN order_items
        ON orders.order_id = order_items.order_id

    GROUP BY
        customers.customer_id,
        customers.customer_name,
        orders.order_id,
        orders.order_date,
        orders.order_status

    ORDER BY
        customers.customer_id,
        orders.order_date;

END $$

DELIMITER ;


-- TEST PROCEDURE 1

CALL get_all_customer_orders();


-- ------------------------------------------------------------
-- PROCEDURE 2: GET ORDERS FOR A PARTICULAR CUSTOMER
-- ------------------------------------------------------------

DROP PROCEDURE IF EXISTS get_customer_orders;

DELIMITER $$

CREATE PROCEDURE get_customer_orders(
    IN p_customer_id INT
)

BEGIN

    SELECT
        customers.customer_id,
        customers.customer_name,
        customers.email,

        orders.order_id,
        orders.order_date,
        orders.order_status,

        products.product_name,
        order_items.quantity,
        order_items.unit_price,

        order_items.quantity * order_items.unit_price
            AS item_total

    FROM customers

    INNER JOIN orders
        ON customers.customer_id = orders.customer_id

    INNER JOIN order_items
        ON orders.order_id = order_items.order_id

    INNER JOIN products
        ON order_items.product_id = products.product_id

    WHERE customers.customer_id = p_customer_id

    ORDER BY orders.order_date;

END $$

DELIMITER ;


-- TEST PROCEDURE 2

CALL get_customer_orders(1);


-- ------------------------------------------------------------
-- PROCEDURE 3: GET PRODUCT SALES
-- ------------------------------------------------------------

DROP PROCEDURE IF EXISTS get_product_sales;

DELIMITER $$

CREATE PROCEDURE get_product_sales()

BEGIN

    SELECT
        products.product_id,
        products.product_name,
        categories.category_name,

        products.price,

        COALESCE(
            SUM(order_items.quantity),
            0
        ) AS total_quantity_sold,

        COALESCE(
            SUM(order_items.quantity * order_items.unit_price),
            0
        ) AS total_sales

    FROM products

    LEFT JOIN categories
        ON products.category_id = categories.category_id

    LEFT JOIN order_items
        ON products.product_id = order_items.product_id

    GROUP BY
        products.product_id,
        products.product_name,
        categories.category_name,
        products.price

    ORDER BY total_sales DESC;

END $$

DELIMITER ;


-- TEST PROCEDURE 3

CALL get_product_sales();


-- ============================================================
-- SECTION 3: TRIGGERS
-- ============================================================


-- ------------------------------------------------------------
-- TRIGGER 1: CHECK PRODUCT STOCK BEFORE ORDER INSERT
-- ------------------------------------------------------------

DROP TRIGGER IF EXISTS check_product_stock;

DELIMITER $$

CREATE TRIGGER check_product_stock

BEFORE INSERT ON order_items

FOR EACH ROW

BEGIN

    DECLARE available_stock INT;

    -- Check that the order quantity is positive

    IF NEW.quantity <= 0 THEN

        SIGNAL SQLSTATE '45000'

        SET MESSAGE_TEXT =
            'Order quantity must be greater than zero';

    END IF;


    -- Retrieve the available stock

    SELECT stock_quantity

    INTO available_stock

    FROM products

    WHERE product_id = NEW.product_id;


    -- Check whether sufficient stock is available

    IF available_stock IS NULL THEN

        SIGNAL SQLSTATE '45000'

        SET MESSAGE_TEXT =
            'Product does not exist';

    ELSEIF NEW.quantity > available_stock THEN

        SIGNAL SQLSTATE '45000'

        SET MESSAGE_TEXT =
            'Insufficient product stock';

    END IF;

END $$

DELIMITER ;


-- ------------------------------------------------------------
-- TRIGGER 2: UPDATE PRODUCT STOCK AFTER ORDER INSERT
-- ------------------------------------------------------------

DROP TRIGGER IF EXISTS update_stock_after_order;

DELIMITER $$

CREATE TRIGGER update_stock_after_order

AFTER INSERT ON order_items

FOR EACH ROW

BEGIN

    UPDATE products

    SET stock_quantity = stock_quantity - NEW.quantity

    WHERE product_id = NEW.product_id;

END $$

DELIMITER ;


-- ============================================================
-- SECTION 4: VERIFICATION
-- ============================================================


-- CHECK ALL VIEWS

SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';


-- CHECK STORED PROCEDURES

SHOW PROCEDURE STATUS
WHERE Db = 'ecommerce_analytics';


-- CHECK TRIGGERS

SHOW TRIGGERS
FROM ecommerce_analytics;


-- CHECK CUSTOMER ORDER VIEW

SELECT *
FROM customer_order_view;


-- CHECK PRODUCT SALES VIEW

SELECT *
FROM product_sales_view;


-- CHECK COMPLETED PAYMENTS VIEW

SELECT *
FROM completed_payments_view;


-- CHECK ALL CUSTOMER ORDERS PROCEDURE

CALL get_all_customer_orders();


-- CHECK CUSTOMER ORDERS FOR CUSTOMER 1

CALL get_customer_orders(1);


-- CHECK PRODUCT SALES PROCEDURE

CALL get_product_sales();


-- ============================================================
-- END OF FILE
-- ============================================================