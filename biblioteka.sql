-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 10, 2020 at 05:35 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.2.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `biblioteka`
--

-- --------------------------------------------------------

--
-- Table structure for table `izdavanje`
--

CREATE TABLE `izdavanje` (
  `korisnik_id` mediumint(8) UNSIGNED DEFAULT NULL,
  `knjiga_id` mediumint(8) UNSIGNED DEFAULT NULL,
  `rezerv_rok` date DEFAULT current_timestamp(),
  `vracanje_rok` date DEFAULT NULL,
  `id` int(10) UNSIGNED NOT NULL,
  `kasni` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `vracena` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `knjiga`
--

CREATE TABLE `knjiga` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `naslov` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `autor` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `broj_dostupnih` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `dodato` datetime NOT NULL DEFAULT current_timestamp(),
  `isbn` varchar(17) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `korisnik`
--

CREATE TABLE `korisnik` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `lozinka` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bibliotekar` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `clan_od` datetime NOT NULL DEFAULT current_timestamp(),
  `aktivan` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `ime` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `prezime` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kontakt` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `korisnik`
--

INSERT INTO `korisnik` (`id`, `lozinka`, `bibliotekar`, `clan_od`, `aktivan`, `ime`, `prezime`, `email`, `kontakt`) VALUES
(2, 'pbkdf2:sha256:150000$fAIBoFPK$8a4496afd6835255cfe85227cc7a6ef4a70d5152e9eb941a1b16effcc5010e42', 1, '2020-06-09 23:33:35', 1, 'Marijana', 'Stanisavljevic', 'bibliotekar1@mail.com', '018-000-5556'),
(4, 'pbkdf2:sha256:150000$CByK0Mfk$a9b0fa62f0a9d3973531b31628c7128479e8a074c2f00ead8a98fd4c777689d2', 0, '2020-06-09 23:46:19', 0, 'Ana', 'Antic', 'korisnik1@mail.com', '060005006');

-- --------------------------------------------------------

--
-- Table structure for table `uplatnica`
--

CREATE TABLE `uplatnica` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `korisnik_id` mediumint(8) UNSIGNED DEFAULT NULL,
  `naziv_fajla` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `datum` date NOT NULL DEFAULT current_timestamp(),
  `kolicina` smallint(5) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `uplatnica`
--
DELIMITER $$
CREATE TRIGGER `dodaj_clanarinu` AFTER INSERT ON `uplatnica` FOR EACH ROW BEGIN
		UPDATE korisnik
		SET aktivan = aktivan + 365 * NEW.kolicina / 500
		WHERE id = NEW.korisnik_id;
	END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `vesti`
--

CREATE TABLE `vesti` (
  `id` mediumint(8) UNSIGNED NOT NULL,
  `naslov` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tekst` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `slika` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `datum` datetime NOT NULL DEFAULT current_timestamp(),
  `autor_id` mediumint(8) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `izdavanje`
--
ALTER TABLE `izdavanje`
  ADD PRIMARY KEY (`id`),
  ADD KEY `izdavanje_FK` (`korisnik_id`),
  ADD KEY `izdavanje_FK1` (`knjiga_id`);

--
-- Indexes for table `knjiga`
--
ALTER TABLE `knjiga`
  ADD PRIMARY KEY (`id`),
  ADD KEY `knjige_ime_IDX` (`naslov`) USING BTREE,
  ADD KEY `knjige_autor_IDX` (`autor`) USING BTREE;

--
-- Indexes for table `korisnik`
--
ALTER TABLE `korisnik`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `uplatnica`
--
ALTER TABLE `uplatnica`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uplatnice_FK` (`korisnik_id`);

--
-- Indexes for table `vesti`
--
ALTER TABLE `vesti`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vesti_FK` (`autor_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `izdavanje`
--
ALTER TABLE `izdavanje`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `knjiga`
--
ALTER TABLE `knjiga`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `korisnik`
--
ALTER TABLE `korisnik`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `uplatnica`
--
ALTER TABLE `uplatnica`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vesti`
--
ALTER TABLE `vesti`
  MODIFY `id` mediumint(8) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `izdavanje`
--
ALTER TABLE `izdavanje`
  ADD CONSTRAINT `izdavanje_FK` FOREIGN KEY (`korisnik_id`) REFERENCES `korisnik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `izdavanje_FK1` FOREIGN KEY (`knjiga_id`) REFERENCES `knjiga` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `uplatnica`
--
ALTER TABLE `uplatnica`
  ADD CONSTRAINT `uplatnice_FK` FOREIGN KEY (`korisnik_id`) REFERENCES `korisnik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `vesti`
--
ALTER TABLE `vesti`
  ADD CONSTRAINT `vesti_FK` FOREIGN KEY (`autor_id`) REFERENCES `korisnik` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `clanarina` ON SCHEDULE EVERY '0 1' DAY_HOUR STARTS '2020-06-09 23:17:02' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Uzmi clanarinu svakog dana' DO UPDATE korisnik
    SET aktivan = aktivan - 1
    WHERE aktivan > 0$$

CREATE DEFINER=`root`@`localhost` EVENT `izdavanje` ON SCHEDULE EVERY '0 1' DAY_HOUR STARTS '2020-06-09 23:17:02' ON COMPLETION NOT PRESERVE ENABLE COMMENT 'Broj dana koje nisu knijge vracane posle roka' DO UPDATE izdavanje
    SET kasni = kasni + 1
    WHERE vracena = 0 AND CURDATE() > vracanje_rok$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
