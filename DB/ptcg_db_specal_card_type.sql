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
-- Table structure for table `specal_card_type`
--

DROP TABLE IF EXISTS `specal_card_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `specal_card_type` (
  `specal_id` int NOT NULL AUTO_INCREMENT,
  `speca_type_en` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `speca_type_ch` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`specal_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specal_card_type`
--

LOCK TABLES `specal_card_type` WRITE;
/*!40000 ALTER TABLE `specal_card_type` DISABLE KEYS */;
INSERT INTO `specal_card_type` VALUES (1,'EX','寶可夢EX'),(2,'EX-Mega Evolution Pokémon','寶可夢EX-M进化寶可夢'),(3,'BREAK','BREAK進化寶可夢'),(4,'GX','寶可夢GX'),(5,'GX-TAG TEAM','寶可夢GX-TAG TEAM'),(6,'Prism Star','稜鏡之星'),(7,'V','寶可夢V'),(8,'VMAX','寶可夢VMAX'),(9,'V-UNION','寶可夢V-UNION'),(10,'VSTAR','寶可夢VSTAR'),(11,'Radiant','光輝寶可夢'),(12,'EX-Tera','寶可夢EX-太晶'),(13,'EX-Mega Evolution','寶可夢EX-超級進化');
/*!40000 ALTER TABLE `specal_card_type` ENABLE KEYS */;
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
