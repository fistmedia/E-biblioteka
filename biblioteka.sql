-- MariaDB dump 10.17  Distrib 10.4.13-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: biblioteka
-- ------------------------------------------------------
-- Server version	10.4.13-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `izdavanje`
--

DROP TABLE IF EXISTS `izdavanje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `izdavanje` (
  `korisnik_id` mediumint(8) unsigned DEFAULT NULL,
  `knjiga_id` mediumint(8) unsigned DEFAULT NULL,
  `rezerv_rok` date DEFAULT curdate(),
  `vracanje_rok` date DEFAULT NULL,
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `kasni` smallint(5) unsigned NOT NULL DEFAULT 0,
  `vracena` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `izdavanje_FK` (`korisnik_id`),
  KEY `izdavanje_FK1` (`knjiga_id`),
  KEY `izdavanje_vracena_IDX` (`vracena`) USING BTREE,
  CONSTRAINT `izdavanje_FK` FOREIGN KEY (`korisnik_id`) REFERENCES `korisnik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `izdavanje_FK1` FOREIGN KEY (`knjiga_id`) REFERENCES `knjiga` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izdavanje`
--

LOCK TABLES `izdavanje` WRITE;
/*!40000 ALTER TABLE `izdavanje` DISABLE KEYS */;
INSERT INTO `izdavanje` VALUES (4,1,'2020-06-14',NULL,1,0,1),(2,2,'2020-06-15',NULL,2,0,1),(4,1,'2020-06-15',NULL,3,0,0),(2,2,'2020-06-15',NULL,4,0,1);
/*!40000 ALTER TABLE `izdavanje` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER izdavanje
AFTER INSERT
ON izdavanje FOR EACH ROW
BEGIN 
	UPDATE knjiga
	SET broj_dostupnih = broj_dostupnih - 1
	WHERE id = NEW.knjiga_id;
END */;;
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
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER vracanje
BEFORE UPDATE
ON izdavanje FOR EACH ROW
BEGIN 
	IF (NEW.vracena <> OLD.vracena AND NEW.vracena = 1) THEN
		UPDATE knjiga
		SET broj_dostupnih = broj_dostupnih + 1
		WHERE id = NEW.knjiga_id;
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `knjiga`
--

DROP TABLE IF EXISTS `knjiga`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knjiga` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `naslov` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `autor` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `broj_dostupnih` smallint(5) unsigned NOT NULL DEFAULT 0,
  `dodato` datetime NOT NULL DEFAULT current_timestamp(),
  `isbn` varchar(17) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `izdavac` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ocena` tinyint(3) unsigned DEFAULT NULL,
  `slika` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `knjige_ime_IDX` (`naslov`) USING BTREE,
  KEY `knjige_autor_IDX` (`autor`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knjiga`
--

