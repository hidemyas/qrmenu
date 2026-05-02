-- phpMyAdmin SQL Dump
-- QR Menu Projesi - GitHub için hazırlanmış temiz versiyon
-- Kişisel veriler temizlenmiş, sadece yapı ve sabit sistem verileri bırakılmıştır.
--
-- Host: localhost:3306
-- Server version: 8.4.3
-- PHP Version: 8.3.16

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
-- (Bu veriler sistem tarafından kullanılır, silinmemesi önerilir)
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
(53, 'urun_hakkinda_baslik', 'gu', 'ઉત્પાદน વિশે'),
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

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_restoran_dashboard`
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

ALTER TABLE `attachments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `restoran_id` (`restoran_id`);

ALTER TABLE `fiyat_logs`
  ADD PRIMARY KEY (`urunID`);

ALTER TABLE `geri_bildirim`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_restoran_geri_bildirim` (`restoran_id`);

ALTER TABLE `kategoriler`
  ADD PRIMARY KEY (`id`),
  ADD KEY `restoranlar` (`restoran_id`),
  ADD KEY `attachments` (`image_id`);

ALTER TABLE `kategori_ceviriler`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unik_kategori_dil` (`kategori_id`,`dil_kodu`);

ALTER TABLE `qr_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_qr_logs_restoran` (`restoran_id`),
  ADD KEY `idx_qr_logs_visit_date` (`visit_date`);

ALTER TABLE `restoranlar`
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD UNIQUE KEY `mail` (`mail`),
  ADD UNIQUE KEY `phone` (`phone`);

ALTER TABLE `sabit_metinler`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unik_anahtar_dil` (`anahtar`,`dil_kodu`);

ALTER TABLE `urunler`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_urunler_kategoriler` (`productCategoryId`),
  ADD KEY `fk_urunler_restoranlar` (`restoran_id`),
  ADD KEY `fk_urunler_attachments` (`prodctImageId`);

ALTER TABLE `urun_ceviriler`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unik_urun_dil` (`urun_id`,`dil_kodu`);

--
-- AUTO_INCREMENT for dumped tables
--

ALTER TABLE `attachments`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `geri_bildirim`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `kategoriler`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `kategori_ceviriler`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `qr_logs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

ALTER TABLE `restoranlar`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `sabit_metinler`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `urunler`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `urun_ceviriler`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

-- --------------------------------------------------------

--
-- Structure for view `view_restoran_dashboard`
--
DROP TABLE IF EXISTS `view_restoran_dashboard`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_restoran_dashboard` AS 
SELECT `r`.`id` AS `restoran_id`, `r`.`name` AS `restoran_adi`, 
count(distinct `k`.`id`) AS `toplam_kategori`, 
count(distinct `u`.`id`) AS `toplam_urun`, 
round(avg((((`g`.`menu_rating` + `g`.`service_rating`) + `g`.`venue_rating`) / 3)),2) AS `ortalama_puan`, 
count(distinct `q`.`id`) AS `toplam_qr` 
FROM ((((`restoranlar` `r` 
left join `kategoriler` `k` on((`k`.`restoran_id` = `r`.`id`))) 
left join `urunler` `u` on((`u`.`restoran_id` = `r`.`id`))) 
left join `geri_bildirim` `g` on((`g`.`restoran_id` = `r`.`id`))) 
left join `qr_logs` `q` on((`q`.`restoran_id` = `r`.`id`))) 
GROUP BY `r`.`id`;

--
-- Constraints for dumped tables
--

ALTER TABLE `attachments`
  ADD CONSTRAINT `fk_attachments_restoran` FOREIGN KEY (`restoran_id`) REFERENCES `restoranlar` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `fiyat_logs`
  ADD CONSTRAINT `fk_fiyat_logs_urun` FOREIGN KEY (`urunID`) REFERENCES `urunler` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `geri_bildirim`
  ADD CONSTRAINT `fk_restoran_geri_bildirim` FOREIGN KEY (`restoran_id`) REFERENCES `restoranlar` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `kategoriler`
  ADD CONSTRAINT `attachments` FOREIGN KEY (`image_id`) REFERENCES `attachments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `restoranlar` FOREIGN KEY (`restoran_id`) REFERENCES `restoranlar` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `kategori_ceviriler`
  ADD CONSTRAINT `fk_ceviriler_kategoriler` FOREIGN KEY (`kategori_id`) REFERENCES `kategoriler` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `qr_logs`
  ADD CONSTRAINT `fk_qr_logs_restoran` FOREIGN KEY (`restoran_id`) REFERENCES `restoranlar` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `urunler`
  ADD CONSTRAINT `fk_urunler_attachments` FOREIGN KEY (`prodctImageId`) REFERENCES `attachments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_urunler_kategoriler` FOREIGN KEY (`productCategoryId`) REFERENCES `kategoriler` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_urunler_restoranlar` FOREIGN KEY (`restoran_id`) REFERENCES `restoranlar` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `urun_ceviriler`
  ADD CONSTRAINT `fk_ceviriler_urunler` FOREIGN KEY (`urun_id`) REFERENCES `urunler` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;