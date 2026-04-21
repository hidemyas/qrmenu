<?php

namespace App\Models;

use Core\Database;

class RestoranUser
{
    private $db;
    // Güvenli DEĞİLDİR! Sadece örnek amaçlı sabit bir tuz.
    // Gerçek bir uygulamada rastgele, benzersiz ve veritabanında saklanan tuzlar kullanılmalıdır.
    private const SECRET_SALT = 'HidemYas_2020';

    public function __construct()
    {
        $this->db = Database::getConnection();
    }

    /**
     * Özel şifre hashleme fonksiyonu (Örnek amaçlı, üretim için güvenli DEĞİLDİR!).
     *
     * @param string $password Hashlenecek ham şifre.
     * @return string Hashlenmiş şifre.
     */
    private function customHashPassword(string $password): string
    {
        // Şifreye statik tuzu ekle ve SHA-256 ile hash'le
        // Bu, password_hash() kadar güvenli değildir çünkü salt sabittir.
        return hash('sha256', $password . self::SECRET_SALT);
    }

    /**
     * Özel şifre doğrulama fonksiyonu.
     *
     * @param string $password Kontrol edilecek ham şifre.
     * @param string $hashedPassword Veritabanından gelen hashlenmiş şifre.
     * @return bool Şifreler eşleşiyorsa true, aksi takdirde false.
     */
    private function customVerifyPassword(string $password, string $hashedPassword): bool
    {
        // Sağlanan şifreyi aynı yöntemle hash'le ve veritabanındaki hash ile karşılaştır
        return $this->customHashPassword($password) === $hashedPassword;
    }

    /**
     * Kullanıcı kimlik bilgilerini (username ve password) doğrular.
     * Artık customVerifyPassword() kullanılıyor (örnek amaçlı).
     *
     * @param string $username Kullanıcı adı.
     * @param string $password Ham şifre.
     * @return array|false Kullanıcı bulunursa kullanıcı verilerini, bulunamazsa false döndürür.
     */
    public function checkCredentials(string $username, string $password)
    {
        $stmt = $this->db->prepare("SELECT * FROM users WHERE mail = :mail LIMIT 1");
        $stmt->bindParam(':username', $username);
        $stmt->execute();
        $user = $stmt->fetch(\PDO::FETCH_ASSOC);


        if ($user && $this->customVerifyPassword($password, $user['password_hash'])) {
            // Şifre doğruysa kullanıcı verilerini döndür
            return $user;
        }

        return false; // Kullanıcı bulunamazsa veya şifre yanlışsa
    }

    /**
     * Yeni bir kullanıcı oluşturur.
     * Artık customHashPassword() kullanılıyor (örnek amaçlı).
     *
     * @param array $user_data Kullanıcı adı.
     * @param array $gunler Ham şifre.
     * @return int Yeni kullanıcının ID'si.
     */

    private function str_slug($string)
    {
        // Türkçe karakter dönüşümleri (önce!)
        $turkishMap = [
            'Ç' => 'c', 'ç' => 'c',
            'Ğ' => 'g', 'ğ' => 'g',
            'İ' => 'i', 'I' => 'i', 'ı' => 'i',
            'Ö' => 'o', 'ö' => 'o',
            'Ş' => 's', 'ş' => 's',
            'Ü' => 'u', 'ü' => 'u',
        ];

        $string = strtr($string, $turkishMap);

        // Küçük harfe çevir (UTF-8 güvenli)
        $string = mb_strtolower($string, 'UTF-8');

        // Harf, rakam ve boşluk dışındaki karakterleri temizle
        $string = preg_replace('/[^a-z0-9\s-]/', '', $string);

        // Boşlukları tire yap
        $string = preg_replace('/\s+/', '-', trim($string));

        return $string;
    }

    public function createUser(array $user_data, array $gunler)
    {
        // Şifreyi özel hash fonksiyonu ile işle
        $hashedPassword = $this->customHashPassword($user_data['password']);

        // slug oluştur
//        $slug = strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $user_data['name'])));

        $slug = $this->str_slug($user_data['name']);

        // slug çakışmasını kontrol et
        $check = $this->db->prepare("SELECT COUNT(*) FROM restoranlar WHERE slug = :slug");
        $check->execute([':slug' => $slug]);
        $count = $check->fetchColumn();

        if ($count > 0) {
            $slug .= '-' . substr(uniqid(), -4); // örn: "awdaw-3f9a"
        }


        // Günleri JSON’a dönüştür
        $gunlerJson = json_encode($gunler, JSON_UNESCAPED_UNICODE);

        // SQL sorgusu
        $sql = "INSERT INTO restoranlar 
            (slug, adres, sehir, ilce, mail, phone, password, gunler, name, slogan, status)
            VALUES 
            (:slug, :adres, :sehir, :ilce, :mail, :phone, :password, :gunler, :name, :slogan, :status)";

        $stmt = $this->db->prepare($sql);

        // Parametreleri bağla
        $stmt->bindValue(':slug', $slug);
        $stmt->bindValue(':adres', $user_data['adres']);
        $stmt->bindValue(':sehir', $user_data['sehir']);
        $stmt->bindValue(':ilce', $user_data['ilce']);
        $stmt->bindValue(':mail', $user_data['mail']);
        $stmt->bindValue(':phone', $user_data['phone']);
        $stmt->bindValue(':password', $hashedPassword);
        $stmt->bindValue(':gunler', $gunlerJson);
        $stmt->bindValue(':name', $user_data['name']);
        $stmt->bindValue(':slogan', $user_data['slogan']);
        $stmt->bindValue(':status', 1); // varsayılan aktif kayıt

        $stmt->execute();

        return $this->db->lastInsertId();
    }

    /**
     * Kullanıcının ddaha önce kayıt açmış olup olmadığını kontrol eder.
     *
     * @return bool Kullanıcı kayıt açmışsa true, değilse false.
     */
    public function userExists(string $mail,string $phone): bool
    {
        $stmt = $this->db->prepare("SELECT id FROM restoranlar WHERE mail = :mail OR  phone = :phone LIMIT 1");
        $stmt->execute([':mail' => $mail,':phone' => $phone]);
        return $stmt->fetch() ? true : false;
    }



    /**
     * Kullanıcının oturum açmış olup olmadığını kontrol eder.
     *
     * @return bool Kullanıcı oturum açmışsa true, değilse false.
     */
    public static function isLoggedIn(): bool
    {
        return isset($_SESSION['user_id']);
    }

    /**
     * Restoranın aktif olup olmadığını kontrol eder
     *
     * @return bool Kullanıcı restoran  aktifse true, değilse false.
     */

    public function isActiveRestoran(): bool
    {
        if (!isset($_SESSION['user_id'])) {
            return false;
        }

        $user_id = (int) $_SESSION['user_id'];
        $stmt = $this->db->prepare('SELECT status FROM restoranlar WHERE id = :id LIMIT 1');
        $stmt->bindParam(':id', $user_id);
        $stmt->execute();
        $status = $stmt->fetchColumn();
        return $status;
    }