LOCK TABLES `knjiga` WRITE;
/*!40000 ALTER TABLE `knjiga` DISABLE KEYS */;
INSERT INTO `knjiga` VALUES (1,'Gospodar Prstenova','J. R. R. Tolkien',4,'2020-06-13 01:06:47','797',NULL,NULL,NULL),(2,'Harry Potter','J. K. Rowling',4,'2020-06-14 23:25:49','321',NULL,NULL,NULL);
/*!40000 ALTER TABLE `knjiga` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `korisnik`
--

DROP TABLE IF EXISTS `korisnik`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `korisnik` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `lozinka` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bibliotekar` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `clan_od` datetime NOT NULL DEFAULT current_timestamp(),
  `aktivan` smallint(5) unsigned NOT NULL DEFAULT 0,
  `ime` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prezime` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kontakt` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `korisnik`
--

LOCK TABLES `korisnik` WRITE;
/*!40000 ALTER TABLE `korisnik` DISABLE KEYS */;
INSERT INTO `korisnik` VALUES (2,'pbkdf2:sha256:150000$fAIBoFPK$8a4496afd6835255cfe85227cc7a6ef4a70d5152e9eb941a1b16effcc5010e42',1,'2020-06-09 23:33:35',1,'Marijana','Stanisavljevic','bibliotekar1@mail.com','018-000-5556'),(4,'pbkdf2:sha256:150000$CByK0Mfk$a9b0fa62f0a9d3973531b31628c7128479e8a074c2f00ead8a98fd4c777689d2',0,'2020-06-09 23:46:19',360,'Ana','Antic','korisnik1@mail.com','060005006');
/*!40000 ALTER TABLE `korisnik` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uplatnica`
--

DROP TABLE IF EXISTS `uplatnica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uplatnica` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `korisnik_id` mediumint(8) unsigned DEFAULT NULL,
  `naziv_fajla` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `datum` date NOT NULL DEFAULT curdate(),
  `kolicina` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `uplatnice_FK` (`korisnik_id`),
  CONSTRAINT `uplatnice_FK` FOREIGN KEY (`korisnik_id`) REFERENCES `korisnik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uplatnica`
--

LOCK TABLES `uplatnica` WRITE;
/*!40000 ALTER TABLE `uplatnica` DISABLE KEYS */;
INSERT INTO `uplatnica` VALUES (1,2,'nalog_za_uplatu-321301.pdf','2020-06-12',1000),(3,2,'nalog_za_uplatu-994436.pdf','2020-06-13',500),(4,4,'nalog_za_uplatu-734500.pdf','2020-06-15',1000);
/*!40000 ALTER TABLE `uplatnica` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `dodaj_clanarinu` BEFORE UPDATE ON uplatnica FOR EACH ROW
	BEGIN
		IF (NEW.kolicina <=> OLD.kolicina) THEN
			UPDATE korisnik
			SET aktivan = aktivan + 365 * NEW.kolicina / 500
			WHERE id = NEW.korisnik_id;
		END IF;
	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `vesti`
--

DROP TABLE IF EXISTS `vesti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vesti` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `naslov` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tekst` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slika` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `datum` datetime NOT NULL DEFAULT current_timestamp(),
  `autor_id` mediumint(8) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `vesti_FK` (`autor_id`),
  CONSTRAINT `vesti_FK` FOREIGN KEY (`autor_id`) REFERENCES `korisnik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vesti`
--

LOCK TABLES `vesti` WRITE;
/*!40000 ALTER TABLE `vesti` DISABLE KEYS */;
INSERT INTO `vesti` VALUES (2,'Zemlja više nije ravna, šok slika','Ovaj, biblioteka se otvorila i kod je otvorenog tipa','cuveveveve-139611.jpg','2020-06-15 04:32:48',2);
/*!40000 ALTER TABLE `vesti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'biblioteka'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `clanarina` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = '+00:00' */ ;;
/*!50106 CREATE*/ /*!50117 */ /*!50106 EVENT `clanarina` ON SCHEDULE EVERY '0 1' DAY_HOUR STARTS '2020-06-09 23:17:02' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Uzmi clanarinu svakog dana' DO UPDATE korisnik
    SET aktivan = aktivan - 1
    WHERE aktivan > 0 */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `izdavanje` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = '+00:00' */ ;;
/*!50106 CREATE*/ /*!50117 */ /*!50106 EVENT `izdavanje` ON SCHEDULE EVERY '0 1' DAY_HOUR STARTS '2020-06-09 23:17:02' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Broj dana koje nisu knijge vracane posle roka' DO UPDATE izdavanje
    SET kasni = kasni + 1
    WHERE vracena = 0 AND CURDATE() > vracanje_rok */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'biblioteka'
--
/*!50003 DROP PROCEDURE IF EXISTS `admin_uplata` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `admin_uplata`()
BEGIN
	SELECT ime, email, uplatnica.id, naziv_fajla 
	FROM uplatnica LEFT JOIN korisnik
	ON korisnik.id = uplatnica.korisnik_id 
	WHERE kolicina IS NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `jedan_korisnik` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `jedan_korisnik`(IN korisnik mediumint(8) unsigned)
BEGIN
	SELECT izdavanje.id, autor, naslov, isbn, vracanje_rok, vracena
	FROM izdavanje LEFT JOIN knjiga
	ON knjiga.id = izdavanje.knjiga_id
	WHERE korisnik_id = korisnik
	ORDER BY vracena;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `korisnik_knjige` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `korisnik_knjige`(IN korisnik mediumint(8) unsigned)
BEGIN
	SELECT autor, naslov, isbn, vracanje_rok
	FROM izdavanje LEFT JOIN knjiga
	ON knjiga.id = izdavanje.knjiga_id
	WHERE korisnik_id = korisnik AND vracena = 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-06-15 15:37:45
