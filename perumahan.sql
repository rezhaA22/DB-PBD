-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 23, 2024 at 01:30 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `perumahan`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAvailableHousesSummary` ()   BEGIN
    DECLARE total_price DECIMAL(10,2);
    DECLARE house_count INT;

    -- Menghitung jumlah rumah yang tersedia
    SELECT COUNT(*) INTO house_count
    FROM houses
    WHERE status = 'available';

    -- Menghitung total harga rumah yang tersedia
    SELECT SUM(price) INTO total_price
    FROM houses
    WHERE status = 'available';

    -- Memeriksa apakah ada rumah yang tersedia
    IF house_count > 0 THEN
        SELECT house_count AS AvailableHouses, total_price AS TotalPrice;
    ELSE
        SELECT 'Tidak ada rumah yang tersedia.' AS Message;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetHousesByComplexAndPrice` (IN `p_complex_id` INT, IN `p_min_price` DECIMAL(10,2))   BEGIN
    DECLARE house_count INT;

    -- Menghitung jumlah rumah yang memenuhi kriteria
    SELECT COUNT(*) INTO house_count
    FROM houses
    WHERE complex_id = p_complex_id
    AND price > p_min_price;

    -- Menampilkan rumah yang memenuhi kriteria atau pesan jika tidak ada
    IF house_count > 0 THEN
        SELECT house_id, house_number, price, size, description
        FROM houses
        WHERE complex_id = p_complex_id
        AND price > p_min_price;
    ELSE
        SELECT 'Tidak ada rumah yang memenuhi kriteria.' AS Message;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_all_users` ()   BEGIN
    SELECT * FROM users;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_house_status` (`houseId` INT, `newStatus` ENUM('available','sold'))   BEGIN
    IF newStatus = 'sold' THEN
        UPDATE houses SET status = newStatus, units_available = 0 WHERE house_id = houseId;
    ELSE
        UPDATE houses SET status = newStatus WHERE house_id = houseId;
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_house_price` (`houseId` INT, `discount` DECIMAL(5,2)) RETURNS DECIMAL(15,2)  BEGIN
    DECLARE price DECIMAL(15,2);
    SELECT price - (price * discount / 100) INTO price FROM houses WHERE house_id = houseId;
    RETURN price;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `HargaKompleks` (`p_complex_id` INT, `p_status` VARCHAR(20)) RETURNS DECIMAL(10,2) DETERMINISTIC BEGIN
    DECLARE avg_price DECIMAL(10,2);

    SELECT AVG(price) INTO avg_price
    FROM houses
    WHERE complex_id = p_complex_id
    AND status = p_status;

    RETURN avg_price;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `TotalRumahTersedia` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM houses
    WHERE status = 'available';

    RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_houses` () RETURNS INT(11)  BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM houses;
    RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin_housing_complexes`
--

CREATE TABLE `admin_housing_complexes` (
  `admin_housing_id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `complex_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_housing_complexes`
--

INSERT INTO `admin_housing_complexes` (`admin_housing_id`, `admin_id`, `complex_id`) VALUES
(2, 17, 44),
(3, 17, 44),
(4, 1, 43),
(5, 18, 43),
(111, 18, 43);

-- --------------------------------------------------------

--
-- Table structure for table `admin_logs`
--

