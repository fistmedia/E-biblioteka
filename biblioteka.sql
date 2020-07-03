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
  `vracena` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `izdavanje_FK` (`korisnik_id`),
  KEY `izdavanje_FK1` (`knjiga_id`),
  CONSTRAINT `izdavanje_FK` FOREIGN KEY (`korisnik_id`) REFERENCES `korisnik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `izdavanje_FK1` FOREIGN KEY (`knjiga_id`) REFERENCES `knjiga` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `izdavanje`
--

LOCK TABLES `izdavanje` WRITE;
/*!40000 ALTER TABLE `izdavanje` DISABLE KEYS */;
INSERT INTO `izdavanje` VALUES (1,1,'2020-06-20',NULL,1,0,1),(1,1,'2020-06-20',NULL,2,0,0),(1,1,'2020-06-20',NULL,3,0,0),(1,1,'2020-06-20',NULL,4,0,0),(2,1,'2020-07-03',NULL,5,0,1),(2,1,'2020-07-03',NULL,6,0,1),(2,2,'2020-07-03',NULL,7,0,1),(2,2,'2020-07-03',NULL,8,0,1),(2,1,'2020-07-03',NULL,9,0,0),(2,1,'2020-07-03',NULL,10,0,0);
/*!40000 ALTER TABLE `izdavanje` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `izdavanje` AFTER INSERT ON `izdavanje` FOR EACH ROW BEGIN 
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
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER `vracanje` BEFORE UPDATE ON `izdavanje` FOR EACH ROW BEGIN 
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
  `dodata` datetime NOT NULL DEFAULT curdate(),
  `isbn` varchar(17) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `izdavac` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ocena` tinyint(3) DEFAULT NULL,
  `slika` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `opis` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `knjige_ime_IDX` (`naslov`) USING BTREE,
  KEY `knjige_autor_IDX` (`autor`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knjiga`
--

LOCK TABLES `knjiga` WRITE;
/*!40000 ALTER TABLE `knjiga` DISABLE KEYS */;
INSERT INTO `knjiga` VALUES (1,'Harry Potter','J. K. Rowling',14,'2020-06-13 01:06:47','321321','Laguna',9,'harry.jpg','Dobrodošli u čarobni svet'),(2,'The Lord of the Rings','J. R. R. Tolkien',11,'2020-06-14 23:25:49','112621','Darkwood',NULL,'lotr.gif','Uzbudljiva priča i avantura'),(3,'Grozomora','R.L Stein',6,'2020-07-02 00:00:00','421462','Darkwood',NULL,'afwafwafw.jpg','Nije za plašljive :)'),(4,'Flask i MySQL','Filip',6,'2020-07-02 00:00:00','521214','Firma',NULL,'fwafwafwadwad.jpg','Autobiografija iskreno');
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
  `bibliotekar` tinyint(1) NOT NULL DEFAULT 0,
  `clan_od` datetime NOT NULL DEFAULT current_timestamp(),
  `aktivan` smallint(5) unsigned NOT NULL DEFAULT 0,
  `ime` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prezime` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kontakt` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `korisnik`
--

LOCK TABLES `korisnik` WRITE;
/*!40000 ALTER TABLE `korisnik` DISABLE KEYS */;
INSERT INTO `korisnik` VALUES (1,'pbkdf2:sha256:150000$fAIBoFPK$8a4496afd6835255cfe85227cc7a6ef4a70d5152e9eb941a1b16effcc5010e42',1,'2020-06-09 23:33:35',1,'Marijana','Stanisavljević','bibliotekar1@mail.com','018-000-5556'),(2,'pbkdf2:sha256:150000$CByK0Mfk$a9b0fa62f0a9d3973531b31628c7128479e8a074c2f00ead8a98fd4c777689d2',0,'2020-06-09 23:46:19',725,'Ana','Antić','korisnik1@mail.com','060005006'),(3,'pbkdf2:sha256:150000$WgpXCZTj$684cb8098e5977b89e00609a74810284592d538c4cd44bb16dd6d38eb2304a95',0,'2020-07-01 02:28:27',0,'Mitic','Mika','korisnik2@mail.com','1521521521');
/*!40000 ALTER TABLE `korisnik` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `neaktivni_korisnici`
--

DROP TABLE IF EXISTS `neaktivni_korisnici`;
/*!50001 DROP VIEW IF EXISTS `neaktivni_korisnici`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `neaktivni_korisnici` (
  `id` tinyint NOT NULL,
  `ime` tinyint NOT NULL,
  `prezime` tinyint NOT NULL,
  `email` tinyint NOT NULL,
  `kontakt` tinyint NOT NULL,
  `aktivan` tinyint NOT NULL,
  `clan_od` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `nevracene_knjige`
--

DROP TABLE IF EXISTS `nevracene_knjige`;
/*!50001 DROP VIEW IF EXISTS `nevracene_knjige`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `nevracene_knjige` (
  `korisnik_id` tinyint NOT NULL,
  `ime` tinyint NOT NULL,
  `email` tinyint NOT NULL,
  `knjiga_id` tinyint NOT NULL,
  `naslov` tinyint NOT NULL,
  `autor` tinyint NOT NULL,
  `isbn` tinyint NOT NULL,
  `izdavanje_id` tinyint NOT NULL,
  `rezerv_rok` tinyint NOT NULL,
  `vracanje_rok` tinyint NOT NULL,
  `kasni` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ocena`
--

DROP TABLE IF EXISTS `ocena`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ocena` (
  `knjiga_id` mediumint(8) unsigned NOT NULL,
  `ocena` tinyint(3) DEFAULT NULL,
  `tekst` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `korisnik_id` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`knjiga_id`,`korisnik_id`),
  KEY `ocena_FK` (`korisnik_id`),
  CONSTRAINT `ocena_FK` FOREIGN KEY (`korisnik_id`) REFERENCES `korisnik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ocena_FK_1` FOREIGN KEY (`knjiga_id`) REFERENCES `knjiga` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ocena`
--

LOCK TABLES `ocena` WRITE;
/*!40000 ALTER TABLE `ocena` DISABLE KEYS */;
INSERT INTO `ocena` VALUES (1,10,'trsita stepeni  ',1),(1,7,'Svidjalo mi se',2);
/*!40000 ALTER TABLE `ocena` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER ocenivanje
AFTER INSERT
ON ocena FOR EACH ROW
BEGIN
	DECLARE grade TINYINT;

	SELECT AVG(ocena)
	INTO grade
	FROM ocena
	WHERE knjiga_id=NEW.knjiga_id;

	UPDATE knjiga
	SET ocena = grade
	WHERE knjiga.id=NEW.knjiga_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `uplatnica`
--

DROP TABLE IF EXISTS `uplatnica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `uplatnica` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `korisnik_id` mediumint(8) unsigned DEFAULT NULL,
  `naziv_fajla` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `datum` date NOT NULL DEFAULT curdate(),
  `kolicina` smallint(5) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `uplatnice_FK` (`korisnik_id`),
  CONSTRAINT `uplatnice_FK` FOREIGN KEY (`korisnik_id`) REFERENCES `korisnik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uplatnica`
--

LOCK TABLES `uplatnica` WRITE;
/*!40000 ALTER TABLE `uplatnica` DISABLE KEYS */;
INSERT INTO `uplatnica` VALUES (1,2,'nalog_za_uplatu-925922.pdf','2020-06-19',500),(2,2,'intvq-427324.pdf','2020-07-01',0),(3,3,'intvq-159652.pdf','2020-07-01',500);
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
/*!50003 CREATE*/ /*!50017 */ /*!50003 TRIGGER dodaj_clanarinu
BEFORE UPDATE
ON uplatnica FOR EACH ROW
BEGIN
	IF (NEW.kolicina <> OLD.kolicina) THEN
		UPDATE korisnik
		SET aktivan = clanarina(NEW.kolicina)
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vesti`
--

LOCK TABLES `vesti` WRITE;
/*!40000 ALTER TABLE `vesti` DISABLE KEYS */;
INSERT INTO `vesti` VALUES (3,'Biblioteka je otvorena','Kod je otvorenog tipa, dobrodošli','spring.jpg','2020-07-03 01:57:36',1),(4,'Biblioteka je na pauzi','Nakon par nadogradnji biblioteka zarad sedmo segmentnog displaya ide u pauzu.','Common_segment_displays.svg-503417.png','2020-07-03 03:21:38',1);
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
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 */ /*!50106 EVENT `clanarina` ON SCHEDULE EVERY '0 1' DAY_HOUR STARTS '2020-06-29 02:16:43' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Uzni clanarinu svakog dana' DO UPDATE korisnik
    SET aktivan = aktivan - 1
    WHERE aktivan > 0 AND bibliotekar = 0 */ ;;
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
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 */ /*!50106 EVENT `izdavanje` ON SCHEDULE EVERY '0 1' DAY_HOUR STARTS '2020-06-29 02:16:59' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Broj dana koje nisu knijge vracane posle roka' DO UPDATE izdavanje
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
/*!50003 DROP FUNCTION IF EXISTS `clanarina` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  FUNCTION `clanarina`(kolicina SMALLINT(5) UNSIGNED) RETURNS smallint(5) unsigned
BEGIN
	DECLARE res SMALLINT(5) UNSIGNED;
	# 365 / 500
  	SET res = kolicina * 0.73;
  	RETURN res;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
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
	WHERE kolicina = 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `dodaj_ocenu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `dodaj_ocenu`(IN `kn_id` MEDIUMINT(8) UNSIGNED, IN `ko_id` MEDIUMINT(8) UNSIGNED, IN `ocena` TINYINT(3), IN `tekst` TEXT)
BEGIN
	SET tekst = REPLACE(tekst,'\n',' ');
	SET tekst = REPLACE(tekst,'\r','');
	INSERT INTO ocena (knjiga_id, korisnik_id, ocena, tekst) VALUES (kn_id, ko_id, ocena, tekst);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `izbrisi_knjigu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `izbrisi_knjigu`(IN `k_id` MEDIUMINT(8) UNSIGNED)
BEGIN
	DELETE FROM knjiga WHERE id = k_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `izbrisi_ocenu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `izbrisi_ocenu`(IN `kn_id` MEDIUMINT(8) UNSIGNED, IN `ko_id` MEDIUMINT(8) UNSIGNED)
BEGIN
	DELETE FROM ocena WHERE knjiga_id = kn_id AND korisnik_id = ko_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `izbrisi_vest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `izbrisi_vest`(IN `v_id` MEDIUMINT(8) UNSIGNED)
BEGIN
	DELETE FROM vesti WHERE id = v_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `izdavanje` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `izdavanje`(IN `korisnik` MEDIUMINT(8) UNSIGNED, IN `knjiga` MEDIUMINT(8) UNSIGNED)
BEGIN
	INSERT INTO
	izdavanje (korisnik_id, knjiga_id)
	VALUES (korisnik, knjiga);
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
CREATE  PROCEDURE `jedan_korisnik`(IN `korisnik` MEDIUMINT(8) UNSIGNED)
BEGIN
	SELECT izdavanje.id, knjiga.id, autor, naslov, isbn, rezerv_rok, vracanje_rok, kasni, vracena
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
/*!50003 DROP PROCEDURE IF EXISTS `knjiga_izmena` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `knjiga_izmena`(IN `k_id` MEDIUMINT(8) UNSIGNED, IN `autor` VARCHAR(25), IN `naslov` VARCHAR(30), IN `isbn` VARCHAR(17), IN `br_dostupnih` SMALLINT(5) UNSIGNED, IN `izdavac` VARCHAR(25), IN `opis` TEXT, IN `slika` VARCHAR(50))
BEGIN
	IF (slika = '') THEN
		UPDATE knjiga
		SET autor = autor, naslov = naslov, isbn = isbn, broj_dostupnih = br_dostupnih, izdavac = izdavac, opis = opis
	    WHERE id = k_id;
    ELSE
		UPDATE knjiga
		SET autor = autor, naslov = naslov, isbn = isbn, broj_dostupnih = br_dostupnih, izdavac = izdavac, opis = opis, slika = slika
	    WHERE id = k_id;
	END IF;
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
CREATE  PROCEDURE `korisnik_knjige`(IN `korisnik` MEDIUMINT(8) UNSIGNED)
BEGIN
	SELECT knjiga_id AS id, autor, naslov, isbn, vracanje_rok
	FROM nevracene_knjige
	WHERE korisnik_id = korisnik;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nova_knjiga` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `nova_knjiga`(IN `naslov` VARCHAR(30), IN `autor` VARCHAR(25), IN `broj_dostupnih` SMALLINT(5) UNSIGNED, IN `isbn` VARCHAR(17), IN `izdavac` VARCHAR(25), IN `opis` TEXT, IN `slika` VARCHAR(50))
BEGIN
	INSERT INTO
    knjiga (naslov, autor, broj_dostupnih, isbn, izdavac, slika, opis)
    VALUES (naslov, autor, broj_dostupnih, isbn, izdavac, slika, opis);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `nova_vest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `nova_vest`(IN `naslov` VARCHAR(50), IN `tekst` TEXT, IN `autor_id` MEDIUMINT(8) UNSIGNED, IN `slika` VARCHAR(50))
BEGIN
	SET tekst = REPLACE(tekst,'\n',' ');
	SET tekst = REPLACE(tekst,'\r','');
	IF (slika = '') THEN
		INSERT INTO
		vesti (naslov, tekst, autor_id)
		VALUES (naslov, tekst, autor_id);
    ELSE
		INSERT INTO
	    vesti (naslov, tekst, autor_id, slika)
	    VALUES (naslov, tekst, autor_id, slika);
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `obrisi_korisnika` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `obrisi_korisnika`(IN `k_id` MEDIUMINT(8) UNSIGNED)
BEGIN
	DELETE FROM korisnik WHERE id = k_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `registracija` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `registracija`(IN `ime` VARCHAR(15), IN `prezime` VARCHAR(15), IN `email` VARCHAR(30), IN `kontakt` VARCHAR(15), IN `lozinka` VARCHAR(100))
BEGIN
	INSERT INTO
    korisnik (ime, prezime, email, kontakt, lozinka)
    VALUES (ime, prezime, email, kontakt, lozinka);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_uplatnica` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `update_uplatnica`(IN `kolicina` SMALLINT(5) UNSIGNED, IN `id` MEDIUMINT(8) UNSIGNED)
BEGIN
	UPDATE uplatnica SET kolicina = kolicina WHERE id = id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `uplata` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `uplata`(IN `korisnik` MEDIUMINT(5) UNSIGNED, IN `naziv_fajla` VARCHAR(30))
BEGIN
	INSERT INTO uplatnica (korisnik_id, naziv_fajla) VALUES (korisnik, naziv_fajla);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `vest_izmena` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `vest_izmena`(IN `v_id` MEDIUMINT(8) UNSIGNED, IN `naslov` VARCHAR(50), IN `tekst` TEXT, IN `slika` VARCHAR(50))
BEGIN
	SET tekst = REPLACE(tekst,'\n',' ');
	SET tekst = REPLACE(tekst,'\r','');
	IF (slika = '') THEN
		UPDATE vesti
		SET naslov = naslov, tekst = tekst
	    WHERE id = v_id;
    ELSE
		UPDATE vesti
		SET naslov = naslov, tekst = tekst, slika = slika
	    WHERE id = v_id;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `vrati_knjigu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE  PROCEDURE `vrati_knjigu`(IN `i_id` MEDIUMINT(8) UNSIGNED)
BEGIN
	UPDATE izdavanje SET vracena = 1 WHERE id = i_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `neaktivni_korisnici`
--

/*!50001 DROP TABLE IF EXISTS `neaktivni_korisnici`*/;
/*!50001 DROP VIEW IF EXISTS `neaktivni_korisnici`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `neaktivni_korisnici` AS select `korisnik`.`id` AS `id`,`korisnik`.`ime` AS `ime`,`korisnik`.`prezime` AS `prezime`,`korisnik`.`email` AS `email`,`korisnik`.`kontakt` AS `kontakt`,`korisnik`.`aktivan` AS `aktivan`,`korisnik`.`clan_od` AS `clan_od` from `korisnik` where `korisnik`.`aktivan` = 0 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `nevracene_knjige`
--

/*!50001 DROP TABLE IF EXISTS `nevracene_knjige`*/;
/*!50001 DROP VIEW IF EXISTS `nevracene_knjige`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013  SQL SECURITY DEFINER */
/*!50001 VIEW `nevracene_knjige` AS select `korisnik`.`id` AS `korisnik_id`,`korisnik`.`ime` AS `ime`,`korisnik`.`email` AS `email`,`knjiga`.`id` AS `knjiga_id`,`knjiga`.`naslov` AS `naslov`,`knjiga`.`autor` AS `autor`,`knjiga`.`isbn` AS `isbn`,`izdavanje`.`id` AS `izdavanje_id`,`izdavanje`.`rezerv_rok` AS `rezerv_rok`,`izdavanje`.`vracanje_rok` AS `vracanje_rok`,`izdavanje`.`kasni` AS `kasni` from ((`izdavanje` left join `knjiga` on(`knjiga`.`id` = `izdavanje`.`knjiga_id`)) left join `korisnik` on(`izdavanje`.`korisnik_id` = `korisnik`.`id`)) where `izdavanje`.`vracena` = 0 */;
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

-- Dump completed on 2020-07-03  3:23:17