    /**
     * Restoranın var olup olmadığını kontrol eder
     *
     * @return bool Kullanıcı restoran  varsa true, değilse false.
     */

    public function checkRestoran($restoran_slug): bool
    {

        $stmt = $this->db->prepare('SELECT status FROM restoranlar WHERE slug = :slug LIMIT 1');
        $stmt->bindParam(':slug', $restoran_slug);
        $stmt->execute();
        $status = $stmt->fetchColumn();
        return $status;
    }



    /**
     * Restoranın id değerini geri döndürür
     *
     * @return array restoran kayıt id değeri
     */

    public function getRestoranID($restoran_slug): array
    {

        $stmt = $this->db->prepare('SELECT id FROM restoranlar WHERE slug = :slug LIMIT 1');
        $stmt->bindParam(':slug', $restoran_slug);
        $stmt->execute();
        $restoran_id = $stmt->fetch(\PDO::FETCH_ASSOC);
        return $restoran_id;
    }



    /**
     * Restoranın kayıtını
     *
     * @return array restoran datasını
     */

    public function getRestoran($restoran_id): array
    {

        $stmt = $this->db->prepare('SELECT * FROM restoranlar WHERE id = :id LIMIT 1');
        $stmt->bindParam(':id', $restoran_id);
        $stmt->execute();
        return $stmt->fetch(\PDO::FETCH_ASSOC);

    }



