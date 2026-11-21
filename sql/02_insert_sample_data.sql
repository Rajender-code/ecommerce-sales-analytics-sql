-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: ecommerce_analytics
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (4,'Accessories'),(1,'Electronics'),(5,'Home Appliances'),(3,'Laptops'),(2,'Mobiles');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Raj Kumar','raj@gmail.com','Hyderabad','2025-01-10'),(2,'Priya Sharma','priya@gmail.com','Bangalore','2025-01-15'),(3,'Arun Reddy','arun@gmail.com','Chennai','2025-02-01'),(4,'Kiran Patel','kiran@gmail.com','Mumbai','2025-02-10'),(5,'Suresh Rao','suresh@gmail.com','Delhi','2025-02-20'),(6,'Anjali Verma','anjali@gmail.com','Hyderabad','2025-03-05'),(7,'Ravi Kumar','ravi@gmail.com','Bangalore','2025-03-12'),(8,'Neha Singh','neha@gmail.com','Mumbai','2025-03-20'),(9,'Vijay Reddy','vijay@gmail.com','Chennai','2025-04-01'),(10,'Meena Das','meena@gmail.com','Delhi','2025-04-15'),(11,'Duplicate Customer','raj@example.com','Hyderabad','2025-05-20');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,1,1,75000.00),(2,1,5,1,5000.00),(3,2,2,1,80000.00),(4,2,6,2,1500.00),(5,3,3,1,65000.00),(6,3,5,1,5000.00),(7,4,4,1,70000.00),(8,4,10,1,3500.00),(9,5,7,1,55000.00),(10,5,6,2,1500.00),(11,6,11,1,40000.00),(12,6,5,2,5000.00),(13,7,8,1,40000.00),(14,8,9,1,45000.00),(15,8,10,2,3500.00),(16,9,1,1,75000.00),(17,9,6,1,1500.00),(18,10,12,1,60000.00),(19,10,5,1,5000.00),(20,11,3,1,65000.00),(21,11,6,1,1500.00),(22,12,2,1,80000.00),(23,12,10,1,3500.00),(24,13,4,1,70000.00),(25,13,5,1,5000.00),(26,14,7,1,55000.00),(27,14,6,1,1500.00),(28,15,11,1,40000.00),(29,15,10,1,3500.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,'2025-05-01 10:30:00','Delivered'),(2,2,'2025-05-02 11:15:00','Delivered'),(3,3,'2025-05-03 14:20:00','Shipped'),(4,4,'2025-05-04 09:45:00','Processing'),(5,5,'2025-05-05 16:00:00','Delivered'),(6,1,'2025-05-06 12:10:00','Delivered'),(7,6,'2025-05-07 13:30:00','Cancelled'),(8,7,'2025-05-08 15:45:00','Delivered'),(9,8,'2025-05-09 10:20:00','Shipped'),(10,9,'2025-05-10 17:00:00','Delivered'),(11,10,'2025-05-11 11:40:00','Processing'),(12,2,'2025-05-12 14:30:00','Delivered'),(13,3,'2025-05-13 09:15:00','Delivered'),(14,5,'2025-05-14 16:20:00','Pending'),(15,7,'2025-05-15 12:00:00','Delivered');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,1,'2025-05-01 10:35:00','UPI',80000.00,'Completed'),(2,2,'2025-05-02 11:20:00','Credit Card',83000.00,'Completed'),(3,3,'2025-05-03 14:25:00','Debit Card',70000.00,'Completed'),(4,4,'2025-05-04 09:50:00','UPI',73500.00,'Pending'),(5,5,'2025-05-05 16:05:00','Net Banking',58000.00,'Completed'),(6,6,'2025-05-06 12:15:00','Credit Card',50000.00,'Completed'),(7,7,'2025-05-07 13:35:00','UPI',40000.00,'Refunded'),(8,8,'2025-05-08 15:50:00','Debit Card',52000.00,'Completed'),(9,9,'2025-05-09 10:25:00','Credit Card',76500.00,'Completed'),(10,10,'2025-05-10 17:05:00','UPI',65000.00,'Completed'),(11,11,'2025-05-11 11:45:00','Cash on Delivery',66500.00,'Pending'),(12,12,'2025-05-12 14:35:00','Net Banking',83500.00,'Completed'),(13,13,'2025-05-13 09:20:00','UPI',75000.00,'Completed'),(14,14,'2025-05-14 16:25:00','Credit Card',56500.00,'Pending'),(15,15,'2025-05-15 12:05:00','Debit Card',43500.00,'Completed');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Samsung Galaxy S24',2,75000.00,20),(2,'iPhone 15',2,80000.00,15),(3,'Dell Inspiron Laptop',3,65000.00,10),(4,'HP Pavilion Laptop',3,70000.00,8),(5,'Sony Headphones',4,5000.00,30),(6,'Logitech Mouse',4,1500.00,50),(7,'Samsung Smart TV',1,55000.00,12),(8,'LG Washing Machine',5,40000.00,7),(9,'Apple iPad',1,45000.00,10),(10,'Mechanical Keyboard',4,3500.00,25),(11,'OnePlus Smartphone',2,40000.00,18),(12,'Canon Camera',1,60000.00,5);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-21 13:22:27
