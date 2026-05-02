-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 02, 2026 at 03:17 PM
-- Server version: 8.4.3
-- PHP Version: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `qr_menu`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_restoran_dashboard` (IN `p_restoran_id` INT)   BEGIN

    SELECT
        r.id AS restoran_id,
        r.name AS restoran_adi,

        (SELECT COUNT(*) 
         FROM kategoriler 
         WHERE restoran_id = r.id) AS toplam_kategori,

        (SELECT COUNT(*) 
         FROM urunler 
         WHERE restoran_id = r.id) AS toplam_urun,

        (SELECT ROUND(
            AVG((menu_rating + service_rating + venue_rating) / 3),
            2
        )
         FROM geri_bildirim
         WHERE restoran_id = r.id) AS ortalama_puan,

        (SELECT COUNT(*)
         FROM geri_bildirim
         WHERE restoran_id = r.id
           AND created_at >= CURDATE() - INTERVAL 7 DAY
        ) AS haftalik_geri_bildirim,

        (SELECT COUNT(*)
         FROM qr_logs
         WHERE restoran_id = r.id
           AND visit_date = CURDATE()
        ) AS bugun_qr

    FROM restoranlar r
    WHERE r.id = p_restoran_id
    LIMIT 1;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `attachments`
--

CREATE TABLE `attachments` (
  `id` int UNSIGNED NOT NULL,
  `restoran_id` int UNSIGNED NOT NULL,
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `file_path` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `file_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mime_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `file_size` bigint UNSIGNED DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attachments`
--

INSERT INTO `attachments` (`id`, `restoran_id`, `file_name`, `original_name`, `file_path`, `file_url`, `mime_type`, `file_size`, `created_at`) VALUES
(1, 1, 'db8b72f0e3baf827b47434efad820606.png', 'Ekran görüntüsü 2023-09-25 101639.png', 'public/share/db8b72f0e3baf827b47434efad820606.png', 'http://localhost/public/share/db8b72f0e3baf827b47434efad820606.png', 'image/png', 72415, '2025-10-25 15:48:56'),
(2, 1, '9e1929e56fb3a486a810f2a6b05091a6.png', 'Ekran görüntüsü 2023-10-24 221739.png', 'public/share/9e1929e56fb3a486a810f2a6b05091a6.png', 'http://localhost/public/share/9e1929e56fb3a486a810f2a6b05091a6.png', 'image/png', 71603, '2025-10-25 15:49:52'),
(3, 1, 'c815d61e163940756d141303c5803579.png', 'Ekran görüntüsü 2023-10-24 221945.png', 'public/share/c815d61e163940756d141303c5803579.png', 'http://localhost/public/share/c815d61e163940756d141303c5803579.png', 'image/png', 40723, '2025-10-25 16:00:03'),
(4, 1, 'a4e94ee10950cee73f5469aae0b3d564.png', 'Ekran görüntüsü 2024-09-28 130621.png', 'public/share/a4e94ee10950cee73f5469aae0b3d564.png', 'http://localhost/public/share/a4e94ee10950cee73f5469aae0b3d564.png', 'image/png', 29953, '2025-10-25 18:09:00'),
(5, 1, '1bf00a9fd98c571b951571d7f8a05109.png', 'Ekran görüntüsü 2023-09-20 121246.png', 'public/share/1bf00a9fd98c571b951571d7f8a05109.png', 'http://localhost/public/share/1bf00a9fd98c571b951571d7f8a05109.png', 'image/png', 3094, '2025-10-25 18:32:57'),
(6, 1, '565dbff76987591a4afd2b663d092617.png', 'Ekran görüntüsü 2023-10-24 221739.png', 'public/share/565dbff76987591a4afd2b663d092617.png', 'http://localhost/public/share/565dbff76987591a4afd2b663d092617.png', 'image/png', 71603, '2025-10-25 18:33:59'),
(7, 1, '1d04f7f58485882e69bbb2dc7fccd71f.png', 'Ekran görüntüsü 2023-10-24 221859.png', 'public/share/1d04f7f58485882e69bbb2dc7fccd71f.png', 'http://localhost/public/share/1d04f7f58485882e69bbb2dc7fccd71f.png', 'image/png', 105736, '2025-10-25 18:36:20'),
(8, 1, '56af9be7b9aa7f24829d86a853ca33f0.png', 'Ekran görüntüsü 2023-09-20 121310.png', 'public/share/56af9be7b9aa7f24829d86a853ca33f0.png', 'http://localhost/public/share/56af9be7b9aa7f24829d86a853ca33f0.png', 'image/png', 8881, '2025-10-25 18:37:53'),
(9, 1, '43602dce3e18ab0fa5971bc075cfd9cd.png', 'Ekran görüntüsü 2023-09-20 121631.png', 'public/share/43602dce3e18ab0fa5971bc075cfd9cd.png', 'http://localhost/public/share/43602dce3e18ab0fa5971bc075cfd9cd.png', 'image/png', 3348, '2025-10-25 18:42:23'),
(10, 1, '6f0d3a86531b20d916bc1bb19c995754.png', 'cropped-sda-192x192.png', 'public/share/6f0d3a86531b20d916bc1bb19c995754.png', 'http://localhost/public/share/6f0d3a86531b20d916bc1bb19c995754.png', 'image/png', 49475, '2025-10-26 20:33:45'),
(11, 1, '7c316a6394873bb5114ad971b83be6ae.png', '205351.png', 'public/share/7c316a6394873bb5114ad971b83be6ae.png', 'http://localhost/public/share/7c316a6394873bb5114ad971b83be6ae.png', 'image/png', 7720, '2025-10-26 20:38:28'),
(12, 1, 'fb067c9d3c77a04968954959d167188a.png', 'vesikalık.png', 'public/share/fb067c9d3c77a04968954959d167188a.png', 'http://localhost/public/share/fb067c9d3c77a04968954959d167188a.png', 'image/png', 67798, '2025-10-26 20:39:34'),
(13, 1, 'bfefbe779b91ce660c69272672c16a57.jpg', '03122024185428000x200.jpg', 'public/share/bfefbe779b91ce660c69272672c16a57.jpg', 'http://localhost/public/share/bfefbe779b91ce660c69272672c16a57.jpg', 'image/jpeg', 9757, '2025-10-26 20:55:34'),
(14, 1, '0aaa36b0461de33734777a9b9f0fa397.jpg', '03122024185454000x200.jpg', 'public/share/0aaa36b0461de33734777a9b9f0fa397.jpg', 'http://localhost/public/share/0aaa36b0461de33734777a9b9f0fa397.jpg', 'image/jpeg', 9673, '2025-10-26 20:56:29'),
(15, 1, '4f2cb9a5004200221b212aa2541a755a.jpg', '03122024185520000x200.jpg', 'public/share/4f2cb9a5004200221b212aa2541a755a.jpg', 'http://localhost/public/share/4f2cb9a5004200221b212aa2541a755a.jpg', 'image/jpeg', 9327, '2025-10-26 20:58:14'),
(16, 1, '01ad4cbf1c54d6460dc8d6963a781517.jpg', '03122024185520000x200.jpg', 'public/share/01ad4cbf1c54d6460dc8d6963a781517.jpg', 'http://localhost/public/share/01ad4cbf1c54d6460dc8d6963a781517.jpg', 'image/jpeg', 9327, '2025-10-26 21:01:33'),
(17, 1, '980211b7fefcf427e2725538e7f06333.jpg', '03122024185600000x200.jpg', 'public/share/980211b7fefcf427e2725538e7f06333.jpg', 'http://localhost/public/share/980211b7fefcf427e2725538e7f06333.jpg', 'image/jpeg', 12178, '2025-10-26 21:02:05'),
(18, 1, '219112a524dbda2fa28671cf125a41bd.jpg', 'Michelangelo_-_Creation_of_Adam_(cropped).jpg', 'public/share/219112a524dbda2fa28671cf125a41bd.jpg', 'http://localhost/public/share/219112a524dbda2fa28671cf125a41bd.jpg', 'image/jpeg', 89141, '2025-11-03 16:44:14'),
(19, 11, '857ee78d0885cc7b939eccd9e74c3565.webp', '26713153.webp', 'public/share/857ee78d0885cc7b939eccd9e74c3565.webp', 'http://localhost/public/share/857ee78d0885cc7b939eccd9e74c3565.webp', 'image/webp', 8022, '2025-12-14 10:39:49'),
(20, 11, '49239abd3079fee2d6e423cab3b0ee60.webp', '66097476.webp', 'public/share/49239abd3079fee2d6e423cab3b0ee60.webp', 'http://localhost/public/share/49239abd3079fee2d6e423cab3b0ee60.webp', 'image/webp', 4170, '2025-12-14 10:41:10'),
(21, 11, '5769d04ac79b59c1b7d9e8c4a8782dee.webp', '8526803.webp', 'public/share/5769d04ac79b59c1b7d9e8c4a8782dee.webp', 'http://localhost/public/share/5769d04ac79b59c1b7d9e8c4a8782dee.webp', 'image/webp', 2246, '2025-12-14 10:42:12'),
(22, 11, 'a49d4af7667c014c5d64752f004ee1c9.webp', '66107990.webp', 'public/share/a49d4af7667c014c5d64752f004ee1c9.webp', 'http://localhost/public/share/a49d4af7667c014c5d64752f004ee1c9.webp', 'image/webp', 2084, '2025-12-14 10:43:08'),
(23, 11, 'ce0e0156ca51294041b2b1a1406460bb.webp', '8526806.webp', 'public/share/ce0e0156ca51294041b2b1a1406460bb.webp', 'http://localhost/public/share/ce0e0156ca51294041b2b1a1406460bb.webp', 'image/webp', 2372, '2025-12-14 10:44:03'),
(24, 11, 'e8ddff5ad34f86a42d55b659377d2a4e.webp', '8526807.webp', 'public/share/e8ddff5ad34f86a42d55b659377d2a4e.webp', 'http://localhost/public/share/e8ddff5ad34f86a42d55b659377d2a4e.webp', 'image/webp', 2282, '2025-12-14 10:44:42'),
(25, 11, '2ecd84cce733181e0b9280102ee653bc.webp', '8526809.webp', 'public/share/2ecd84cce733181e0b9280102ee653bc.webp', 'http://localhost/public/share/2ecd84cce733181e0b9280102ee653bc.webp', 'image/webp', 2624, '2025-12-14 10:50:03'),
(26, 11, '9a9d65966eea3c0a3e362f614e2397db.webp', '27895310.webp', 'public/share/9a9d65966eea3c0a3e362f614e2397db.webp', 'http://localhost/public/share/9a9d65966eea3c0a3e362f614e2397db.webp', 'image/webp', 2346, '2025-12-14 10:50:51'),
(27, 11, '2f374497226de97892ed63bbd3a21768.webp', '66097469.webp', 'public/share/2f374497226de97892ed63bbd3a21768.webp', 'http://localhost/public/share/2f374497226de97892ed63bbd3a21768.webp', 'image/webp', 2448, '2025-12-14 10:51:26'),
(28, 11, '365c853934ec47987412e26446f6ca57.webp', '8526811.webp', 'public/share/365c853934ec47987412e26446f6ca57.webp', 'http://localhost/public/share/365c853934ec47987412e26446f6ca57.webp', 'image/webp', 2848, '2025-12-14 10:52:01'),
(29, 11, '4810f40d320237ca1bf93da94f27b139.webp', '8526812.webp', 'public/share/4810f40d320237ca1bf93da94f27b139.webp', 'http://localhost/public/share/4810f40d320237ca1bf93da94f27b139.webp', 'image/webp', 4512, '2025-12-14 10:52:54'),
(30, 11, '351fe15a1d067e919507dfc6bd64fc3e.webp', '8526815.webp', 'public/share/351fe15a1d067e919507dfc6bd64fc3e.webp', 'http://localhost/public/share/351fe15a1d067e919507dfc6bd64fc3e.webp', 'image/webp', 10770, '2025-12-14 10:53:49'),
(31, 11, 'becfdb29a3d02ea507232df010b05b16.webp', '8526816.webp', 'public/share/becfdb29a3d02ea507232df010b05b16.webp', 'http://localhost/public/share/becfdb29a3d02ea507232df010b05b16.webp', 'image/webp', 8596, '2025-12-14 10:54:41'),
(32, 11, '2183c8d45707ded5e351bec3a168adc7.webp', '65408207.webp', 'public/share/2183c8d45707ded5e351bec3a168adc7.webp', 'http://localhost/public/share/2183c8d45707ded5e351bec3a168adc7.webp', 'image/webp', 3290, '2025-12-14 10:55:12'),
(33, 11, 'abb465abfc3a0d7b349005d54cc94ac4.webp', '66097470.webp', 'public/share/abb465abfc3a0d7b349005d54cc94ac4.webp', 'http://localhost/public/share/abb465abfc3a0d7b349005d54cc94ac4.webp', 'image/webp', 15354, '2025-12-14 10:56:01'),
(34, 11, 'db974e48e7134dfa51f97bbcc182914a.webp', '66097470.webp', 'public/share/db974e48e7134dfa51f97bbcc182914a.webp', 'http://localhost/public/share/db974e48e7134dfa51f97bbcc182914a.webp', 'image/webp', 15354, '2025-12-14 10:59:21'),
(35, 11, 'b6b4814830c93d6f2cd0148a3dd47ac5.webp', 'ca7qi-logo.webp', 'public/share/b6b4814830c93d6f2cd0148a3dd47ac5.webp', 'http://localhost/public/share/b6b4814830c93d6f2cd0148a3dd47ac5.webp', 'image/webp', 17712, '2025-12-14 10:59:34'),
(36, 11, '3bc20e80dec2514574456b4942688bf6.webp', 'ca7qi-logo.webp', 'public/share/3bc20e80dec2514574456b4942688bf6.webp', 'http://localhost/public/share/3bc20e80dec2514574456b4942688bf6.webp', 'image/webp', 17712, '2025-12-14 11:00:40'),
(37, 11, 'b4d0fbe62826397d2bc57d03e5726eb0.webp', '67837932.webp', 'public/share/b4d0fbe62826397d2bc57d03e5726eb0.webp', 'http://localhost/public/share/b4d0fbe62826397d2bc57d03e5726eb0.webp', 'image/webp', 2912, '2025-12-14 11:00:48'),
(38, 11, 'fd86ecbcc4a27836c9001246efaed9b1.webp', '8526818.webp', 'public/share/fd86ecbcc4a27836c9001246efaed9b1.webp', 'http://localhost/public/share/fd86ecbcc4a27836c9001246efaed9b1.webp', 'image/webp', 5724, '2025-12-14 11:01:47'),
(39, 11, '77526472036399ca2532b0cf70a45bf0.webp', '8526822.webp', 'public/share/77526472036399ca2532b0cf70a45bf0.webp', 'http://localhost/public/share/77526472036399ca2532b0cf70a45bf0.webp', 'image/webp', 8442, '2025-12-14 11:04:11'),
(40, 11, '592e1944316883a98b91666409ea8458.webp', '8526823.webp', 'public/share/592e1944316883a98b91666409ea8458.webp', 'http://localhost/public/share/592e1944316883a98b91666409ea8458.webp', 'image/webp', 7652, '2025-12-14 11:04:43'),
(41, 11, '1401d0093c4488b5c51170276f33dbe8.webp', '8526824.webp', 'public/share/1401d0093c4488b5c51170276f33dbe8.webp', 'http://localhost/public/share/1401d0093c4488b5c51170276f33dbe8.webp', 'image/webp', 7604, '2025-12-14 11:05:11'),
(42, 11, 'd79a98246cec6086c4db1ceec27bcc6d.webp', '8526826.webp', 'public/share/d79a98246cec6086c4db1ceec27bcc6d.webp', 'http://localhost/public/share/d79a98246cec6086c4db1ceec27bcc6d.webp', 'image/webp', 4166, '2025-12-14 11:05:44'),
(43, 11, '8bcdffe9d0a1ff5703b89847e2fd4d61.webp', '8526827.webp', 'public/share/8bcdffe9d0a1ff5703b89847e2fd4d61.webp', 'http://localhost/public/share/8bcdffe9d0a1ff5703b89847e2fd4d61.webp', 'image/webp', 5538, '2025-12-14 11:06:31'),
(44, 11, 'c083c54e9581503960457659b4463f0d.webp', '8526829.webp', 'public/share/c083c54e9581503960457659b4463f0d.webp', 'http://localhost/public/share/c083c54e9581503960457659b4463f0d.webp', 'image/webp', 6058, '2025-12-14 11:07:01'),
(45, 11, 'fbf02e214314afb5f7edf356a60e3c1e.webp', '8526830.webp', 'public/share/fbf02e214314afb5f7edf356a60e3c1e.webp', 'http://localhost/public/share/fbf02e214314afb5f7edf356a60e3c1e.webp', 'image/webp', 6226, '2025-12-14 11:07:33'),
(46, 11, '188d597a1bc0a563940baf7e3155b4e6.webp', '64068905.webp', 'public/share/188d597a1bc0a563940baf7e3155b4e6.webp', 'http://localhost/public/share/188d597a1bc0a563940baf7e3155b4e6.webp', 'image/webp', 8384, '2025-12-14 11:08:12'),
(47, 11, '87c053594044bbcb5d2f262eb1635fb9.webp', '64068943.webp', 'public/share/87c053594044bbcb5d2f262eb1635fb9.webp', 'http://localhost/public/share/87c053594044bbcb5d2f262eb1635fb9.webp', 'image/webp', 4304, '2025-12-14 11:08:58'),
(48, 11, '900c46f9c7a4e52c66efef30245716f2.webp', '64068946.webp', 'public/share/900c46f9c7a4e52c66efef30245716f2.webp', 'http://localhost/public/share/900c46f9c7a4e52c66efef30245716f2.webp', 'image/webp', 12658, '2025-12-14 11:09:28'),
(49, 11, '4d61bb119082fe0657cc7116bda0f77a.webp', '64095459.webp', 'public/share/4d61bb119082fe0657cc7116bda0f77a.webp', 'http://localhost/public/share/4d61bb119082fe0657cc7116bda0f77a.webp', 'image/webp', 9096, '2025-12-14 11:10:01'),
(50, 11, 'a2ab69c81ecedcbe623f191cfcdb56f5.webp', '66097478.webp', 'public/share/a2ab69c81ecedcbe623f191cfcdb56f5.webp', 'http://localhost/public/share/a2ab69c81ecedcbe623f191cfcdb56f5.webp', 'image/webp', 5718, '2025-12-14 11:11:10'),
(51, 11, '4d9f70f00744454bafee7b3377ad8993.webp', '8526833.webp', 'public/share/4d9f70f00744454bafee7b3377ad8993.webp', 'http://localhost/public/share/4d9f70f00744454bafee7b3377ad8993.webp', 'image/webp', 8418, '2025-12-14 11:11:40'),
(52, 11, 'ed8d999ca06a6e20f0265817f6c0cef6.webp', '63589933.webp', 'public/share/ed8d999ca06a6e20f0265817f6c0cef6.webp', 'http://localhost/public/share/ed8d999ca06a6e20f0265817f6c0cef6.webp', 'image/webp', 9528, '2025-12-14 11:12:15'),
(53, 12, 'ac57e6192bc14d433429a5fd81ff2ae3.webp', '71531394.webp', 'public/share/ac57e6192bc14d433429a5fd81ff2ae3.webp', 'http://localhost/public/share/ac57e6192bc14d433429a5fd81ff2ae3.webp', 'image/webp', 3106, '2025-12-15 19:52:40'),
(54, 12, '5df8d668e1f3994106a8575161e73ded.webp', '8694123.webp', 'public/share/5df8d668e1f3994106a8575161e73ded.webp', 'http://localhost/public/share/5df8d668e1f3994106a8575161e73ded.webp', 'image/webp', 3622, '2025-12-15 19:53:45'),
(55, 12, '7e799801b6ccf48bca7cd363af361608.webp', '71531398.webp', 'public/share/7e799801b6ccf48bca7cd363af361608.webp', 'http://localhost/public/share/7e799801b6ccf48bca7cd363af361608.webp', 'image/webp', 3102, '2025-12-15 19:54:16'),
(56, 12, '0f8acbd0b8688345a892caed87f6d9ae.webp', '71531399.webp', 'public/share/0f8acbd0b8688345a892caed87f6d9ae.webp', 'http://localhost/public/share/0f8acbd0b8688345a892caed87f6d9ae.webp', 'image/webp', 4762, '2025-12-15 19:54:49'),
(57, 12, '82f975f4025dd1a1195fa4ef119b48f6.webp', '74762313.webp', 'public/share/82f975f4025dd1a1195fa4ef119b48f6.webp', 'http://localhost/public/share/82f975f4025dd1a1195fa4ef119b48f6.webp', 'image/webp', 4272, '2025-12-15 19:55:19'),
(58, 12, '16b241c9483e3b199808d4c2ec471d15.webp', '74762314.webp', 'public/share/16b241c9483e3b199808d4c2ec471d15.webp', 'http://localhost/public/share/16b241c9483e3b199808d4c2ec471d15.webp', 'image/webp', 3208, '2025-12-15 19:56:20'),
(59, 12, 'f1512371fab1f648381706c4356bf1f0.webp', '75653406.webp', 'public/share/f1512371fab1f648381706c4356bf1f0.webp', 'http://localhost/public/share/f1512371fab1f648381706c4356bf1f0.webp', 'image/webp', 6508, '2025-12-15 19:57:36'),
(60, 12, '674326b21b92bca9dc01f1e5d00ead13.webp', '75653386.webp', 'public/share/674326b21b92bca9dc01f1e5d00ead13.webp', 'http://localhost/public/share/674326b21b92bca9dc01f1e5d00ead13.webp', 'image/webp', 6336, '2025-12-15 19:58:05'),
(61, 12, 'feb51ade5dd16c337b3f7fd990517194.webp', '8694127.webp', 'public/share/feb51ade5dd16c337b3f7fd990517194.webp', 'http://localhost/public/share/feb51ade5dd16c337b3f7fd990517194.webp', 'image/webp', 10770, '2025-12-15 19:58:29'),
(62, 12, '77de04811324672fbd36ceffc877af29.webp', '8694128.webp', 'public/share/77de04811324672fbd36ceffc877af29.webp', 'http://localhost/public/share/77de04811324672fbd36ceffc877af29.webp', 'image/webp', 5724, '2025-12-15 19:59:08'),
(63, 12, '39603ad5ec964d4ea99bc277de67aecd.webp', '8694131.webp', 'public/share/39603ad5ec964d4ea99bc277de67aecd.webp', 'http://localhost/public/share/39603ad5ec964d4ea99bc277de67aecd.webp', 'image/webp', 8442, '2025-12-15 20:00:25'),
(64, 12, '745d0f66a2d4fbf46b7c883d2e9ebb2f.webp', '8694132.webp', 'public/share/745d0f66a2d4fbf46b7c883d2e9ebb2f.webp', 'http://localhost/public/share/745d0f66a2d4fbf46b7c883d2e9ebb2f.webp', 'image/webp', 7956, '2025-12-15 20:00:53'),
(65, 12, '934c64932fc7eb9fefbaa09bb3cc9744.webp', '8694133.webp', 'public/share/934c64932fc7eb9fefbaa09bb3cc9744.webp', 'http://localhost/public/share/934c64932fc7eb9fefbaa09bb3cc9744.webp', 'image/webp', 7652, '2025-12-15 20:04:34'),
(66, 12, 'b0f676e3b26c7ab7d60866ee7d3fa042.webp', '8694134.webp', 'public/share/b0f676e3b26c7ab7d60866ee7d3fa042.webp', 'http://localhost/public/share/b0f676e3b26c7ab7d60866ee7d3fa042.webp', 'image/webp', 7604, '2025-12-15 20:07:16'),
(67, 12, 'fb2a838bdb393b0d12499ec5222f18dc.webp', '8694135.webp', 'public/share/fb2a838bdb393b0d12499ec5222f18dc.webp', 'http://localhost/public/share/fb2a838bdb393b0d12499ec5222f18dc.webp', 'image/webp', 4166, '2025-12-15 20:07:43'),
(68, 12, 'fcfd8014a93a58f5f59f05da3c778ca9.webp', '8694136.webp', 'public/share/fcfd8014a93a58f5f59f05da3c778ca9.webp', 'http://localhost/public/share/fcfd8014a93a58f5f59f05da3c778ca9.webp', 'image/webp', 6058, '2025-12-15 20:08:14'),
(69, 12, '03b8670088d0046c41d231038c111e23.webp', '8694140.webp', 'public/share/03b8670088d0046c41d231038c111e23.webp', 'http://localhost/public/share/03b8670088d0046c41d231038c111e23.webp', 'image/webp', 7180, '2025-12-15 20:09:14'),
(70, 12, 'cc7a492e83ab585679161ad13ab13d87.webp', '71799561.webp', 'public/share/cc7a492e83ab585679161ad13ab13d87.webp', 'http://localhost/public/share/cc7a492e83ab585679161ad13ab13d87.webp', 'image/webp', 9416, '2025-12-15 20:09:39'),
(71, 13, '09c3798f312db7fb994c1163c417b7c7.webp', '7497066.webp', 'public/share/09c3798f312db7fb994c1163c417b7c7.webp', 'http://localhost/public/share/09c3798f312db7fb994c1163c417b7c7.webp', 'image/webp', 4418, '2025-12-16 21:30:00'),
(72, 13, '3ac3d53efa9560e9287f5b67c07826b1.webp', '7497067.webp', 'public/share/3ac3d53efa9560e9287f5b67c07826b1.webp', 'http://localhost/public/share/3ac3d53efa9560e9287f5b67c07826b1.webp', 'image/webp', 4440, '2025-12-16 21:30:47'),
(73, 13, 'eb9f366d2f52a527ddd59f2c5a276c12.webp', '7497070.webp', 'public/share/eb9f366d2f52a527ddd59f2c5a276c12.webp', 'http://localhost/public/share/eb9f366d2f52a527ddd59f2c5a276c12.webp', 'image/webp', 4748, '2025-12-16 21:31:17'),
(74, 13, 'c2ea41100f8eb082d8030ea95cd4e9db.webp', '24364855.webp', 'public/share/c2ea41100f8eb082d8030ea95cd4e9db.webp', 'http://localhost/public/share/c2ea41100f8eb082d8030ea95cd4e9db.webp', 'image/webp', 7210, '2025-12-16 21:31:47'),
(75, 13, '5d976eb25f64e02f1ae14860d1aec821.webp', '7497073.webp', 'public/share/5d976eb25f64e02f1ae14860d1aec821.webp', 'http://localhost/public/share/5d976eb25f64e02f1ae14860d1aec821.webp', 'image/webp', 4992, '2025-12-16 21:32:41'),
(76, 13, 'c5563a71b8415e37e3e399aa03464e15.webp', '7497074.webp', 'public/share/c5563a71b8415e37e3e399aa03464e15.webp', 'http://localhost/public/share/c5563a71b8415e37e3e399aa03464e15.webp', 'image/webp', 5266, '2025-12-16 21:33:27'),
(77, 13, '031fb2e8bc9ff25abddbbf866057f214.webp', '39546593.webp', 'public/share/031fb2e8bc9ff25abddbbf866057f214.webp', 'http://localhost/public/share/031fb2e8bc9ff25abddbbf866057f214.webp', 'image/webp', 4496, '2025-12-16 21:34:19'),
(78, 13, '260e98f6735f4c532120a9a9d7894e68.webp', '7497072.webp', 'public/share/260e98f6735f4c532120a9a9d7894e68.webp', 'http://localhost/public/share/260e98f6735f4c532120a9a9d7894e68.webp', 'image/webp', 2628, '2025-12-16 21:46:08'),
(79, 13, '4a8de5298aed0073c9bdd1a42a4a1ecf.webp', '66127387.webp', 'public/share/4a8de5298aed0073c9bdd1a42a4a1ecf.webp', 'http://localhost/public/share/4a8de5298aed0073c9bdd1a42a4a1ecf.webp', 'image/webp', 3766, '2025-12-16 21:46:46'),
(80, 13, 'c0ff455b17335d5c69ea8abd1c8e6aad.webp', '68576599.webp', 'public/share/c0ff455b17335d5c69ea8abd1c8e6aad.webp', 'http://localhost/public/share/c0ff455b17335d5c69ea8abd1c8e6aad.webp', 'image/webp', 3132, '2025-12-16 21:47:12'),
(81, 13, '4c08e17c2fe78f254e31a05be82217dc.webp', '7497089.webp', 'public/share/4c08e17c2fe78f254e31a05be82217dc.webp', 'http://localhost/public/share/4c08e17c2fe78f254e31a05be82217dc.webp', 'image/webp', 6234, '2025-12-16 21:47:38'),
(82, 13, '79cc5468364d6d732b57f8ceb55be50d.webp', '7497090.webp', 'public/share/79cc5468364d6d732b57f8ceb55be50d.webp', 'http://localhost/public/share/79cc5468364d6d732b57f8ceb55be50d.webp', 'image/webp', 4968, '2025-12-16 21:48:19'),
(83, 13, 'c13a6d445e1d3a05a3fbde0984e09034.webp', '7497091.webp', 'public/share/c13a6d445e1d3a05a3fbde0984e09034.webp', 'http://localhost/public/share/c13a6d445e1d3a05a3fbde0984e09034.webp', 'image/webp', 5040, '2025-12-16 21:48:43'),
(84, 13, '0b2989b3b71189f9ef7a14e84fcd575c.webp', '7497092.webp', 'public/share/0b2989b3b71189f9ef7a14e84fcd575c.webp', 'http://localhost/public/share/0b2989b3b71189f9ef7a14e84fcd575c.webp', 'image/webp', 5218, '2025-12-16 21:49:13'),
(85, 13, 'fa7e90eb22431a962e92a0480533a324.webp', '7497094.webp', 'public/share/fa7e90eb22431a962e92a0480533a324.webp', 'http://localhost/public/share/fa7e90eb22431a962e92a0480533a324.webp', 'image/webp', 5144, '2025-12-16 21:50:00'),
(86, 13, '89ffc21407ae1c5848efc1b77176055e.webp', '7497098.webp', 'public/share/89ffc21407ae1c5848efc1b77176055e.webp', 'http://localhost/public/share/89ffc21407ae1c5848efc1b77176055e.webp', 'image/webp', 6392, '2025-12-16 21:51:48'),
(87, 13, '6728dd955b2913f5ab143088e7fa0eec.webp', '7497099.webp', 'public/share/6728dd955b2913f5ab143088e7fa0eec.webp', 'http://localhost/public/share/6728dd955b2913f5ab143088e7fa0eec.webp', 'image/webp', 5450, '2025-12-16 21:52:30'),
(88, 13, '20f07dc16688baaa425166c9d976176d.webp', '7497100.webp', 'public/share/20f07dc16688baaa425166c9d976176d.webp', 'http://localhost/public/share/20f07dc16688baaa425166c9d976176d.webp', 'image/webp', 5364, '2025-12-16 21:52:58'),
(89, 13, 'abaf47e680fed63aba6dd6cd66d6ea0d.webp', '32794164.webp', 'public/share/abaf47e680fed63aba6dd6cd66d6ea0d.webp', 'http://localhost/public/share/abaf47e680fed63aba6dd6cd66d6ea0d.webp', 'image/webp', 4814, '2025-12-16 21:53:24'),
(90, 13, '030b2f576f716d9504b62e931d27d921.webp', '34816556.webp', 'public/share/030b2f576f716d9504b62e931d27d921.webp', 'http://localhost/public/share/030b2f576f716d9504b62e931d27d921.webp', 'image/webp', 5376, '2025-12-16 21:53:54'),
(91, 13, '5f7b3a2c3c320ac22c4aa65eb2390d32.webp', '39544942.webp', 'public/share/5f7b3a2c3c320ac22c4aa65eb2390d32.webp', 'http://localhost/public/share/5f7b3a2c3c320ac22c4aa65eb2390d32.webp', 'image/webp', 7742, '2025-12-16 21:54:25'),
(92, 13, '06ddb7fb7d6ef54eebad51c5b5495480.webp', '39544973.webp', 'public/share/06ddb7fb7d6ef54eebad51c5b5495480.webp', 'http://localhost/public/share/06ddb7fb7d6ef54eebad51c5b5495480.webp', 'image/webp', 4746, '2025-12-16 21:54:51'),
(93, 13, '8414873db64377ad4c2ad562881b94b6.webp', '39545060.webp', 'public/share/8414873db64377ad4c2ad562881b94b6.webp', 'http://localhost/public/share/8414873db64377ad4c2ad562881b94b6.webp', 'image/webp', 4526, '2025-12-16 21:56:15'),
(94, 13, '56d93ac2752cdd640d8de862a1066298.webp', '39545101.webp', 'public/share/56d93ac2752cdd640d8de862a1066298.webp', 'http://localhost/public/share/56d93ac2752cdd640d8de862a1066298.webp', 'image/webp', 4440, '2025-12-16 21:56:37'),
(95, 13, '24e2d1b956d33dd81a7fc1e7e94925f3.webp', '39545144.webp', 'public/share/24e2d1b956d33dd81a7fc1e7e94925f3.webp', 'http://localhost/public/share/24e2d1b956d33dd81a7fc1e7e94925f3.webp', 'image/webp', 4504, '2025-12-16 21:57:09'),
(96, 13, '84ebc02c36d46c91f59b082151c2313f.webp', '39545849.webp', 'public/share/84ebc02c36d46c91f59b082151c2313f.webp', 'http://localhost/public/share/84ebc02c36d46c91f59b082151c2313f.webp', 'image/webp', 6016, '2025-12-16 21:57:35'),
(97, 13, 'd6d144a947c5766125378caa7179da9e.webp', 'cy8tb-logo.webp', 'public/share/d6d144a947c5766125378caa7179da9e.webp', 'http://localhost/public/share/d6d144a947c5766125378caa7179da9e.webp', 'image/webp', 21766, '2025-12-16 21:58:05'),
(98, 13, 'd6775e50a833da6c21a0ff584ea67263.jpg', '57795dc6-cf08-e411-a1b0-14feb5cc13c9.jpg', 'public/share/d6775e50a833da6c21a0ff584ea67263.jpg', 'http://localhost/public/share/d6775e50a833da6c21a0ff584ea67263.jpg', 'image/jpeg', 124702, '2025-12-16 21:58:16'),
(99, 13, '116a5d18c94a760ec2e4067faf8b4eb4.jpeg', 'images.jpeg', 'public/share/116a5d18c94a760ec2e4067faf8b4eb4.jpeg', 'http://localhost/public/share/116a5d18c94a760ec2e4067faf8b4eb4.jpeg', 'image/jpeg', 8461, '2025-12-16 21:58:20'),
(100, 13, '4272ae600fc14fd5a099b177b493ed38.png', 'Ekran görüntüsü 2023-09-20 121246.png', 'public/share/4272ae600fc14fd5a099b177b493ed38.png', 'http://localhost/public/share/4272ae600fc14fd5a099b177b493ed38.png', 'image/png', 3094, '2025-12-16 21:58:31'),
(101, 13, 'e503436c5f525b811e323dcd591779e4.png', 'Ekran görüntüsü 2023-10-24 221945.png', 'public/share/e503436c5f525b811e323dcd591779e4.png', 'http://localhost/public/share/e503436c5f525b811e323dcd591779e4.png', 'image/png', 40723, '2025-12-16 21:58:39'),
(102, 136, '390f047a6a2b5b30320bc1a43bf6519b.png', 'Ana Ekran 1.png', 'public/share/390f047a6a2b5b30320bc1a43bf6519b.png', 'http://localhost/public/share/390f047a6a2b5b30320bc1a43bf6519b.png', 'image/png', 2368488, '2026-04-18 13:09:21'),
(103, 137, '951ce110be611a7e433b2760d36209f3.jpg', 'Kilit Ekranı 1.jpg', 'public/share/951ce110be611a7e433b2760d36209f3.jpg', 'http://localhost/public/share/951ce110be611a7e433b2760d36209f3.jpg', 'image/jpeg', 2627624, '2026-04-21 16:32:42'),
(104, 137, 'c5fd2f20f3584c501a198b95f366f09b.png', 'Ana Ekran 6.png', 'public/share/c5fd2f20f3584c501a198b95f366f09b.png', 'http://localhost/public/share/c5fd2f20f3584c501a198b95f366f09b.png', 'image/png', 2491805, '2026-04-21 16:34:19'),
(105, 137, '975757937ec4e0f1a64f754f4e1798d2.png', 'Ana Ekran 4.png', 'public/share/975757937ec4e0f1a64f754f4e1798d2.png', 'http://localhost/public/share/975757937ec4e0f1a64f754f4e1798d2.png', 'image/png', 3794545, '2026-04-21 16:34:55'),
(106, 137, '55e69da0e27f50b720edc03cb398514e.jpg', 'Kilit Ekranı 3.jpg', 'public/share/55e69da0e27f50b720edc03cb398514e.jpg', 'http://localhost/public/share/55e69da0e27f50b720edc03cb398514e.jpg', 'image/jpeg', 3634417, '2026-04-21 16:35:39');

-- --------------------------------------------------------

--
-- Table structure for table `fiyat_logs`
--

CREATE TABLE `fiyat_logs` (
  `urunID` int UNSIGNED NOT NULL,
  `eskiFiyat` decimal(10,2) NOT NULL,
  `yeniFiyat` decimal(10,2) NOT NULL,
  `tarih` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fiyat_logs`
