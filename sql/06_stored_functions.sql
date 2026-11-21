-- ============================================================
-- PROJECT: E-Commerce Sales & Business Analytics
-- DATABASE: ecommerce_analytics
-- FILE: 06_stored_functions.sql
-- PURPOSE: Stored Functions for Business Calculations
-- ============================================================

USE ecommerce_analytics;


-- ============================================================
-- FUNCTION 1: CALCULATE DISCOUNT
-- ============================================================

DROP FUNCTION IF EXISTS calculate_discount;

DELIMITER $$

CREATE FUNCTION calculate_discount(
    order_amount DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC

BEGIN

    DECLARE discount_amount DECIMAL(10,2);

    IF order_amount >= 100000 THEN

        SET discount_amount = order_amount * 0.15;

    ELSEIF order_amount >= 50000 THEN

        SET discount_amount = order_amount * 0.10;

    ELSEIF order_amount >= 10000 THEN

        SET discount_amount = order_amount * 0.05;

    ELSE

        SET discount_amount = 0;

    END IF;

    RETURN discount_amount;

END $$

DELIMITER ;


-- ============================================================
-- TEST FUNCTION 1: CALCULATE DISCOUNT
-- ============================================================

SELECT
    150000 AS order_amount,
    calculate_discount(150000) AS discount_15_percent,

    75000 AS second_order_amount,
    calculate_discount(75000) AS discount_10_percent,

    25000 AS third_order_amount,
    calculate_discount(25000) AS discount_5_percent,

    5000 AS fourth_order_amount,
    calculate_discount(5000) AS no_discount;


-- ============================================================
-- FUNCTION 2: CALCULATE FINAL PRICE
-- ============================================================

DROP FUNCTION IF EXISTS calculate_final_price;

DELIMITER $$

CREATE FUNCTION calculate_final_price(
    order_amount DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC

BEGIN

    DECLARE final_amount DECIMAL(10,2);

    SET final_amount =
        order_amount - calculate_discount(order_amount);

    RETURN final_amount;

END $$

DELIMITER ;


-- ============================================================
-- TEST FUNCTION 2: CALCULATE FINAL PRICE
-- ============================================================

SELECT
    150000 AS original_amount,

    calculate_discount(150000) AS discount_amount,

    calculate_final_price(150000) AS final_amount;


-- ============================================================
-- FUNCTION 3: CALCULATE GST
-- ============================================================

DROP FUNCTION IF EXISTS calculate_gst;

DELIMITER $$

CREATE FUNCTION calculate_gst(
    amount DECIMAL(10,2),
    gst_percentage DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC

BEGIN

    DECLARE tax_amount DECIMAL(10,2);

    SET tax_amount =
        amount * gst_percentage / 100;

    RETURN tax_amount;

END $$

DELIMITER ;


-- ============================================================
-- TEST FUNCTION 3: CALCULATE GST
-- ============================================================

SELECT
    50000 AS amount,

    18 AS gst_percentage,

    calculate_gst(50000, 18) AS gst_amount,

    50000 + calculate_gst(50000, 18)
        AS total_amount_with_gst;


-- ============================================================
-- BUSINESS APPLICATION: DISCOUNT ON ORDER TOTALS
-- ============================================================

SELECT
    order_items.order_id,

    SUM(
        order_items.quantity * order_items.unit_price
    ) AS order_amount,

    calculate_discount(
        SUM(order_items.quantity * order_items.unit_price)
    ) AS discount_amount,

    calculate_final_price(
        SUM(order_items.quantity * order_items.unit_price)
    ) AS final_amount

FROM order_items

GROUP BY order_items.order_id

ORDER BY final_amount DESC;


-- ============================================================
-- BUSINESS APPLICATION: GST CALCULATION FOR ORDERS
-- ============================================================

SELECT
    order_items.order_id,

    SUM(
        order_items.quantity * order_items.unit_price
    ) AS order_amount,

    calculate_gst(
        SUM(order_items.quantity * order_items.unit_price),
        18
    ) AS gst_amount,

    SUM(
        order_items.quantity * order_items.unit_price
    )
    +
    calculate_gst(
        SUM(order_items.quantity * order_items.unit_price),
        18
    ) AS total_amount_with_gst

FROM order_items

GROUP BY order_items.order_id

ORDER BY total_amount_with_gst DESC;


-- ============================================================
-- END OF STORED FUNCTIONS
-- ============================================================