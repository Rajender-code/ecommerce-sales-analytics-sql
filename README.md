# E-commerce Sales Analytics Project

## Project Overview

This project is an E-commerce Sales Analytics database built using MySQL.

The project focuses on designing a relational database, inserting sample
e-commerce data, performing sales analytics, creating reusable database
objects, optimizing queries, and testing data integrity.

The database helps analyze customers, products, orders, payments,
sales performance, and inventory.

## Technologies Used

- MySQL 8.0
- MySQL Workbench
- SQL

## Database Structure

The database contains the following tables:

1. customers
2. categories
3. products
4. orders
5. order_items
6. payments

## Entity Relationship Diagram

The Entity Relationship Diagram (ERD) represents the relationships
between customers, products, categories, orders, order items, and payments.

![Database ER Diagram](er_diagram.png)

## Project Structure

```text
ecommerce-sales-analytics/
│
├── README.md
├── er_diagram.png
├── ecommerce_analytics.mwb
│
├── screenshots/
│
└── sql/
    ├── 01_database_schema.sql
    ├── 02_insert_sample_data.sql
    ├── 03_basic_analytics.sql
    ├── 04_advanced_analytics.sql
    ├── 05_views_procedures_triggers.sql
    ├── 06_stored_functions.sql
    ├── 07_indexes_optimization.sql
    └── 08_data_integrity_testing.sql