--

INSERT INTO `fiyat_logs` (`urunID`, `eskiFiyat`, `yeniFiyat`, `tarih`) VALUES
(10, 150.00, 180.00, '2025-12-17 09:02:39'),
(15, 130.00, 150.00, '2025-12-17 09:58:57'),
(34, 30.00, 31.00, '2025-12-17 09:06:33'),
(39, 90.00, 89.00, '2025-12-17 09:06:40'),
(42, 48.00, 50.00, '2025-12-17 09:06:46'),
(43, 30.00, 39.00, '2025-12-17 09:06:12');

-- --------------------------------------------------------

--
-- Table structure for table `geri_bildirim`
--

CREATE TABLE `geri_bildirim` (
  `id` int UNSIGNED NOT NULL,
  `restoran_id` int UNSIGNED NOT NULL,
  `customer_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `customer_comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `menu_rating` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `service_rating` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `venue_rating` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `geri_bildirim`
--

INSERT INTO `geri_bildirim` (`id`, `restoran_id`, `customer_name`, `customer_comment`, `menu_rating`, `service_rating`, `venue_rating`, `created_at`) VALUES
(1, 1, 'Ad Soyad', 'yorumum', 2, 3, 4, '2025-12-08 20:11:33'),
(2, 1, 'yusuf k', 'başarılı restoran her şey için teşekkürler', 5, 5, 5, '2025-12-08 20:12:16'),
(3, 1, 'Murat D.', 'Yemekler çok lezzetliydi, özellikle ana yemek harikaydı.', 5, 4, 5, '2025-12-08 20:20:11'),
(4, 1, 'Selin A.', 'Servis biraz yavaştı ama ortam çok hoştu.', 4, 3, 5, '2025-12-08 20:21:03'),
(5, 1, 'Kaan T.', 'Fiyat performans açısından gayet iyi bir restoran.', 4, 4, 4, '2025-12-08 20:21:45'),
(6, 1, 'Elif Y.', 'Tatlılar beklediğim kadar iyi değildi, geliştirilebilir.', 3, 4, 4, '2025-12-08 20:22:18'),
(7, 1, 'Baran S.', 'Garsonlar çok ilgiliydi, tekrar geleceğim.', 5, 5, 4, '2025-12-08 20:22:59'),
(8, 1, 'Deniz K.', 'Müzik biraz yüksek ama yemekler şahane.', 5, 4, 3, '2025-12-08 20:23:30'),
(9, 1, 'Gizem R.', 'Ortam çok sıcak ve aile dostu, çok beğendik.', 4, 5, 5, '2025-12-08 20:24:02'),
(10, 1, 'Arda Ç.', 'Porsiyonlar biraz küçük ama lezzet üst düzey.', 5, 4, 4, '2025-12-08 20:24:41'),
(11, 1, 'Hatice M.', 'Rezervasyona rağmen 10 dakika bekledik, idare eder.', 3, 3, 4, '2025-12-08 20:25:16'),
(12, 1, 'Oğuz H.', 'Kahveler efsane, personel çok güler yüzlü.', 4, 5, 5, '2025-12-08 20:26:02'),
(13, 1, 'Yusuf', 'test test', 5, 2, 5, '2025-12-15 18:08:32'),
(14, 11, 'duygu', 'harika mağaza', 5, 5, 5, '2025-12-15 19:29:42'),
(15, 12, 'Ozan Tufan', 'Fena mekan Güzel döner', 5, 3, 2, '2025-12-15 20:12:52'),
(16, 12, 'Serap Dağ', 'Garsonlar gayet iyi', 5, 5, 5, '2025-12-15 20:13:11'),
(17, 1, 'Ahmet Yılmaz', 'Yemekler çok lezzetliydi.', 5, 5, 5, '2025-12-08 07:01:00'),
(18, 1, 'Mehmet Kaya', 'Servis hızlı ve ilgiliydi.', 4, 5, 4, '2025-12-08 07:02:00'),
(19, 1, 'Ali Demir', 'Genel olarak memnun kaldım.', 4, 4, 4, '2025-12-08 07:03:00'),
(20, 1, 'Mustafa Çelik', 'Fiyat performans başarılı.', 5, 4, 4, '2025-12-08 07:04:00'),
(21, 1, 'Emre Şahin', 'Mekân temiz ve ferah.', 4, 4, 5, '2025-12-08 07:05:00'),
(22, 1, 'Burak Aydın', 'Lezzet beklentimin üstündeydi.', 5, 5, 4, '2025-12-08 07:06:00'),
(23, 1, 'Caner Arslan', 'Tekrar gelirim.', 4, 4, 4, '2025-12-08 07:07:00'),
(24, 1, 'Onur Yıldız', 'Çalışanlar çok güler yüzlü.', 5, 5, 5, '2025-12-08 07:08:00'),
(25, 1, 'Serkan Koç', 'Sunumlar gayet iyiydi.', 4, 4, 4, '2025-12-08 07:09:00'),
(26, 1, 'Hakan Öztürk', 'Menü çeşitliliği yeterli.', 4, 4, 4, '2025-12-08 07:10:00'),
(27, 1, 'Tolga Korkmaz', 'Her şey olması gerektiği gibiydi.', 4, 4, 4, '2025-12-08 07:11:00'),
(28, 1, 'Uğur Polat', 'Yemekler sıcak servis edildi.', 5, 4, 4, '2025-12-08 07:12:00'),
(29, 1, 'Furkan Güneş', 'Tatlılar çok başarılı.', 5, 5, 4, '2025-12-08 07:13:00'),
(30, 1, 'Okan Karaca', 'Ortam çok hoştu.', 4, 4, 5, '2025-12-08 07:14:00'),
(31, 1, 'İsmail Aksoy', 'Servis biraz yavaştı.', 3, 3, 4, '2025-12-08 07:15:00'),
(32, 1, 'Kadir Yavuz', 'Genel olarak memnunum.', 4, 4, 4, '2025-12-08 07:16:00'),
(33, 1, 'Batuhan Eren', 'Lezzetli ve kaliteli.', 5, 5, 5, '2025-12-08 07:17:00'),
(34, 1, 'Mert Toprak', 'Fiyatlar makul.', 4, 4, 4, '2025-12-08 07:18:00'),
(35, 1, 'Volkan Tunç', 'Mekân biraz kalabalıktı.', 4, 3, 4, '2025-12-08 07:19:00'),
(36, 1, 'Recep Özkan', 'Servis ekibi profesyonel.', 5, 5, 5, '2025-12-08 07:20:00'),
(37, 1, 'Sinan Erdem', 'Sunumları beğendim.', 4, 4, 4, '2025-12-08 07:21:00'),
(38, 1, 'Cem Akın', 'Tekrar tercih ederim.', 4, 4, 4, '2025-12-08 07:22:00'),
(39, 1, 'Yasin Bozkurt', 'Lezzet standardı yüksek.', 5, 4, 4, '2025-12-08 07:23:00'),
(40, 1, 'Orhan Keskin', 'Ortam biraz gürültülüydü.', 3, 4, 3, '2025-12-08 07:24:00'),
(41, 1, 'Halil İbrahim Aslan', 'Genel deneyim çok iyiydi.', 5, 5, 5, '2025-12-08 07:25:00'),
(42, 11, 'Selim Karahan', 'Yemekler oldukça başarılı.', 5, 4, 4, '2025-12-08 08:01:00'),
(43, 11, 'Erdem Balcı', 'Servis kalitesi yüksek.', 4, 5, 4, '2025-12-08 08:02:00'),
(44, 11, 'Ömer Faruk Yıldırım', 'Mekân atmosferi çok iyi.', 4, 4, 5, '2025-12-08 08:03:00'),
(45, 11, 'Cihan Kılıç', 'Lezzet açısından tatmin edici.', 4, 4, 4, '2025-12-08 08:04:00'),
(46, 11, 'Berkay Sarı', 'Tekrar gelmeyi düşünüyorum.', 4, 4, 4, '2025-12-08 08:05:00'),
(47, 11, 'Kaan Yaman', 'Personel ilgiliydi.', 5, 5, 4, '2025-12-08 08:06:00'),
(48, 11, 'Tuncay Demirtaş', 'Sunumlar başarılı.', 4, 4, 4, '2025-12-08 08:07:00'),
(49, 11, 'Emrah Doğan', 'Yemekler biraz geç geldi.', 3, 3, 4, '2025-12-08 08:08:00'),
(50, 11, 'Suat Karabulut', 'Genel olarak iyi.', 4, 4, 4, '2025-12-08 08:09:00'),
(51, 11, 'Levent Uslu', 'Fiyatlar makul.', 4, 4, 4, '2025-12-08 08:10:00'),
(52, 11, 'Ramazan Acar', 'Lezzet beklentimi karşıladı.', 4, 4, 4, '2025-12-08 08:11:00'),
(53, 11, 'İbrahim Yüksel', 'Mekân temizdi.', 4, 4, 5, '2025-12-08 08:12:00'),
(54, 11, 'Hüseyin Bayram', 'Servis biraz yavaştı.', 3, 3, 4, '2025-12-08 08:13:00'),
(55, 11, 'Kemalettin Özdemir', 'Genel deneyim iyi.', 4, 4, 4, '2025-12-08 08:14:00'),
(56, 11, 'Serhat Taş', 'Lezzetli yemekler.', 5, 4, 4, '2025-12-08 08:15:00'),
(57, 11, 'Alperen Şimşek', 'Tatlılar çok güzeldi.', 5, 5, 4, '2025-12-08 08:16:00'),
(58, 11, 'Yavuz Selim Kurt', 'Sunumları beğendim.', 4, 4, 4, '2025-12-08 08:17:00'),
(59, 11, 'Tolunay Sezer', 'Tekrar tercih ederim.', 4, 4, 4, '2025-12-08 08:18:00'),
(60, 11, 'Nihat Çoban', 'Mekân ferah.', 4, 4, 5, '2025-12-08 08:19:00'),
(61, 11, 'Metin Gök', 'Personel güler yüzlü.', 5, 5, 4, '2025-12-08 08:20:00'),
(62, 11, 'Oğuzhan Işık', 'Genel olarak memnun kaldım.', 4, 4, 4, '2025-12-08 08:21:00'),
(63, 11, 'Barış Sönmez', 'Lezzet ortalamanın üstünde.', 4, 4, 4, '2025-12-08 08:22:00'),
(64, 11, 'Fikret Ersoy', 'Servis başarılıydı.', 4, 5, 4, '2025-12-08 08:23:00'),
(65, 11, 'Murat Karataş', 'Ortam hoştu.', 4, 4, 5, '2025-12-08 08:24:00'),
(66, 11, 'Zafer Kalkan', 'Genel deneyim olumlu.', 4, 4, 4, '2025-12-08 08:25:00'),
(67, 12, 'Ahmet Can Erdem', 'Yemekler oldukça lezzetliydi.', 5, 4, 4, '2025-12-08 09:01:00'),
(68, 12, 'Mehmet Ali Korkut', 'Servis hızlıydı.', 4, 5, 4, '2025-12-08 09:02:00'),
(69, 12, 'Burhan Yılmaz', 'Genel olarak memnun kaldım.', 4, 4, 4, '2025-12-08 09:03:00'),
(70, 12, 'Kemal Arif Demir', 'Mekân ferah ve temiz.', 4, 4, 5, '2025-12-08 09:04:00'),
(71, 12, 'Hakan Murat Özkan', 'Sunumlar başarılıydı.', 4, 4, 4, '2025-12-08 09:05:00'),
(72, 12, 'Serdar Emre Şahin', 'Lezzet beklentimi karşıladı.', 5, 4, 4, '2025-12-08 09:06:00'),
(73, 12, 'Tolga Berat Aydın', 'Personel ilgiliydi.', 4, 5, 4, '2025-12-08 09:07:00'),
(74, 12, 'Yunus Emre Polat', 'Tekrar gelmeyi düşünüyorum.', 4, 4, 4, '2025-12-08 09:08:00'),
(75, 12, 'İsmail Hakkı Aktaş', 'Fiyat performans dengeli.', 4, 4, 4, '2025-12-08 09:09:00'),
(76, 12, 'Onur Can Kılıç', 'Tatlılar çok güzeldi.', 5, 5, 4, '2025-12-08 09:10:00'),
(77, 12, 'Mert Can Uslu', 'Mekân biraz kalabalıktı.', 3, 4, 3, '2025-12-08 09:11:00'),
(78, 12, 'Furkan Ömer Yavuz', 'Servis kalitesi iyiydi.', 4, 4, 4, '2025-12-08 09:12:00'),
(79, 12, 'Volkan Selim Çetin', 'Yemekler sıcak servis edildi.', 5, 4, 4, '2025-12-08 09:13:00'),
(80, 12, 'Kadir Emrah Bozkurt', 'Ortam oldukça hoş.', 4, 4, 5, '2025-12-08 09:14:00'),
(81, 12, 'Uğur Serkan Koç', 'Genel deneyim başarılı.', 4, 4, 4, '2025-12-08 09:15:00'),
(82, 12, 'Batuhan Kerem Güneş', 'Menü yeterince çeşitli.', 4, 4, 4, '2025-12-08 09:16:00'),
(83, 12, 'Recep Tayyip Aslan', 'Lezzet standardı yüksek.', 5, 4, 4, '2025-12-08 09:17:00'),
(84, 12, 'Sinan Ali Ersoy', 'Servis biraz yavaştı.', 3, 3, 4, '2025-12-08 09:18:00'),
(85, 12, 'Cem Berk Toprak', 'Tekrar tercih ederim.', 4, 4, 4, '2025-12-08 09:19:00'),
(86, 12, 'Halil İbrahim Kurt', 'Sunumlar gayet iyiydi.', 4, 4, 4, '2025-12-08 09:20:00'),
(87, 12, 'Okan Furkan Karaca', 'Mekân temizdi.', 4, 4, 5, '2025-12-08 09:21:00'),
(88, 12, 'Mustafa Eren Duman', 'Yemekler oldukça doyurucuydu.', 4, 4, 4, '2025-12-08 09:22:00'),
(89, 12, 'Levent Burak Sezer', 'Personel güler yüzlü.', 5, 5, 4, '2025-12-08 09:23:00'),
(90, 12, 'Yasin Talha Kalkan', 'Genel olarak memnunum.', 4, 4, 4, '2025-12-08 09:24:00'),
(91, 12, 'Orhan Veli Keskin', 'Ortam biraz gürültülüydü.', 3, 4, 3, '2025-12-08 09:25:00'),
(92, 13, 'Ali Rıza Yıldırım', 'Yemekler gerçekten çok iyiydi.', 5, 5, 5, '2025-12-08 10:01:00'),
(93, 13, 'Mehmet Emin Aksoy', 'Servis kalitesi üst seviyede.', 4, 5, 4, '2025-12-08 10:02:00'),
(94, 13, 'Ahmet Furkan Şimşek', 'Mekân atmosferi hoştu.', 4, 4, 5, '2025-12-08 10:03:00'),
(95, 13, 'Burak Can Karahan', 'Lezzet beklentimi karşıladı.', 4, 4, 4, '2025-12-08 10:04:00'),
(96, 13, 'Emre Alp Doğan', 'Tekrar gelmeyi düşünüyorum.', 4, 4, 4, '2025-12-08 10:05:00'),
(97, 13, 'Serkan Volkan Tunç', 'Sunumlar oldukça başarılı.', 4, 4, 4, '2025-12-08 10:06:00'),
(98, 13, 'Hakan Uğur Özdemir', 'Personel çok ilgiliydi.', 5, 5, 4, '2025-12-08 10:07:00'),
(99, 13, 'Murat Can Ergin', 'Yemekler biraz geç geldi.', 3, 3, 4, '2025-12-08 10:08:00'),
(100, 13, 'Tolga Arda Sarı', 'Genel deneyim iyiydi.', 4, 4, 4, '2025-12-08 10:09:00'),
(101, 13, 'Onur Berk Kapan', 'Fiyatlar makul seviyede.', 4, 4, 4, '2025-12-08 10:10:00'),
(102, 13, 'İbrahim Halil Bayram', 'Mekân temiz ve düzenli.', 4, 4, 5, '2025-12-08 10:11:00'),
(103, 13, 'Kemal Yusuf Acar', 'Lezzet ortalamanın üstünde.', 4, 4, 4, '2025-12-08 10:12:00'),
(104, 13, 'Cihan Emre Balcı', 'Servis hızı iyiydi.', 4, 5, 4, '2025-12-08 10:13:00'),
(105, 13, 'Suat Burhan Karabulut', 'Tatlılar çok başarılı.', 5, 5, 4, '2025-12-08 10:14:00'),
(106, 13, 'Nihat Selim Çoban', 'Ortam oldukça ferah.', 4, 4, 5, '2025-12-08 10:15:00'),
(107, 13, 'Alperen Kaan Yaman', 'Tekrar tercih edilecek bir yer.', 4, 4, 4, '2025-12-08 10:16:00'),
(108, 13, 'Yavuz Selim Kurt', 'Sunumları beğendim.', 4, 4, 4, '2025-12-08 10:17:00'),
(109, 13, 'Ramazan Ali Gök', 'Servis biraz yavaştı.', 3, 3, 4, '2025-12-08 10:18:00'),
(110, 13, 'Metin Faruk Ersoy', 'Genel olarak memnun kaldım.', 4, 4, 4, '2025-12-08 10:19:00'),
(111, 13, 'Oğuzhan Berk Işık', 'Yemekler sıcak servis edildi.', 5, 4, 4, '2025-12-08 10:20:00'),
(112, 13, 'Barış Can Sönmez', 'Lezzet standardı iyi.', 4, 4, 4, '2025-12-08 10:21:00'),
(113, 13, 'Fikret Hasan Erdem', 'Mekân biraz kalabalıktı.', 3, 4, 3, '2025-12-08 10:22:00'),
(114, 13, 'Zafer Murat Kalkan', 'Personel güler yüzlüydü.', 5, 5, 4, '2025-12-08 10:23:00'),
(115, 13, 'Levent Burhan Taş', 'Genel deneyim olumlu.', 4, 4, 4, '2025-12-08 10:24:00'),
(116, 13, 'Selim Taha Karataş', 'Tekrar gelirim.', 4, 4, 4, '2025-12-08 10:25:00'),
(117, 11, 'Ozan Tufan', 'test', 1, 1, 1, '2025-12-17 09:42:04'),
(118, 137, 'asd', 'asd', 2, 3, 5, '2026-04-21 16:52:14'),
(119, 137, 'ikinci', 'asd', 3, 3, 3, '2026-04-21 17:06:09'),
(120, 137, 'üc', 'üc', 3, 3, 3, '2026-04-21 17:14:26'),
(121, 137, '4', '4', 2, 5, 4, '2026-04-21 17:15:18'),
(122, 137, '5', '5', 4, 4, 4, '2026-04-21 17:22:42'),
(123, 137, '6', '6', 5, 5, 5, '2026-04-21 17:24:32'),
(124, 137, '7', '7', 2, 4, 4, '2026-04-21 17:43:02'),
(125, 137, '8', '8', 4, 4, 4, '2026-04-21 17:50:39'),
(126, 137, '8', '8', 3, 3, 3, '2026-04-21 18:04:59'),
(127, 137, '9', '9', 5, 4, 4, '2026-04-21 19:20:51');

-- --------------------------------------------------------

--
-- Table structure for table `kategoriler`
--

CREATE TABLE `kategoriler` (
  `id` int UNSIGNED NOT NULL,
  `restoran_id` int UNSIGNED NOT NULL,
  `image_id` int UNSIGNED DEFAULT NULL,
  `kategori_adi` varchar(255) NOT NULL,
  `durum` enum('aktif','pasif') DEFAULT 'aktif',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `kategoriler`
--

INSERT INTO `kategoriler` (`id`, `restoran_id`, `image_id`, `kategori_adi`, `durum`, `created_at`) VALUES
(16, 1, 15, 'Hamburgerler', 'aktif', '2025-11-03 16:30:25'),
(17, 1, 17, 'Kahvaltılık', 'aktif', '2025-11-03 20:25:12'),
(18, 1, 1, 'test test yusuf', 'aktif', '2025-11-03 20:35:38'),
(20, 1, 1, 'deneme 123456', 'aktif', '2025-11-03 20:35:54'),
(21, 1, 14, 'adawd', 'pasif', '2025-11-03 20:36:06'),
(24, 1, 9, 'Test Hızlı İşlem', 'aktif', '2025-12-14 09:48:18'),
(25, 11, 19, 'Burgerler', 'pasif', '2025-12-14 10:39:51'),
(26, 11, 21, 'Tavuk Dönerler', 'aktif', '2025-12-14 10:42:13'),
(27, 11, 28, 'Köfteler', 'pasif', '2025-12-14 10:52:03'),
(28, 11, 30, 'Yan Ürünler', 'aktif', '2025-12-14 10:53:50'),
(29, 11, 37, 'Tatlılar', 'aktif', '2025-12-14 11:00:49'),
(30, 11, 38, 'İçecekler', 'aktif', '2025-12-14 11:01:48'),
(31, 11, 52, 'Soslar', 'aktif', '2025-12-14 11:12:30'),
(32, 12, 53, 'Tavuk Dönerler', 'aktif', '2025-12-15 19:52:42'),
(33, 12, 57, 'Menü', 'aktif', '2025-12-15 19:55:21'),
(34, 12, 61, 'Yan Ürünler', 'aktif', '2025-12-15 19:58:30'),
(35, 12, 62, 'İçecekler', 'aktif', '2025-12-15 19:59:10'),
(36, 13, 71, 'Kahvaltılıklar', 'aktif', '2025-12-16 21:30:01'),
(37, 13, 75, 'Gözlemeler', 'aktif', '2025-12-16 21:32:42'),
(38, 13, 77, 'Tostlar', 'aktif', '2025-12-16 21:34:12'),
(39, 13, 78, 'Çorbalar', 'aktif', '2025-12-16 21:46:08'),
(40, 13, 81, 'Fırın Ürünleri', 'aktif', '2025-12-16 21:47:39'),
(41, 1, 12, 'Burger Menüleri', 'aktif', '2025-12-10 07:00:00'),
(42, 1, 34, 'Kahvaltı Çeşitleri', 'aktif', '2025-12-10 07:01:00'),
(43, 1, 7, 'Izgara Ürünler', 'aktif', '2025-12-10 07:02:00'),
(44, 1, 56, 'İçecekler', 'aktif', '2025-12-10 07:03:00'),
(45, 1, 22, 'Tatlılar', 'aktif', '2025-12-10 07:04:00'),
(46, 1, 89, 'Çocuk Menüsü', 'pasif', '2025-12-10 07:05:00'),
(47, 1, 41, 'Fast Food', 'aktif', '2025-12-10 07:06:00'),
(48, 1, 65, 'Salatalar', 'aktif', '2025-12-10 07:07:00'),
(49, 1, 3, 'Günün Menüsü', 'aktif', '2025-12-10 07:08:00'),
(50, 1, 77, 'Atıştırmalıklar', 'pasif', '2025-12-10 07:09:00'),
(51, 11, 18, 'Ana Yemekler', 'aktif', '2025-12-10 08:00:00'),
(52, 11, 92, 'Çorbalar', 'aktif', '2025-12-10 08:01:00'),
(53, 11, 44, 'Ev Yemekleri', 'aktif', '2025-12-10 08:02:00'),
(54, 11, 9, 'Fırın Ürünleri', 'aktif', '2025-12-10 08:03:00'),
(55, 11, 61, 'İçecekler', 'aktif', '2025-12-10 08:04:00'),
(56, 11, 28, 'Tatlı & Pasta', 'aktif', '2025-12-10 08:05:00'),
(57, 11, 70, 'Özel Menü', 'pasif', '2025-12-10 08:06:00'),
(58, 11, 15, 'Salata & Meze', 'aktif', '2025-12-10 08:07:00'),
(59, 11, 83, 'Günün Çorbası', 'aktif', '2025-12-10 08:08:00'),
(60, 11, 50, 'Fit Menü', 'pasif', '2025-12-10 08:09:00'),
(61, 12, 6, 'Pizza Çeşitleri', 'aktif', '2025-12-10 09:00:00'),
(62, 12, 39, 'Makarnalar', 'aktif', '2025-12-10 09:01:00'),
(63, 12, 74, 'Başlangıçlar', 'aktif', '2025-12-10 09:02:00'),
(64, 12, 11, 'Tatlılar', 'aktif', '2025-12-10 09:03:00'),
(65, 12, 58, 'Soğuk İçecekler', 'aktif', '2025-12-10 09:04:00'),
(66, 12, 90, 'Sıcak İçecekler', 'aktif', '2025-12-10 09:05:00'),
(67, 12, 21, 'Şefin Önerileri', 'aktif', '2025-12-10 09:06:00'),
(68, 12, 67, 'Vejetaryen Menü', 'aktif', '2025-12-10 09:07:00'),
(69, 12, 31, 'Çocuk Menüleri', 'pasif', '2025-12-10 09:08:00'),
(70, 12, 99, 'Kampanyalı Ürünler', 'pasif', '2025-12-10 09:09:00'),
(81, 1, 4, 'Öğle Menüsü', 'aktif', '2025-12-11 07:00:00'),
(82, 1, 18, 'Akşam Menüsü', 'aktif', '2025-12-11 07:01:00'),
(83, 1, 27, 'Premium Burgerler', 'aktif', '2025-12-11 07:02:00'),
(84, 1, 36, 'Mini Atıştırmalıklar', 'aktif', '2025-12-11 07:03:00'),
(85, 1, 48, 'Sos Çeşitleri', 'aktif', '2025-12-11 07:04:00'),
(86, 1, 59, 'Özel İçecekler', 'aktif', '2025-12-11 07:05:00'),
(87, 1, 63, 'Glutensiz Ürünler', 'pasif', '2025-12-11 07:06:00'),
(88, 1, 71, 'Diyet Menü', 'pasif', '2025-12-11 07:07:00'),
(89, 1, 82, 'Yeni Eklenenler', 'aktif', '2025-12-11 07:08:00'),
(90, 1, 91, 'Sezonluk Ürünler', 'aktif', '2025-12-11 07:09:00'),
(91, 1, 6, 'Sokak Lezzetleri', 'aktif', '2025-12-11 07:10:00'),
(92, 1, 13, 'Özel Soslu Ürünler', 'aktif', '2025-12-11 07:11:00'),
(93, 1, 29, 'Paylaşmalık Tabaklar', 'aktif', '2025-12-11 07:12:00'),
(94, 1, 38, 'Hızlı Menü', 'aktif', '2025-12-11 07:13:00'),
(96, 1, 54, 'Özel Kampanyalar', 'pasif', '2025-12-11 07:15:00'),
(97, 1, 68, 'Hafta Sonu Menüsü', 'aktif', '2025-12-11 07:16:00'),
(98, 1, 76, 'Sınırlı Üretim', 'pasif', '2025-12-11 07:17:00'),
(99, 1, 87, 'Şef Dokunuşları', 'aktif', '2025-12-11 07:18:00'),
(100, 1, 94, 'En Çok Tercih Edilenler', 'aktif', '2025-12-11 07:19:00'),
(101, 11, 5, 'Geleneksel Lezzetler', 'aktif', '2025-12-11 08:00:00'),
(102, 11, 16, 'Tencere Yemekleri', 'aktif', '2025-12-11 08:01:00'),
(103, 11, 24, 'Ev Usulü Menü', 'aktif', '2025-12-11 08:02:00'),
(104, 11, 32, 'Köy Kahvaltısı', 'aktif', '2025-12-11 08:03:00'),
(105, 11, 43, 'Taş Fırın Ürünleri', 'aktif', '2025-12-11 08:04:00'),
(106, 11, 57, 'Organik Menü', 'pasif', '2025-12-11 08:05:00'),
(107, 11, 66, 'Vejetaryen Seçenekler', 'aktif', '2025-12-11 08:06:00'),
(108, 11, 78, 'Ev Tatlıları', 'aktif', '2025-12-11 08:07:00'),
(109, 11, 86, 'Özel Gün Yemekleri', 'pasif', '2025-12-11 08:08:00'),
(110, 11, 95, 'Uygun Fiyatlı Menü', 'aktif', '2025-12-11 08:09:00'),
(111, 11, 2, 'Haftalık Menü', 'aktif', '2025-12-11 08:10:00'),
(112, 11, 14, 'Geleneksel Çorbalar', 'aktif', '2025-12-11 08:11:00'),
(113, 11, 21, 'Izgara Ev Yemekleri', 'aktif', '2025-12-11 08:12:00'),
(114, 11, 35, 'Fırın Tatlıları', 'aktif', '2025-12-11 08:13:00'),
(115, 11, 49, 'Kış Menüleri', 'aktif', '2025-12-11 08:14:00'),
(116, 11, 58, 'Yaz Menüleri', 'aktif', '2025-12-11 08:15:00'),
(117, 11, 69, 'Şefin Tenceresi', 'pasif', '2025-12-11 08:16:00'),
(118, 11, 74, 'Ev Yapımı Lezzetler', 'aktif', '2025-12-11 08:17:00'),
(119, 11, 81, 'Doğal Ürünler', 'aktif', '2025-12-11 08:18:00'),
(120, 11, 98, 'Özel Tarifler', 'aktif', '2025-12-11 08:19:00'),
(122, 12, 12, 'Taş Fırın Pizzalar', 'aktif', '2025-12-11 09:01:00'),
(123, 12, 23, 'Kremalı Makarnalar', 'aktif', '2025-12-11 09:02:00'),
(124, 12, 34, 'Penne Çeşitleri', 'aktif', '2025-12-11 09:03:00'),
(125, 12, 46, 'Lazanya & Fırın', 'aktif', '2025-12-11 09:04:00'),
(126, 12, 55, 'Deniz Ürünleri', 'pasif', '2025-12-11 09:05:00'),
(127, 12, 62, 'Vegan Menü', 'aktif', '2025-12-11 09:06:00'),
(128, 12, 70, 'Glutensiz Pizza', 'pasif', '2025-12-11 09:07:00'),
(129, 12, 79, 'Özel Soslu Makarnalar', 'aktif', '2025-12-11 09:08:00'),
(130, 12, 88, 'Şefin Menüsü', 'aktif', '2025-12-11 09:09:00'),
(131, 12, 7, 'Paylaşımlık Pizzalar', 'aktif', '2025-12-11 09:10:00'),
(132, 12, 19, 'Mini Pizza', 'aktif', '2025-12-11 09:11:00'),
(133, 12, 26, 'Fırın Tatlıları', 'aktif', '2025-12-11 09:12:00'),
(134, 12, 37, 'Ev Yapımı Soslar', 'aktif', '2025-12-11 09:13:00'),
(135, 12, 42, 'Özel Hamurlar', 'aktif', '2025-12-11 09:14:00'),
(136, 12, 51, 'Sezonluk Tatlar', 'aktif', '2025-12-11 09:15:00'),
(137, 12, 64, 'Çocuk Pizzaları', 'pasif', '2025-12-11 09:16:00'),
(138, 12, 75, 'En Çok Satanlar', 'aktif', '2025-12-11 09:17:00'),
(139, 12, 83, 'Yeni Tarifler', 'aktif', '2025-12-11 09:18:00'),
(140, 12, 97, 'Sınırlı Süre', 'pasif', '2025-12-11 09:19:00'),
(161, 11, 25, 'Tavuk Dönerler', 'aktif', '2025-12-18 20:59:49'),
(162, 136, 102, 'tatlılar', 'aktif', '2026-04-18 12:20:30'),
(163, 137, 103, 'tatlılar', 'aktif', '2026-04-21 16:32:46'),
(164, 137, 105, 'ana yemekler', 'aktif', '2026-04-21 16:34:56');

-- --------------------------------------------------------

--
-- Table structure for table `kategori_ceviriler`
--

CREATE TABLE `kategori_ceviriler` (
  `id` int UNSIGNED NOT NULL,
  `kategori_id` int UNSIGNED NOT NULL,
  `dil_kodu` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ceviri_adi` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kategori_ceviriler`
--

INSERT INTO `kategori_ceviriler` (`id`, `kategori_id`, `dil_kodu`, `ceviri_adi`, `created_at`) VALUES
(1, 162, 'en', 'sweets', '2026-04-18 13:04:46'),
(2, 162, 'fr', 'bonbons', '2026-04-18 13:04:52'),
(3, 162, 'hi', 'मिठाई', '2026-04-18 13:05:03'),
(4, 162, 'es', 'dulces', '2026-04-18 13:05:10'),
(5, 162, 'zh', '糖果', '2026-04-18 13:05:13'),
(6, 162, 'de', 'Süßigkeiten', '2026-04-18 13:06:41'),
(7, 162, 'pt', 'doces', '2026-04-18 13:08:51'),
(8, 162, 'ru', 'сладости', '2026-04-18 13:08:58'),
(9, 162, 'ja', 'お菓子', '2026-04-18 13:09:01'),
(10, 162, 'ro', 'dulciuri', '2026-04-18 13:28:56'),
(11, 162, 'el', 'γλύκα', '2026-04-18 13:29:04'),
(12, 162, 'gu', 'મીઠાઈ', '2026-04-18 13:29:10'),
(13, 162, 'ko', '과자', '2026-04-18 13:45:58'),
(14, 162, 'ur', 'مٹھائیاں', '2026-04-19 07:35:34'),
(15, 162, 'ar', 'حلويات', '2026-04-19 07:39:30'),
(16, 162, 'id', 'permen', '2026-04-19 07:39:41'),
(17, 162, 'it', 'dolci', '2026-04-19 07:45:29'),
(18, 162, 'mr', 'मिठाई', '2026-04-20 08:21:08'),
(19, 163, 'en', 'sweets', '2026-04-21 16:35:50'),
(20, 164, 'en', 'main courses', '2026-04-21 16:35:56'),
(21, 163, 'zh', '糖果', '2026-04-21 16:36:21'),
(22, 164, 'zh', '主菜', '2026-04-21 16:36:25'),
(23, 163, 'es', 'dulces', '2026-04-21 19:24:35'),
(24, 164, 'es', 'platos principales', '2026-04-21 19:24:40');

-- --------------------------------------------------------

--
-- Table structure for table `qr_logs`
--

CREATE TABLE `qr_logs` (
  `id` int NOT NULL,
  `restoran_id` int UNSIGNED NOT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `device_info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `visit_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `qr_logs`
--

INSERT INTO `qr_logs` (`id`, `restoran_id`, `ip_address`, `device_info`, `user_agent`, `visit_date`, `created_at`) VALUES
(1, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 09:38:17'),
(2, 1, '::1', 'Mobile', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1', '2025-12-14', '2025-12-14 09:39:00'),
(3, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 09:39:17'),
(4, 1, '::1', 'Desktop', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Safari/605.1.15', '2025-12-14', '2025-12-14 09:39:32'),
(5, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 09:48:00'),
(6, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 09:51:09'),
(7, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 09:51:27'),
(8, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 10:03:12'),
(9, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 10:03:56'),
(10, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 10:04:15'),
(11, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 10:04:21'),
(12, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 10:04:33'),
(13, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 10:06:08'),
(14, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 10:07:24'),
(15, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 10:07:27'),
(16, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 10:07:37'),
(17, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 10:07:45'),
(18, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 10:08:35'),
(19, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 10:35:31'),
(20, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-14', '2025-12-14 11:17:03'),
(21, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:04:45'),
(22, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:04:59'),
(23, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:14:20'),
(24, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:14:47'),
(25, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:14:57'),
(26, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:16:02'),
(27, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:19:10'),
(28, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:20:13'),
(29, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:21:58'),
(30, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:22:28'),
(31, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:22:47'),
(32, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:23:01'),
(33, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:23:54'),
(34, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:28:32'),
(35, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:28:40'),
(36, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:30:07'),
(37, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:30:33'),
(38, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 18:30:58'),
(39, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:05:27'),
(40, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:05:44'),
(41, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:06:13'),
(42, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:20:55'),
(43, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:21:25'),
(44, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:22:12'),
(45, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:23:00'),
(46, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:23:23'),
(47, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:24:45'),
(48, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:25:08'),
(49, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:27:06'),
(50, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:28:58'),
(51, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:30:27'),
(52, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:31:34'),
(53, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:34:53'),
(54, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:35:13'),
(55, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:35:50'),
(56, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:36:40'),
(57, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:37:08'),
(58, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:37:21'),
(59, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:37:29'),
(60, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:37:29'),
(61, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:38:16'),
(62, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:39:42'),
(63, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:39:48'),
(64, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:44:20'),
(65, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:51:14'),
(66, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 19:51:18'),
(67, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:10:27'),
(68, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:11:36'),
(69, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:12:13'),
(70, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:12:18'),
(71, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:13:48'),
(72, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:14:06'),
(73, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:14:20'),
(74, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:21:43'),
(75, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:21:50'),
(76, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:22:10'),
(77, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:23:18'),
(78, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:23:38'),
(79, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:24:14'),
(80, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:24:44'),
(81, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:25:01'),
(82, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:25:10'),
(83, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:25:16'),
(84, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:25:25'),
(85, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 20:25:37'),
(86, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 21:31:58'),
(87, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 21:32:16'),
(88, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 21:33:15'),
(89, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 21:33:19'),
(90, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 21:35:20'),
(91, 1, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-15', '2025-12-15 21:35:51'),
(92, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 21:28:33'),
(93, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 21:37:22'),
(94, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 21:37:43'),
(95, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 21:41:53'),
(96, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 21:41:54'),
(97, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 21:41:55'),
(98, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 21:41:58'),
(99, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 21:41:58'),
(100, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 21:42:00'),
(101, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 21:55:07'),
(102, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 22:19:41'),
(103, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 22:20:18'),
(104, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 22:21:51'),
(105, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 22:37:50'),
(106, 13, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-16', '2025-12-16 22:37:52'),
(107, 135, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-17', '2025-12-17 08:41:28'),
(108, 135, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-17', '2025-12-17 08:41:34'),
(109, 135, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-17', '2025-12-17 08:41:40'),
(110, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-17', '2025-12-17 09:27:11'),
(111, 11, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', '2025-12-17', '2025-12-17 09:41:48'),
(112, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-06', '2026-03-06 09:03:06'),
(113, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-06', '2026-03-06 09:03:11'),
(114, 12, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', '2026-03-06', '2026-03-06 09:03:22'),
(115, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:22:13'),
(116, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:22:39'),
(117, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:35:25'),
(118, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:35:45'),
(119, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:36:12'),
(120, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:39:45'),
(121, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:39:52'),
(122, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:41:15'),
(123, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:42:16'),
(124, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:42:22'),
(125, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:42:27'),
(126, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:44:32'),
(127, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:44:42'),
(128, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:50:58'),
(129, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:54:03'),
(130, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:54:20'),
(131, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:57:32'),
(132, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 12:59:31'),
(133, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 13:00:47'),
(134, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 13:04:42'),
(135, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 13:06:17'),
(136, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 13:08:36'),
(137, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 13:09:27'),
(138, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 13:28:38'),
(139, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 13:39:25'),
(140, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 13:44:43'),
(141, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 13:53:47'),
(142, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-18', '2026-04-18 13:58:55'),
(143, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-19', '2026-04-19 07:11:53'),
(144, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-19', '2026-04-19 07:19:50'),
(145, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-19', '2026-04-19 07:34:34'),
(146, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-19', '2026-04-19 07:39:04'),
(147, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-19', '2026-04-19 07:44:15'),
(148, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-19', '2026-04-19 07:49:51'),
(149, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 07:28:21'),
(150, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 07:35:40'),
(151, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 07:35:47'),
(152, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 07:36:18'),
(153, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 08:07:54'),
(154, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 08:08:25'),
(155, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 08:10:37'),
(156, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 08:14:35'),
(157, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 08:15:08'),
(158, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 08:15:14'),
(159, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 08:20:55'),
(160, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 08:24:59'),
(161, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 09:45:44'),
(162, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 09:46:02'),
(163, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 14:02:43'),
(164, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-20', '2026-04-20 14:25:36'),
(165, 136, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 16:31:51'),
(166, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 16:35:44'),
(167, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 16:51:58'),
(168, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:05:59'),
(169, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:14:14'),
(170, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:14:56'),
(171, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:15:00'),
(172, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:22:30'),
(173, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:24:22'),
(174, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:32:07'),
(175, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:34:20'),
(176, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:41:55'),
(177, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:42:53'),
(178, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:50:08'),
(179, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:50:28'),
(180, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 17:52:02'),
(181, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 18:04:48'),
(182, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 18:06:20'),
(183, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 19:20:42'),
(184, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 19:24:15'),
(185, 137, '::1', 'Desktop', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '2026-04-21', '2026-04-21 19:25:05');

-- --------------------------------------------------------

--
-- Table structure for table `restoranlar`
--

CREATE TABLE `restoranlar` (
  `id` int UNSIGNED NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `adres` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sehir` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ilce` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `mail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `gunler` json NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `slogan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` tinyint(1) NOT NULL,
  `teras_var` tinyint(1) NOT NULL DEFAULT '0',
  `konum_lat` decimal(10,8) DEFAULT NULL,
  `konum_lng` decimal(11,8) DEFAULT NULL,
  `hava_durumu_cache` text COLLATE utf8mb4_general_ci,
  `hava_durumu_guncelleme` timestamp NULL DEFAULT NULL,
  `google_maps_url` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `restoranlar`
--

INSERT INTO `restoranlar` (`id`, `slug`, `adres`, `sehir`, `ilce`, `mail`, `phone`, `password`, `gunler`, `name`, `slogan`, `status`, `teras_var`, `konum_lat`, `konum_lng`, `hava_durumu_cache`, `hava_durumu_guncelleme`, `google_maps_url`) VALUES
(1, 'awdaw', 'adana çukurovayurtmahallesi', 'adanam', 'adana', 'infoyusufkrgz@gmail.com', '05385614304', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"10:00\", \"23:00\"], \"sali\": [\"10:00\", \"23:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"10:00\", \"23:00\"], \"persembe\": [\"10:00\", \"23:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"10:00\", \"23:00\"], \"restoranHerGun\": \"off\"}', 'Lezzet Dünyası', 'hidem', 0, 0, NULL, NULL, NULL, NULL, NULL),
(7, 'awdaw-0241', 'adana çukurova\r\nyurtmahallesi', 'adana', 'adana', 'infoyusufkrgz12@gmail.com', '905385614304', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"10:00\", \"23:00\"], \"sali\": [\"10:00\", \"23:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"10:00\", \"23:00\"], \"persembe\": [\"10:00\", \"23:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"10:00\", \"23:00\"], \"restoranHerGun\": \"off\"}', 'awdaw', 'hidem', 0, 0, NULL, NULL, NULL, NULL, NULL),
(8, 'awdaw-6bbe', 'adana çukurova\r\nyurtmahallesi', 'adana', 'adana', 'infoyusufkrgz1@gmail.com', '5385614304', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"10:00\", \"23:00\"], \"sali\": [\"10:00\", \"23:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"10:00\", \"23:00\"], \"persembe\": [\"10:00\", \"23:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"10:00\", \"23:00\"], \"restoranHerGun\": \"off\"}', 'awdaw', 'hidem', 0, 0, NULL, NULL, NULL, NULL, NULL),
(9, 'awdaw-e04e', 'adana çukurova\r\nyurtmahallesi', 'adana', 'adana', 'infoyusufkrgz1e@gmail.com', '53856143042', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"10:00\", \"23:00\"], \"sali\": [\"10:00\", \"23:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"10:00\", \"23:00\"], \"persembe\": [\"10:00\", \"23:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"10:00\", \"23:00\"], \"restoranHerGun\": \"off\"}', 'awdaw', 'hidem', 0, 0, NULL, NULL, NULL, NULL, NULL),
(10, 'lezzet-d-nyas-', 'şahin mah 3227 sokak', 'Mersin', 'Mersin', 'admin@hidemyas.org', '5102207550', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"10:00\", \"23:00\"], \"sali\": [\"10:00\", \"23:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"10:00\", \"23:00\"], \"persembe\": [\"10:00\", \"23:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"10:00\", \"23:00\"], \"restoranHerGun\": \"off\"}', 'Lezzet Dünyası', 'infoyusufkrgz@gmail.com', 0, 0, NULL, NULL, NULL, NULL, NULL),
(11, 'g-tg-t-chicken-horon-k-fte-ak-aabat', 'Gıtgıt Chicken Horon Köfte Akçaabat', 'trabzon', 'trabzon', 'gitgit@qrmenu.otomasyonlar.net', '4622400808', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"10:00\", \"23:00\"], \"sali\": [\"10:00\", \"23:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"10:00\", \"23:00\"], \"persembe\": [\"10:00\", \"23:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"10:00\", \"23:00\"], \"restoranHerGun\": \"on\"}', 'Gıtgıt Chicken Horon Köfte Akçaabat', 'Gıt Gıt Chicken & Horon Köfte, Akçaabat ', 1, 0, NULL, NULL, NULL, NULL, NULL),
(12, 'kd-katik-doner', 'Söğütlü, Adnan Kahveci Blv. No:108, 61300', 'Trabzon', 'Akçaabat', 'kdkatikdoner@qrmenu.otomasyonlar.net', '(0462) 666 31 31', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"10:00\", \"23:00\"], \"sali\": [\"10:00\", \"23:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"10:00\", \"23:00\"], \"persembe\": [\"10:00\", \"23:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"10:00\", \"23:00\"], \"restoranHerGun\": \"on\"}', 'Kd Katık Döner', 'Döner Yiyin', 1, 0, NULL, NULL, NULL, NULL, NULL),
(13, 'star-nirvana-cafe-restaurant', ' Orta Mahallesi, Adnan Kahveci Blv. 88 A, 61300 ', 'Akçaabat', 'Akçaabat', 'sitarnirvana@qrmenu.otomasyonlar.net', '0462 248 80 64', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"10:00\", \"23:00\"], \"sali\": [\"10:00\", \"23:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"10:00\", \"23:00\"], \"persembe\": [\"10:00\", \"23:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"10:00\", \"23:00\"], \"restoranHerGun\": \"off\"}', 'Star Nirvana Cafe & Restaurant', '', 1, 0, NULL, NULL, NULL, NULL, NULL),
(14, 'lezzet-duragi-1', 'Atatürk Mah. No:12', 'İstanbul', 'Kadıköy', 'info1@restoran.com', '05550000001', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"pzt\": [\"09:00\", \"22:00\"]}', 'Lezzet Durağı', 'Kalitede sınır tanımayız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(15, 'lezzet-duragi-2', 'Cumhuriyet Cad. No:45', 'Ankara', 'Çankaya', 'info2@restoran.com', '05550000002', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"sal\": [\"10:00\", \"23:00\"]}', 'Ankara Sofrası', 'Gerçek ev lezzeti', 1, 0, NULL, NULL, NULL, NULL, NULL),
(16, 'lezzet-duragi-3', 'İnönü Cad. No:8', 'İzmir', 'Bornova', 'info3@restoran.com', '05550000003', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"car\": [\"09:00\", \"22:00\"]}', 'Ege Mutfağı', 'Doğadan sofraya', 1, 0, NULL, NULL, NULL, NULL, NULL),
(17, 'lezzet-duragi-4', 'Barbaros Blv. No:22', 'Bursa', 'Nilüfer', 'info4@restoran.com', '05550000004', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"per\": [\"09:00\", \"22:00\"]}', 'Bursa Lezzet', 'Gelenekten geleceğe', 1, 0, NULL, NULL, NULL, NULL, NULL),
(18, 'lezzet-duragi-5', 'Fatih Sk. No:14', 'Antalya', 'Muratpaşa', 'info5@restoran.com', '05550000005', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cum\": [\"10:00\", \"23:30\"]}', 'Akdeniz Sofrası', 'Tazelik burada', 1, 0, NULL, NULL, NULL, NULL, NULL),
(19, 'lezzet-duragi-6', 'Merkez Sk. No:3', 'Adana', 'Seyhan', 'info6@restoran.com', '05550000006', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cts\": [\"11:00\", \"00:00\"]}', 'Adana Kebap', 'Ateşin lezzeti', 1, 0, NULL, NULL, NULL, NULL, NULL),
(20, 'lezzet-duragi-7', 'Gazi Cad. No:9', 'Mersin', 'Yenişehir', 'info7@restoran.com', '05550000007', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"paz\": [\"10:00\", \"22:00\"]}', 'Mersin Sofrası', 'Denizden sofraya', 1, 0, NULL, NULL, NULL, NULL, NULL),
(21, 'lezzet-duragi-8', 'İstasyon Cad. No:6', 'Konya', 'Selçuklu', 'info8@restoran.com', '05550000008', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"pzt\": [\"09:00\", \"21:00\"]}', 'Konya Mutfağı', 'Geleneksel tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(22, 'lezzet-duragi-9', 'Yeni Mah. No:18', 'Kayseri', 'Melikgazi', 'info9@restoran.com', '05550000009', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"sal\": [\"09:00\", \"22:00\"]}', 'Kayseri Sofrası', 'Lezzetin merkezi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(23, 'lezzet-duragi-10', 'Cumhuriyet Sk. No:5', 'Samsun', 'Atakum', 'info10@restoran.com', '05550000010', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"car\": [\"10:00\", \"22:00\"]}', 'Karadeniz Mutfağı', 'Doğal ve taze', 1, 0, NULL, NULL, NULL, NULL, NULL),
(24, 'lezzet-duragi-11', 'Sahil Yolu No:1', 'Trabzon', 'Ortahisar', 'info11@restoran.com', '05550000011', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"per\": [\"09:00\", \"22:00\"]}', 'Hamsi Evi', 'Denizden gelen tat', 1, 0, NULL, NULL, NULL, NULL, NULL),
(25, 'lezzet-duragi-12', 'Gaziler Cad. No:7', 'Rize', 'Merkez', 'info12@restoran.com', '05550000012', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cum\": [\"10:00\", \"23:00\"]}', 'Rize Sofrası', 'Doğanın lezzeti', 1, 0, NULL, NULL, NULL, NULL, NULL),
(26, 'lezzet-duragi-13', 'İnönü Sk. No:4', 'Ordu', 'Altınordu', 'info13@restoran.com', '05550000013', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cts\": [\"10:00\", \"22:00\"]}', 'Ordu Mutfağı', 'Karadeniz tadı', 1, 0, NULL, NULL, NULL, NULL, NULL),
(27, 'lezzet-duragi-14', 'Merkez Cad. No:20', 'Giresun', 'Merkez', 'info14@restoran.com', '05550000014', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"paz\": [\"10:00\", \"21:00\"]}', 'Giresun Lezzet', 'Taze ve doğal', 1, 0, NULL, NULL, NULL, NULL, NULL),
(28, 'lezzet-duragi-15', 'Yeni Cad. No:2', 'Tokat', 'Merkez', 'info15@restoran.com', '05550000015', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"pzt\": [\"09:00\", \"21:00\"]}', 'Tokat Sofrası', 'Ev tadında', 1, 0, NULL, NULL, NULL, NULL, NULL),
(29, 'lezzet-duragi-96', 'Merkez Sk. No:9', 'Kayseri', 'Melikgazi', 'info96@restoran.com', '05550000096', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cum\": [\"10:00\", \"23:00\"]}', 'Kayseri Mutfağı', 'Lezzetin merkezi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(30, 'lezzet-duragi-97', 'Sanayi Cad. No:5', 'Samsun', 'Atakum', 'info97@restoran.com', '05550000097', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"pzt\": [\"09:00\", \"22:00\"]}', 'Karadeniz Sofrası', 'Doğal ve lezzetli', 1, 0, NULL, NULL, NULL, NULL, NULL),
(31, 'lezzet-duragi-98', 'Sahil Yolu No:3', 'Trabzon', 'Ortahisar', 'info98@restoran.com', '05550000098', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"sal\": [\"10:00\", \"23:00\"]}', 'Hamsi Evi', 'Karadeniz’den sofraya', 1, 0, NULL, NULL, NULL, NULL, NULL),
(32, 'lezzet-duragi-99', 'Yeni Mah. No:18', 'Gaziantep', 'Şahinbey', 'info99@restoran.com', '05550000099', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"pzt\": [\"09:00\", \"23:00\"]}', 'Antep Sofrası', 'Ustalık işimiz', 1, 0, NULL, NULL, NULL, NULL, NULL),
(33, 'lezzet-duragi-100', 'Merkez Cad. No:1', 'Şanlıurfa', 'Haliliye', 'info100@restoran.com', '05550000100', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cum\": [\"11:00\", \"00:00\"]}', 'Urfa Kebap', 'Ateşin lezzeti', 1, 0, NULL, NULL, NULL, NULL, NULL),
(34, 'lezzet-kebap-1', 'İnönü Cad. No:133', 'Ankara', 'Yenimahalle', 'info1@lezzetkebap1.com', '05390127880', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Lezzet Kebap', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(35, 'lezzet-restaurant-2', 'Lale Sok. No:138', 'İzmir', 'Karşıyaka', 'info2@lezzetrestaurant2.com', '05310340272', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Lezzet Restaurant', 'Sıcacık ve taze', 1, 0, NULL, NULL, NULL, NULL, NULL),
(36, 'lezzet-baklava-3', 'İnönü Cad. No:99', 'Ankara', 'Mamak', 'info3@lezzetbaklava3.com', '05320262832', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Lezzet Baklava', 'Lezzetin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(37, 'keyif-durum-4', 'Lale Sok. No:93', 'Antalya', 'Kepez', 'info4@keyifdurum4.com', '05352638878', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Keyif Dürüm', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(38, 'anadolu-doner-5', 'Atatürk Cad. No:36', 'İstanbul', 'Kadıköy', 'info5@anadoludoner5.com', '05338431435', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Anadolu Döner', 'Efsane lezzetler', 1, 0, NULL, NULL, NULL, NULL, NULL),
(39, 'anadolu-restaurant-6', 'Menekşe Sok. No:42', 'Adana', 'Seyhan', 'info6@anadolurestaurant6.com', '05377848357', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Anadolu Restaurant', 'Damak çatlatan tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(40, 'bizim-doner-7', 'İnönü Cad. No:1', 'İzmir', 'Bornova', 'info7@bizimdoner7.com', '05350516660', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Bizim Döner', 'Kalitenin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(41, 'ustam-balikcisi-8', 'Gazi Bulvarı No:104', 'İstanbul', 'Üsküdar', 'info8@ustambalikcisi8.com', '05333809224', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Ustam Balıkçısı', 'Kalitenin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(42, 'anadolu-doner-9', 'İnönü Cad. No:20', 'Adana', 'Çukurova', 'info9@anadoludoner9.com', '05359175839', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Anadolu Döner', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(43, 'anadolu-koftecisi-10', 'Gazi Bulvarı No:126', 'Adana', 'Yüreğir', 'info10@anadolukoftecisi10.com', '05372878221', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Anadolu Köftecisi', 'Lezzetin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(44, 'kose-balikcisi-11', 'Atatürk Cad. No:8', 'Ankara', 'Çankaya', 'info11@kosebalikcisi11.com', '05325390021', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Köşe Balıkçısı', 'Sıcacık ve taze', 1, 0, NULL, NULL, NULL, NULL, NULL),
(45, 'saray-baklava-12', 'Gazi Bulvarı No:127', 'İzmir', 'Bornova', 'info12@saraybaklava12.com', '05326523980', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Saray Baklava', 'Lezzetin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(46, 'anadolu-kebap-13', 'Lale Sok. No:140', 'Antalya', 'Kepez', 'info13@anadolukebap13.com', '05360048085', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Anadolu Kebap', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(47, 'ustam-sofrasi-14', 'Sahil Yolu No:74', 'İzmir', 'Karşıyaka', 'info14@ustamsofrasi14.com', '05322025073', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Ustam Sofrası', 'Mutluluk verir', 1, 0, NULL, NULL, NULL, NULL, NULL),
(48, 'doyum-balikcisi-15', 'Gazi Bulvarı No:23', 'İzmir', 'Karşıyaka', 'info15@doyumbalikcisi15.com', '05335191703', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Doyum Balıkçısı', 'Sıcacık ve taze', 1, 0, NULL, NULL, NULL, NULL, NULL),
(49, 'sehir-baklava-16', 'Cumhuriyet Mah. No:34', 'İzmir', 'Buca', 'info16@sehirbaklava16.com', '05350742382', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Şehir Baklava', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(50, 'anadolu-kebap-17', 'Sahil Yolu No:57', 'Ankara', 'Keçiören', 'info17@anadolukebap17.com', '05342004533', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Anadolu Kebap', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(51, 'liman-pide-18', 'Lale Sok. No:92', 'Ankara', 'Yenimahalle', 'info18@limanpide18.com', '05349839410', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Liman Pide', 'Damak çatlatan tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(52, 'lezzet-balikcisi-19', 'Lale Sok. No:86', 'İstanbul', 'Üsküdar', 'info19@lezzetbalikcisi19.com', '05331179278', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Lezzet Balıkçısı', 'Ailenizin yeri', 1, 0, NULL, NULL, NULL, NULL, NULL),
(53, 'sehir-kebap-20', 'Meydan Cad. No:121', 'Ankara', 'Yenimahalle', 'info20@sehirkebap20.com', '05377033070', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Şehir Kebap', 'Sıcacık ve taze', 1, 0, NULL, NULL, NULL, NULL, NULL),
(54, 'kose-cafe-21', 'Lale Sok. No:109', 'İzmir', 'Konak', 'info21@kosecafe21.com', '05371981383', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Köşe Cafe', 'Efsane lezzetler', 1, 0, NULL, NULL, NULL, NULL, NULL),
(55, 'sehir-durum-22', 'Atatürk Cad. No:37', 'Ankara', 'Keçiören', 'info22@sehirdurum22.com', '05323857221', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Şehir Dürüm', 'Ailenizin yeri', 1, 0, NULL, NULL, NULL, NULL, NULL),
(56, 'sahil-koftecisi-23', 'Gazi Bulvarı No:96', 'İzmir', 'Bornova', 'info23@sahilkoftecisi23.com', '05384489486', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Sahil Köftecisi', 'Damak çatlatan tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(57, 'kose-restaurant-24', 'Meydan Cad. No:7', 'İzmir', 'Konak', 'info24@koserestaurant24.com', '05364658633', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Köşe Restaurant', 'Ailenizin yeri', 1, 0, NULL, NULL, NULL, NULL, NULL),
(58, 'kose-sofrasi-25', 'Menekşe Sok. No:40', 'İstanbul', 'Şişli', 'info25@kosesofrasi25.com', '05345612262', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Köşe Sofrası', 'Kalitenin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(59, 'doyum-mutfagi-26', 'Menekşe Sok. No:94', 'İzmir', 'Bornova', 'info26@doyummutfagi26.com', '05394863726', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Doyum Mutfağı', 'Lezzetin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(60, 'lezzet-kebap-27', 'Menekşe Sok. No:105', 'Adana', 'Yüreğir', 'info27@lezzetkebap27.com', '05327525355', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Lezzet Kebap', 'Damak çatlatan tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(61, 'liman-balikcisi-28', 'Sahil Yolu No:65', 'İstanbul', 'Beşiktaş', 'info28@limanbalikcisi28.com', '05361530994', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Liman Balıkçısı', 'Yöresel tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(62, 'anadolu-doner-29', 'İnönü Cad. No:45', 'Ankara', 'Mamak', 'info29@anadoludoner29.com', '05317527078', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Anadolu Döner', 'Mutluluk verir', 1, 0, NULL, NULL, NULL, NULL, NULL),
(63, 'sehir-pizza-30', 'Gazi Bulvarı No:76', 'İstanbul', 'Üsküdar', 'info30@sehirpizza30.com', '05314109992', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Şehir Pizza', 'Efsane lezzetler', 1, 0, NULL, NULL, NULL, NULL, NULL),
(64, 'lezzet-restaurant-31', 'Lale Sok. No:51', 'İstanbul', 'Fatih', 'info31@lezzetrestaurant31.com', '05354721871', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Lezzet Restaurant', 'Damak çatlatan tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(65, 'sahil-doner-32', 'Lale Sok. No:105', 'Ankara', 'Yenimahalle', 'info32@sahildoner32.com', '05315611767', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Sahil Döner', 'Efsane lezzetler', 1, 0, NULL, NULL, NULL, NULL, NULL),
(66, 'sahil-mutfagi-33', 'Gazi Bulvarı No:33', 'İstanbul', 'Maltepe', 'info33@sahilmutfagi33.com', '05350535768', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Sahil Mutfağı', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(67, 'sahil-balikcisi-34', 'Menekşe Sok. No:79', 'Ankara', 'Çankaya', 'info34@sahilbalikcisi34.com', '05359493234', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Sahil Balıkçısı', 'Damak çatlatan tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(68, 'bizim-restaurant-35', 'Cumhuriyet Mah. No:106', 'Antalya', 'Konyaaltı', 'info35@bizimrestaurant35.com', '05379762352', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Bizim Restaurant', 'Lezzetin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(69, 'doyum-pide-36', 'Atatürk Cad. No:72', 'Adana', 'Yüreğir', 'info36@doyumpide36.com', '05312506931', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Doyum Pide', 'Damak çatlatan tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(70, 'liman-doner-37', 'Menekşe Sok. No:70', 'İstanbul', 'Maltepe', 'info37@limandoner37.com', '05385454798', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Liman Döner', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(71, 'meshur-burger-38', 'İnönü Cad. No:114', 'Adana', 'Çukurova', 'info38@meshurburger38.com', '05341351748', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Meşhur Burger', 'Yöresel tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(72, 'saray-burger-39', 'Menekşe Sok. No:142', 'İzmir', 'Bornova', 'info39@sarayburger39.com', '05340908977', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Saray Burger', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(73, 'sahil-sofrasi-40', 'Lale Sok. No:136', 'Ankara', 'Yenimahalle', 'info40@sahilsofrasi40.com', '05312655473', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Sahil Sofrası', 'Damak çatlatan tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(74, 'ustam-doner-41', 'Lale Sok. No:59', 'İzmir', 'Konak', 'info41@ustamdoner41.com', '05340310962', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Ustam Döner', 'Ailenizin yeri', 1, 0, NULL, NULL, NULL, NULL, NULL),
(75, 'liman-balikcisi-42', 'İnönü Cad. No:23', 'Antalya', 'Konyaaltı', 'info42@limanbalikcisi42.com', '05373252367', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Liman Balıkçısı', 'Damak çatlatan tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(76, 'sahil-cafe-43', 'Sahil Yolu No:101', 'Antalya', 'Muratpaşa', 'info43@sahilcafe43.com', '05368652970', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Sahil Cafe', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(77, 'lezzet-durum-44', 'Sahil Yolu No:146', 'Antalya', 'Kepez', 'info44@lezzetdurum44.com', '05324569381', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Lezzet Dürüm', 'Efsane lezzetler', 1, 0, NULL, NULL, NULL, NULL, NULL),
(78, 'sahil-cafe-45', 'Atatürk Cad. No:99', 'İzmir', 'Karşıyaka', 'info45@sahilcafe45.com', '05345569432', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Sahil Cafe', 'Sıcacık ve taze', 1, 0, NULL, NULL, NULL, NULL, NULL),
(79, 'meshur-koftecisi-46', 'Atatürk Cad. No:138', 'İzmir', 'Karşıyaka', 'info46@meshurkoftecisi46.com', '05358455349', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Meşhur Köftecisi', 'Sıcacık ve taze', 1, 0, NULL, NULL, NULL, NULL, NULL),
(80, 'keyif-cafe-47', 'Lale Sok. No:139', 'İstanbul', 'Beşiktaş', 'info47@keyifcafe47.com', '05355180974', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Keyif Cafe', 'Kalitenin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(81, 'sahil-burger-48', 'Gazi Bulvarı No:120', 'Adana', 'Çukurova', 'info48@sahilburger48.com', '05368658532', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Sahil Burger', 'Ailenizin yeri', 1, 0, NULL, NULL, NULL, NULL, NULL),
(82, 'doyum-pizza-49', 'Gazi Bulvarı No:71', 'Adana', 'Seyhan', 'info49@doyumpizza49.com', '05372256194', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Doyum Pizza', 'Yöresel tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(83, 'bizim-baklava-50', 'Lale Sok. No:61', 'Adana', 'Yüreğir', 'info50@bizimbaklava50.com', '05323156489', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Bizim Baklava', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(84, 'anadolu-balikcisi-51', 'Menekşe Sok. No:72', 'Ankara', 'Çankaya', 'info51@anadolubalikcisi51.com', '05386489175', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Anadolu Balıkçısı', 'Lezzetin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(85, 'tarihi-koftecisi-52', 'Gazi Bulvarı No:54', 'Antalya', 'Muratpaşa', 'info52@tarihikoftecisi52.com', '05399427355', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Tarihi Köftecisi', 'Kalitenin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(86, 'tarihi-mutfagi-53', 'Menekşe Sok. No:106', 'Antalya', 'Kepez', 'info53@tarihimutfagi53.com', '05379282411', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Tarihi Mutfağı', 'Damak çatlatan tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(87, 'doyum-cafe-54', 'Meydan Cad. No:14', 'İzmir', 'Karşıyaka', 'info54@doyumcafe54.com', '05339655121', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Doyum Cafe', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(88, 'keyif-koftecisi-55', 'Cumhuriyet Mah. No:38', 'Ankara', 'Keçiören', 'info55@keyifkoftecisi55.com', '05381964441', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Keyif Köftecisi', 'Lezzetin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(89, 'meshur-sofrasi-56', 'Sahil Yolu No:122', 'İzmir', 'Buca', 'info56@meshursofrasi56.com', '05386739762', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Meşhur Sofrası', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(90, 'liman-mutfagi-57', 'Lale Sok. No:33', 'Ankara', 'Keçiören', 'info57@limanmutfagi57.com', '05336738615', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Liman Mutfağı', 'Kalitenin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(91, 'saray-koftecisi-58', 'Sahil Yolu No:119', 'Adana', 'Çukurova', 'info58@saraykoftecisi58.com', '05317323655', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Saray Köftecisi', 'Sıcacık ve taze', 1, 0, NULL, NULL, NULL, NULL, NULL),
(92, 'bizim-mutfagi-59', 'Gazi Bulvarı No:123', 'İzmir', 'Bornova', 'info59@bizimmutfagi59.com', '05328712730', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Bizim Mutfağı', 'Efsane lezzetler', 1, 0, NULL, NULL, NULL, NULL, NULL),
(93, 'ustam-durum-60', 'Menekşe Sok. No:66', 'Antalya', 'Kepez', 'info60@ustamdurum60.com', '05361951282', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Ustam Dürüm', 'Efsane lezzetler', 1, 0, NULL, NULL, NULL, NULL, NULL),
(94, 'liman-mutfagi-61', 'Meydan Cad. No:103', 'Antalya', 'Kepez', 'info61@limanmutfagi61.com', '05366459658', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Liman Mutfağı', 'Efsane lezzetler', 1, 0, NULL, NULL, NULL, NULL, NULL),
(95, 'keyif-pide-62', 'Atatürk Cad. No:106', 'İstanbul', 'Şişli', 'info62@keyifpide62.com', '05392712123', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Keyif Pide', 'Kalitenin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(96, 'bizim-baklava-63', 'Meydan Cad. No:117', 'Ankara', 'Mamak', 'info63@bizimbaklava63.com', '05326494211', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Bizim Baklava', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(97, 'sahil-sofrasi-64', 'Meydan Cad. No:98', 'Antalya', 'Kepez', 'info64@sahilsofrasi64.com', '05385756040', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Sahil Sofrası', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(98, 'lezzet-pizza-65', 'Gazi Bulvarı No:143', 'İstanbul', 'Beşiktaş', 'info65@lezzetpizza65.com', '05333964144', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Lezzet Pizza', 'Mutluluk verir', 1, 0, NULL, NULL, NULL, NULL, NULL),
(99, 'kose-burger-66', 'İnönü Cad. No:144', 'Antalya', 'Konyaaltı', 'info66@koseburger66.com', '05323955251', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Köşe Burger', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(100, 'sehir-durum-67', 'Lale Sok. No:36', 'İstanbul', 'Şişli', 'info67@sehirdurum67.com', '05313035191', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Şehir Dürüm', 'Kalitenin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(101, 'keyif-cafe-68', 'Meydan Cad. No:145', 'Ankara', 'Yenimahalle', 'info68@keyifcafe68.com', '05373723145', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Keyif Cafe', 'Mutluluk verir', 1, 0, NULL, NULL, NULL, NULL, NULL),
(102, 'sahil-mutfagi-69', 'Atatürk Cad. No:131', 'İzmir', 'Karşıyaka', 'info69@sahilmutfagi69.com', '05399654199', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Sahil Mutfağı', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(103, 'keyif-restaurant-70', 'Sahil Yolu No:5', 'Antalya', 'Konyaaltı', 'info70@keyifrestaurant70.com', '05335542818', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Keyif Restaurant', 'Lezzetin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(104, 'lezzet-pizza-71', 'Sahil Yolu No:85', 'İzmir', 'Konak', 'info71@lezzetpizza71.com', '05363718138', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Lezzet Pizza', 'Mutluluk verir', 1, 0, NULL, NULL, NULL, NULL, NULL),
(105, 'keyif-cafe-72', 'Atatürk Cad. No:76', 'İstanbul', 'Beşiktaş', 'info72@keyifcafe72.com', '05325869882', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Keyif Cafe', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(106, 'sehir-cafe-73', 'Atatürk Cad. No:54', 'İstanbul', 'Üsküdar', 'info73@sehircafe73.com', '05393066442', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Şehir Cafe', 'Damak çatlatan tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(107, 'anadolu-pizza-74', 'Cumhuriyet Mah. No:142', 'İstanbul', 'Maltepe', 'info74@anadolupizza74.com', '05399345430', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Anadolu Pizza', 'Yöresel tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(108, 'kose-baklava-75', 'Cumhuriyet Mah. No:75', 'Antalya', 'Muratpaşa', 'info75@kosebaklava75.com', '05318227317', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Köşe Baklava', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(109, 'saray-cafe-76', 'Gazi Bulvarı No:108', 'İstanbul', 'Kadıköy', 'info76@saraycafe76.com', '05342411014', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Saray Cafe', 'Mutluluk verir', 1, 0, NULL, NULL, NULL, NULL, NULL),
(110, 'ustam-restaurant-77', 'Lale Sok. No:82', 'Ankara', 'Yenimahalle', 'info77@ustamrestaurant77.com', '05374046291', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Ustam Restaurant', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `restoranlar` (`id`, `slug`, `adres`, `sehir`, `ilce`, `mail`, `phone`, `password`, `gunler`, `name`, `slogan`, `status`, `teras_var`, `konum_lat`, `konum_lng`, `hava_durumu_cache`, `hava_durumu_guncelleme`, `google_maps_url`) VALUES
(111, 'anadolu-restaurant-78', 'Atatürk Cad. No:50', 'İstanbul', 'Maltepe', 'info78@anadolurestaurant78.com', '05377955049', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Anadolu Restaurant', 'Kalitenin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(112, 'saray-baklava-79', 'Gazi Bulvarı No:4', 'İzmir', 'Bornova', 'info79@saraybaklava79.com', '05317843682', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Saray Baklava', 'Sıcacık ve taze', 1, 0, NULL, NULL, NULL, NULL, NULL),
(113, 'bizim-cafe-80', 'İnönü Cad. No:45', 'Ankara', 'Mamak', 'info80@bizimcafe80.com', '05391769537', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Bizim Cafe', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(114, 'liman-balikcisi-81', 'Gazi Bulvarı No:119', 'Ankara', 'Yenimahalle', 'info81@limanbalikcisi81.com', '05314313949', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Liman Balıkçısı', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(115, 'ustam-doner-82', 'Lale Sok. No:79', 'İzmir', 'Karşıyaka', 'info82@ustamdoner82.com', '05325914006', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Ustam Döner', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(116, 'doyum-sofrasi-83', 'Cumhuriyet Mah. No:131', 'Ankara', 'Keçiören', 'info83@doyumsofrasi83.com', '05383974972', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Doyum Sofrası', 'Kalitenin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(117, 'sehir-kebap-84', 'Sahil Yolu No:30', 'Ankara', 'Mamak', 'info84@sehirkebap84.com', '05359802797', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Şehir Kebap', 'Ailenizin yeri', 1, 0, NULL, NULL, NULL, NULL, NULL),
(118, 'meshur-baklava-85', 'Atatürk Cad. No:105', 'Antalya', 'Kepez', 'info85@meshurbaklava85.com', '05356648377', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Meşhur Baklava', 'Kalitenin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(119, 'ustam-sofrasi-86', 'Menekşe Sok. No:44', 'Antalya', 'Konyaaltı', 'info86@ustamsofrasi86.com', '05334649191', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Ustam Sofrası', 'Efsane lezzetler', 1, 0, NULL, NULL, NULL, NULL, NULL),
(120, 'tarihi-pide-87', 'Cumhuriyet Mah. No:117', 'İzmir', 'Karşıyaka', 'info87@tarihipide87.com', '05330737083', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Tarihi Pide', 'Tadına doyamayacaksınız', 1, 0, NULL, NULL, NULL, NULL, NULL),
(121, 'kose-durum-88', 'Sahil Yolu No:64', 'Antalya', 'Kepez', 'info88@kosedurum88.com', '05399111785', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Köşe Dürüm', 'Sıcacık ve taze', 1, 0, NULL, NULL, NULL, NULL, NULL),
(122, 'doyum-baklava-89', 'Sahil Yolu No:118', 'Ankara', 'Keçiören', 'info89@doyumbaklava89.com', '05341728021', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Doyum Baklava', 'Yöresel tatlar', 1, 0, NULL, NULL, NULL, NULL, NULL),
(123, 'sehir-doner-90', 'Menekşe Sok. No:137', 'İzmir', 'Buca', 'info90@sehirdoner90.com', '05394385939', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Şehir Döner', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(124, 'ustam-baklava-91', 'Menekşe Sok. No:91', 'Adana', 'Seyhan', 'info91@ustambaklava91.com', '05382330023', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Ustam Baklava', 'Sıcacık ve taze', 1, 0, NULL, NULL, NULL, NULL, NULL),
(125, 'kose-koftecisi-92', 'İnönü Cad. No:28', 'İstanbul', 'Beşiktaş', 'info92@kosekoftecisi92.com', '05358527499', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Köşe Köftecisi', 'Sıcacık ve taze', 1, 0, NULL, NULL, NULL, NULL, NULL),
(126, 'liman-pide-93', 'Menekşe Sok. No:114', 'İzmir', 'Karşıyaka', 'info93@limanpide93.com', '05395079470', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Liman Pide', 'En iyi malzemelerle', 1, 0, NULL, NULL, NULL, NULL, NULL),
(127, 'kose-restaurant-94', 'Gazi Bulvarı No:94', 'Ankara', 'Çankaya', 'info94@koserestaurant94.com', '05379716400', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Köşe Restaurant', 'Mutluluk verir', 1, 0, NULL, NULL, NULL, NULL, NULL),
(128, 'liman-pide-95', 'Atatürk Cad. No:119', 'İzmir', 'Bornova', 'info95@limanpide95.com', '05330175613', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Liman Pide', 'Lezzetin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(129, 'sehir-sofrasi-96', 'Meydan Cad. No:49', 'Adana', 'Seyhan', 'info96@sehirsofrasi96.com', '05387708227', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Şehir Sofrası', 'Efsane lezzetler', 1, 0, NULL, NULL, NULL, NULL, NULL),
(130, 'lezzet-mutfagi-97', 'Lale Sok. No:6', 'İstanbul', 'Şişli', 'info97@lezzetmutfagi97.com', '05354910334', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Lezzet Mutfağı', 'Lezzetin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(131, 'keyif-restaurant-98', 'Atatürk Cad. No:35', 'İzmir', 'Buca', 'info98@keyifrestaurant98.com', '05330037426', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Keyif Restaurant', 'Lezzetin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(132, 'doyum-sofrasi-99', 'Gazi Bulvarı No:147', 'Adana', 'Yüreğir', 'info99@doyumsofrasi99.com', '05354646024', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Doyum Sofrası', 'Lezzetin adresi', 1, 0, NULL, NULL, NULL, NULL, NULL),
(133, 'kose-durum-100', 'Sahil Yolu No:50', 'Ankara', 'Mamak', 'info100@kosedurum100.com', '05399569134', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"09:00\", \"23:00\"], \"sali\": [\"09:00\", \"22:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"09:00\", \"22:00\"], \"persembe\": [\"09:00\", \"22:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"09:00\", \"22:00\"]}', 'Köşe Dürüm', 'Efsane lezzetler', 1, 0, NULL, NULL, NULL, NULL, NULL),
(135, 'burger-king', 'adana çukurova\r\nyurtmahallesi', 'adana', 'adana', 'burgerking@qrmenu.otomasyonlar.net', '5385614301', '7a3b69d004cabc843f122a9475d818a84904fd1f45876687a8e79817f0084955', '{\"cuma\": [\"10:00\", \"23:00\"], \"sali\": [\"10:00\", \"23:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"10:00\", \"23:00\"], \"persembe\": [\"10:00\", \"23:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"10:00\", \"23:00\"], \"restoranHerGun\": \"off\"}', 'Burger King', 'BİG MAC', 1, 0, NULL, NULL, NULL, NULL, NULL),
(136, 'ali-said', 'esenyurt', 'istanbul', 'istanbul', 'alisasmazsaid@gmail.com', '5050682305', 'd276566f7a8cea145cd962a010e08d008e2e70f6ad6b3bfc3f6e76ab7bf4b4a6', '{\"cuma\": [\"10:00\", \"23:00\"], \"sali\": [\"10:00\", \"23:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"10:00\", \"23:00\"], \"persembe\": [\"10:00\", \"23:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"10:00\", \"23:00\"], \"restoranHerGun\": \"off\"}', 'ali said', 'alinin lezzetleri', 1, 1, 41.01169300, 39.59972800, '{\"sicaklik\":13,\"nem\":76,\"ruzgar\":5,\"ikon\":\"\\u2600\\ufe0f\",\"durum\":\"A\\u00e7\\u0131k\"}', '2026-04-21 16:32:00', NULL),
(137, 'ali-said-f8b1', 'asd', 'adsasd', 'adsasd', 'das@gmail.com', '05050689586', 'd276566f7a8cea145cd962a010e08d008e2e70f6ad6b3bfc3f6e76ab7bf4b4a6', '{\"cuma\": [\"10:00\", \"23:00\"], \"sali\": [\"10:00\", \"23:00\"], \"pazar\": [\"10:00\", \"23:00\"], \"carsamba\": [\"10:00\", \"23:00\"], \"persembe\": [\"10:00\", \"23:00\"], \"cumartesi\": [\"10:00\", \"23:00\"], \"pazartesi\": [\"10:00\", \"23:00\"], \"restoranHerGun\": \"off\"}', 'ali said', 'en iyi waffle', 1, 1, 41.01158900, 39.59980500, '{\"sicaklik\":13,\"nem\":77,\"ruzgar\":6,\"ikon\":\"\\u2600\\ufe0f\",\"durum\":\"A\\u00e7\\u0131k\"}', '2026-04-21 16:51:59', '');

-- --------------------------------------------------------

--
-- Table structure for table `sabit_metinler`
--

CREATE TABLE `sabit_metinler` (
  `id` int UNSIGNED NOT NULL,
  `anahtar` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dil_kodu` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `metin` text COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sabit_metinler`
--

INSERT INTO `sabit_metinler` (`id`, `anahtar`, `dil_kodu`, `metin`) VALUES
(1, 'urun_hakkinda', 'tr', 'Bu ürünümüz özel tarifimizle hazırlanmaktadır. Taze ve kaliteli malzemeler kullanılarak özenle pişirilir. Alerjen bilgisi için lütfen garsonumuzla görüşün.'),
(2, 'urun_hakkinda', 'en', 'This product is prepared with our special recipe. It is carefully cooked using fresh and quality ingredients. Please consult our waiter for allergen information.'),
(3, 'urun_hakkinda', 'zh', '该产品采用我们的特殊配方制作。使用新鲜优质的食材精心烹制。过敏原信息请咨询我们的服务员。'),
(4, 'urun_hakkinda', 'hi', 'यह उत्पाद हमारी विशेष रेसिपी से तैयार किया गया है। ताजी और गुणवत्तापूर्ण सामग्री का उपयोग करके सावधानीपूर्वक पकाया गया है। एलर्जेन जानकारी के लिए कृपया हमारे वेटर से परामर्श करें।'),
(5, 'urun_hakkinda', 'es', 'Este producto se prepara con nuestra receta especial. Se cocina cuidadosamente con ingredientes frescos y de calidad. Consulte a nuestro camarero para obtener información sobre alérgenos.'),
(6, 'urun_hakkinda', 'fr', 'Ce produit est préparé selon notre recette spéciale. Il est soigneusement cuisiné avec des ingrédients frais et de qualité. Veuillez consulter notre serveur pour les informations sur les allergènes.'),
(7, 'urun_hakkinda', 'ar', 'يتم تحضير هذا المنتج وفق وصفتنا الخاصة. يُطهى بعناية باستخدام مكونات طازجة وعالية الجودة. يرجى استشارة النادل للحصول على معلومات حول مسببات الحساسية.'),
(8, 'urun_hakkinda', 'bn', 'এই পণ্যটি আমাদের বিশেষ রেসিপি দিয়ে তৈরি। তাজা এবং মানসম্পন্ন উপাদান ব্যবহার করে যত্ন সহকারে রান্না করা হয়। অ্যালার্জেন তথ্যের জন্য আমাদের ওয়েটারের সাথে পরামর্শ করুন।'),
(9, 'urun_hakkinda', 'pt', 'Este produto é preparado com nossa receita especial. É cuidadosamente cozido com ingredientes frescos e de qualidade. Consulte nosso garçom para informações sobre alérgenos.'),
(10, 'urun_hakkinda', 'ru', 'Этот продукт готовится по нашему специальному рецепту. Он тщательно приготовлен из свежих и качественных ингредиентов. Пожалуйста, проконсультируйтесь с нашим официантом по поводу аллергенов.'),
(11, 'urun_hakkinda', 'ur', 'یہ پروڈکٹ ہماری خاص ترکیب سے تیار کیا گیا ہے۔ تازہ اور معیاری اجزاء کا استعمال کرتے ہوئے احتیاط سے پکایا گیا ہے۔ الرجن کی معلومات کے لیے براہ کرم ہمارے ویٹر سے مشورہ کریں۔'),
(12, 'urun_hakkinda', 'id', 'Produk ini disiapkan dengan resep khusus kami. Dimasak dengan hati-hati menggunakan bahan-bahan segar dan berkualitas. Silakan konsultasikan dengan pelayan kami untuk informasi alergen.'),
(13, 'urun_hakkinda', 'de', 'Dieses Produkt wird nach unserem speziellen Rezept zubereitet. Es wird sorgfältig mit frischen und hochwertigen Zutaten gekocht. Bitte fragen Sie unseren Kellner nach Allergeninformationen.'),
(14, 'urun_hakkinda', 'ja', 'この製品は特別なレシピで作られています。新鮮で高品質な食材を使用して丁寧に調理されています。アレルゲン情報については、ウェイターにご相談ください。'),
(15, 'urun_hakkinda', 'sw', 'Bidhaa hii imetayarishwa kwa mapishi yetu maalum. Imepikwa kwa uangalifu kwa kutumia viungo vipya na vya ubora. Tafadhali wasiliana na mhudumu wetu kwa habari za allergen.'),
(16, 'urun_hakkinda', 'mr', 'हे उत्पादन आमच्या विशेष रेसिपीने तयार केले आहे. ताज्या आणि दर्जेदार घटकांचा वापर करून काळजीपूर्वक शिजवले आहे. ऍलर्जन माहितीसाठी कृपया आमच्या वेटरशी सल्लामसलत करा.'),
(17, 'urun_hakkinda', 'te', 'ఈ ఉత్పత్తి మా ప్రత్యేక రెసిపీతో తయారు చేయబడింది. తాజా మరియు నాణ్యమైన పదార్థాలను ఉపయోగించి జాగ్రత్తగా వండబడింది. అలెర్జెన్ సమాచారం కోసం దయచేసి మా వెయిటర్‌ను సంప్రదించండి.'),
(18, 'urun_hakkinda', 'ko', '이 제품은 특별한 레시피로 준비됩니다. 신선하고 품질 좋은 재료를 사용하여 정성스럽게 조리됩니다. 알레르겐 정보는 직원에게 문의하세요.'),
(19, 'urun_hakkinda', 'vi', 'Sản phẩm này được chế biến theo công thức đặc biệt của chúng tôi. Được nấu cẩn thận với các nguyên liệu tươi và chất lượng. Vui lòng hỏi nhân viên phục vụ để biết thông tin về chất gây dị ứng.'),
(20, 'urun_hakkinda', 'ta', 'இந்த தயாரிப்பு எங்கள் சிறப்பு செய்முறையில் தயாரிக்கப்படுகிறது. புதிய மற்றும் தரமான பொருட்களைப் பயன்படுத்தி கவனமாக சமைக்கப்படுகிறது. ஒவ்வாமை தகவலுக்கு எங்கள் பணியாளரிடம் கலந்தாலோசிக்கவும்.'),
(21, 'urun_hakkinda', 'it', 'Questo prodotto è preparato con la nostra ricetta speciale. È cucinato con cura con ingredienti freschi e di qualità. Si prega di consultare il nostro cameriere per informazioni sugli allergeni.'),
(22, 'urun_hakkinda', 'th', 'ผลิตภัณฑ์นี้จัดทำตามสูตรพิเศษของเรา ปรุงอย่างระมัดระวังโดยใช้วัตถุดิบสดและมีคุณภาพ โปรดปรึกษาพนักงานเสิร์ฟสำหรับข้อมูลสารก่อภูมิแพ้'),
(23, 'urun_hakkinda', 'gu', 'આ ઉત્પાદન અમારી વિશેષ રેસીપી સાથે તૈયાર કરવામાં આવ્યું છે. તાજા અને ગુણવત્તાયુક્ત સામગ્રીનો ઉપયોગ કરીને કાળજીપૂર્વક રાંધવામાં આવ્યું છે. એલર્જન માહિતી માટે કૃપા કરીને અમારા વેઈટરની સલાહ લો.'),
(24, 'urun_hakkinda', 'fa', 'این محصول با دستور العمل ویژه ما تهیه می شود. با استفاده از مواد تازه و با کیفیت با دقت پخته می شود. لطفاً برای اطلاعات آلرژن با پیشخدمت ما مشورت کنید.'),
(25, 'urun_hakkinda', 'pl', 'Ten produkt jest przygotowywany według naszego specjalnego przepisu. Jest starannie gotowany ze świeżych i wysokiej jakości składników. Proszę skonsultować się z naszym kelnerem w sprawie informacji o alergenach.'),
(26, 'urun_hakkinda', 'nl', 'Dit product wordt bereid volgens ons speciale recept. Het wordt zorgvuldig gekookt met verse en kwalitatieve ingrediënten. Raadpleeg onze ober voor informatie over allergenen.'),
(27, 'urun_hakkinda', 'uk', 'Цей продукт готується за нашим спеціальним рецептом. Він ретельно приготований зі свіжих та якісних інгредієнтів. Будь ласка, проконсультуйтеся з нашим офіціантом щодо інформації про алергени.'),
(28, 'urun_hakkinda', 'ms', 'Produk ini disediakan dengan resipi istimewa kami. Dimasak dengan teliti menggunakan bahan-bahan segar dan berkualiti. Sila rujuk pelayan kami untuk maklumat alergen.'),
(29, 'urun_hakkinda', 'ro', 'Acest produs este pregătit cu rețeta noastră specială. Este gătit cu grijă folosind ingrediente proaspete și de calitate. Vă rugăm să consultați chelnerul nostru pentru informații despre alergeni.'),
(30, 'urun_hakkinda', 'el', 'Αυτό το προϊόν παρασκευάζεται με τη δική μας ειδική συνταγή. Μαγειρεύεται προσεκτικά με φρέσκα και ποιοτικά υλικά. Παρακαλώ συμβουλευτείτε τον σερβιτόρο μας για πληροφορίες σχετικά με αλλεργιογόνα.'),
(31, 'urun_hakkinda_baslik', 'tr', 'Ürün Hakkında'),
(32, 'urun_hakkinda_baslik', 'en', 'About the Product'),
(33, 'urun_hakkinda_baslik', 'zh', '关于产品'),
(34, 'urun_hakkinda_baslik', 'hi', 'उत्पाद के बारे में'),
(35, 'urun_hakkinda_baslik', 'es', 'Sobre el Producto'),
(36, 'urun_hakkinda_baslik', 'fr', 'À propos du produit'),
(37, 'urun_hakkinda_baslik', 'ar', 'حول المنتج'),
(38, 'urun_hakkinda_baslik', 'bn', 'পণ্য সম্পর্কে'),
(39, 'urun_hakkinda_baslik', 'pt', 'Sobre o Produto'),
(40, 'urun_hakkinda_baslik', 'ru', 'О продукте'),
(41, 'urun_hakkinda_baslik', 'ur', 'پروڈکٹ کے بارے میں'),
(42, 'urun_hakkinda_baslik', 'id', 'Tentang Produk'),
(43, 'urun_hakkinda_baslik', 'de', 'Über das Produkt'),
(44, 'urun_hakkinda_baslik', 'ja', '商品について'),
(45, 'urun_hakkinda_baslik', 'sw', 'Kuhusu Bidhaa'),
(46, 'urun_hakkinda_baslik', 'mr', 'उत्पादनाबद्दल'),
(47, 'urun_hakkinda_baslik', 'te', 'ఉత్పత్తి గురించి'),
(48, 'urun_hakkinda_baslik', 'ko', '제품 정보'),
(49, 'urun_hakkinda_baslik', 'vi', 'Về Sản Phẩm'),
(50, 'urun_hakkinda_baslik', 'ta', 'தயாரிப்பு பற்றி'),
(51, 'urun_hakkinda_baslik', 'it', 'Sul Prodotto'),
(52, 'urun_hakkinda_baslik', 'th', 'เกี่ยวกับสินค้า'),
(53, 'urun_hakkinda_baslik', 'gu', 'ઉત્પાદન વિશે'),
(54, 'urun_hakkinda_baslik', 'fa', 'درباره محصول'),
(55, 'urun_hakkinda_baslik', 'pl', 'O produkcie'),
(56, 'urun_hakkinda_baslik', 'nl', 'Over het product'),
(57, 'urun_hakkinda_baslik', 'uk', 'Про продукт'),
(58, 'urun_hakkinda_baslik', 'ms', 'Tentang Produk'),
(59, 'urun_hakkinda_baslik', 'ro', 'Despre produs'),
(60, 'urun_hakkinda_baslik', 'el', 'Σχετικά με το προϊόν');

-- --------------------------------------------------------

--
-- Table structure for table `urunler`
--

CREATE TABLE `urunler` (
  `id` int UNSIGNED NOT NULL,
  `restoran_id` int UNSIGNED NOT NULL,
  `productCategoryId` int UNSIGNED NOT NULL,
  `prodctImageId` int UNSIGNED DEFAULT NULL,
  `productName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `prodctPrice` decimal(10,2) NOT NULL DEFAULT '0.00',
  `prodctStatus` enum('aktif','pasif') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'aktif',
  `prodctDescription` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `urunler`
--

INSERT INTO `urunler` (`id`, `restoran_id`, `productCategoryId`, `prodctImageId`, `productName`, `prodctPrice`, `prodctStatus`, `prodctDescription`, `created_at`) VALUES
(1, 1, 16, 16, 'big mac', 250.00, 'pasif', 'test', '2025-11-03 17:10:59'),
(2, 1, 18, 13, 'test', 200.00, 'aktif', 'ürün açıklaması', '2025-11-03 20:24:49'),
(3, 1, 17, 14, 'Yumurta', 150.00, 'aktif', 'yumurtalık', '2025-11-03 20:26:00'),
(8, 1, 16, 15, 'Maxi Doyuran', 120.00, 'aktif', 'Açıklama', '2025-11-03 20:37:41'),
(9, 1, 24, 3, 'Hızlı İşlemden Ürün', 150.00, 'aktif', 'Hızlı İşlemden Ürün', '2025-12-14 09:49:50'),
(10, 11, 25, 19, 'Tavuk Burger', 180.00, 'aktif', 'Turşu, domates, ketçap, mayonez, patates kızartması ile', '2025-12-14 10:40:15'),
(11, 11, 25, 20, 'Hamburger', 172.00, 'aktif', 'Turşu, domates, ketçap, mayonez, patates kızartması ile', '2025-12-14 10:41:24'),
(12, 11, 26, 21, 'Kaşarlı Gıt-Gıt Tavuk Döner Dürüm', 165.00, 'aktif', 'Patates kızartması, sos ile hazırlanır.', '2025-12-14 10:42:31'),
(13, 11, 26, 22, 'Gıt-Gıt Tavuk Döner Dürüm', 130.00, 'aktif', 'Patates kızartması, turşu, sos, mayonez', '2025-12-14 10:43:09'),
(14, 11, 26, 23, 'Gıt-Gıt Mega Tavuk Dürüm', 150.00, 'aktif', 'Patates kızartması, turşu, sos, mayonez, çift lavaş ile', '2025-12-14 10:44:06'),
(15, 11, 26, 24, 'Gıt-Gıt Sandviç', 150.00, 'aktif', 'Patates kızartması, turşu, sos, mayonez', '2025-12-14 10:44:49'),
(16, 11, 26, 25, 'Gıt Gıt Boru Tavuk Döner Dürüm', 225.00, 'aktif', 'Patates kızartması, turşu, sos, mayonez, 3 adet lavaş ile', '2025-12-14 10:50:14'),
(17, 11, 26, 26, 'Kaşarlı Mega Tavuk Döner Dürüm', 240.00, 'aktif', 'Çift lavaşa; patates kızartması, sos', '2025-12-14 10:50:53'),
(18, 11, 26, 27, 'Duble Kaşarlı Gıt Gıt Tavuk Döner Dürüm', 264.00, 'aktif', 'Patates kızartması, turşu, sos, mayonez, duble kaşar peyniri', '2025-12-14 10:51:28'),
(19, 11, 27, 28, 'Sandviç Ekmek Arası Köfte', 150.00, 'aktif', 'Marul, domates, soğan', '2025-12-14 10:52:20'),
(20, 11, 27, 29, 'Horon Akçaabat Köfte', 250.00, 'aktif', 'Marul, domates, soğan ile', '2025-12-14 10:52:58'),
(21, 11, 28, 30, 'Patates Kızartması', 90.00, 'aktif', 'Dilimlenmiş patateslerin kızartılarak servis edildiği bir atıştırmalıktır.', '2025-12-14 10:54:07'),
(22, 11, 28, 31, 'Biber Turşusu', 8.00, 'aktif', '1 kişilik', '2025-12-14 10:54:43'),
(23, 11, 28, 32, 'Soğan Halkası (8 Adet)', 90.00, 'aktif', 'Çıtır soğan halkası', '2025-12-14 10:55:16'),
(24, 11, 28, 33, 'Nugget (6 Adet)', 90.00, 'aktif', 'Çıtır tavuk nugget', '2025-12-14 10:56:02'),
(25, 11, 28, 35, 'Tavuk Topları (12 Adet)', 90.00, 'aktif', 'Çıtır tavuk topları', '2025-12-14 10:56:37'),
(27, 11, 29, 37, 'Hamsiköy Sütlaç', 70.00, 'aktif', 'Tek kişilik', '2025-12-14 11:01:05'),
(28, 11, 30, 38, 'Coca-Cola Zero Sugar (33 cl.)', 64.00, 'aktif', 'Kutu içecek', '2025-12-14 11:02:07'),
(29, 11, 30, 38, 'Coca-Cola (33 cl.)', 64.00, 'aktif', 'Kutu içecek', '2025-12-14 11:02:41'),
(30, 11, 30, 38, 'Coca-Cola Light (33 cl.)', 64.00, 'aktif', 'Kutu içecek', '2025-12-14 11:03:04'),
(31, 11, 30, 39, 'Fanta (33 cl.)', 64.00, 'aktif', 'Kutu içecek', '2025-12-14 11:04:12'),
(32, 11, 30, 40, 'Cappy (33 cl.)', 64.00, 'aktif', 'Kutu içecek', '2025-12-14 11:04:46'),
(33, 11, 30, 41, 'Fuse Tea (33 cl.)', 64.00, 'aktif', 'Kutu içecek', '2025-12-14 11:05:17'),
(34, 11, 30, 42, 'Ayran (28,5 cl.)', 31.00, 'aktif', 'Büyük boy', '2025-12-14 11:05:46'),
(35, 11, 30, 43, 'Meyveli Soda (20 cl.)', 30.00, 'aktif', 'Cam şişe', '2025-12-14 11:06:32'),
(36, 11, 30, 44, 'Su (50 cl.)', 10.00, 'aktif', 'Pet şişe', '2025-12-14 11:07:02'),
(37, 11, 30, 45, 'Coca-Cola (1 L.)', 75.00, 'aktif', 'Pet şişe', '2025-12-14 11:07:35'),
(38, 11, 30, 46, 'Fanta (2,5 L.)', 90.00, 'aktif', 'Pet şişe', '2025-12-14 11:08:14'),
(39, 11, 30, 45, 'Coca-Cola (2,5 L.)', 89.00, 'aktif', 'Pet şişe', '2025-12-14 11:08:33'),
(40, 11, 30, 47, 'Coca-Cola (20 cl.)', 50.00, 'aktif', 'Cam şişe', '2025-12-14 11:09:00'),
(41, 11, 30, 48, 'Fanta (1 L.)', 75.00, 'aktif', 'Pet şişe', '2025-12-14 11:09:30'),
(42, 11, 30, 49, 'Sprite (33 cl.)', 50.00, 'aktif', 'Kutu içecek', '2025-12-14 11:10:02'),
(43, 11, 30, 50, 'Soda (20 cl.)', 39.00, 'aktif', 'Cam şişe', '2025-12-14 11:11:11'),
(44, 11, 31, 51, 'Mayonez (9 gr.)', 8.00, 'aktif', 'Adet olarak servis edilmektedir.', '2025-12-14 11:11:41'),
(45, 11, 31, 52, 'Ketçap (9 gr.)', 8.00, 'aktif', 'Adet olarak servis edilmektedir.', '2025-12-14 11:12:17'),
(46, 12, 32, 53, 'Mega Katık Tavuk Döner Dürüm (110 gr.)', 210.00, 'aktif', 'Marul, salatalık turşusu, patates kızartması, mayonez, sos', '2025-12-15 19:53:10'),
(47, 12, 32, 54, 'Katık Tabak', 260.00, 'aktif', 'Marul, salatalık turşusu, patates kızartması, sos, mayonez ile', '2025-12-15 19:53:47'),
(48, 12, 32, 55, 'Katık Tavuk Döner Dürüm (80 gr.)', 170.00, 'aktif', 'Marul, salatalık turşusu, patates kızartması, mayonez, sos', '2025-12-15 19:54:18'),
(49, 12, 32, 56, 'Katık Kebap Tavuk Döner (110 gr.)', 170.00, 'aktif', 'Marul, salatalık turşusu, patates kızartması, mayonez, sos', '2025-12-15 19:54:50'),
(50, 12, 33, 57, 'Mega Dürüm & Cola Menü', 340.00, 'aktif', 'Mega Tavuk Döner Dürüm + Patates Kızartması + Coca-Cola (33 cl.)', '2025-12-15 19:55:44'),
(51, 12, 33, 58, 'Dürüm & Ayran Menü', 280.00, 'aktif', 'Tavuk Döner Dürüm + Patates Kızartması + Ayran (33 cl.)', '2025-12-15 19:56:22'),
(52, 12, 33, 58, 'Mega Dürüm & Ayran Menü', 320.00, 'aktif', 'Zurna Dürüm, Cips ve Ayran İle', '2025-12-15 19:56:49'),
(53, 12, 33, 57, 'Dürüm & Cola Menü', 240.00, 'aktif', 'Tavuk Döner Dürüm + Patates Kızartması + Coca-Cola (33 cl.)', '2025-12-15 19:57:09'),
(54, 12, 33, 59, 'Katık Doyuran Menü', 480.00, 'aktif', '2 Adet Katık Tavuk Dürüm + 2 Patates Kızartması + Coca-Cola (1 L.)', '2025-12-15 19:57:37'),
(55, 12, 33, 60, 'Katık Aile Paketi', 790.00, 'aktif', '4 Adet Katık Dürüm + 2 Porsiyon Patates Kızartması+ Coca-Cola (2.5 L)', '2025-12-15 19:58:06'),
(56, 12, 34, 61, 'Yan Ürünler', 80.00, 'aktif', 'Parmak patates', '2025-12-15 19:58:46'),
(57, 12, 35, 62, 'Coca-Cola Zero Sugar (33 cl.)', 69.00, 'aktif', 'Kutu içecek', '2025-12-15 19:59:30'),
(58, 12, 35, 62, 'Coca-Cola (33 cl.)', 69.00, 'aktif', 'Kutu içecek', '2025-12-15 19:59:52'),
(59, 12, 35, 63, 'Fanta (33 cl.)', 70.00, 'aktif', 'Kutu içecek', '2025-12-15 20:00:27'),
(60, 12, 35, 64, 'Sprite (33 cl.)', 70.00, 'aktif', 'Kutu içecek', '2025-12-15 20:00:55'),
(61, 12, 35, 65, 'Cappy (33 cl.)', 70.00, 'aktif', 'Kutu içecek', '2025-12-15 20:04:36'),
(62, 12, 35, 66, 'Fuse Tea (33 cl.)', 70.00, 'aktif', 'Kutu içecek', '2025-12-15 20:07:17'),
(63, 12, 35, 67, 'Ayran (30 cl.)', 40.00, 'aktif', 'Büyük', '2025-12-15 20:07:44'),
(64, 12, 35, 68, 'Su (50 cl.)', 10.00, 'aktif', 'Pet şişe', '2025-12-15 20:08:16'),
(65, 12, 35, 69, 'Fanta (2,5 L.)', 115.00, 'aktif', 'Pet şişe', '2025-12-15 20:09:16'),
(66, 12, 35, 70, 'Coca-Cola (2,5 L.)', 100.00, 'aktif', 'Pet şişe', '2025-12-15 20:09:43'),
(67, 12, 35, 70, 'Coca-Cola (1 L.)', 80.00, 'aktif', 'Pet şişe', '2025-12-15 20:10:03'),
(68, 12, 35, 69, 'Fanta (1 L.)', 80.00, 'aktif', 'Pet şişe', '2025-12-15 20:10:20'),
(69, 13, 36, 71, 'Menemen', 200.00, 'aktif', 'Domates, biber, yumurta, isteğe göre soğanlı, peynir', '2025-12-16 21:30:20'),
(70, 13, 36, 72, 'Omlet', 200.00, 'aktif', 'Domates, salatalık, patates kızartması ile', '2025-12-16 21:30:51'),
(71, 13, 36, 73, 'Kaygana', 140.00, 'aktif', 'Domates, salatalık, patates kızartması ile', '2025-12-16 21:31:19'),
(72, 13, 36, 74, 'Kahvaltı Tabağı', 440.00, 'aktif', 'Salatalık, domates, beyaz peyniri, kaşar peyniri, burgu peynir, salam, siyah zeytin, yeşil zeytin, bal, 2 çeşit reçel', '2025-12-16 21:31:48'),
(73, 13, 37, 75, 'Kaşar Peynirli Gözleme', 240.00, 'aktif', 'Cips, salatalık, domates, zeytin ile', '2025-12-16 21:32:58'),
(74, 13, 37, 76, 'Patatesli Gözleme', 250.00, 'aktif', 'Patates kızartması, salatalık, domates, zeytin ile', '2025-12-16 21:33:29'),
(75, 13, 37, 75, 'Kıymalı Gözleme', 275.00, 'aktif', 'Patates kızartması, salatalık, domates, zeytin ile', '2025-12-16 21:33:47'),
(76, 13, 38, 77, 'Sucuklu Tost', 250.00, 'aktif', 'Dana sucuk, az kaşar peyniri. Patates kızartması, salatalık, domates ile', '2025-12-16 21:34:45'),
(77, 13, 38, 77, 'Kaşarlı Tost', 240.00, 'aktif', 'Patates kızartması, salatalık, domates ile', '2025-12-16 21:35:15'),
(78, 13, 38, 77, 'Kavurmalı Tost', 325.00, 'aktif', 'Dana kavurma, az kaşar peyniri. Patates kızartması, salatalık, domates ile', '2025-12-16 21:35:46'),
(79, 13, 38, 77, 'Akdeniz Tost', 265.00, 'aktif', 'Beyaz peynir, turşu, zeytin, domates. Patates kızartması, salatalık, domates ile', '2025-12-16 21:36:08'),
(80, 13, 38, 77, 'Bazlama Tost', 300.00, 'aktif', 'Kaşar peyniri, napoliten sos, salam,dana sucuk, domates, biber çeşitleri, patates cips, salatalık ve domates ile servis edilir', '2025-12-16 21:36:25'),
(81, 13, 38, 77, 'Karışık Tost', 275.00, 'aktif', 'Kaşar peyniri, dana sucuk. Patates kızartması, salatalık, domates ile', '2025-12-16 21:36:46'),
(82, 13, 38, 77, 'Patost', 260.00, 'aktif', 'Patates kızartması, cheddar peyniri, sucuk, kaşar peyniri. Patates kızartması, salatalık, domates ile', '2025-12-16 21:37:03'),
(83, 13, 39, 78, 'Mercimek Çorbası', 70.00, 'aktif', 'Ekmek ile', '2025-12-16 21:46:21'),
(84, 13, 39, 79, 'Lahana Çorbası', 175.00, 'aktif', 'Ekmek ile', '2025-12-16 21:46:47'),
(85, 13, 39, 80, 'Tavuklu Çorba', 150.00, 'aktif', 'Ekmek ile', '2025-12-16 21:47:18'),
(86, 13, 40, 81, 'Lahmacun', 135.00, 'aktif', 'Akdeniz yeşilliği, limon, sumaklı soğan ile', '2025-12-16 21:47:54'),
(87, 13, 40, 82, 'Kavurmalı Pide', 475.00, 'aktif', 'Dana eti, tereyağı', '2025-12-16 21:48:20'),
(88, 13, 40, 83, 'Peynirli Pide (Uzun)', 280.00, 'aktif', 'Yağsız peynir, tereyağı', '2025-12-16 21:48:44'),
(89, 13, 40, 84, 'Tavuklu Pide', 325.00, 'aktif', 'Tavuk, biber çeşitleri, domates, salça, tereyağı', '2025-12-16 21:49:17'),
(90, 13, 40, 83, 'Kaşarlı Pide', 300.00, 'aktif', 'Kaşar peyniri, tereyağı', '2025-12-16 21:49:37'),
(91, 13, 40, 85, 'Peynirli Pide (Yuvarlak)', 300.00, 'aktif', 'Yağsız peynir, tel peyniri, tereyağı', '2025-12-16 21:50:05'),
(92, 13, 40, 82, 'Kıymalı Pide (Kapalı)', 375.00, 'aktif', 'Dana kıyma, soğan, biber çeşitleri, tereyağı', '2025-12-16 21:50:27'),
(93, 13, 40, 85, 'Kıymalı Pide (Açık)', 385.00, 'aktif', 'Dana kıyma, soğan, biber çeşitleri, tereyağı', '2025-12-16 21:50:45'),
(94, 13, 40, 86, 'Yaprak Kıymalı Pide', 395.00, 'aktif', 'Yeşillik ile', '2025-12-16 21:51:55'),
(95, 13, 40, 87, 'Kuşbaşılı Pide', 395.00, 'aktif', 'Dana kuşbaşı, biber, domates, tereyağı', '2025-12-16 21:52:32'),
(96, 13, 40, 88, 'Karışık Pide', 370.00, 'aktif', 'Dana kıyma, dana kuşbaşı, pastırma, sucuk, domates, biber, kaşar peyniri, tereyağı', '2025-12-16 21:53:00'),
(97, 13, 40, 89, 'Sucuklu Pide', 360.00, 'aktif', 'Dana sucuk, tereyağı', '2025-12-16 21:53:33'),
(98, 13, 40, 90, 'Mantarlı Pide', 290.00, 'aktif', 'Mantar, biber çeşitleri, domates, tereyağı', '2025-12-16 21:53:59'),
(99, 13, 40, 91, 'Pizza Pide', 375.00, 'aktif', 'Çıtır hamur üzerine sürülen sos, sucuk, mantar, mısır, biber çeşitleri, domates, kaşar peyniri', '2025-12-16 21:54:30'),
(100, 13, 40, 92, 'Mevlana Pide', 350.00, 'aktif', 'Dana kıyma, biber, domates, küflü peynir', '2025-12-16 21:54:58'),
(101, 13, 40, 83, 'Labneli Pide', 340.00, 'aktif', 'Labne, isteğe göre bal', '2025-12-16 21:55:49'),
(102, 13, 40, 93, 'Patatesli Pide', 300.00, 'aktif', 'Patates, kaşar peyniri, tereyağı', '2025-12-16 21:56:16'),
(103, 13, 40, 94, 'Trabzon Yağlı Pide', 300.00, 'aktif', 'Tek kişilik', '2025-12-16 21:56:45'),
(104, 13, 40, 95, 'Bafra Pidesi', 380.00, 'aktif', 'Özel hazırlanmış hamur içerisine; dana kıyma, tereyağı', '2025-12-16 21:57:16'),
(105, 13, 40, 96, 'Nirvana Special Pide', 450.00, 'aktif', 'Dana kuşbaşı, dana kıyma, sucuk, domates, biber, kaşar peyniri, tereyağı', '2025-12-16 21:57:43'),
(106, 136, 162, NULL, 'Browni', 15.00, 'aktif', 'bu tatlı kakaolu bir tatlıdır ve tadı çok güzeldir', '2026-04-18 12:21:15'),
(107, 137, 163, NULL, 'sad', 40.00, 'aktif', 'felan filan intermilan', '2026-04-21 16:33:47'),
(108, 137, 163, 104, 'asd', 40.00, 'aktif', 'adasd', '2026-04-21 16:34:21'),
(109, 137, 164, 104, 'das', 50.00, 'aktif', 'adsawdawd', '2026-04-21 16:35:15'),
(110, 137, 164, 106, 'tarhana ühü', 40.00, 'aktif', 'asdads', '2026-04-21 16:35:40');

--
-- Triggers `urunler`
--
DELIMITER $$
CREATE TRIGGER `fiyat_logs` AFTER UPDATE ON `urunler` FOR EACH ROW INSERT INTO fiyat_logs (urunID,eskiFiyat,yeniFiyat) VALUES (NEW.id,OLD.prodctPrice,NEW.prodctPrice)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `urun_ceviriler`
--

CREATE TABLE `urun_ceviriler` (
  `id` int UNSIGNED NOT NULL,
  `urun_id` int UNSIGNED NOT NULL,
  `dil_kodu` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ceviri_adi` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ceviri_aciklama` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `urun_ceviriler`
--

INSERT INTO `urun_ceviriler` (`id`, `urun_id`, `dil_kodu`, `ceviri_adi`, `ceviri_aciklama`, `created_at`, `updated_at`) VALUES
(1, 106, 'en', 'brownie', 'This dessert is a cocoa dessert and it tastes very good.', '2026-04-18 12:51:10', '2026-04-18 12:51:10'),
(2, 106, 'es', 'duende', 'Este postre es un postre de cacao y sabe muy bien.', '2026-04-18 12:51:38', '2026-04-18 12:51:38'),
(3, 106, 'fr', 'lutin', 'Ce dessert est un dessert au cacao et il a très bon goût.', '2026-04-18 12:51:42', '2026-04-18 12:51:42'),
(4, 106, 'zh', '布朗尼', '这道甜点是可可甜点，味道非常好。', '2026-04-18 12:51:45', '2026-04-18 12:51:45'),
(5, 106, 'de', 'Brownie', 'Dieses Dessert ist ein Kakaodessert und schmeckt sehr gut.', '2026-04-18 13:01:03', '2026-04-18 13:01:03'),
(6, 106, 'hi', 'ब्राउनी', 'यह मिठाई एक कोको मिठाई है और इसका स्वाद बहुत अच्छा होता है.', '2026-04-18 13:05:05', '2026-04-18 13:05:05'),
(7, 106, 'pt', 'brownie', 'Esta sobremesa é uma sobremesa de cacau e tem um sabor muito bom.', '2026-04-18 13:08:52', '2026-04-18 13:08:52'),
(8, 106, 'ru', 'пирожное', 'Этот десерт представляет собой какао-десерт и имеет очень приятный вкус.', '2026-04-18 13:08:59', '2026-04-18 13:08:59'),
(9, 106, 'ja', 'ブラウニー', 'このデザートはココアデザートでとても美味しいです。', '2026-04-18 13:09:04', '2026-04-18 13:09:04'),
(10, 106, 'ro', 'brownie', 'Acest desert este un desert cu cacao și are un gust foarte bun.', '2026-04-18 13:28:58', '2026-04-18 13:28:58'),
(11, 106, 'el', 'νεράιδα', 'Αυτό το γλυκό είναι επιδόρπιο κακάο και έχει πολύ καλή γεύση.', '2026-04-18 13:29:06', '2026-04-18 13:29:06'),
(12, 106, 'gu', 'બ્રાઉની', 'આ ડેઝર્ટ કોકો ડેઝર્ટ છે અને તેનો સ્વાદ ખૂબ જ સારો છે.', '2026-04-18 13:29:12', '2026-04-18 13:29:12'),
(13, 106, 'ko', '브라우니', '이 디저트는 코코아 디저트인데 맛이 아주 좋아요.', '2026-04-18 13:45:59', '2026-04-18 13:45:59'),
(14, 106, 'ur', 'براؤنی', 'یہ میٹھا ایک کوکو میٹھا ہے اور اس کا ذائقہ بہت اچھا ہے۔', '2026-04-19 07:35:36', '2026-04-19 07:35:36'),
(15, 106, 'ar', 'كعكة براوني', 'هذه الحلوى عبارة عن حلوى كاكاو وطعمها جيد جدًا.', '2026-04-19 07:39:32', '2026-04-19 07:39:32'),
(16, 106, 'id', 'brownies', 'Makanan penutup ini adalah makanan penutup coklat dan rasanya sangat enak.', '2026-04-19 07:39:44', '2026-04-19 07:39:44'),
(17, 106, 'it', 'biscotto', 'Questo dessert è un dessert al cacao ed è molto buono.', '2026-04-19 07:45:32', '2026-04-19 07:45:32'),
(18, 106, 'mr', 'ब्राउनी', 'ही मिष्टान्न कोको मिठाई आहे आणि ती खूप छान लागते.', '2026-04-20 08:21:10', '2026-04-20 08:21:10'),
(19, 107, 'en', 'sad', 'blah blah blah intermilan', '2026-04-21 16:35:52', '2026-04-21 16:35:52'),
(20, 108, 'en', 'asd', 'adasd', '2026-04-21 16:35:54', '2026-04-21 16:35:54'),
(21, 109, 'en', 'das', 'adsawdawd', '2026-04-21 16:35:57', '2026-04-21 16:35:57'),
(22, 110, 'en', 'tarhana boo', 'asdads', '2026-04-21 16:35:59', '2026-04-21 16:35:59'),
(23, 107, 'zh', '伤心', '哈哈哈哈哈哈国际米兰', '2026-04-21 16:36:23', '2026-04-21 16:36:23'),
(24, 108, 'zh', '自闭症谱系障碍', '阿达斯德', '2026-04-21 16:36:25', '2026-04-21 16:36:25'),
(25, 109, 'zh', '达斯', '阿德萨瓦德', '2026-04-21 16:36:27', '2026-04-21 16:36:27'),
(26, 110, 'zh', '塔哈纳嘘声', '阿斯达兹', '2026-04-21 16:36:29', '2026-04-21 16:36:29'),
(27, 107, 'es', 'triste', 'bla, bla, bla, intermilán', '2026-04-21 19:24:37', '2026-04-21 19:24:37'),
(28, 108, 'es', 'asd', 'adasd', '2026-04-21 19:24:39', '2026-04-21 19:24:39'),
(29, 109, 'es', 'da', 'adsawdawd', '2026-04-21 19:24:43', '2026-04-21 19:24:43'),
(30, 110, 'es', 'boo tarhana', 'asdades', '2026-04-21 19:24:46', '2026-04-21 19:24:46');

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_restoran_dashboard`
-- (See below for the actual view)
--
CREATE TABLE `view_restoran_dashboard` (
`restoran_id` int unsigned
,`restoran_adi` varchar(255)
,`toplam_kategori` bigint
,`toplam_urun` bigint
,`ortalama_puan` decimal(8,2)
,`toplam_qr` bigint
);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attachments`
--
ALTER TABLE `attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `restoran_id` (`restoran_id`);

--
-- Indexes for table `fiyat_logs`
--
ALTER TABLE `fiyat_logs`
  ADD PRIMARY KEY (`urunID`);

--
-- Indexes for table `geri_bildirim`
--
ALTER TABLE `geri_bildirim`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_restoran_geri_bildirim` (`restoran_id`);

--
-- Indexes for table `kategoriler`
--
ALTER TABLE `kategoriler`
  ADD PRIMARY KEY (`id`),
  ADD KEY `restoranlar` (`restoran_id`),
  ADD KEY `attachments` (`image_id`);

--
-- Indexes for table `kategori_ceviriler`
--
ALTER TABLE `kategori_ceviriler`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unik_kategori_dil` (`kategori_id`,`dil_kodu`);

--
-- Indexes for table `qr_logs`
--
ALTER TABLE `qr_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_qr_logs_restoran` (`restoran_id`),
  ADD KEY `idx_qr_logs_visit_date` (`visit_date`);

--
-- Indexes for table `restoranlar`
--
ALTER TABLE `restoranlar`
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD UNIQUE KEY `mail` (`mail`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- Indexes for table `sabit_metinler`
--
ALTER TABLE `sabit_metinler`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unik_anahtar_dil` (`anahtar`,`dil_kodu`);

--
-- Indexes for table `urunler`
--
ALTER TABLE `urunler`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_urunler_kategoriler` (`productCategoryId`),
  ADD KEY `fk_urunler_restoranlar` (`restoran_id`),
  ADD KEY `fk_urunler_attachments` (`prodctImageId`);

--
-- Indexes for table `urun_ceviriler`
--
ALTER TABLE `urun_ceviriler`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unik_urun_dil` (`urun_id`,`dil_kodu`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attachments`
--
ALTER TABLE `attachments`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT for table `geri_bildirim`
--
ALTER TABLE `geri_bildirim`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=128;

--
-- AUTO_INCREMENT for table `kategoriler`
--
ALTER TABLE `kategoriler`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165;

--
-- AUTO_INCREMENT for table `kategori_ceviriler`
--
ALTER TABLE `kategori_ceviriler`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `qr_logs`
--
ALTER TABLE `qr_logs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=186;

--
-- AUTO_INCREMENT for table `restoranlar`
--
ALTER TABLE `restoranlar`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=138;

--
-- AUTO_INCREMENT for table `sabit_metinler`
--
ALTER TABLE `sabit_metinler`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `urunler`
--
ALTER TABLE `urunler`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT for table `urun_ceviriler`
--
ALTER TABLE `urun_ceviriler`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

-- --------------------------------------------------------

--
-- Structure for view `view_restoran_dashboard`
--
DROP TABLE IF EXISTS `view_restoran_dashboard`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_restoran_dashboard`  AS SELECT `r`.`id` AS `restoran_id`, `r`.`name` AS `restoran_adi`, count(distinct `k`.`id`) AS `toplam_kategori`, count(distinct `u`.`id`) AS `toplam_urun`, round(avg((((`g`.`menu_rating` + `g`.`service_rating`) + `g`.`venue_rating`) / 3)),2) AS `ortalama_puan`, count(distinct `q`.`id`) AS `toplam_qr` FROM ((((`restoranlar` `r` left join `kategoriler` `k` on((`k`.`restoran_id` = `r`.`id`))) left join `urunler` `u` on((`u`.`restoran_id` = `r`.`id`))) left join `geri_bildirim` `g` on((`g`.`restoran_id` = `r`.`id`))) left join `qr_logs` `q` on((`q`.`restoran_id` = `r`.`id`))) GROUP BY `r`.`id` ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attachments`
--
ALTER TABLE `attachments`
  ADD CONSTRAINT `fk_attachments_restoran` FOREIGN KEY (`restoran_id`) REFERENCES `restoranlar` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `fiyat_logs`
--
ALTER TABLE `fiyat_logs`
  ADD CONSTRAINT `fk_fiyat_logs_urun` FOREIGN KEY (`urunID`) REFERENCES `urunler` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `geri_bildirim`
--
ALTER TABLE `geri_bildirim`
  ADD CONSTRAINT `fk_restoran_geri_bildirim` FOREIGN KEY (`restoran_id`) REFERENCES `restoranlar` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `kategoriler`
--
ALTER TABLE `kategoriler`
  ADD CONSTRAINT `attachments` FOREIGN KEY (`image_id`) REFERENCES `attachments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `restoranlar` FOREIGN KEY (`restoran_id`) REFERENCES `restoranlar` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `kategori_ceviriler`
--
ALTER TABLE `kategori_ceviriler`
  ADD CONSTRAINT `fk_ceviriler_kategoriler` FOREIGN KEY (`kategori_id`) REFERENCES `kategoriler` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `qr_logs`
--
ALTER TABLE `qr_logs`
  ADD CONSTRAINT `fk_qr_logs_restoran` FOREIGN KEY (`restoran_id`) REFERENCES `restoranlar` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `urunler`
--
ALTER TABLE `urunler`
  ADD CONSTRAINT `fk_urunler_attachments` FOREIGN KEY (`prodctImageId`) REFERENCES `attachments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_urunler_kategoriler` FOREIGN KEY (`productCategoryId`) REFERENCES `kategoriler` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_urunler_restoranlar` FOREIGN KEY (`restoran_id`) REFERENCES `restoranlar` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `urun_ceviriler`
--
ALTER TABLE `urun_ceviriler`
  ADD CONSTRAINT `fk_ceviriler_urunler` FOREIGN KEY (`urun_id`) REFERENCES `urunler` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