CREATE TABLE `admin_logs` (
  `log_id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `action_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_logs`
--

INSERT INTO `admin_logs` (`log_id`, `admin_id`, `action`, `description`, `action_date`) VALUES
(1, 1, 'CREATE', 'Created housing complex with ID 14', '2024-05-29 10:55:59'),
(2, 1, 'CREATE', 'Created housing complex with ID 15', '2024-05-29 10:56:05'),
(3, 1, 'CREATE', 'Created housing complex with ID 16', '2024-05-29 10:56:06'),
(4, 1, 'CREATE', 'Created housing complex with ID 17', '2024-05-29 11:02:59'),
(5, 1, 'CREATE', 'Created housing complex with ID 18', '2024-05-29 11:04:50'),
(6, 1, 'CREATE', 'Created housing complex with ID 19', '2024-05-29 11:04:51'),
(7, 1, 'CREATE', 'Created housing complex with ID 20', '2024-05-29 11:04:53'),
(8, 1, 'CREATE', 'Created housing complex with ID 21', '2024-05-29 11:04:55'),
(9, 1, 'UPDATE', 'Updated housing complex with ID 19', '2024-05-29 11:07:13'),
(10, 1, 'UPDATE', 'Updated housing complex with ID 20', '2024-05-29 11:07:23'),
(11, 1, 'DELETE', 'Deleted housing complex with ID 21', '2024-05-29 11:16:20'),
(12, 1, 'CREATE', 'Created housing complex with ID 23', '2024-05-29 11:30:17'),
(13, 1, 'CREATE', 'Created housing complex with ID 24', '2024-05-29 11:36:25'),
(14, 1, 'CREATE', 'Created housing complex with ID 25', '2024-05-29 11:36:27'),
(15, 1, 'DELETE', 'Deleted housing complex with ID 24', '2024-05-29 11:37:13'),
(16, 1, 'UPDATE', 'Updated housing complex with ID 25', '2024-05-29 11:39:50'),
(17, 1, 'UPDATE', 'Updated housing complex with ID 25', '2024-05-29 11:39:53'),
(18, 1, 'UPDATE', 'Updated housing complex with ID 25', '2024-05-29 11:39:54'),
(19, 1, 'UPDATE', 'Updated housing complex with ID 22', '2024-05-29 12:20:28'),
(20, 1, 'UPDATE', 'Updated housing complex with ID 23', '2024-05-29 12:20:31'),
(21, 1, 'DELETE', 'Deleted housing complex with ID 22', '2024-05-29 12:20:37'),
(22, 1, 'DELETE', 'Deleted housing complex with ID 23', '2024-05-29 12:20:40'),
(23, 1, 'DELETE', 'Deleted housing complex with ID 25', '2024-05-29 12:20:43'),
(24, 1, 'CREATE', 'Created housing complex with ID 26', '2024-05-29 12:49:44'),
(25, 1, 'UPDATE', 'Updated housing complex with ID 26', '2024-05-29 12:50:24'),
(26, 1, 'DELETE', 'Deleted housing complex with ID 26', '2024-05-29 12:51:03'),
(27, 1, 'CREATE', 'Created housing complex with ID 27', '2024-05-29 15:16:58'),
(28, 1, 'CREATE', 'Created housing complex with ID 28', '2024-05-29 15:17:07'),
(29, 1, 'CREATE', 'Created housing complex with ID 29', '2024-05-29 15:17:08'),
(30, 1, 'CREATE', 'Created housing complex with ID 30', '2024-05-29 15:30:45'),
(31, 1, 'CREATE', 'Created housing complex with ID 31', '2024-05-29 15:30:46'),
(32, 1, 'CREATE', 'Created housing complex with ID 32', '2024-05-29 15:39:43'),
(33, 1, 'CREATE', 'Created housing complex with ID 33', '2024-05-29 15:39:45'),
(34, 1, 'CREATE', 'Created housing complex with ID 34', '2024-05-29 15:39:46'),
(35, 1, 'CREATE', 'Created housing complex with ID 35', '2024-05-30 03:28:31'),
(36, 1, 'CREATE', 'Created housing complex with ID 36', '2024-05-30 03:28:38'),
(37, 1, 'CREATE', 'Created housing complex with ID 37', '2024-05-30 03:28:46'),
(38, 1, 'CREATE', 'Created housing complex with ID 38', '2024-05-30 03:28:48'),
(39, 1, 'CREATE', 'Created housing complex with ID 39', '2024-05-30 03:45:10'),
(40, 1, 'DELETE', 'Deleted housing complex with ID 27', '2024-05-30 03:45:33'),
(41, 1, 'DELETE', 'Deleted housing complex with ID 28', '2024-05-30 03:45:36'),
(42, 1, 'DELETE', 'Deleted housing complex with ID 29', '2024-05-30 03:45:39'),
(43, 1, 'DELETE', 'Deleted housing complex with ID 30', '2024-05-30 03:45:45'),
(44, 1, 'DELETE', 'Deleted housing complex with ID 31', '2024-05-30 03:45:48'),
(45, 1, 'CREATE', 'Created housing complex with ID 40', '2024-05-30 03:47:48'),
(46, 1, 'DELETE', 'Deleted housing complex with ID 34', '2024-05-30 03:48:04'),
(47, 1, 'DELETE', 'Deleted housing complex with ID 35', '2024-05-30 03:48:07'),
(48, 1, 'DELETE', 'Deleted housing complex with ID 36', '2024-05-30 03:48:09'),
(49, 1, 'DELETE', 'Deleted housing complex with ID 37', '2024-05-30 03:48:13'),
(50, 1, 'DELETE', 'Deleted housing complex with ID 38', '2024-05-30 03:48:16'),
(51, 1, 'DELETE', 'Deleted housing complex with ID 39', '2024-05-30 03:48:19'),
(52, 1, 'DELETE', 'Deleted housing complex with ID 40', '2024-05-30 03:48:24'),
(53, 1, 'CREATE', 'Created housing complex with ID 41', '2024-05-30 03:53:33'),
(54, 1, 'CREATE', 'Created housing complex with ID 42', '2024-05-31 04:35:28'),
(55, 1, 'CREATE', 'Created housing complex with ID 43', '2024-05-31 04:35:33'),
(56, 1, 'CREATE', 'Created housing complex with ID 44', '2024-05-31 04:46:53'),
(60, 1, 'CREATE', 'Created housing complex with ID 48', '2024-05-31 07:12:56'),
(61, 1, 'DELETE', 'Deleted housing complex with ID 42', '2024-05-31 07:13:00'),
(62, 1, 'UPDATE', 'Updated housing complex with ID 43', '2024-05-31 07:13:08'),
(63, 1, 'CREATE', 'Created sale with ID 4', '2024-06-13 13:48:09'),
(64, 1, 'CREATE', 'Created sale with ID 5', '2024-06-13 13:48:20'),
(65, 1, 'CREATE', 'Created sale with ID 6', '2024-06-13 13:49:56'),
(66, 1, 'CREATE', 'Created sale with ID 7', '2024-06-13 13:50:14'),
(67, 1, 'CREATE', 'Created sale with ID 8', '2024-06-13 13:51:00'),
(68, 1, 'CREATE', 'Created sale with ID 9', '2024-06-13 13:52:08'),
(69, 1, 'CREATE', 'Created sale with ID 10', '2024-06-13 13:52:09'),
(70, 1, 'CREATE', 'Created sale with ID 11', '2024-06-13 13:53:57'),
(71, 1, 'CREATE', 'Created sale with ID 12', '2024-06-13 13:55:38'),
(72, 1, 'CREATE', 'Created sale with ID 13', '2024-06-13 13:55:48'),
(73, 1, 'CREATE', 'Created sale with ID 14', '2024-06-13 13:55:49'),
(74, 1, 'CREATE', 'Created sale with ID 15', '2024-06-13 13:55:50'),
(75, 1, 'CREATE', 'Created sale with ID 16', '2024-06-13 13:55:50'),
(76, 1, 'CREATE', 'Created sale with ID 17', '2024-06-13 13:55:51'),
(77, 1, 'CREATE', 'Created sale with ID 18', '2024-06-13 14:04:24'),
(78, 1, 'CREATE', 'Created sale with ID 19', '2024-06-13 14:26:07'),
(79, 1, 'CREATE', 'Created sale with ID 20', '2024-06-13 14:26:17'),
(80, 1, 'CREATE', 'Created sale with ID 21', '2024-06-13 14:26:19'),
(81, 1, 'CREATE', 'Created sale with ID 22', '2024-06-13 14:26:19'),
(82, 1, 'CREATE', 'Created sale with ID 23', '2024-06-13 14:26:19'),
(83, 1, 'CREATE', 'Created sale with ID 24', '2024-06-13 14:26:19'),
(84, 1, 'CREATE', 'Created sale with ID 25', '2024-06-13 14:26:20'),
(85, 1, 'CREATE', 'Created sale with ID 26', '2024-06-13 14:26:20'),
(86, 1, 'CREATE', 'Created sale with ID 27', '2024-06-13 14:26:20'),
(87, 1, 'CREATE', 'Created sale with ID 28', '2024-06-13 14:26:21'),
(88, 1, 'CREATE', 'Created sale with ID 29', '2024-06-13 14:26:24'),
(89, 1, 'CREATE', 'Created sale with ID 30', '2024-06-13 14:26:24'),
(90, 1, 'CREATE', 'Created sale with ID 31', '2024-06-13 14:26:25'),
(91, 1, 'CREATE', 'Created sale with ID 32', '2024-06-13 14:26:25'),
(92, 1, 'CREATE', 'Created sale with ID 33', '2024-06-13 14:26:25'),
(93, 1, 'CREATE', 'Created sale with ID 34', '2024-06-13 14:26:26'),
(94, 1, 'CREATE', 'Created sale with ID 35', '2024-06-13 14:26:26'),
(95, 1, 'CREATE', 'Created sale with ID 36', '2024-06-13 14:26:26'),
(96, 1, 'CREATE', 'Created sale with ID 37', '2024-06-13 14:26:26'),
(97, 1, 'CREATE', 'Created sale with ID 38', '2024-06-13 14:26:27'),
(98, 1, 'CREATE', 'Created sale with ID 39', '2024-06-13 14:26:35'),
(99, 1, 'UPDATE', 'Updated sale with ID 39', '2024-06-13 14:35:07'),
(100, 1, 'DELETE', 'Deleted sale with ID 38', '2024-06-13 14:36:32'),
(101, 1, 'DELETE', 'Deleted sale with ID 37', '2024-06-13 14:43:21'),
(102, 1, 'DELETE', 'Deleted sale with ID 36', '2024-06-13 14:44:28'),
(103, 1, 'DELETE', 'Deleted sale with ID 35', '2024-06-13 14:44:41'),
(104, 1, 'UPDATE', 'Updated sale with ID 34', '2024-06-13 14:44:54'),
(105, 1, 'CREATE', 'Created sale with ID 40', '2024-06-13 14:45:47'),
(106, 1, 'CREATE', 'Created sale with ID 41', '2024-06-13 14:45:50'),
(107, 1, 'UPDATE', 'Updated sale with ID 33', '2024-06-13 14:45:59'),
(108, 1, 'UPDATE', 'Updated sale with ID 32', '2024-06-13 14:46:03'),
(109, 1, 'UPDATE', 'Updated sale with ID 31', '2024-06-13 14:46:08'),
(110, 1, 'DELETE', 'Deleted sale with ID 32', '2024-06-13 14:46:36'),
(111, 1, 'DELETE', 'Deleted sale with ID 33', '2024-06-13 14:46:39'),
(112, 1, 'CREATE', 'Created sale with ID 42', '2024-06-13 14:46:50'),
(113, 1, 'CREATE', 'Created sale with ID 43', '2024-06-14 08:10:32'),
(114, 1, 'DELETE', 'Deleted sale with ID 40', '2024-06-14 08:11:01'),
(115, 1, 'DELETE', 'Deleted sale with ID 41', '2024-06-14 08:11:05'),
(116, 1, 'DELETE', 'Deleted sale with ID 42', '2024-06-14 08:11:08'),
(117, 1, 'DELETE', 'Deleted sale with ID 43', '2024-06-14 08:11:10'),
(118, 1, 'DELETE', 'Deleted sale with ID 30', '2024-06-14 08:11:22'),
(119, 1, 'CREATE', 'Created sale with ID 44', '2024-06-14 08:11:58'),
(120, 1, 'CREATE', 'Created sale with ID 45', '2024-06-14 08:19:15'),
(121, 1, 'CREATE', 'Created sale with ID 46', '2024-06-14 08:36:45'),
(122, 1, 'CREATE', 'Created sale with ID 47', '2024-06-14 09:18:30'),
(123, 1, 'CREATE', 'Created sale with ID 48', '2024-06-14 09:41:22'),
(124, 1, 'DELETE', 'Deleted sale with ID 31', '2024-06-15 04:31:37'),
(125, 1, 'CREATE', 'Created sale with ID 49', '2024-06-15 04:32:23'),
(126, 1, 'CREATE', 'Created housing complex with ID 49', '2024-06-15 04:36:55'),
(127, 1, 'UPDATE', 'Updated housing complex with ID 49', '2024-06-15 04:37:39'),
(128, 1, 'DELETE', 'Deleted housing complex with ID 49', '2024-06-15 04:38:10'),
(129, 1, 'DELETE', 'Deleted housing complex with ID 48', '2024-06-15 04:38:18'),
(130, 1, 'DELETE', 'Deleted housing complex with ID 47', '2024-06-15 04:38:26'),
(131, 1, 'DELETE', 'Deleted housing complex with ID 46', '2024-06-15 04:38:29'),
(132, 1, 'DELETE', 'Deleted housing complex with ID 45', '2024-06-15 04:38:32'),
(133, 1, 'DELETE', 'Deleted sale with ID 1', '2024-06-15 04:56:28'),
(134, 1, 'DELETE', 'Deleted sale with ID 2', '2024-06-15 04:56:30'),
(135, 1, 'DELETE', 'Deleted sale with ID 3', '2024-06-15 04:56:32'),
(136, 1, 'DELETE', 'Deleted sale with ID 4', '2024-06-15 04:56:34'),
(137, 1, 'DELETE', 'Deleted sale with ID 5', '2024-06-15 04:56:37'),
(138, 1, 'CREATE', 'Created sale with ID 50', '2024-06-15 04:57:48'),
(139, 1, 'CREATE', 'Created sale with ID 51', '2024-06-15 04:57:55'),
(140, 1, 'CREATE', 'Created sale with ID 52', '2024-06-15 04:58:00'),
(141, 1, 'CREATE', 'Created sale with ID 53', '2024-06-15 05:03:04'),
(142, 1, 'CREATE', 'Created sale with ID 54', '2024-06-15 05:03:24'),
(143, 1, 'CREATE', 'Created admin housing complex entry with ID 9', '2024-06-21 05:53:29'),
(144, 1, 'UPDATE', 'Updated admin housing complex entry with ID 8', '2024-06-21 05:54:56'),
(145, 1, 'DELETE', 'Deleted admin housing complex entry with ID 9', '2024-06-21 05:55:06'),
(146, 1, 'DELETE', 'Deleted admin housing complex entry with ID 8', '2024-06-21 05:55:08'),
(147, 1, 'DELETE', 'Deleted admin housing complex entry with ID 7', '2024-06-21 05:55:11'),
(148, 1, 'DELETE', 'Deleted admin housing complex entry with ID 6', '2024-06-21 05:55:13'),
(149, 1, 'DELETE', 'Deleted admin housing complex entry with ID 5', '2024-06-21 05:55:15'),
(150, 1, 'DELETE', 'Deleted admin housing complex entry with ID 4', '2024-06-21 05:55:17'),
(151, 1, 'CREATE', 'Created admin housing complex entry with ID 10', '2024-06-23 09:11:22'),
(152, 1, 'DELETE', 'Deleted admin housing complex entry with ID 10', '2024-06-23 09:11:46'),
(153, 1, 'CREATE', 'Created admin housing complex entry with ID 13', '2024-06-24 12:28:03'),
(154, 1, 'CREATE', 'Created admin housing complex entry with ID 14', '2024-06-24 12:51:33'),
(155, 1, 'DELETE', 'Deleted admin housing complex entry with ID 14', '2024-06-24 13:32:59'),
(156, 1, 'CREATE', 'Created admin housing complex entry with ID 15', '2024-06-24 13:37:54'),
(157, 1, 'DELETE', 'Deleted admin housing complex entry with ID 15', '2024-06-24 13:38:01'),
(158, 1, 'DELETE', 'Deleted admin housing complex entry with ID 13', '2024-06-24 13:38:16'),
(159, 1, 'DELETE', 'Deleted review with ID 3', '2024-06-24 14:47:21'),
(160, 1, 'UPDATE', 'Updated admin housing complex entry with ID 3', '2024-06-25 03:09:06'),
(161, 1, 'UPDATE', 'Updated admin housing complex entry with ID 3', '2024-06-25 03:14:21'),
(162, 1, 'UPDATE', 'Updated admin housing complex entry with ID 3', '2024-06-25 03:14:24'),
(163, 1, 'UPDATE', 'Updated admin housing complex entry with ID 3', '2024-06-25 03:14:37'),
(164, 1, 'UPDATE', 'Updated admin housing complex entry with ID 3', '2024-06-25 03:14:39'),
(165, 1, 'UPDATE', 'Updated admin housing complex entry with ID 3', '2024-06-25 03:14:53'),
(166, 1, 'UPDATE', 'Updated admin housing complex entry with ID 3', '2024-06-25 03:14:59'),
(167, 1, 'CREATE', 'Created admin housing complex entry with ID 16', '2024-06-25 03:17:09'),
(168, 1, 'DELETE', 'Deleted admin housing complex entry with ID 16', '2024-06-25 03:17:30'),
(169, 1, 'CREATE', 'Created admin housing complex entry with ID 17', '2024-06-25 03:23:43'),
(170, 1, 'DELETE', 'Deleted admin housing complex entry with ID 17', '2024-06-25 03:24:06'),
(171, 1, 'CREATE', 'Created admin housing complex entry with ID 18', '2024-06-25 03:26:44'),
(172, 1, 'DELETE', 'Deleted admin housing complex entry with ID 3', '2024-06-25 03:32:40'),
(173, 1, 'UPDATE', 'Updated admin housing complex entry with ID 18', '2024-06-25 03:32:58'),
(174, 1, 'CREATE', 'Created admin housing complex entry with ID 19', '2024-06-25 03:33:21'),
(175, 1, 'DELETE', 'Deleted admin housing complex entry with ID 19', '2024-06-25 03:33:53'),
(176, 1, 'CREATE', 'Created admin housing complex entry with ID 20', '2024-06-25 03:34:57'),
(177, 1, 'DELETE', 'Deleted admin housing complex entry with ID 20', '2024-06-25 03:35:05'),
(178, 1, 'CREATE', 'Created admin housing complex entry with ID 21', '2024-06-25 03:36:09'),
(179, 1, 'DELETE', 'Deleted admin housing complex entry with ID 18', '2024-06-25 03:36:21'),
(180, 1, 'CREATE', 'Created admin housing complex entry with ID 22', '2024-06-25 03:37:42'),
(181, 1, 'UPDATE', 'Updated admin housing complex entry with ID 21', '2024-06-25 03:37:53'),
(182, 1, 'UPDATE', 'Updated admin housing complex entry with ID 21', '2024-06-25 03:37:57'),
(183, 1, 'DELETE', 'Deleted admin housing complex entry with ID 22', '2024-06-25 03:38:11'),
(184, 1, 'CREATE', 'Created admin housing complex entry with ID 23', '2024-06-25 03:40:29'),
(185, 1, 'DELETE', 'Deleted admin housing complex entry with ID 23', '2024-06-25 03:40:52'),
(186, 1, 'CREATE', 'Created admin housing complex entry with ID 24', '2024-06-25 03:44:21'),
(187, 1, 'DELETE', 'Deleted admin housing complex entry with ID 24', '2024-06-25 03:44:38'),
(188, 1, 'CREATE', 'Created admin housing complex entry with ID 25', '2024-06-25 03:50:56'),
(189, 1, 'CREATE', 'Created admin housing complex entry with ID 26', '2024-06-25 03:50:58'),
(190, 1, 'CREATE', 'Created admin housing complex entry with ID 27', '2024-06-25 03:51:00'),
(191, 1, 'CREATE', 'Created admin housing complex entry with ID 28', '2024-06-25 03:51:02'),
(192, 1, 'CREATE', 'Created admin housing complex entry with ID 29', '2024-06-25 03:51:03'),
(193, 1, 'CREATE', 'Created admin housing complex entry with ID 30', '2024-06-25 03:51:04'),
(194, 1, 'DELETE', 'Deleted admin housing complex entry with ID 30', '2024-06-25 03:51:13'),
(195, 1, 'DELETE', 'Deleted admin housing complex entry with ID 29', '2024-06-25 03:52:05'),
(196, 1, 'DELETE', 'Deleted admin housing complex entry with ID 28', '2024-06-25 03:53:25'),
(197, 1, 'DELETE', 'Deleted admin housing complex entry with ID 27', '2024-06-25 03:54:48'),
(198, 1, 'DELETE', 'Deleted admin housing complex entry with ID 26', '2024-06-25 03:56:20'),
(199, 1, 'CREATE', 'Created admin housing complex entry with ID 31', '2024-06-25 03:57:08'),
(200, 1, 'CREATE', 'Created admin housing complex entry with ID 32', '2024-06-25 03:57:10'),
(201, 1, 'CREATE', 'Created admin housing complex entry with ID 33', '2024-06-25 03:57:11'),
(202, 1, 'CREATE', 'Created admin housing complex entry with ID 34', '2024-06-25 03:57:13'),
(203, 1, 'DELETE', 'Deleted admin housing complex entry with ID 34', '2024-06-25 03:57:21'),
(204, 1, 'DELETE', 'Deleted admin housing complex entry with ID 33', '2024-06-25 04:00:05'),
(205, 1, 'DELETE', 'Deleted admin housing complex entry with ID 32', '2024-06-25 04:01:30'),
(206, 1, 'CREATE', 'Created admin housing complex entry with ID 35', '2024-06-25 04:02:38'),
(207, 1, 'CREATE', 'Created admin housing complex entry with ID 36', '2024-06-25 04:02:41'),
(208, 1, 'DELETE', 'Deleted admin housing complex entry with ID 36', '2024-06-25 04:03:01'),
(209, 1, 'DELETE', 'Deleted admin housing complex entry with ID 35', '2024-06-25 04:03:51'),
(210, 1, 'DELETE', 'Deleted admin housing complex entry with ID 31', '2024-06-25 04:03:56'),
(211, 1, 'CREATE', 'Created admin housing complex entry with ID 37', '2024-06-25 04:11:27'),
(212, 1, 'CREATE', 'Created admin housing complex entry with ID 38', '2024-06-25 04:11:29'),
(213, 1, 'CREATE', 'Created admin housing complex entry with ID 39', '2024-06-25 04:11:30'),
(214, 1, 'CREATE', 'Created admin housing complex entry with ID 40', '2024-06-25 04:11:31'),
(215, 1, 'CREATE', 'Created admin housing complex entry with ID 41', '2024-06-25 04:11:32'),
(216, 1, 'CREATE', 'Created admin housing complex entry with ID 42', '2024-06-25 04:11:32'),
(217, 1, 'CREATE', 'Created admin housing complex entry with ID 43', '2024-06-25 04:11:33'),
(218, 1, 'CREATE', 'Created admin housing complex entry with ID 44', '2024-06-25 04:11:33'),
(219, 1, 'CREATE', 'Created admin housing complex entry with ID 45', '2024-06-25 04:11:34'),
(220, 1, 'DELETE', 'Deleted admin housing complex entry with ID 45', '2024-06-25 04:11:57'),
(221, 1, 'DELETE', 'Deleted admin housing complex entry with ID 44', '2024-06-25 04:12:40'),
(222, 1, 'DELETE', 'Deleted admin housing complex entry with ID 43', '2024-06-25 04:18:56'),
(223, 1, 'DELETE', 'Deleted admin housing complex entry with ID 42', '2024-06-25 04:21:53'),
(224, 1, 'DELETE', 'Deleted admin housing complex entry with ID 25', '2024-06-25 04:22:04'),
(225, 1, 'DELETE', 'Deleted admin housing complex entry with ID 41', '2024-06-25 04:23:09'),
(226, 1, 'DELETE', 'Deleted admin housing complex entry with ID 40', '2024-06-25 04:24:03'),
(227, 1, 'DELETE', 'Deleted admin housing complex entry with ID 39', '2024-06-25 04:24:14'),
(228, 1, 'DELETE', 'Deleted admin housing complex entry with ID 38', '2024-06-25 04:25:04'),
(229, 1, 'CREATE', 'Created admin housing complex entry with ID 46', '2024-06-25 04:25:44'),
(230, 1, 'CREATE', 'Created admin housing complex entry with ID 47', '2024-06-25 04:25:46'),
(231, 1, 'CREATE', 'Created admin housing complex entry with ID 48', '2024-06-25 04:25:49'),
(232, 1, 'DELETE', 'Deleted admin housing complex entry with ID 48', '2024-06-25 04:25:55'),
(233, 1, 'DELETE', 'Deleted admin housing complex entry with ID 46', '2024-06-25 04:28:29'),
(234, 1, 'DELETE', 'Deleted admin housing complex entry with ID 47', '2024-06-25 04:29:30'),
(235, 1, 'DELETE', 'Deleted admin housing complex entry with ID 37', '2024-06-25 04:36:44'),
(236, 1, 'CREATE', 'Created admin housing complex entry with ID 49', '2024-06-25 04:37:25'),
(237, 1, 'CREATE', 'Created admin housing complex entry with ID 50', '2024-06-25 04:37:27'),
(238, 1, 'CREATE', 'Created admin housing complex entry with ID 51', '2024-06-25 04:37:28'),
(239, 1, 'CREATE', 'Created admin housing complex entry with ID 52', '2024-06-25 04:37:29'),
(240, 1, 'CREATE', 'Created admin housing complex entry with ID 53', '2024-06-25 04:37:33'),
(241, 1, 'CREATE', 'Created admin housing complex entry with ID 54', '2024-06-25 04:37:33'),
(242, 1, 'CREATE', 'Created admin housing complex entry with ID 55', '2024-06-25 04:37:34'),
(243, 1, 'CREATE', 'Created admin housing complex entry with ID 56', '2024-06-25 04:37:35'),
(244, 1, 'DELETE', 'Deleted admin housing complex entry with ID 56', '2024-06-25 04:37:44'),
(245, 1, 'DELETE', 'Deleted admin housing complex entry with ID 55', '2024-06-25 04:44:35'),
(246, 1, 'DELETE', 'Deleted admin housing complex entry with ID 54', '2024-06-25 04:47:38'),
(247, 1, 'DELETE', 'Deleted admin housing complex entry with ID 53', '2024-06-25 04:49:30'),
(248, 1, 'DELETE', 'Deleted admin housing complex entry with ID 52', '2024-06-25 04:49:50'),
(249, 1, 'DELETE', 'Deleted admin housing complex entry with ID 51', '2024-06-25 04:53:08'),
(250, 1, 'DELETE', 'Deleted admin housing complex entry with ID 50', '2024-06-25 05:33:31'),
(251, 1, 'DELETE', 'Deleted admin housing complex entry with ID 49', '2024-06-25 05:35:47'),
(252, 1, 'CREATE', 'Created admin housing complex entry with ID 57', '2024-06-25 05:38:41'),
(253, 1, 'CREATE', 'Created admin housing complex entry with ID 58', '2024-06-25 05:38:43'),
(254, 1, 'CREATE', 'Created admin housing complex entry with ID 59', '2024-06-25 05:38:43'),
(255, 1, 'CREATE', 'Created admin housing complex entry with ID 60', '2024-06-25 05:38:44'),
(256, 1, 'CREATE', 'Created admin housing complex entry with ID 61', '2024-06-25 05:38:45'),
(257, 1, 'DELETE', 'Deleted admin housing complex entry with ID 61', '2024-06-25 05:38:52'),
(258, 1, 'DELETE', 'Deleted admin housing complex entry with ID 59', '2024-06-25 05:38:59'),
(259, 1, 'DELETE', 'Deleted admin housing complex entry with ID 60', '2024-06-25 05:39:37'),
(260, 1, 'DELETE', 'Deleted admin housing complex entry with ID 58', '2024-06-25 05:41:29'),
(261, 1, 'CREATE', 'Created admin housing complex entry with ID 62', '2024-06-25 08:15:06'),
(262, 1, 'CREATE', 'Created admin housing complex entry with ID 63', '2024-06-25 08:15:08'),
(263, 1, 'CREATE', 'Created admin housing complex entry with ID 64', '2024-06-25 08:15:09'),
(264, 1, 'CREATE', 'Created admin housing complex entry with ID 65', '2024-06-25 08:15:11'),
(265, 1, 'CREATE', 'Created admin housing complex entry with ID 66', '2024-06-25 08:15:13'),
(266, 1, 'DELETE', 'Deleted admin housing complex entry with ID 66', '2024-06-25 08:15:20'),
(267, 1, 'DELETE', 'Deleted admin housing complex entry with ID 62', '2024-06-25 08:16:58'),
(268, 1, 'DELETE', 'Deleted admin housing complex entry with ID 65', '2024-06-25 08:17:17'),
(269, 1, 'CREATE', 'Created admin housing complex entry with ID 67', '2024-06-25 08:19:58'),
(270, 1, 'CREATE', 'Created admin housing complex entry with ID 68', '2024-06-25 08:20:00'),
(271, 1, 'CREATE', 'Created admin housing complex entry with ID 69', '2024-06-25 08:20:01'),
(272, 1, 'CREATE', 'Created admin housing complex entry with ID 70', '2024-06-25 08:20:02'),
(273, 1, 'DELETE', 'Deleted admin housing complex entry with ID 70', '2024-06-25 08:20:29'),
(274, 1, 'DELETE', 'Deleted admin housing complex entry with ID 69', '2024-06-25 08:28:02'),
(275, 1, 'DELETE', 'Deleted admin housing complex entry with ID 68', '2024-06-25 08:30:47'),
(276, 1, 'DELETE', 'Deleted admin housing complex entry with ID 67', '2024-06-25 08:33:29'),
(277, 1, 'DELETE', 'Deleted admin housing complex entry with ID 64', '2024-06-25 08:35:36'),
(278, 1, 'DELETE', 'Deleted admin housing complex entry with ID 63', '2024-06-25 08:37:38'),
(279, 1, 'DELETE', 'Deleted admin housing complex entry with ID 57', '2024-06-25 08:37:47'),
(280, 1, 'CREATE', 'Created admin housing complex entry with ID 71', '2024-06-25 08:38:38'),
(281, 1, 'CREATE', 'Created admin housing complex entry with ID 72', '2024-06-25 08:38:40'),
(282, 1, 'CREATE', 'Created admin housing complex entry with ID 73', '2024-06-25 08:38:41'),
(283, 1, 'CREATE', 'Created admin housing complex entry with ID 74', '2024-06-25 08:38:42'),
(284, 1, 'CREATE', 'Created admin housing complex entry with ID 75', '2024-06-25 08:38:42'),
(285, 1, 'CREATE', 'Created admin housing complex entry with ID 76', '2024-06-25 08:38:42'),
(286, 1, 'CREATE', 'Created admin housing complex entry with ID 77', '2024-06-25 08:38:43'),
(287, 1, 'DELETE', 'Deleted admin housing complex entry with ID 77', '2024-06-25 08:38:48'),
(288, 1, 'DELETE', 'Deleted admin housing complex entry with ID 76', '2024-06-25 08:38:51'),
(289, 1, 'DELETE', 'Deleted admin housing complex entry with ID 75', '2024-06-25 08:38:53'),
(290, 1, 'DELETE', 'Deleted admin housing complex entry with ID 74', '2024-06-25 08:39:31'),
(291, 1, 'DELETE', 'Deleted admin housing complex entry with ID 73', '2024-06-25 09:01:27'),
(292, 1, 'DELETE', 'Deleted admin housing complex entry with ID 72', '2024-06-25 09:11:47'),
(293, 1, 'CREATE', 'Created admin housing complex entry with ID 78', '2024-06-25 09:21:22'),
(294, 1, 'CREATE', 'Created admin housing complex entry with ID 79', '2024-06-25 09:21:24'),
(295, 1, 'CREATE', 'Created admin housing complex entry with ID 80', '2024-06-25 09:21:25'),
(296, 1, 'DELETE', 'Deleted admin housing complex entry with ID 80', '2024-06-25 10:08:31'),
(297, 1, 'DELETE', 'Deleted admin housing complex entry with ID 79', '2024-06-25 10:12:55'),
(298, 1, 'CREATE', 'Created admin housing complex entry with ID 81', '2024-06-25 10:13:30'),
(299, 1, 'CREATE', 'Created admin housing complex entry with ID 82', '2024-06-25 10:13:31'),
(300, 1, 'DELETE', 'Deleted admin housing complex entry with ID 82', '2024-06-25 10:13:38'),
(301, 1, 'DELETE', 'Deleted admin housing complex entry with ID 81', '2024-06-25 10:13:42'),
(302, 1, 'DELETE', 'Deleted admin housing complex entry with ID 78', '2024-06-25 10:14:35'),
(303, 1, 'DELETE', 'Deleted admin housing complex entry with ID 71', '2024-06-25 10:14:50'),
(304, 1, 'CREATE', 'Created admin housing complex entry with ID 83', '2024-06-25 10:15:47'),
(305, 1, 'CREATE', 'Created admin housing complex entry with ID 84', '2024-06-25 10:15:48'),
(306, 1, 'CREATE', 'Created admin housing complex entry with ID 85', '2024-06-25 10:15:50'),
(307, 1, 'CREATE', 'Created admin housing complex entry with ID 86', '2024-06-25 10:15:52'),
(308, 1, 'CREATE', 'Created admin housing complex entry with ID 87', '2024-06-25 10:15:52'),
(309, 1, 'CREATE', 'Created admin housing complex entry with ID 88', '2024-06-25 10:15:54'),
(310, 1, 'CREATE', 'Created admin housing complex entry with ID 89', '2024-06-25 10:15:55'),
(311, 1, 'DELETE', 'Deleted admin housing complex entry with ID 89', '2024-06-25 10:16:01'),
(312, 1, 'DELETE', 'Deleted admin housing complex entry with ID 88', '2024-06-25 10:17:27'),
(313, 1, 'DELETE', 'Deleted admin housing complex entry with ID 87', '2024-06-25 10:17:32'),
(314, 1, 'DELETE', 'Deleted admin housing complex entry with ID 86', '2024-06-25 10:17:39'),
(315, 1, 'DELETE', 'Deleted admin housing complex entry with ID 85', '2024-06-25 10:18:23'),
(316, 1, 'DELETE', 'Deleted admin housing complex entry with ID 84', '2024-06-25 10:18:34'),
(317, 1, 'CREATE', 'Created admin housing complex entry with ID 90', '2024-06-25 10:20:54'),
(318, 1, 'CREATE', 'Created admin housing complex entry with ID 91', '2024-06-25 10:20:56'),
(319, 1, 'CREATE', 'Created admin housing complex entry with ID 92', '2024-06-25 10:20:56'),
(320, 1, 'CREATE', 'Created admin housing complex entry with ID 93', '2024-06-25 10:20:57'),
(321, 1, 'CREATE', 'Created admin housing complex entry with ID 94', '2024-06-25 10:20:58'),
(322, 1, 'CREATE', 'Created admin housing complex entry with ID 95', '2024-06-25 10:20:59'),
(323, 1, 'CREATE', 'Created admin housing complex entry with ID 96', '2024-06-25 10:21:00'),
(324, 1, 'CREATE', 'Created admin housing complex entry with ID 97', '2024-06-25 10:21:01'),
(325, 1, 'CREATE', 'Created admin housing complex entry with ID 98', '2024-06-25 10:21:01'),
(326, 1, 'DELETE', 'Deleted admin housing complex entry with ID 98', '2024-06-25 10:21:55'),
(327, 1, 'DELETE', 'Deleted admin housing complex entry with ID 93', '2024-06-25 10:23:37'),
(328, 1, 'DELETE', 'Deleted admin housing complex entry with ID 92', '2024-06-25 10:23:40'),
(329, 1, 'DELETE', 'Deleted admin housing complex entry with ID 96', '2024-06-25 10:24:04'),
(330, 1, 'DELETE', 'Deleted admin housing complex entry with ID 95', '2024-06-25 10:24:08'),
(331, 1, 'CREATE', 'Created admin housing complex entry with ID 99', '2024-06-25 10:27:35'),
(332, 1, 'CREATE', 'Created admin housing complex entry with ID 100', '2024-06-25 10:27:35'),
(333, 1, 'CREATE', 'Created admin housing complex entry with ID 101', '2024-06-25 10:27:36'),
(334, 1, 'CREATE', 'Created admin housing complex entry with ID 102', '2024-06-25 10:27:36'),
(335, 1, 'CREATE', 'Created admin housing complex entry with ID 103', '2024-06-25 10:27:36'),
(336, 1, 'CREATE', 'Created admin housing complex entry with ID 104', '2024-06-25 10:27:37'),
(337, 1, 'CREATE', 'Created admin housing complex entry with ID 105', '2024-06-25 10:27:37'),
(338, 1, 'CREATE', 'Created admin housing complex entry with ID 106', '2024-06-25 10:27:37'),
(339, 1, 'CREATE', 'Created admin housing complex entry with ID 107', '2024-06-25 10:27:37'),
(340, 1, 'DELETE', 'Deleted admin housing complex entry with ID 106', '2024-06-25 10:27:42'),
(341, 1, 'DELETE', 'Deleted admin housing complex entry with ID 105', '2024-06-25 10:28:39'),
(342, 1, 'DELETE', 'Deleted admin housing complex entry with ID 104', '2024-06-25 10:29:25'),
(343, 1, 'DELETE', 'Deleted admin housing complex entry with ID 103', '2024-06-25 10:29:27'),
(344, 1, 'DELETE', 'Deleted admin housing complex entry with ID 102', '2024-06-25 10:29:28'),
(345, 1, 'DELETE', 'Deleted admin housing complex entry with ID 101', '2024-06-25 10:29:32'),
(346, 1, 'DELETE', 'Deleted admin housing complex entry with ID 100', '2024-06-25 10:29:35'),
(347, 1, 'DELETE', 'Deleted admin housing complex entry with ID 97', '2024-06-25 10:33:41'),
(348, 1, 'DELETE', 'Deleted admin housing complex entry with ID 99', '2024-06-25 10:35:24'),
(349, 1, 'DELETE', 'Deleted admin housing complex entry with ID 94', '2024-06-25 10:35:51'),
(350, 1, 'DELETE', 'Deleted admin housing complex entry with ID 91', '2024-06-25 10:37:20'),
(351, 1, 'CREATE', 'Created admin housing complex entry with ID 108', '2024-06-25 10:37:28'),
(352, 1, 'CREATE', 'Created admin housing complex entry with ID 109', '2024-06-25 10:37:34'),
(353, 1, 'CREATE', 'Created admin housing complex entry with ID 110', '2024-06-25 10:37:36'),
(354, 1, 'CREATE', 'Created admin housing complex entry with ID 111', '2024-06-25 10:37:39'),
(355, 1, 'DELETE', 'Deleted admin housing complex entry with ID 109', '2024-06-25 10:38:42'),
(356, 1, 'DELETE', 'Deleted admin housing complex entry with ID 110', '2024-06-25 10:39:59'),
(357, 1, 'DELETE', 'Deleted admin housing complex entry with ID 108', '2024-06-25 10:40:03'),
(358, 1, 'DELETE', 'Deleted admin housing complex entry with ID 90', '2024-06-25 10:40:07'),
(359, 1, 'DELETE', 'Deleted admin housing complex entry with ID 21', '2024-06-25 10:40:45'),
(360, 1, 'DELETE', 'Deleted admin housing complex entry with ID 83', '2024-06-25 10:41:07'),
(361, 1, 'DELETE', 'Deleted admin housing complex entry with ID 107', '2024-06-25 10:41:10'),
(362, 1, 'CREATE', 'Created admin housing complex entry with ID 112', '2024-06-25 10:46:20'),
(363, 1, 'CREATE', 'Created admin housing complex entry with ID 113', '2024-06-25 10:46:23'),
(364, 1, 'CREATE', 'Created admin housing complex entry with ID 114', '2024-06-25 10:46:26'),
(365, 1, 'CREATE', 'Created admin housing complex entry with ID 115', '2024-06-25 10:46:29'),
(366, 1, 'DELETE', 'Deleted admin housing complex entry with ID 115', '2024-06-25 10:46:37'),
(367, 1, 'DELETE', 'Deleted admin housing complex entry with ID 113', '2024-06-25 10:47:06'),
(368, 1, 'DELETE', 'Deleted admin housing complex entry with ID 114', '2024-06-25 10:47:10'),
(369, 1, 'DELETE', 'Deleted admin housing complex entry with ID 112', '2024-06-25 10:47:24'),
(370, 1, 'CREATE', 'Created admin housing complex entry with ID 116', '2024-06-25 10:48:58'),
(371, 1, 'CREATE', 'Created admin housing complex entry with ID 117', '2024-06-25 10:49:03'),
(372, 1, 'CREATE', 'Created admin housing complex entry with ID 118', '2024-06-25 10:49:06'),
(373, 1, 'CREATE', 'Created admin housing complex entry with ID 119', '2024-06-25 10:49:07'),
(374, 1, 'CREATE', 'Created admin housing complex entry with ID 120', '2024-06-25 10:49:08'),
(375, 1, 'CREATE', 'Created admin housing complex entry with ID 121', '2024-06-25 10:49:08'),
(376, 1, 'DELETE', 'Deleted admin housing complex entry with ID 121', '2024-06-25 10:49:22'),
(377, 1, 'DELETE', 'Deleted admin housing complex entry with ID 120', '2024-06-25 10:49:56'),
(378, 1, 'DELETE', 'Deleted admin housing complex entry with ID 118', '2024-06-25 10:50:47'),
(379, 1, 'DELETE', 'Deleted admin housing complex entry with ID 117', '2024-06-25 10:51:25'),
(380, 1, 'DELETE', 'Deleted admin housing complex entry with ID 119', '2024-06-25 10:53:08'),
(381, 1, 'DELETE', 'Deleted admin housing complex entry with ID 116', '2024-06-25 10:54:24'),
(382, 1, 'CREATE', 'Created admin housing complex entry with ID 122', '2024-06-25 10:55:29'),
(383, 1, 'CREATE', 'Created admin housing complex entry with ID 123', '2024-06-25 10:55:29'),
(384, 1, 'CREATE', 'Created admin housing complex entry with ID 124', '2024-06-25 10:55:30'),
(385, 1, 'CREATE', 'Created admin housing complex entry with ID 125', '2024-06-25 10:55:30'),
(386, 1, 'DELETE', 'Deleted admin housing complex entry with ID 125', '2024-06-25 10:55:39'),
(387, 1, 'DELETE', 'Deleted admin housing complex entry with ID 124', '2024-06-25 10:56:12'),
(388, 1, 'DELETE', 'Deleted admin housing complex entry with ID 123', '2024-06-25 10:57:59'),
(389, 1, 'DELETE', 'Deleted admin housing complex entry with ID 122', '2024-06-25 10:58:50'),
(390, 1, 'CREATE', 'Created admin housing complex entry with ID 126', '2024-06-25 10:59:42'),
(391, 1, 'CREATE', 'Created admin housing complex entry with ID 127', '2024-06-25 10:59:42'),
(392, 1, 'CREATE', 'Created admin housing complex entry with ID 128', '2024-06-25 10:59:42'),
(393, 1, 'CREATE', 'Created admin housing complex entry with ID 129', '2024-06-25 10:59:43'),
(394, 1, 'DELETE', 'Deleted admin housing complex entry with ID 129', '2024-06-25 10:59:47'),
(395, 1, 'CREATE', 'Created admin housing complex entry with ID 130', '2024-06-25 12:10:16'),
(396, 1, 'CREATE', 'Created admin housing complex entry with ID 131', '2024-06-25 12:10:19'),
(397, 1, 'CREATE', 'Created admin housing complex entry with ID 132', '2024-06-25 12:10:22'),
(398, 1, 'DELETE', 'Deleted admin housing complex entry with ID 126', '2024-06-26 11:57:06'),
(399, 1, 'DELETE', 'Deleted admin housing complex entry with ID 127', '2024-06-26 11:57:08'),
(400, 1, 'DELETE', 'Deleted admin housing complex entry with ID 128', '2024-06-26 11:57:10'),
(401, 1, 'DELETE', 'Deleted admin housing complex entry with ID 130', '2024-06-26 11:57:11'),
(402, 1, 'DELETE', 'Deleted admin housing complex entry with ID 131', '2024-06-26 11:57:13'),
(403, 1, 'DELETE', 'Deleted admin housing complex entry with ID 132', '2024-06-26 11:57:15'),
(404, 1, 'CREATE', 'Created admin housing complex entry with ID 133', '2024-06-26 12:05:54'),
(405, 1, 'CREATE', 'Created admin housing complex entry with ID 134', '2024-06-26 12:05:56'),
(406, 1, 'CREATE', 'Created admin housing complex entry with ID 135', '2024-06-26 12:05:57'),
(407, 1, 'CREATE', 'Created admin housing complex entry with ID 136', '2024-06-26 12:05:59'),
(408, 1, 'CREATE', 'Created admin housing complex entry with ID 137', '2024-06-26 12:05:59'),
(409, 1, 'CREATE', 'Created admin housing complex entry with ID 138', '2024-06-26 12:06:00'),
(410, 1, 'CREATE', 'Created admin housing complex entry with ID 139', '2024-06-26 12:06:01'),
(411, 1, 'CREATE', 'Created admin housing complex entry with ID 140', '2024-06-26 12:06:01'),
(412, 1, 'CREATE', 'Created admin housing complex entry with ID 141', '2024-06-26 12:06:01'),
(413, 1, 'DELETE', 'Deleted admin housing complex entry with ID 133', '2024-06-26 12:06:42'),
(414, 1, 'DELETE', 'Deleted admin housing complex entry with ID 135', '2024-06-26 12:06:44'),
(415, 1, 'DELETE', 'Deleted admin housing complex entry with ID 138', '2024-06-26 12:06:46'),
(416, 1, 'DELETE', 'Deleted admin housing complex entry with ID 134', '2024-06-26 12:07:25'),
(417, 1, 'DELETE', 'Deleted admin housing complex entry with ID 137', '2024-06-26 12:07:27'),
(418, 1, 'DELETE', 'Deleted admin housing complex entry with ID 139', '2024-06-26 12:07:28'),
(419, 1, 'DELETE', 'Deleted admin housing complex entry with ID 140', '2024-06-26 12:07:31'),
(420, 1, 'DELETE', 'Deleted admin housing complex entry with ID 136', '2024-06-26 12:07:36'),
(421, 1, 'DELETE', 'Deleted admin housing complex entry with ID 141', '2024-06-26 12:07:38'),
(422, 1, 'CREATE', 'Created admin housing complex entry with ID 142', '2024-06-26 12:13:13'),
(423, 1, 'CREATE', 'Created admin housing complex entry with ID 143', '2024-06-26 12:13:17'),
(424, 1, 'CREATE', 'Created admin housing complex entry with ID 144', '2024-06-26 12:13:20'),
(425, 1, 'CREATE', 'Created admin housing complex entry with ID 145', '2024-06-26 12:13:23'),
(426, 1, 'CREATE', 'Created admin housing complex entry with ID 146', '2024-06-26 12:13:25'),
(427, 1, 'UPDATE', 'Updated admin housing complex entry with ID 142', '2024-06-26 12:16:57'),
(428, 1, 'DELETE', 'Deleted admin housing complex entry with ID 142', '2024-06-26 12:17:50'),
(429, 1, 'DELETE', 'Deleted admin housing complex entry with ID 143', '2024-06-26 12:17:53'),
(430, 1, 'DELETE', 'Deleted admin housing complex entry with ID 144', '2024-06-26 12:17:54'),
(431, 1, 'DELETE', 'Deleted admin housing complex entry with ID 145', '2024-06-26 12:17:56'),
(432, 1, 'DELETE', 'Deleted admin housing complex entry with ID 146', '2024-06-26 12:18:07'),
(433, 1, 'DELETE', 'Deleted sale with ID 6', '2024-06-27 12:29:09'),
(434, 1, 'DELETE', 'Deleted sale with ID 7', '2024-06-27 12:29:41'),
(435, 1, 'DELETE', 'Deleted sale with ID 11', '2024-06-27 12:29:49'),
(436, 1, 'CREATE', 'Created housing complex with ID 50', '2024-06-27 13:28:02'),
(437, 1, 'DELETE', 'Deleted housing complex with ID 50', '2024-06-27 13:29:46'),
(438, 1, 'CREATE', 'Created housing complex with ID 51', '2024-06-28 03:57:52'),
(439, 1, 'DELETE', 'Deleted housing complex with ID 51', '2024-06-28 03:58:15'),
(444, 17, 'INSERT', 'Inserted house with number: A101', '2024-07-23 17:14:57'),
(445, 18, 'INSERT', 'Inserted house with number: A102', '2024-07-23 17:14:57');

-- --------------------------------------------------------

--
-- Table structure for table `houses`
--

CREATE TABLE `houses` (
  `house_id` int(11) NOT NULL,
  `complex_id` int(11) NOT NULL,
  `house_number` varchar(50) NOT NULL,
  `price` decimal(15,2) NOT NULL,
  `size` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('available','sold') NOT NULL,
  `units_available` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `houses`
--

INSERT INTO `houses` (`house_id`, `complex_id`, `house_number`, `price`, `size`, `description`, `status`, `units_available`, `admin_id`) VALUES
(1, 43, '13A', 123432.00, 12.00, 'urusai', 'available', 3, 1),
(10, 43, 'a99', 1212.00, 120.00, 'asdasda', 'available', 12, 1),
(11, 44, '33A', 100.00, 12.00, NULL, 'available', 12, 1),
(55, 43, 'A101', 500000000.00, 43.00, 'Rumah baru dengan 3 kamar tidur', 'available', 1, 17),
(56, 44, 'A102', 550000000.00, 44.00, 'Rumah dengan pemandangan taman', 'sold', 0, 18);

--
-- Triggers `houses`
--
DELIMITER $$
CREATE TRIGGER `after_house_delete` AFTER DELETE ON `houses` FOR EACH ROW BEGIN
    -- Menyimpan log setelah menghapus data
    INSERT INTO admin_logs (admin_id, action, description, action_date)
    VALUES (OLD.admin_id, 'AFTER DELETE', CONCAT('Menghapus rumah dengan ID ', OLD.house_id), NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_house_insert` AFTER INSERT ON `houses` FOR EACH ROW BEGIN
    -- Menyimpan log setelah menyisipkan data baru
    INSERT INTO admin_logs (admin_id, action, description, action_date)
    VALUES (NEW.admin_id, 'AFTER INSERT', CONCAT('Menambahkan rumah baru dengan ID ', NEW.house_id), NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_house_update` AFTER UPDATE ON `houses` FOR EACH ROW BEGIN
    -- Menyimpan log setelah memperbarui data
    INSERT INTO admin_logs (admin_id, action, description, action_date)
    VALUES (NEW.admin_id, 'AFTER UPDATE', CONCAT('Memperbarui rumah dengan ID ', OLD.house_id, ' menjadi ID ', NEW.house_id), NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_house_delete` BEFORE DELETE ON `houses` FOR EACH ROW BEGIN
    -- Menyimpan log sebelum menghapus data
    INSERT INTO admin_logs (admin_id, action, description, action_date)
    VALUES (OLD.admin_id, 'BEFORE DELETE', CONCAT('Akan menghapus rumah dengan ID ', OLD.house_id), NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_house_insert` BEFORE INSERT ON `houses` FOR EACH ROW BEGIN
    -- Menyimpan log sebelum menyisipkan data baru
    INSERT INTO admin_logs (admin_id, action, description, action_date)
    VALUES (NEW.admin_id, 'BEFORE INSERT', CONCAT('Akan menambahkan rumah baru dengan ID ', NEW.house_id), NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_house_update` BEFORE UPDATE ON `houses` FOR EACH ROW BEGIN
    -- Menyimpan log sebelum memperbarui data
    INSERT INTO admin_logs (admin_id, action, description, action_date)
    VALUES (NEW.admin_id, 'BEFORE UPDATE', CONCAT('Akan memperbarui rumah dengan ID ', OLD.house_id, ' menjadi ID ', NEW.house_id), NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `house_photos`
--

CREATE TABLE `house_photos` (
  `photo_id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `photo_url` varchar(255) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `house_photos`
--

INSERT INTO `house_photos` (`photo_id`, `house_id`, `photo_url`, `description`) VALUES
(43, 10, '1718599548917-Screenshot 2023-11-10 163155.png', 'undefined untuk rumah 10 '),
(44, 10, '1718599548921-Screenshot 2023-11-10 163155.png', 'undefined untuk rumah 10 '),
(45, 10, '1718599548928-Screenshot 2022-07-15 152909.png', 'undefined untuk rumah 10 '),
(46, 11, '1719559238666-a6cd02bb-5adc-415c-9f25-beedb671aa23.jpg', 'undefined untuk rumah 11 '),
(47, 11, '1719559238667-Screenshot 2023-11-10 163004.png', 'undefined untuk rumah 11 ');

-- --------------------------------------------------------

--
-- Table structure for table `house_price_index`
--

CREATE TABLE `house_price_index` (
  `house_id` int(11) DEFAULT NULL,
  `complex_id` int(11) DEFAULT NULL,
  `price` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `housing_complexes`
--

CREATE TABLE `housing_complexes` (
  `complex_id` int(11) NOT NULL,
  `complex_name` varchar(100) NOT NULL,
  `location` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `complex_photo` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `housing_complexes`
--

INSERT INTO `housing_complexes` (`complex_id`, `complex_name`, `location`, `description`, `complex_photo`) VALUES
(1, 'Kompleks Permata', 'Jakarta Selatan', 'Kompleks perumahan modern dengan fasilitas lengkap', 'permata.jpg'),
(2, 'Kompleks Melati', 'Bandung', 'Kompleks perumahan hijau dengan pemandangan alam', 'melati.jpg'),
(3, 'Kompleks Anggrek', 'Surabaya', 'Kompleks perumahan strategis di pusat kota', 'anggrek.jpg'),
(43, 'aaaaa', 'test', 'aaaaaa', '1717139588155-model_03_hukuman.png'),
(44, 'test', 'test', 'test', '1717130813530-Screenshot 2023-11-10 163004.png');

-- --------------------------------------------------------

--
-- Stand-in structure for view `nested_view`
-- (See below for the actual view)
--
CREATE TABLE `nested_view` (
`house_id` int(11)
,`house_number` varchar(50)
,`price` decimal(15,2)
,`size` decimal(10,2)
,`status` enum('available','sold')
);

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `comment` text DEFAULT NULL,
  `review_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`review_id`, `user_id`, `house_id`, `rating`, `comment`, `review_date`) VALUES
(1, 18, 1, 4, 'adasd aasd a', '2024-06-21 11:38:14'),
(2, 17, 1, 5, 'asd d asd aa', '2024-06-21 11:38:14'),
(3, 3, 56, 4, 'Rumah bagus tapi agak berisik karena dekat jalan besar.', '2024-07-22 00:00:00'),
(4, 4, 55, 5, 'Rumahnya nyaman dan lokasinya strategis.', '2024-07-20 00:00:00'),
(5, 2, 55, 5, 'Sangat puas dengan fasilitas yang disediakan.', '2024-07-21 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(11) NOT NULL,
  `role_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `role_name`) VALUES
(1, 'S_admin'),
(2, 'user'),
(3, 'User'),
(4, 'Administrator'),
(5, 'Moderator');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `sale_id` int(11) NOT NULL,
  `house_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `sale_date` datetime NOT NULL,
  `sale_price` decimal(15,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`sale_id`, `house_id`, `user_id`, `sale_date`, `sale_price`) VALUES
(8, 1, 1, '2024-06-13 13:51:00', 11212.00),
(9, 1, 1, '2024-06-13 13:52:08', 11212.00),
(10, 1, 1, '2024-06-13 13:52:09', 11212.00),
(12, 1, 1, '2024-06-13 13:55:38', 11212.00),
(13, 1, 1, '2024-06-13 13:55:48', 11212.00),
(14, 1, 1, '2024-06-13 13:55:49', 11212.00),
(15, 1, 1, '2024-06-13 13:55:50', 11212.00),
(16, 1, 1, '2024-06-13 13:55:50', 11212.00),
(17, 1, 1, '2024-06-13 13:55:51', 11212.00),
(18, 1, 1, '2024-06-13 14:04:24', 11212.00),
(19, 1, 1, '2024-06-13 14:26:07', 11212.00),
(20, 1, 1, '2024-06-13 14:26:17', 11212.00),
(21, 1, 1, '2024-06-13 14:26:19', 11212.00),
(22, 1, 1, '2024-06-13 14:26:19', 11212.00),
(23, 1, 1, '2024-06-13 14:26:19', 11212.00),
(24, 1, 1, '2024-06-13 14:26:19', 11212.00),
(25, 1, 1, '2024-06-13 14:26:20', 11212.00),
(26, 1, 1, '2024-06-13 14:26:20', 11212.00),
(27, 1, 1, '2024-06-13 14:26:20', 11212.00),
(28, 1, 1, '2024-06-13 14:26:21', 11212.00),
(29, 1, 1, '2024-06-13 14:26:24', 11212.00),
(34, 1, 1, '2024-06-13 14:26:26', 1111111.00),
(39, 1, 1, '2024-06-13 14:26:35', 1111111.00),
(44, 1, 1, '2024-06-14 08:11:58', 11212.00),
(45, 1, 1, '2024-06-14 08:19:15', 11212.00),
(46, 1, 1, '2024-06-14 08:36:45', 11212.00),
(47, 1, 1, '2024-06-14 09:18:30', 11212.00),
(48, 1, 1, '2024-06-14 09:41:22', 111.00),
(49, 1, 1, '2024-06-15 04:32:23', 11212.00),
(50, 1, 1, '2024-06-15 04:57:48', 111111.00),
(51, 1, 1, '2024-06-15 04:57:55', 111111.00),
(52, 1, 1, '2024-06-15 04:58:00', 111111.00),
(53, 1, 1, '2024-06-15 05:03:04', 11111.00),
(54, 1, 1, '2024-06-15 05:03:24', 1111.00);

--
-- Triggers `sales`
--
DELIMITER $$
CREATE TRIGGER `after_delete_sales` AFTER DELETE ON `sales` FOR EACH ROW BEGIN
    UPDATE houses
    SET units_available = units_available + 1
    WHERE house_id = OLD.house_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_sales` AFTER INSERT ON `sales` FOR EACH ROW BEGIN
    UPDATE houses
    SET units_available = units_available - 1
    WHERE house_id = NEW.house_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_sales` AFTER UPDATE ON `sales` FOR EACH ROW BEGIN
    -- Jika house_id berubah, perbarui units_available untuk house_id yang lama dan yang baru
    IF OLD.house_id <> NEW.house_id THEN
        -- Tambah units_available pada house_id yang lama
        UPDATE houses
        SET units_available = units_available + 1
        WHERE house_id = OLD.house_id;

        -- Kurangi units_available pada house_id yang baru
        UPDATE houses
        SET units_available = units_available - 1
        WHERE house_id = NEW.house_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `img_profile` varchar(255) NOT NULL DEFAULT 'default_profile.png',
  `resetPasswordToken` varchar(255) DEFAULT NULL,
  `resetPasswordExpires` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `full_name`, `phone_number`, `address`, `img_profile`, `resetPasswordToken`, `resetPasswordExpires`) VALUES
(1, 'asep11', '$2b$15$5szSpzvwYvkMx1L37HprXegHl1y97gqCPTrwJ7gCmPr5OtQ0KUZCS', 'asep@gmail.com', 'asep suaji arbani', '0928124123', 'jalan manig pudal,selatan purwanto,selatan', 'profile-default.png', NULL, NULL),
(2, 'jane_smith', 'password456', 'jane.smith@example.com', 'Jane Smith', '081234567891', 'Jl. Sudirman No. 10, Bandung', 'jane_smith.jpg', NULL, NULL),
(3, 'alice_johnson', 'password789', 'alice.johnson@example.com', 'Alice Johnson', '081234567892', 'Jl. Gatot Subroto No. 5, Surabaya', 'alice_johnson.jpg', NULL, NULL),
(4, 'john_doe', 'password123', 'john.doe@example.com', 'John Doe', '081234567890', 'Jl. Merdeka No. 1, Jakarta', 'john_doe.jpg', NULL, NULL),
(17, 'udin', '$2b$15$mMnBuGLoO/O8THU78FaBBOGNSsZIGGyrXAyjO.p7nvRNQiGXfSoQe', 'rezhaikwanh@students.amikom.ac.id', 'udin', '0921277412', 'jalan udin', 'default_profile.png', NULL, NULL),
(18, 'udin22', '$2b$15$5szSpzvwYvkMx1L37HprXegHl1y97gqCPTrwJ7gCmPr5OtQ0KUZCS', '123@gmail.com', 'uding ipul', '018821733', 'jalan ciprit', 'default_profile.png', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_roles`
--

INSERT INTO `user_roles` (`user_id`, `role_id`) VALUES
(1, 1),
(2, 5),
(4, 1),
(17, 2),
(18, 2);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_houses`
-- (See below for the actual view)
--
CREATE TABLE `view_houses` (
`house_id` int(11)
,`house_number` varchar(50)
,`price` decimal(15,2)
,`size` decimal(10,2)
,`status` enum('available','sold')
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_houses_vertical`
-- (See below for the actual view)
--
CREATE TABLE `view_houses_vertical` (
`house_id` int(11)
,`house_number` varchar(50)
);

-- --------------------------------------------------------

--
-- Structure for view `nested_view`
--
DROP TABLE IF EXISTS `nested_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `nested_view`  AS SELECT `view_houses`.`house_id` AS `house_id`, `view_houses`.`house_number` AS `house_number`, `view_houses`.`price` AS `price`, `view_houses`.`size` AS `size`, `view_houses`.`status` AS `status` FROM `view_houses` WHERE `view_houses`.`status` = 'available'WITH CASCADED CHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `view_houses`
--
DROP TABLE IF EXISTS `view_houses`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_houses`  AS SELECT `houses`.`house_id` AS `house_id`, `houses`.`house_number` AS `house_number`, `houses`.`price` AS `price`, `houses`.`size` AS `size`, `houses`.`status` AS `status` FROM `houses` ;

-- --------------------------------------------------------

--
-- Structure for view `view_houses_vertical`
--
DROP TABLE IF EXISTS `view_houses_vertical`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_houses_vertical`  AS SELECT `houses`.`house_id` AS `house_id`, `houses`.`house_number` AS `house_number` FROM `houses` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_housing_complexes`
--
ALTER TABLE `admin_housing_complexes`
  ADD PRIMARY KEY (`admin_housing_id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `complex_id` (`complex_id`);

--
-- Indexes for table `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `houses`
--
ALTER TABLE `houses`
  ADD PRIMARY KEY (`house_id`),
  ADD KEY `complex_id` (`complex_id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `idx_house_status` (`status`,`price`);

--
-- Indexes for table `house_photos`
--
ALTER TABLE `house_photos`
  ADD PRIMARY KEY (`photo_id`),
  ADD KEY `house_id` (`house_id`);

--
-- Indexes for table `house_price_index`
--
ALTER TABLE `house_price_index`
  ADD KEY `house_id` (`house_id`,`complex_id`);

--
-- Indexes for table `housing_complexes`
--
ALTER TABLE `housing_complexes`
  ADD PRIMARY KEY (`complex_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `house_id` (`house_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`sale_id`),
  ADD KEY `house_id` (`house_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_sales_date` (`sale_date`,`sale_price`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_housing_complexes`
--
ALTER TABLE `admin_housing_complexes`
  MODIFY `admin_housing_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=147;

--
-- AUTO_INCREMENT for table `admin_logs`
--
ALTER TABLE `admin_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=446;

--
-- AUTO_INCREMENT for table `houses`
--
ALTER TABLE `houses`
  MODIFY `house_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `house_photos`
--
ALTER TABLE `house_photos`
  MODIFY `photo_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `housing_complexes`
--
ALTER TABLE `housing_complexes`
  MODIFY `complex_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `sale_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_housing_complexes`
--
ALTER TABLE `admin_housing_complexes`
  ADD CONSTRAINT `admin_housing_complexes_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `admin_housing_complexes_ibfk_2` FOREIGN KEY (`complex_id`) REFERENCES `housing_complexes` (`complex_id`);

--
-- Constraints for table `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD CONSTRAINT `admin_logs_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `houses`
--
ALTER TABLE `houses`
  ADD CONSTRAINT `admin_id` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `houses_ibfk_1` FOREIGN KEY (`complex_id`) REFERENCES `housing_complexes` (`complex_id`);

--
-- Constraints for table `house_photos`
--
ALTER TABLE `house_photos`
  ADD CONSTRAINT `house_photos_ibfk_1` FOREIGN KEY (`house_id`) REFERENCES `houses` (`house_id`);

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`house_id`) REFERENCES `houses` (`house_id`);

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`house_id`) REFERENCES `houses` (`house_id`),
  ADD CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