    /**
     * QR üzerinden restorana yapılan ziyareti loglar.
     *
     * @return bool
     */
    public function logQrVisit($restoran_id): bool
    {


        $restoranID = (int)  $restoran_id;

        // IP adresi
        $ipAddress = $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';

        // User agent
        $userAgent = $_SERVER['HTTP_USER_AGENT'] ?? null;

        // Basit cihaz tespiti
        $deviceInfo = 'Desktop';
        if (preg_match('/mobile/i', $userAgent)) {
            $deviceInfo = 'Mobile';
        } elseif (preg_match('/tablet|ipad/i', $userAgent)) {
            $deviceInfo = 'Tablet';
        }

        // Gün bilgisi
        $visitDate = date('Y-m-d');

        // Restoran var mı kontrolü
        $check = $this->db->prepare("
        SELECT COUNT(*) FROM restoranlar WHERE id = :id
    ");
        $check->execute([':id' => $restoranID]);

        if ($check->fetchColumn() == 0) {
            return false;
        }

        // Log ekle
        $stmt = $this->db->prepare("
        INSERT INTO qr_logs
        (restoran_id, ip_address, device_info, user_agent, visit_date)
        VALUES
        (:restoran_id, :ip_address, :device_info, :user_agent, :visit_date)
    ");

        return $stmt->execute([
            ':restoran_id' => $restoranID,
            ':ip_address'  => $ipAddress,
            ':device_info' => $deviceInfo,
            ':user_agent'  => $userAgent,
            ':visit_date'  => $visitDate
        ]);
    }


    public function uploadAttachment(): array
    {
        // JSON tipi çıktı döneceğiz
        header('Content-Type: application/json; charset=utf-8');

        // --- 1. Dosya kontrolü ---
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return [
                'success' => false,
                'message' => 'Yalnızca POST isteği kabul edilir.'
            ];
        }

        if (!isset($_POST['restoranId']) || !ctype_digit((string)$_POST['restoranId'])) {
            return [
                'success' => false,
                'message' => 'Geçerli bir restoranId belirtilmelidir.'
            ];
        }

        $restoranId = $_SESSION['user_id'];

        if (!isset($_FILES['image'])) {
            return [
                'success' => false,
                'message' => 'Yüklenecek dosya bulunamadı.'
            ];
        }

        $file = $_FILES['image'];
        if ($file['error'] !== UPLOAD_ERR_OK) {
            return [
                'success' => false,
                'message' => 'Yükleme hatası oluştu. Kod: ' . $file['error']
            ];
        }

        // --- 2. Dosya türü & boyut kontrolü ---
        $maxSize = 5 * 1024 * 1024; // 5 MB
        if ($file['size'] > $maxSize) {
            return [
                'success' => false,
                'message' => 'Dosya boyutu en fazla 5 MB olabilir.'
            ];
        }

        $allowedMime = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        $finfo = new \finfo(FILEINFO_MIME_TYPE);
        $mime = $finfo->file($file['tmp_name']);

        if (!in_array($mime, $allowedMime, true)) {
            return [
                'success' => false,
                'message' => 'Desteklenmeyen dosya türü: ' . $mime
            ];
        }

        // --- 3. Klasör oluşturma ---
        $uploadDir = __DIR__ . '/../../public/share';
        if (!is_dir($uploadDir)) {
            if (!mkdir($uploadDir, 0755, true)) {
                return [
                    'success' => false,
                    'message' => 'Yükleme klasörü oluşturulamadı.'
                ];
            }
        }

        // --- 4. Benzersiz dosya adı ---
        $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
        $uniqueName = bin2hex(random_bytes(16)) . '.' . strtolower($ext);
        $targetPath = $uploadDir . '/' . $uniqueName;

        if (!move_uploaded_file($file['tmp_name'], $targetPath)) {
            return [
                'success' => false,
                'message' => 'Dosya taşınamadı.'
            ];
        }

        // --- 5. Restoran var mı kontrol et ---
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM restoranlar WHERE id = :id");
        $stmt->execute([':id' => $restoranId]);
        if ($stmt->fetchColumn() == 0) {
            // Dosyayı geri sil
            @unlink($targetPath);
            return [
                'success' => false,
                'message' => 'Restoran bulunamadı.'
            ];
        }

        // --- 6. DB Kaydı ---
        $relativePath = 'public/share/' . $uniqueName;
        $baseUrl = (isset($_SERVER['REQUEST_SCHEME']) ? $_SERVER['REQUEST_SCHEME'] : 'https') . '://' . $_SERVER['HTTP_HOST'];
        $fileUrl = $baseUrl . '/public/share/' . $uniqueName;

        $insert = $this->db->prepare("
        INSERT INTO attachments (restoran_id, file_name, original_name, file_path, file_url, mime_type, file_size)
        VALUES (:restoran_id, :file_name, :original_name, :file_path, :file_url, :mime_type, :file_size)
    ");

        $insert->execute([
            ':restoran_id' => $restoranId,
            ':file_name' => $uniqueName,
            ':original_name' => $file['name'],
            ':file_path' => $relativePath,
            ':file_url' => $fileUrl,
            ':mime_type' => $mime,
            ':file_size' => $file['size']
        ]);

        $attachmentId = $this->db->lastInsertId();

        // --- 7. Başarılı dönüş ---
        return [
            'success' => true,
            'message' => 'Resim başarıyla yüklendi.',
            'data' => [
                'imageId' => (int)$attachmentId,
                'url' => $fileUrl,
                'path' => $relativePath,
                'mime' => $mime,
                'size' => $file['size']
            ]
        ];
    }


    /**
     * Yeni bir kategori ekler.
     *
     * @return array JSON uyumlu sonuç dizisi
     */
    public function addCategory(): array
    {
        header('Content-Type: application/json; charset=utf-8');

        // --- 1. İstek kontrolü ---
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return [
                'success' => false,
                'message' => 'Yalnızca POST isteği kabul edilir.'
            ];
        }

        // --- 2. Kullanıcı (restoran) oturum kontrolü ---
        if (!isset($_SESSION['user_id'])) {
            return [
                'success' => false,
                'message' => 'Oturum bulunamadı. Lütfen giriş yapın.'
            ];
        }

        $restoranId = (int) $_SESSION['user_id'];

        // --- 3. Gerekli alanları kontrol et ---
        $catName = $_POST['catName'] ?? null;
        $catImageId = $_POST['catImageId'] ?? null;
        $catStatus = $_POST['catStatus'] ?? 'aktif';

        if (empty($catName)) {
            return [
                'success' => false,
                'message' => 'Kategori adı boş olamaz.'
            ];
        }

        if (!in_array($catStatus, ['aktif', 'pasif'], true)) {
            return [
                'success' => false,
                'message' => 'Geçersiz kategori durumu.'
            ];
        }

        // --- 4. Restoran doğrulaması ---
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM restoranlar WHERE id = :id");
        $stmt->execute([':id' => $restoranId]);
        if ($stmt->fetchColumn() == 0) {
            return [
                'success' => false,
                'message' => 'Geçersiz restoran ID.'
            ];
        }

        // --- 5. Görsel ID doğrulaması (isteğe bağlı) ---
        if (!empty($catImageId)) {
            $stmt = $this->db->prepare("SELECT COUNT(*) FROM attachments WHERE id = :id");
            $stmt->execute([':id' => $catImageId]);
            if ($stmt->fetchColumn() == 0) {
                return [
                    'success' => false,
                    'message' => 'Geçersiz resim ID (attachments tablosunda bulunamadı).'
                ];
            }
        }

        // --- 6. Veritabanına ekleme ---
        $insert = $this->db->prepare("
            INSERT INTO kategoriler (restoran_id, image_id, kategori_adi, durum)
            VALUES (:restoran_id, :image_id, :kategori_adi, :durum)
        ");

        $insert->execute([
            ':restoran_id' => $restoranId,
            ':image_id' => $catImageId ?: null,
            ':kategori_adi' => trim($catName),
            ':durum' => $catStatus
        ]);

        $categoryId = $this->db->lastInsertId();

        // --- 7. Başarılı dönüş ---
        return [
            'success' => true,
            'message' => 'Kategori başarıyla eklendi.',
            'data' => [
                'categoryId' => (int)$categoryId,
                'categoryName' => $catName,
                'imageId' => (int)$catImageId,
                'status' => $catStatus
            ]
        ];
    }


    /**
     * Kullanıcının yüklediği resimleri listeler.
     *
     * @return array Kullanıcının yüklediği resimlerin listesi (boşsa boş dizi döner)
     */
    public function getUserImages(): array
    {
        // Kullanıcı oturumu açık mı kontrol et
        if (!isset($_SESSION['user_id'])) {
            return [];
        }

        $user_id = (int) $_SESSION['user_id'];

        // Resimlerin tutulduğu tablo: "user_images" varsayıldı
        // Kolonlar: id, user_id, image_path, uploaded_at
        $stmt = $this->db->prepare('SELECT id, file_url, created_at 
                                    FROM attachments 
                                    WHERE restoran_id = :restoran_id 
                                    ORDER BY created_at DESC');
        $stmt->bindParam(':restoran_id', $user_id);
        $stmt->execute();

        // Verileri dizi olarak döndür
        $images = $stmt->fetchAll(\PDO::FETCH_ASSOC);
        return $images ?: [];
    }

    /**
     * İlgili restorana ait kategorileri ve kategori resimlerini listeler.
     *
     * @return array Kategori listesi, resim bilgisi ile birlikte
     */
    public function getRestoranCategories($restoranId=null): array
    {

        if ($restoranId==null){
            $restoranId = (int) $_SESSION['user_id'];

            // Kullanıcı oturumu açık mı kontrol et
            if (!isset($_SESSION['user_id'])) {
                return [];
            }

            // SQL sorgusu: kategoriler ve ilişkili resim bilgisi
            $stmt = $this->db->prepare("
            SELECT 
                k.id AS kategori_id,
                k.kategori_adi,
                k.durum AS kategori_durumu,
                k.restoran_id,
            
                a.id AS image_id,
                a.file_name,
                a.original_name,
                a.file_url,
                a.mime_type,
                a.file_size,
            
                COUNT(u.id) AS urun_sayisi
            
            FROM kategoriler k
            
            LEFT JOIN attachments a 
                ON k.image_id = a.id
            
            LEFT JOIN urunler u
                ON u.productCategoryId = k.id
                AND u.restoran_id = k.restoran_id 
                AND u.prodctStatus = 'aktif'
            
            WHERE k.restoran_id = :restoran_id  
            
            GROUP BY 
                k.id,
                k.kategori_adi,
                k.durum,
                k.restoran_id,
                a.id,
                a.file_name,
                a.original_name,
                a.file_url,
                a.mime_type,
                a.file_size
            
            ORDER BY k.created_at DESC;

    ");
        }else{
            // SQL sorgusu: kategoriler ve ilişkili resim bilgisi
            $stmt = $this->db->prepare("
            SELECT 
                k.id AS kategori_id,
                k.kategori_adi,
                k.durum AS kategori_durumu,
                k.restoran_id,
            
                a.id AS image_id,
                a.file_name,
                a.original_name,
                a.file_url,
                a.mime_type,
                a.file_size,
            
                COUNT(u.id) AS urun_sayisi
            
            FROM kategoriler k
            
            LEFT JOIN attachments a 
                ON k.image_id = a.id
            
            LEFT JOIN urunler u
                ON u.productCategoryId = k.id
                AND u.restoran_id = k.restoran_id 
                AND u.prodctStatus = 'aktif'
            
            WHERE k.restoran_id = :restoran_id 
                AND k.durum = 'aktif'
            
            GROUP BY 
                k.id,
                k.kategori_adi,
                k.durum,
                k.restoran_id,
                a.id,
                a.file_name,
                a.original_name,
                a.file_url,
                a.mime_type,
                a.file_size
            
            ORDER BY k.created_at DESC;

    ");
        }




        $stmt->bindParam(':restoran_id', $restoranId, \PDO::PARAM_INT);
        $stmt->execute();

        $categories = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        return $categories ?: [];
    }

    /**
     * Belirli bir kategori ID'sine ait bilgileri getirir.
     *
     * @param int $catId Kategori ID
     * @return array Kategori bilgisi veya hata mesajı
     */
    public function getCategoryInfo(): array
    {

        if (!isset($_POST['catId']) || !ctype_digit((string)$_POST['catId'])) {
            return [
                'success' => false,
                'message' => 'Geçerli bir kategori ID belirtilmelidir.'
            ];
        }
        $catId = (int) $_POST['catId'];

        // Oturum kontrolü
        if (!isset($_SESSION['user_id'])) {
            return [
                'success' => false,
                'message' => 'Oturum bulunamadı.'
            ];
        }

        $restoranId = (int) $_SESSION['user_id'];

        // SQL: kategori ve ilişkili resim bilgisi
        $stmt = $this->db->prepare("
        SELECT 
            k.id AS kategori_id,
            k.kategori_adi,
            k.durum AS kategori_durumu,
            k.restoran_id,
            a.id AS image_id,
            a.file_name,
            a.original_name,
            a.file_url,
            a.mime_type,
            a.file_size
        FROM kategoriler k
        LEFT JOIN attachments a 
            ON k.image_id = a.id
        WHERE k.id = :catId AND k.restoran_id = :restoran_id
        LIMIT 1
    ");

        $stmt->execute([
            ':catId' => $catId,
            ':restoran_id' => $restoranId
        ]);

        $category = $stmt->fetch(\PDO::FETCH_ASSOC);

        if (!$category) {
            return [
                'success' => false,
                'message' => 'Kategori bulunamadı.'
            ];
        }

        return [
            'success' => true,
            'data' => $category,
            'message' => 'Kategori bilgisi getirildi.'
        ];
    }

    /**
     * Belirli bir kategori ID'sine göre veri getirir ve günceller.
     *
     * @return array JSON uyumlu sonuç dizisi
     */
    public function updateCategory(): array
    {
        header('Content-Type: application/json; charset=utf-8');

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return [
                'success' => false,
                'message' => 'Yalnızca POST isteği kabul edilir.'
            ];
        }

        if (!isset($_POST['catId']) || !ctype_digit((string)$_POST['catId'])) {
            return [
                'success' => false,
                'message' => 'Geçerli bir kategori ID belirtilmelidir.'
            ];
        }

        $catId = (int) $_POST['catId'];
        $restoranId = (int) $_SESSION['user_id'] ?? 0;

        if (!$restoranId) {
            return [
                'success' => false,
                'message' => 'Oturum bulunamadı.'
            ];
        }

        // --- 1. Kategori var mı kontrol ---
        $stmt = $this->db->prepare("
        SELECT * FROM kategoriler 
        WHERE id = :catId AND restoran_id = :restoran_id
        LIMIT 1
    ");
        $stmt->execute([
            ':catId' => $catId,
            ':restoran_id' => $restoranId
        ]);
        $category = $stmt->fetch(\PDO::FETCH_ASSOC);

        if (!$category) {
            return [
                'success' => false,
                'message' => 'Kategori bulunamadı.'
            ];
        }

        // --- 2. Güncelleme verilerini al ---
        $catName = $_POST['catName'] ?? $category['kategori_adi'];
        $catImageId = $_POST['catImageId'] ?? $category['image_id'];
        $catStatus = $_POST['catStatus'] ?? $category['durum'];

        if (!in_array($catStatus, ['aktif', 'pasif'], true)) {
            return [
                'success' => false,
                'message' => 'Geçersiz kategori durumu.'
            ];
        }

        // --- 3. Eğer catImageId dolu ise attachments tablosunda kontrol et ---
        if ($catImageId) {
            $stmt = $this->db->prepare("SELECT COUNT(*) FROM attachments WHERE id = :id");
            $stmt->execute([':id' => $catImageId]);
            if ($stmt->fetchColumn() == 0) {
                return [
                    'success' => false,
                    'message' => 'Geçersiz resim ID.'
                ];
            }
        }

        // --- 4. Güncelle ---
        $update = $this->db->prepare("
        UPDATE kategoriler
        SET kategori_adi = :kategori_adi,
            image_id = :image_id,
            durum = :durum
        WHERE id = :catId AND restoran_id = :restoran_id
    ");

        $update->execute([
            ':kategori_adi' => trim($catName),
            ':image_id' => $catImageId ?: null,
            ':durum' => $catStatus,
            ':catId' => $catId,
            ':restoran_id' => $restoranId
        ]);

        // --- 5. Başarılı dönüş ---
        return [
            'success' => true,
            'message' => 'Kategori güncellendi.',
            'data' => [
                'categoryId' => $catId,
                'categoryName' => $catName,
                'imageId' => $catImageId,
                'status' => $catStatus
            ]
        ];
    }


    /**
     * Belirli bir kategori ID'sine göre kategoriyi siler.
     *
     * @return array JSON uyumlu sonuç dizisi
     */
    public function deleteCategory(): array
    {
        header('Content-Type: application/json; charset=utf-8');

        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return [
                'success' => false,
                'message' => 'Yalnızca POST isteği kabul edilir.'
            ];
        }

        if (!isset($_POST['catId']) || !ctype_digit((string)$_POST['catId'])) {
            return [
                'success' => false,
                'message' => 'Geçerli bir kategori ID belirtilmelidir.'
            ];
        }

        $catId = (int) $_POST['catId'];
        $restoranId = (int) $_SESSION['user_id'] ?? 0;

        if (!$restoranId) {
            return [
                'success' => false,
                'message' => 'Oturum bulunamadı.'
            ];
        }

        // --- 1. Kategori var mı kontrol ---
        $stmt = $this->db->prepare("
        SELECT * FROM kategoriler 
        WHERE id = :catId AND restoran_id = :restoran_id
        LIMIT 1
    ");
        $stmt->execute([
            ':catId' => $catId,
            ':restoran_id' => $restoranId
        ]);
        $category = $stmt->fetch(\PDO::FETCH_ASSOC);

        if (!$category) {
            return [
                'success' => false,
                'message' => 'Kategori bulunamadı.'
            ];
        }



        // --- 4. Güncelle ---
        $update = $this->db->prepare("
        DELETE FROM kategoriler  WHERE id = :catId AND restoran_id = :restoran_id
    ");

        $update->execute([
            ':catId' => $catId,
            ':restoran_id' => $restoranId
        ]);

        // --- 5. Başarılı dönüş ---
        return [
            'success' => true,
            'message' => 'Kategori Silindi.',
            'data' => [
                'categoryId' => $catId
            ]
        ];
    }

    /**
     * Yeni bir ürün ekler.
     *
     * @return array JSON uyumlu sonuç dizisi
     */
    public function addProduct(): array
    {
        header('Content-Type: application/json; charset=utf-8');

        // --- 1. İstek kontrolü ---
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return [
                'success' => false,
                'message' => 'Yalnızca POST isteği kabul edilir.'
            ];
        }

        // --- 2. Kullanıcı (restoran) oturum kontrolü ---
        if (!isset($_SESSION['user_id'])) {
            return [
                'success' => false,
                'message' => 'Oturum bulunamadı. Lütfen giriş yapın.'
            ];
        }

        $restoranId = (int) $_SESSION['user_id'];

        // --- 3. Gerekli alanları al ve kontrol et ---
        $productName        = $_POST['productName']        ?? null;
        $productCategoryId  = $_POST['productCategoryId']  ?? null;
        $prodctPrice        = $_POST['prodctPrice']        ?? 0;
        $prodctStatus       = $_POST['prodctStatus']       ?? 'aktif';
        $prodctDescription  = $_POST['prodctDescription']  ?? null;
        $prodctImageId      = $_POST['prodctImageId']      ?? null;

        if (empty($productName)) {
            return [
                'success' => false,
                'message' => 'Ürün adı boş olamaz.'
            ];
        }

        if (empty($productCategoryId)) {
            return [
                'success' => false,
                'message' => 'Kategori ID boş olamaz.'
            ];
        }

        if (!is_numeric($prodctPrice) || $prodctPrice < 0) {
            return [
                'success' => false,
                'message' => 'Geçersiz ürün fiyatı.'
            ];
        }

        if (!in_array($prodctStatus, ['aktif', 'pasif'], true)) {
            return [
                'success' => false,
                'message' => 'Geçersiz ürün durumu.'
            ];
        }

        // --- 4. Restoran doğrulaması ---
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM restoranlar WHERE id = :id");
        $stmt->execute([':id' => $restoranId]);
        if ($stmt->fetchColumn() == 0) {
            return [
                'success' => false,
                'message' => 'Geçersiz restoran ID.'
            ];
        }

        // --- 5. Kategori doğrulaması ---
        $stmt = $this->db->prepare("SELECT COUNT(*) FROM kategoriler WHERE id = :id");
        $stmt->execute([':id' => $productCategoryId]);
        if ($stmt->fetchColumn() == 0) {
            return [
                'success' => false,
                'message' => 'Geçersiz kategori ID (kategoriler tablosunda bulunamadı).'
            ];
        }

        // --- 6. Görsel (isteğe bağlı) doğrulaması ---
        if (!empty($prodctImageId)) {
            $stmt = $this->db->prepare("SELECT COUNT(*) FROM attachments WHERE id = :id");
            $stmt->execute([':id' => $prodctImageId]);
            if ($stmt->fetchColumn() == 0) {
                return [
                    'success' => false,
                    'message' => 'Geçersiz resim ID (attachments tablosunda bulunamadı).'
                ];
            }
        }

        // --- 7. Veritabanına ekleme ---
        $insert = $this->db->prepare("
        INSERT INTO urunler 
        (restoran_id, productCategoryId, prodctImageId, productName, prodctPrice, prodctStatus, prodctDescription)
        VALUES 
        (:restoran_id, :productCategoryId, :prodctImageId, :productName, :prodctPrice, :prodctStatus, :prodctDescription)
    ");

        $insert->execute([
            ':restoran_id'        => $restoranId,
            ':productCategoryId'  => $productCategoryId,
            ':prodctImageId'      => $prodctImageId ?: null,
            ':productName'        => trim($productName),
            ':prodctPrice'        => $prodctPrice,
            ':prodctStatus'       => $prodctStatus,
            ':prodctDescription'  => trim($prodctDescription)
        ]);

        $productId = $this->db->lastInsertId();

        // --- 8. Başarılı dönüş ---
        return [
            'success' => true,
            'message' => 'Ürün başarıyla eklendi.',
            'data' => [
                'productId'        => (int)$productId,
                'productName'      => $productName,
                'productCategoryId'=> (int)$productCategoryId,
                'prodctPrice'      => (float)$prodctPrice,
                'prodctStatus'     => $prodctStatus,
                'prodctDescription'=> $prodctDescription,
                'prodctImageId'    => $prodctImageId ? (int)$prodctImageId : null
            ]
        ];
    }

    /**
     * İlgili restorana ait ürünleri, ürün görsellerini ve kategori bilgilerini listeler.
     *
     * @return array Ürün listesi (kategori ve görsel dahil)
     */
    public function getRestoranProducts(): array
    {
        // Oturum kontrolü
        if (!isset($_SESSION['user_id'])) {
            return [];
        }

        $restoranId = (int) $_SESSION['user_id'];

        // --- Ürünleri kategori ve görsel bilgileriyle birlikte çek ---
        $stmt = $this->db->prepare("
        SELECT 
            u.id AS urun_id,
            u.productName,
            u.prodctPrice,
            u.prodctDescription,
            u.prodctStatus,
            u.created_at,

            -- Ürün görseli
            ua.id AS urun_image_id,
            ua.file_name AS urun_file_name,
            ua.file_url AS urun_file_url,
            ua.mime_type AS urun_mime_type,
            ua.file_size AS urun_file_size,

            -- Kategori bilgisi
            k.id AS kategori_id,
            k.kategori_adi,
            k.durum AS kategori_durumu,

            -- Kategori görseli
            ka.id AS kategori_image_id,
            ka.file_name AS kategori_file_name,
            ka.file_url AS kategori_file_url

        FROM urunler u
        LEFT JOIN kategoriler k ON u.productCategoryId = k.id
        LEFT JOIN attachments ua ON u.prodctImageId = ua.id
        LEFT JOIN attachments ka ON k.image_id = ka.id
        WHERE u.restoran_id = :restoran_id
        ORDER BY   u.created_at DESC
    ");

        $stmt->bindParam(':restoran_id', $restoranId, \PDO::PARAM_INT);
        $stmt->execute();

        $products = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        return $products ?: [];
    }

    /*
     * Ürün status güncelleme aktif/pasif
     * */
    public function toggleProductStatus(): array
    {
        header('Content-Type: application/json; charset=utf-8');

        // 1) Gerekli POST değerleri var mı?
        if (
            !isset($_POST['productId']) ||
            !ctype_digit((string)$_POST['productId']) ||
            !isset($_POST['productStatus'])
        ) {
            return [
                'success' => false,
                'message' => 'Geçerli bir ürün ID ve status belirtilmelidir.'
            ];
        }

        $productId = (int) $_POST['productId'];
        $newStatus = trim($_POST['productStatus']);

        // 2) Status değeri kontrolü
        if (!in_array($newStatus, ['aktif', 'pasif'], true)) {
            return [
                'success' => false,
                'message' => 'Geçersiz ürün durumu.'
            ];
        }

        // 3) Oturum kontrolü
        if (!isset($_SESSION['user_id'])) {
            return [
                'success' => false,
                'message' => 'Oturum bulunamadı.'
            ];
        }

        $restoranId = (int) $_SESSION['user_id'];

        // 4) Ürün gerçekten bu restorana mı ait kontrolü
        $check = $this->db->prepare("
        SELECT COUNT(*) FROM urunler 
        WHERE id = :id AND restoran_id = :restoran_id
    ");

        $check->execute([
            ':id' => $productId,
            ':restoran_id' => $restoranId
        ]);

        if ($check->fetchColumn() == 0) {
            return [
                'success' => false,
                'message' => 'Bu ürün bulunamadı veya size ait değil.'
            ];
        }

        // 5) Güncelleme işlemi
        $update = $this->db->prepare("
        UPDATE urunler
        SET prodctStatus = :status
        WHERE id = :id AND restoran_id = :restoran_id
    ");

        $updateResult = $update->execute([
            ':status' => $newStatus,
            ':id' => $productId,
            ':restoran_id' => $restoranId
        ]);

        if (!$updateResult) {
            return [
                'success' => false,
                'message' => 'Durum güncellenirken bir hata oluştu.'
            ];
        }

        // 6) Başarılı dönüş
        return [
            'success' => true,
            'message' => 'Ürün durumu güncellendi.',
            'data' => [
                'productId' => $productId,
                'newStatus' => $newStatus
            ]
        ];
    }


    public function getProductInfo(): array
    {
        header('Content-Type: application/json; charset=utf-8');

        // 1) productId kontrolü
        if (!isset($_POST['productId']) || !ctype_digit((string)$_POST['productId'])) {
            return [
                'success' => false,
                'message' => 'Geçerli bir ürün ID belirtilmelidir.'
            ];
        }
        $productId = (int) $_POST['productId'];

        // 2) Oturum kontrolü
        if (!isset($_SESSION['user_id'])) {
            return [
                'success' => false,
                'message' => 'Oturum bulunamadı.'
            ];
        }

        $restoranId = (int) $_SESSION['user_id'];

        // 3) SQL — Ürün, kategori ve görseller dahil
        $stmt = $this->db->prepare("
        SELECT 
            u.id AS urun_id,
            u.productName,
            u.prodctPrice,
            u.prodctDescription,
            u.prodctStatus,
            u.created_at,

            -- Ürün görseli
            ua.id AS urun_image_id,
            ua.file_name AS urun_file_name,
            ua.file_url AS urun_file_url,
            ua.mime_type AS urun_mime_type,
            ua.file_size AS urun_file_size,

            -- Kategori bilgisi
            k.id AS kategori_id,
            k.kategori_adi,
            k.durum AS kategori_durumu,

            -- Kategori görseli
            ka.id AS kategori_image_id,
            ka.file_name AS kategori_file_name,
            ka.file_url AS kategori_file_url,
            ka.mime_type AS kategori_mime_type,
            ka.file_size AS kategori_file_size

        FROM urunler u
        LEFT JOIN kategoriler k 
            ON u.productCategoryId = k.id
        LEFT JOIN attachments ua 
            ON u.prodctImageId = ua.id
        LEFT JOIN attachments ka 
            ON k.image_id = ka.id
        WHERE u.id = :productId 
            AND u.restoran_id = :restoranId
        LIMIT 1
    ");

        $stmt->execute([
            ':productId' => $productId,
            ':restoranId' => $restoranId
        ]);

        $product = $stmt->fetch(\PDO::FETCH_ASSOC);

        // 4) Bulunamadıysa
        if (!$product) {
            return [
                'success' => false,
                'message' => 'Ürün bulunamadı.'
            ];
        }

        // 5) Başarılı dönüş
        return [
            'success' => true,
            'data' => $product,
            'message' => 'Ürün bilgisi getirildi.'
        ];
    }

    /**
     * Belirli bir menü (ürün) ID'sine göre güncelleme yapar.
     *
     * @return array JSON uyumlu sonuç dizisi
     */
    public function updateMenu(): array
    {
        header('Content-Type: application/json; charset=utf-8');

        // 1. Yalnızca POST kabul edilir
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return [
                'success' => false,
                'message' => 'Yalnızca POST isteği kabul edilir.'
            ];
        }

        // 2. Ürün ID kontrolü
        if (!isset($_POST['menuID']) || !ctype_digit((string)$_POST['menuID'])) {
            return [
                'success' => false,
                'message' => 'Geçerli bir ürün ID belirtilmelidir.'
            ];
        }

        $productId = (int) $_POST['menuID'];
        $restoranId = (int) ($_SESSION['user_id'] ?? 0);

        if (!$restoranId) {
            return [
                'success' => false,
                'message' => 'Oturum bulunamadı.'
            ];
        }

        // 3. Ürün var mı ve bu restorana mı ait kontrol
        $stmt = $this->db->prepare("
        SELECT * FROM urunler
        WHERE id = :id AND restoran_id = :restoran_id
        LIMIT 1
    ");

        $stmt->execute([
            ':id' => $productId,
            ':restoran_id' => $restoranId
        ]);

        $product = $stmt->fetch(\PDO::FETCH_ASSOC);

        if (!$product) {
            return [
                'success' => false,
                'message' => 'Ürün bulunamadı veya size ait değil.'
            ];
        }

        // --- 4. Yeni verileri al ---
        $menuName        = $_POST['menuName'] ?? $product['productName'];
        $menuCatID       = $_POST['menuCatID'] ?? $product['productCategoryId'];
        $menuPrice       = $_POST['menuPrice'] ?? $product['prodctPrice'];
        $menuStatus      = $_POST['menuStatus'] ?? $product['prodctStatus'];
        $menuDesc        = $_POST['menuDescription'] ?? $product['prodctDescription'];
        $menuImageID     = $_POST['menuImageID'] ?? $product['prodctImageId'];

        // --- 5. Durum kontrolü ---
//        if (!in_array($menuStatus, ['aktif', 'pasif'], true)) {
//            return [
//                'success' => false,
//                'message' => 'Geçersiz ürün durumu.'
//            ];
//        }

        // --- 6. Kategori ID geçerli mi kontrol ---
        if ($menuCatID) {
            $stmt = $this->db->prepare("
            SELECT COUNT(*) FROM kategoriler 
            WHERE id = :id AND restoran_id = :restoran_id
        ");
            $stmt->execute([
                ':id' => $menuCatID,
                ':restoran_id' => $restoranId
            ]);

            if ($stmt->fetchColumn() == 0) {
                return [
                    'success' => false,
                    'message' => 'Geçersiz kategori ID.'
                ];
            }
        }

        // --- 7. Görsel ID geçerli mi kontrol ---
        if ($menuImageID) {
            $stmt = $this->db->prepare("SELECT COUNT(*) FROM attachments WHERE id = :id");
            $stmt->execute([':id' => $menuImageID]);

            if ($stmt->fetchColumn() == 0) {
                return [
                    'success' => false,
                    'message' => 'Geçersiz resim ID.'
                ];
            }
        }

        // --- 8. Güncelle ---
        $update = $this->db->prepare("
        UPDATE urunler
        SET 
            productName = :name,
            productCategoryId = :catId,
            prodctPrice = :price,
            prodctStatus = :status,
            prodctDescription = :description,
            prodctImageId = :imageId
        WHERE id = :id AND restoran_id = :restoran_id
    ");

        $update->execute([
            ':name' => trim($menuName),
            ':catId' => $menuCatID,
            ':price' => $menuPrice,
            ':status' => $menuStatus,
            ':description' => $menuDesc,
            ':imageId' => $menuImageID ?: null,
            ':id' => $productId,
            ':restoran_id' => $restoranId
        ]);

        // --- 9. Başarılı dönüş ---
        return [
            'success' => true,
            'message' => 'Ürün başarıyla güncellendi.',
            'data' => [
                'productId' => $productId,
                'productName' => $menuName,
                'productCategoryId' => $menuCatID,
                'prodctPrice' => $menuPrice,
                'prodctStatus' => $menuStatus,
                'prodctDescription' => $menuDesc,
                'prodctImageId' => $menuImageID
            ]
        ];
    }

    /**
     * Belirli bir ürün ID'sine göre ürün siler.
     *
     * @return array JSON uyumlu sonuç dizisi
     */
    public function deleteProduct(): array
    {
        header('Content-Type: application/json; charset=utf-8');

        // --- 1. POST kontrolü ---
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            return [
                'success' => false,
                'message' => 'Yalnızca POST isteği kabul edilir.'
            ];
        }

        // --- 2. productID kontrolü ---
        if (!isset($_POST['productID']) || !ctype_digit((string)$_POST['productID'])) {
            return [
                'success' => false,
                'message' => 'Geçerli bir ürün ID belirtilmelidir.'
            ];
        }

        $productId = (int) $_POST['productID'];
        $restoranId = (int) ($_SESSION['user_id'] ?? 0);

        if (!$restoranId) {
            return [
                'success' => false,
                'message' => 'Oturum bulunamadı.'
            ];
        }

        // --- 3. Ürün var mı kontrol et ---
        $stmt = $this->db->prepare("
        SELECT * FROM urunler 
        WHERE id = :id AND restoran_id = :restoran_id
        LIMIT 1
    ");
        $stmt->execute([
            ':id' => $productId,
            ':restoran_id' => $restoranId
        ]);

        $product = $stmt->fetch(\PDO::FETCH_ASSOC);

        if (!$product) {
            return [
                'success' => false,
                'message' => 'Silinmek istenen ürün bulunamadı.'
            ];
        }

        // --- 4. Silme işlemi ---
        $delete = $this->db->prepare("
        DELETE FROM urunler
        WHERE id = :id AND restoran_id = :restoran_id
    ");
        $delete->execute([
            ':id' => $productId,
            ':restoran_id' => $restoranId
        ]);

        // --- 5. Başarılı dönüş ---
        return [
            'success' => true,
            'message' => 'Ürün başarıyla silindi.',
            'data' => [
                'productID' => $productId
            ]
        ];
    }

    /**
     * İlgili restorana ait tüm restoran bilgilerini getirir.
     *
     * @return array Restoran bilgileri
     */
    public function getRestoranInfo(): array
    {
        // Oturum kontrolü
        if (!isset($_SESSION['user_id'])) {
            return [
                'success' => false,
                'message' => 'Oturum bulunamadı.'
            ];
        }

        $restoranId = (int) $_SESSION['user_id'];

        // Restoran bilgilerini getir
        $stmt = $this->db->prepare("
        SELECT 
            id,
            slug,
            adres,
            sehir,
            ilce,
            mail,
            phone,
            gunler,
            name,
            slogan,
            status,
            teras_var,
            konum_lat,
            konum_lng
        FROM restoranlar
        WHERE id = :restoran_id
        LIMIT 1
    ");

        $stmt->bindParam(':restoran_id', $restoranId, \PDO::PARAM_INT);
        $stmt->execute();

        $restoran = $stmt->fetch(\PDO::FETCH_ASSOC);

        if (!$restoran) {
            return [
                'success' => false,
                'message' => 'Restoran bilgisi bulunamadı.'
            ];
        }

        // JSON formatlı veri döndür
        return [
            'success' => true,
            'data' => $restoran
        ];
    }

    /**
     * Restoran temel bilgilerini günceller.
     *
     * Beklenen POST parametreleri:
     * restoranName
     * restoranSlogan
     * restoranAddress
     * restoranAddressIlce
     * restoranAddressIl
     * restoranAddressPhone
     * form_type = updateRestoranInfo
     *
     * @return array
     */
    public function updateRestoranInfo(): array
    {
        // Kullanıcı oturum kontrolü
        if (!isset($_SESSION['user_id'])) {
            return [
                "success" => false,
                "message" => "Oturum bulunamadı."
            ];
        }

        // Form tipi doğrulama
        if (!isset($_POST['form_type']) || $_POST['form_type'] !== 'updateRestoranInfo') {
            return [
                "success" => false,
                "message" => "Geçersiz işlem."
            ];
        }

        $restoranId = (int) $_SESSION['user_id'];

        // POST verilerini al
        $name   = trim($_POST['restoranName'] ?? '');
        $slogan = trim($_POST['restoranSlogan'] ?? '');
        $adres  = trim($_POST['restoranAddress'] ?? '');
        $ilce   = trim($_POST['restoranAddressIlce'] ?? '');
        $il     = trim($_POST['restoranAddressIl'] ?? '');
        $phone  = trim($_POST['restoranAddressPhone'] ?? '');
        // Temel validasyon
        if ($name === '') {
            return ["success" => false, "message" => "Restoran adı boş olamaz."];
        }

        // UPDATE SQL
        $sql = "
        UPDATE restoranlar 
        SET 
            name = :name,
            slogan = :slogan,
            adres = :adres,
            ilce = :ilce,
            sehir = :il,
            phone = :phone,
        WHERE id = :id
    ";

        $stmt = $this->db->prepare($sql);

        // Parametre bağlama
        $stmt->bindParam(':name', $name, \PDO::PARAM_STR);
        $stmt->bindParam(':slogan', $slogan, \PDO::PARAM_STR);
        $stmt->bindParam(':adres', $adres, \PDO::PARAM_STR);
        $stmt->bindParam(':ilce', $ilce, \PDO::PARAM_STR);
        $stmt->bindParam(':il', $il, \PDO::PARAM_STR);
        $stmt->bindParam(':phone', $phone, \PDO::PARAM_STR);
        $stmt->bindParam(':id', $restoranId, \PDO::PARAM_INT);

        $result = $stmt->execute();

        if ($result) {
            return [
                "success" => true,
                "message" => "Restoran bilgileri başarıyla güncellendi."
            ];
        }

        return [
            "success" => false,
            "message" => "Güncelleme sırasında bir hata oluştu."
        ];
    }


    /**
     * Belirli bir restorana ait slug bilgisini döndürür.
     *
     * @return array Slug verisi veya hata mesajı
     */
    public function getRestoranSlug(): array
    {



        $restoranID = (int) $_SESSION['user_id'];

        try {
            $stmt = $this->db->prepare("
            SELECT slug 
            FROM restoranlar
            WHERE id = :restoran_id
            LIMIT 1
        ");

            $stmt->bindParam(':restoran_id', $restoranID, \PDO::PARAM_INT);
            $stmt->execute();

            $slugData = $stmt->fetch(\PDO::FETCH_ASSOC);

            if (!$slugData) {
                return [
                    'success' => 0,
                    'message' => 'Restoran bulunamadı.'
                ];
            }

            return $slugData;

        } catch (\PDOException $e) {
            return [
                'success' => 0,
                'message' => 'Veritabanı hatası: ' . $e->getMessage()
            ];
        }
    }


    /*
     * Dashboard
     * Belirli istatistiksel metriksleri çağırır
     * */
    function getDashboardStats(): array
    {
        $restoranId = (int) $_SESSION['user_id'];
        $stmt = $this->db->prepare("CALL sp_get_restoran_dashboard(:rid)");
        $stmt->bindParam(':rid', $restoranId, \PDO::PARAM_INT);
        $stmt->execute();

        $data = $stmt->fetch(\PDO::FETCH_ASSOC);
        $stmt->closeCursor(); // ⚠️ Çok önemli

        return $data ?: [];
    }
    /**
     * Restoran menüsünü kategori + ürünler halinde döndürür
     *
     * @param int $restoranId
     * @return array
     */
    public function getRestoranMenu(int $restoranId): array
    {
        $stmt = $this->db->prepare("
        SELECT
            k.id               AS kategori_id,
            k.kategori_adi     AS kategori_adi,

            u.id               AS product_id,
            u.productName      AS product_name,
            u.prodctPrice      AS product_price,
            u.prodctDescription AS product_description,
            u.prodctStatus     AS product_status,

            a.file_url         AS image_url

        FROM kategoriler k
        LEFT JOIN urunler u 
            ON u.productCategoryId = k.id
            AND u.prodctStatus = 'aktif'
        LEFT JOIN attachments a
            ON u.prodctImageId = a.id

        WHERE k.restoran_id = :restoran_id
        AND k.durum = 'aktif'
        ORDER BY k.created_at ASC, u.created_at ASC
    ");

        $stmt->bindParam(':restoran_id', $restoranId, \PDO::PARAM_INT);
        $stmt->execute();

        $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);

        if (!$rows) {
            return [];
        }

        $menu = [];

        foreach ($rows as $row) {

            $categoryKey = 'cat'.$row['kategori_id'];

            if (!isset($menu[$categoryKey])) {
                $menu[$categoryKey] = [
                    'title'    => $row['kategori_adi'],
                    'products' => []
                ];
            }

            // Ürün yoksa (kategori boş olabilir)
            if (empty($row['product_id'])) {
                continue;
            }

            $menu[$categoryKey]['products'][] = [
                'id'          => (int) $row['product_id'],
                'name'        => $row['product_name'],
                'price'       => (float) $row['product_price'],
                'description' => $row['product_description'],
                'image'       => $row['image_url'] ?: null
            ];
        }

        return $menu;
    }



    /**
     * Restoran  istatiksel verilerini döndürür
     *
     * @return array
     */
    public function getRestoranStatics(): array
    {
        $restoranId = (int) $_SESSION['user_id'];
        $stmt = $this->db->prepare("SELECT * FROM `view_restoran_dashboard` WHERE restoran_id = :restoran_id  ");

        $stmt->bindParam(':restoran_id', $restoranId, \PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetchAll(\PDO::FETCH_ASSOC);


    }


    public function getRestaurantPerformanceSummary($minAverageScore = 3.5)
    {
        $sql = "
        SELECT
            r.id AS restoran_id,
            r.name AS restoran_adi,

            COUNT(DISTINCT k.id) AS toplam_kategori,
            COUNT(DISTINCT u.id) AS toplam_urun,

            ROUND(
                AVG((g.menu_rating + g.service_rating + g.venue_rating) / 3),
                2
            ) AS ortalama_puan,

            (
                SELECT COUNT(*)
                FROM geri_bildirim gb
                WHERE gb.restoran_id = r.id
                  AND gb.created_at >= CURDATE() - INTERVAL 7 DAY
            ) AS haftalik_geri_bildirim

        FROM restoranlar r
        LEFT JOIN kategoriler k ON k.restoran_id = r.id
        LEFT JOIN urunler u ON u.restoran_id = r.id
        LEFT JOIN geri_bildirim g ON g.restoran_id = r.id

        GROUP BY r.id, r.name
        HAVING ortalama_puan >= :minScore
        ORDER BY ortalama_puan DESC
    ";

        $stmt = $this->db->prepare($sql);
        $stmt->bindValue(':minScore', $minAverageScore, PDO::PARAM_STR);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getRestaurantDashboardData($restoranID)
    {
        $sql = "
        SELECT
            r.id AS restoran_id,
            r.name AS restoran_adi,

            (SELECT COUNT(*) FROM kategoriler WHERE restoran_id = r.id) AS toplam_kategori,
            (SELECT COUNT(*) FROM urunler WHERE restoran_id = r.id) AS toplam_urun,

            (
                SELECT ROUND(
                    AVG((menu_rating + service_rating + venue_rating) / 3),
                    2
                )
                FROM geri_bildirim
                WHERE restoran_id = r.id
            ) AS ortalama_puan,

            (
                SELECT COUNT(*)
                FROM geri_bildirim
                WHERE restoran_id = r.id
                  AND created_at >= CURDATE() - INTERVAL 7 DAY
            ) AS haftalik_geri_bildirim,

            (
                SELECT COUNT(*)
                FROM qr_logs
                WHERE restoran_id = r.id
                  AND visit_date = CURDATE()
            ) AS bugun_qr

        FROM restoranlar r
        WHERE r.id = :restoranID
        LIMIT 1
    ";

        $stmt = $this->db->prepare($sql);
        $stmt->bindValue(':restoranID', $restoranID, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetch(PDO::FETCH_ASSOC);
    }



    public function addFeedbackWithTransaction(array $data)
    {
        try {
            // Transaction başlat
            $this->db->beginTransaction();

            /* ------------------------------
             * 1. Geri Bildirim Ekle
             * ------------------------------ */
            $feedbackSql = "
            INSERT INTO geri_bildirim
                (restoran_id, menu_rating, service_rating, venue_rating, yorum, created_at)
            VALUES
                (:restoran_id, :menu_rating, :service_rating, :venue_rating, :yorum, NOW())
        ";

            $stmtFeedback = $this->db->prepare($feedbackSql);
            $stmtFeedback->execute([
                ':restoran_id'    => $data['restoran_id'],
                ':menu_rating'    => $data['menu_rating'],
                ':service_rating' => $data['service_rating'],
                ':venue_rating'   => $data['venue_rating'],
                ':yorum'          => $data['yorum']
            ]);

            /* ------------------------------
             * 2. QR Log Ekle
             * ------------------------------ */
            $logSql = "
            INSERT INTO qr_logs
                (restoran_id, ip_address, device, visit_date)
            VALUES
                (:restoran_id, :ip_address, :device, CURDATE())
        ";

            $stmtLog = $this->db->prepare($logSql);
            $stmtLog->execute([
                ':restoran_id' => $data['restoran_id'],
                ':ip_address'  => $data['ip_address'],
                ':device'      => $data['device']
            ]);

            // Her şey başarılı → commit
            $this->db->commit();

            return [
                'status'  => true,
                'message' => 'İşlem başarıyla tamamlandı'
            ];

        } catch (PDOException $e) {

            // Hata varsa → rollback
            if ($this->db->inTransaction()) {
                $this->db->rollBack();
            }

            return [
                'status'  => false,
                'message' => 'Transaction başarısız',
                'error'   => $e->getMessage()
            ];
        }
    }







}