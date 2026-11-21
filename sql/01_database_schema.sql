-- ============================================
-- PROJECT: E-Commerce Sales & Business Analytics
-- DATABASE: ecommerce_analytics
-- ============================================

CREATE DATABASE IF NOT EXISTS ecommerce_analytics;

USE ecommerce_analytics;


-- ============================================
-- TABLE 1: CUSTOMERS
-- ============================================

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    city VARCHAR(100),
    registration_date DATE NOT NULL
);


-- ============================================
-- TABLE 2: CATEGORIES
-- ============================================

CREATE TABLE IF NOT EXISTS categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) UNIQUE NOT NULL
);


-- ============================================
-- TABLE 3: PRODUCTS
-- ============================================

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(150) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,

    FOREIGN KEY (category_id)
        REFERENCES categories(category_id),

    CONSTRAINT chk_product_price
        CHECK (price >= 0),

    CONSTRAINT chk_product_stock
        CHECK (stock_quantity >= 0)
);


-- ============================================
-- TABLE 4: ORDERS
-- ============================================

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATETIME NOT NULL,

    order_status ENUM(
        'Pending',
        'Processing',
        'Shipped',
        'Delivered',
        'Cancelled'
    ) DEFAULT 'Pending',

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);


-- ============================================
-- TABLE 5: ORDER_ITEMS
-- ============================================

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT chk_order_item_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_item_price
        CHECK (unit_price >= 0)
);


-- ============================================
-- TABLE 6: PAYMENTS
-- ============================================

CREATE TABLE IF NOT EXISTS payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date DATETIME,

    payment_method ENUM(
        'UPI',
        'Credit Card',
        'Debit Card',
        'Net Banking',
        'Cash on Delivery'
    ),

    payment_amount DECIMAL(10,2) NOT NULL,

    payment_status ENUM(
        'Pending',
        'Completed',
        'Failed',
        'Refunded'
    ) DEFAULT 'Pending',

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT chk_payment_amount
        CHECK (payment_amount >= 0)
);


-- ============================================
-- VERIFY DATABASE TABLES
-- ============================================

SHOW TABLES;