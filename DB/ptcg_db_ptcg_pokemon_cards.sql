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
-- Table structure for table `ptcg_pokemon_cards`
--

DROP TABLE IF EXISTS `ptcg_pokemon_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ptcg_pokemon_cards` (
  `card_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hp` int NOT NULL,
  `stage` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `info` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `energy_type` int NOT NULL,
  `collection_id` int NOT NULL,
  `specal_card_type` int NOT NULL,
  `rarity_id` int NOT NULL,
  PRIMARY KEY (`card_id`),
  KEY `energy_type` (`energy_type`),
  KEY `collection_id` (`collection_id`),
  KEY `specal_card_type` (`specal_card_type`),
  KEY `rarity_id` (`rarity_id`),
  CONSTRAINT `ptcg_pokemon_cards_ibfk_1` FOREIGN KEY (`energy_type`) REFERENCES `energy_attributes` (`energy_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ptcg_pokemon_cards_ibfk_2` FOREIGN KEY (`collection_id`) REFERENCES `ptcg_collections` (`collections_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ptcg_pokemon_cards_ibfk_3` FOREIGN KEY (`specal_card_type`) REFERENCES `specal_card_type` (`specal_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ptcg_pokemon_cards_ibfk_4` FOREIGN KEY (`rarity_id`) REFERENCES `rarity` (`rarity_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ptcg_pokemon_cards`
--

LOCK TABLES `ptcg_pokemon_cards` WRITE;
/*!40000 ALTER TABLE `ptcg_pokemon_cards` DISABLE KEYS */;
/*!40000 ALTER TABLE `ptcg_pokemon_cards` ENABLE KEYS */;
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
