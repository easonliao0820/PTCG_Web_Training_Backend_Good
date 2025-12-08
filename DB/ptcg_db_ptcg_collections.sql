-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 127.0.0.2    Database: ptcg_db
-- ------------------------------------------------------
-- Server version	8.0.43

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
-- Table structure for table `ptcg_collections`
--

DROP TABLE IF EXISTS `ptcg_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ptcg_collections` (
  `collections_id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_ch` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `release_date` date NOT NULL,
  `symbol_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `collection_type` int NOT NULL,
  PRIMARY KEY (`collections_id`),
  KEY `collection_type_idx` (`collection_type`),
  CONSTRAINT `collection_type` FOREIGN KEY (`collection_type`) REFERENCES `collection_type` (`id_collection_type`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ptcg_collections`
--

LOCK TABLES `ptcg_collections` WRITE;
/*!40000 ALTER TABLE `ptcg_collections` DISABLE KEYS */;
INSERT INTO `ptcg_collections` VALUES (1,'M2a','超級進化夢想ex','2025-12-05','/assets/collection_images/M2a.png','2025-12-08 09:06:34',1),(2,'M2','烈獄狂火X','2025-10-09','/assets/collection_images/M2.png','2025-12-08 09:06:34',2),(3,'MBG','超級耿鬼ex','2025-09-19','/assets/collection_images/MBG.png','2025-12-08 09:06:34',3),(4,'MBD','超級蒂安希ex','2025-09-19','/assets/collection_images/MBD.png','2025-12-08 09:06:34',3),(5,'M1L','超級勇氣','2025-08-15','/assets/collection_images/M1L.png','2025-12-08 09:06:34',2),(6,'M1S','超級交響樂','2025-08-15','/assets/collection_images/M1S.png','2025-12-08 09:06:34',2);
/*!40000 ALTER TABLE `ptcg_collections` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-08  9:48:29
