-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: company_rbac_audit
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `access_requests`
--

DROP TABLE IF EXISTS `access_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `access_requests` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `target_table` varchar(50) DEFAULT NULL,
  `target_id` int DEFAULT NULL,
  `action_attempted` varchar(20) DEFAULT NULL,
  `reason` text,
  `status` enum('pending','approved','denied') DEFAULT 'pending',
  `reviewer_id` int DEFAULT NULL,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `user_id` (`user_id`),
  KEY `reviewer_id` (`reviewer_id`),
  CONSTRAINT `access_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `access_requests_ibfk_2` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `access_requests`
--

LOCK TABLES `access_requests` WRITE;
/*!40000 ALTER TABLE `access_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `access_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `admin_view`
--

DROP TABLE IF EXISTS `admin_view`;
/*!50001 DROP VIEW IF EXISTS `admin_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `admin_view` AS SELECT 
 1 AS `emp_id`,
 1 AS `name`,
 1 AS `email`,
 1 AS `doj`,
 1 AS `salary`,
 1 AS `dept_name`,
 1 AS `role_name`,
 1 AS `username`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `action` varchar(20) DEFAULT NULL,
  `table_name` varchar(50) DEFAULT NULL,
  `target_id` int DEFAULT NULL,
  `old_value` text,
  `new_value` text,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `audit_view`
--

DROP TABLE IF EXISTS `audit_view`;
/*!50001 DROP VIEW IF EXISTS `audit_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `audit_view` AS SELECT 
 1 AS `log_id`,
 1 AS `action`,
 1 AS `table_name`,
 1 AS `target_id`,
 1 AS `performed_by`,
 1 AS `old_value`,
 1 AS `new_value`,
 1 AS `timestamp`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `dept_id` int NOT NULL AUTO_INCREMENT,
  `dept_name` varchar(100) NOT NULL,
  PRIMARY KEY (`dept_id`),
  UNIQUE KEY `dept_name` (`dept_name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `emp_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `doj` date NOT NULL,
  `salary` decimal(10,2) NOT NULL,
  `dept_id` int DEFAULT NULL,
  `manager_id` int DEFAULT NULL,
  PRIMARY KEY (`emp_id`),
  UNIQUE KEY `email` (`email`),
  KEY `dept_id` (`dept_id`),
  KEY `manager_id` (`manager_id`),
  CONSTRAINT `employees_ibfk_1` FOREIGN KEY (`dept_id`) REFERENCES `departments` (`dept_id`),
  CONSTRAINT `employees_ibfk_2` FOREIGN KEY (`manager_id`) REFERENCES `employees` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_employees_update` AFTER UPDATE ON `employees` FOR EACH ROW begin insert into audit_logs( user_id, action, table_name, target_id, old_value, new_value ) values ( @logged_in_user_id, 'UPDATE', 'employees', OLD.emp_id, CONCAT('name: ', OLD.name, ', email: ', OLD.email, ', salary: ', OLD.salary), CONCAT('name: ', NEW.name, ', email: ', NEW.email, ', salary: ', NEW.salary)); END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_employees_delete` AFTER DELETE ON `employees` FOR EACH ROW begin insert into audit_logs( user_id, action, table_name, target_id, old_value, new_value ) values ( @logged_in_user_id, 'DELETE', 'employees', OLD.emp_id, CONCAT('name: ', OLD.name, ', email: ', OLD.email, ', salary: ', OLD.salary), NULL ); END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `hr_view`
--

DROP TABLE IF EXISTS `hr_view`;
/*!50001 DROP VIEW IF EXISTS `hr_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `hr_view` AS SELECT 
 1 AS `emp_id`,
 1 AS `name`,
 1 AS `email`,
 1 AS `doj`,
 1 AS `salary`,
 1 AS `dept_name`,
 1 AS `role_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `intern_view`
--

DROP TABLE IF EXISTS `intern_view`;
/*!50001 DROP VIEW IF EXISTS `intern_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `intern_view` AS SELECT 
 1 AS `emp_id`,
 1 AS `name`,
 1 AS `email`,
 1 AS `doj`,
 1 AS `dept_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `manager_view`
--

DROP TABLE IF EXISTS `manager_view`;
/*!50001 DROP VIEW IF EXISTS `manager_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `manager_view` AS SELECT 
 1 AS `emp_id`,
 1 AS `name`,
 1 AS `email`,
 1 AS `doj`,
 1 AS `salary`,
 1 AS `manager_id`,
 1 AS `dept_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `pending_requests_view`
--

DROP TABLE IF EXISTS `pending_requests_view`;
/*!50001 DROP VIEW IF EXISTS `pending_requests_view`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `pending_requests_view` AS SELECT 
 1 AS `request_id`,
 1 AS `requested_by`,
 1 AS `target_table`,
 1 AS `target_id`,
 1 AS `action_attempted`,
 1 AS `reason`,
 1 AS `timestamp`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `role_id` int NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `role_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salary_recommendations`
--

DROP TABLE IF EXISTS `salary_recommendations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salary_recommendations` (
  `rec_id` int NOT NULL AUTO_INCREMENT,
  `emp_id` int DEFAULT NULL,
  `manager_id` int DEFAULT NULL,
  `old_salary` decimal(10,2) DEFAULT NULL,
  `proposed_salary` decimal(10,2) DEFAULT NULL,
  `reason` text,
  `status` enum('pending','approved','denied') DEFAULT 'pending',
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rec_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salary_recommendations`
--

LOCK TABLES `salary_recommendations` WRITE;
/*!40000 ALTER TABLE `salary_recommendations` DISABLE KEYS */;
/*!40000 ALTER TABLE `salary_recommendations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `signup_requests`
--

DROP TABLE IF EXISTS `signup_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `signup_requests` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `dept_id` int DEFAULT NULL,
  `doj` date DEFAULT NULL,
  `salary` decimal(10,2) DEFAULT NULL,
  `password_hash` text,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `signup_requests`
--

LOCK TABLES `signup_requests` WRITE;
/*!40000 ALTER TABLE `signup_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `signup_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_id` int DEFAULT NULL,
  `employee_id` int DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  KEY `role_id` (`role_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`),
  CONSTRAINT `users_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `admin_view`
--

/*!50001 DROP VIEW IF EXISTS `admin_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `admin_view` AS select `e`.`emp_id` AS `emp_id`,`e`.`name` AS `name`,`e`.`email` AS `email`,`e`.`doj` AS `doj`,`e`.`salary` AS `salary`,`d`.`dept_name` AS `dept_name`,`r`.`role_name` AS `role_name`,`u`.`username` AS `username` from (((`employees` `e` join `departments` `d` on((`e`.`dept_id` = `d`.`dept_id`))) left join `users` `u` on((`u`.`employee_id` = `e`.`emp_id`))) left join `roles` `r` on((`u`.`role_id` = `r`.`role_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `audit_view`
--

/*!50001 DROP VIEW IF EXISTS `audit_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `audit_view` AS select `a`.`log_id` AS `log_id`,`a`.`action` AS `action`,`a`.`table_name` AS `table_name`,`a`.`target_id` AS `target_id`,`u`.`username` AS `performed_by`,`a`.`old_value` AS `old_value`,`a`.`new_value` AS `new_value`,`a`.`timestamp` AS `timestamp` from (`audit_logs` `a` left join `users` `u` on((`a`.`user_id` = `u`.`user_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `hr_view`
--

/*!50001 DROP VIEW IF EXISTS `hr_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `hr_view` AS select `e`.`emp_id` AS `emp_id`,`e`.`name` AS `name`,`e`.`email` AS `email`,`e`.`doj` AS `doj`,`e`.`salary` AS `salary`,`d`.`dept_name` AS `dept_name`,`r`.`role_name` AS `role_name` from (((`employees` `e` join `departments` `d` on((`e`.`dept_id` = `d`.`dept_id`))) left join `users` `u` on((`u`.`employee_id` = `e`.`emp_id`))) left join `roles` `r` on((`u`.`role_id` = `r`.`role_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `intern_view`
--

/*!50001 DROP VIEW IF EXISTS `intern_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `intern_view` AS select `e`.`emp_id` AS `emp_id`,`e`.`name` AS `name`,`e`.`email` AS `email`,`e`.`doj` AS `doj`,`d`.`dept_name` AS `dept_name` from (`employees` `e` join `departments` `d` on((`e`.`dept_id` = `d`.`dept_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `manager_view`
--

/*!50001 DROP VIEW IF EXISTS `manager_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `manager_view` AS select `e`.`emp_id` AS `emp_id`,`e`.`name` AS `name`,`e`.`email` AS `email`,`e`.`doj` AS `doj`,`e`.`salary` AS `salary`,`e`.`manager_id` AS `manager_id`,`d`.`dept_name` AS `dept_name` from (`employees` `e` join `departments` `d` on((`e`.`dept_id` = `d`.`dept_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pending_requests_view`
--

/*!50001 DROP VIEW IF EXISTS `pending_requests_view`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `pending_requests_view` AS select `ar`.`request_id` AS `request_id`,`u`.`username` AS `requested_by`,`ar`.`target_table` AS `target_table`,`ar`.`target_id` AS `target_id`,`ar`.`action_attempted` AS `action_attempted`,`ar`.`reason` AS `reason`,`ar`.`timestamp` AS `timestamp` from (`access_requests` `ar` join `users` `u` on((`ar`.`user_id` = `u`.`user_id`))) where (`ar`.`status` = 'pending') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-10  6:01:15
-- Sanitized demo dataset for RBAC Audit System
-- All names, emails, and passwords below are fictional/demo data.
-- See credentials.txt for demo login usernames and passwords.

SET FOREIGN_KEY_CHECKS=0;

-- departments
DELETE FROM departments;
INSERT INTO departments (dept_id, dept_name) VALUES
(1,'Human Resources'),(2,'Engineering'),(3,'Finance'),(4,'Marketing'),(5,'Legal'),(6,'IT Infrastructure'),(7,'Sales'),(8,'Customer Support'),(9,'Product Management'),(10,'Operations');

-- roles
DELETE FROM roles;
INSERT INTO roles (role_id, role_name) VALUES
(1,'Admin'),(2,'HR'),(3,'Manager'),(4,'Intern'),(5,'Auditor');

-- employees
DELETE FROM employees;
INSERT INTO employees (emp_id, name, email, doj, salary, dept_id, manager_id) VALUES
(1,'Aditya Rao','aditya.rao.demo@example.com','2022-01-10',85000.0,1,NULL),(2,'Kavya Singh','kavya.singh.demo@example.com','2021-03-15',90000.0,2,NULL),(3,'Devansh Patel','devansh.patel.demo@example.com','2020-11-05',95000.0,3,NULL),(4,'Meera Nair','meera.nair.demo@example.com','2022-07-21',88000.0,4,NULL),(5,'Arjun Verma','arjun.verma.demo@example.com','2021-06-18',91000.0,5,NULL),(6,'Riya Kapoor','riya.kapoor.demo@example.com','2023-08-15',105000.0,6,NULL),(7,'Karan Malhotra','karan.malhotra.demo@example.com','2022-10-10',86000.0,7,NULL),(8,'Simran Chawla','simran.chawla.demo@example.com','2023-02-14',92000.0,8,NULL),(9,'Nikhil Bansal','nikhil.bansal.demo@example.com','2023-11-24',100000.0,9,NULL),(10,'Priya Deshmukh','priya.deshmukh.demo@example.com','2023-03-12',88000.0,10,NULL),(11,'Rohan Mehta','rohan.mehta.demo@example.com','2023-09-30',75000.0,9,NULL),(13,'Ananya Joshi','ananya.joshi.demo@example.com','2023-05-13',76000.0,6,NULL),(14,'Yash Thakur','yash.thakur.demo@example.com','2023-09-17',55000.0,6,13),(15,'Kabir Sharma','kabir.sharma.demo@example.com','2023-02-21',88000.0,6,NULL),(16,'Diya Reddy','diya.reddy.demo@example.com','2023-09-26',45000.0,6,13),(19,'Sana Kapadia','sana.kapadia.demo@example.com','2023-07-24',88000.0,9,NULL),(20,'Neha Iyer','neha.iyer.demo@example.com','2023-10-01',98000.0,10,NULL);

-- users
DELETE FROM users;
INSERT INTO users (user_id, username, password_hash, role_id, employee_id) VALUES
(1,'aditya_admin_humanresources_1','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',1,1),(2,'kavya_admin_engineering_2','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',1,2),(3,'devansh_admin_finance_3','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',1,3),(4,'meera_admin_marketing_4','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',1,4),(5,'arjun_admin_legal_5','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',1,5),(6,'riya_admin_itinfrastructure_6','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',1,6),(7,'karan_admin_sales_7','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',1,7),(8,'simran_admin_customersupport_8','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',1,8),(9,'nikhil_admin_productmanagement_9','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',1,9),(10,'priya_admin_operations_10','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',1,10),(11,'rohan_hr_productmanagement_11','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',2,11),(13,'ananya_manager_itinfrastructure_13','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',3,13),(14,'yash_intern_itinfrastructure_14','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',4,14),(15,'kabir_hr_itinfrastructure_15','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',2,15),(16,'diya_auditor_itinfrastructure_16','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',5,16),(19,'sana_manager_productmanagement_19','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',3,19),(20,'neha_hr_operations_20','ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73',2,20);

-- signup_requests
DELETE FROM signup_requests;
INSERT INTO signup_requests (request_id, name, email, role, dept_id, doj, salary, password_hash, status, timestamp) VALUES
(1,'Rohan Mehta','rohan.mehta.demo@example.com','HR',9,'2023-09-17',65000.0,'ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73','approved','2025-01-15 10:00:00'),(2,'Sana Kapadia','sana.kapadia.demo@example.com','Manager',9,'2023-07-24',87000.0,'ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73','approved','2025-01-15 10:00:00'),(4,'Ananya Joshi','ananya.joshi.demo@example.com','Manager',6,'2023-05-13',76000.0,'ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73','approved','2025-01-15 10:00:00'),(5,'Yash Thakur','yash.thakur.demo@example.com','Intern',6,'2023-09-17',55000.0,'ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73','approved','2025-01-15 10:00:00'),(6,'Kabir Sharma','kabir.sharma.demo@example.com','HR',6,'2023-02-21',88000.0,'ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73','approved','2025-01-15 10:00:00'),(7,'Diya Reddy','diya.reddy.demo@example.com','Auditor',6,'2023-09-26',45000.0,'ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73','approved','2025-01-15 10:00:00'),(10,'Neha Iyer','neha.iyer.demo@example.com','HR',10,'2023-10-01',98000.0,'ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73','approved','2025-01-15 10:00:00'),(11,'Amit Bose','amit.bose.demo@example.com','Intern',6,'2023-08-30',50000.0,'ff96673205dc722320598ebf8f88325b2ac56922d5a2164b5765868274bc0d73','rejected','2025-01-15 10:00:00');

-- audit_logs
DELETE FROM audit_logs;
INSERT INTO audit_logs (log_id, user_id, action, table_name, target_id, old_value, new_value, timestamp) VALUES
(1,NULL,'UPDATE','employees',9,'name: Nikhil Bansal, email: nikhil.bansal.demo@example.com, salary: 90000.00','name: Nikhil Bansal, email: nikhil.bansal.demo@example.com, salary: 100000.00','2025-01-16 09:15:00'),(2,NULL,'UPDATE','employees',16,'name: Diya Reddy, email: diya.reddy.demo@example.com, salary: 40000.00','name: Diya Reddy, email: diya.reddy.demo@example.com, salary: 45000.00','2025-01-17 11:20:00'),(3,NULL,'UPDATE','employees',14,'name: Yash Thakur, email: yash.thakur.demo@example.com, salary: 50000.00','name: Yash Thakur, email: yash.thakur.demo@example.com, salary: 55000.00','2025-01-18 14:05:00');

-- access_requests
DELETE FROM access_requests;
INSERT INTO access_requests (request_id, user_id, target_table, target_id, action_attempted, reason, status, reviewer_id, timestamp) VALUES
(1,14,'client_database',NULL,'edit','Need to add new features for the demo client project','approved',15,'2025-01-20 10:00:00'),(2,14,'internal_docs',NULL,'view','Cross check the data before submission','denied',15,'2025-01-21 12:30:00'),(3,14,'code_repository',NULL,'edit','Needs to update the code structure','approved',15,'2025-01-22 15:45:00');

-- salary_recommendations
DELETE FROM salary_recommendations;
INSERT INTO salary_recommendations (rec_id, emp_id, manager_id, old_salary, proposed_salary, reason, status, timestamp) VALUES
(1,14,13,NULL,60000.00,'Good teamwork and consistent delivery','approved','2025-01-25 09:00:00'),(2,16,13,NULL,48000.00,'Solid quarterly performance','approved','2025-01-26 10:30:00');

SET FOREIGN_KEY_CHECKS=1;
