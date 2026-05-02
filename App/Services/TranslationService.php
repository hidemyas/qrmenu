<?php

namespace App\Services;

use Core\Database;

class TranslationService
{
    public static array $destekliDiller = [
        'tr' => 'Türkçe',
        'en' => 'English',
        'zh' => '中文',
        'hi' => 'हिन्दी',
        'es' => 'Español',
        'fr' => 'Français',
        'ar' => 'العربية',
        'bn' => 'বাংলা',
        'pt' => 'Português',
        'ru' => 'Русский',
        'ur' => 'اردو',
        'id' => 'Indonesia',
        'de' => 'Deutsch',
        'ja' => '日本語',
        'sw' => 'Kiswahili',
        'mr' => 'मराठी',
        'te' => 'తెలుగు',
        'ko' => '한국어',
        'vi' => 'Tiếng Việt',
        'ta' => 'தமிழ்',
        'it' => 'Italiano',
        'th' => 'ภาษาไทย',
        'gu' => 'ગુજરાતી',
        'fa' => 'فارسی',
        'pl' => 'Polski',
        'nl' => 'Nederlands',
        'uk' => 'Українська',
        'ms' => 'Melayu',
        'ro' => 'Română',
        'el' => 'Ελληνικά',
    ];
    public static function sabitMetinGetir(string $anahtar, string $dil): string
    {
        $pdo = Database::getConnection();
        $stmt = $pdo->prepare(
            "SELECT metin FROM sabit_metinler WHERE anahtar = :anahtar AND dil_kodu = :dil LIMIT 1"
        );
        $stmt->execute([':anahtar' => $anahtar, ':dil' => $dil]);
        $row = $stmt->fetch(\PDO::FETCH_ASSOC);
        return $row ? $row['metin'] : '';
    }
    public static function cevir(string $metin, string $hedefDil, string $kaynakDil = 'tr'): string
    {
        if (empty(trim($metin))) return $metin;
        if ($hedefDil === $kaynakDil) return $metin;

        $url = 'https://translate.googleapis.com/translate_a/single?client=gtx'
            . '&sl=' . urlencode($kaynakDil)
            . '&tl=' . urlencode($hedefDil)
            . '&dt=t'
            . '&q=' . urlencode($metin);

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/5.0');
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        $response = curl_exec($ch);
        curl_close($ch);

        if (!$response) return $metin;

        $data = json_decode($response, true);
        $sonuc = '';
        if (isset($data[0]) && is_array($data[0])) {
            foreach ($data[0] as $parca) {
                if (isset($parca[0])) $sonuc .= $parca[0];
            }
        }

        return $sonuc ?: $metin;
    }

    public static function urunCevirisiGetir(int $urunId, string $dil): array
    {
        $pdo = Database::getConnection();

        // Önce DB'de var mı bak
        $stmt = $pdo->prepare(
            "SELECT ceviri_adi, ceviri_aciklama 
             FROM urun_ceviriler 
             WHERE urun_id = :urun_id AND dil_kodu = :dil"
        );
        $stmt->execute([':urun_id' => $urunId, ':dil' => $dil]);
        $mevcut = $stmt->fetch(\PDO::FETCH_ASSOC);

        if ($mevcut) {
            return [
                'name'        => $mevcut['ceviri_adi'],
                'description' => $mevcut['ceviri_aciklama'],
            ];
        }

        // Yoksa orijinali çek
        $stmt = $pdo->prepare(
            "SELECT productName, prodctDescription FROM urunler WHERE id = :id"
        );
        $stmt->execute([':id' => $urunId]);
        $urun = $stmt->fetch(\PDO::FETCH_ASSOC);

        if (!$urun) return [];

        // Çevir
        $ceviriAdi  = self::cevir($urun['productName'], $dil);
        $ceviriAcik = self::cevir($urun['prodctDescription'] ?? '', $dil);

        // DB'ye kaydet
        $stmt = $pdo->prepare(
            "INSERT INTO urun_ceviriler (urun_id, dil_kodu, ceviri_adi, ceviri_aciklama)
             VALUES (:urun_id, :dil, :adi, :aciklama)
             ON DUPLICATE KEY UPDATE 
               ceviri_adi = VALUES(ceviri_adi),
               ceviri_aciklama = VALUES(ceviri_aciklama)"
        );
        $stmt->execute([
            ':urun_id'  => $urunId,
            ':dil'      => $dil,
            ':adi'      => $ceviriAdi,
            ':aciklama' => $ceviriAcik,
        ]);

        return [
            'name'        => $ceviriAdi,
            'description' => $ceviriAcik,
        ];
    }
    public static function kategoriCevirisiGetir(int $kategoriId, string $dil): string
    {
        $pdo = Database::getConnection();

        // DB'de var mı?
        $stmt = $pdo->prepare(
            "SELECT ceviri_adi FROM kategori_ceviriler 
            WHERE kategori_id = :kategori_id AND dil_kodu = :dil"
        );
        $stmt->execute([':kategori_id' => $kategoriId, ':dil' => $dil]);
        $mevcut = $stmt->fetch(\PDO::FETCH_ASSOC);

        if ($mevcut) {
            return $mevcut['ceviri_adi'];
        }

        // Yoksa orijinali çek
        $stmt = $pdo->prepare(
            "SELECT kategori_adi FROM kategoriler WHERE id = :id"
        );
        $stmt->execute([':id' => $kategoriId]);
        $kategori = $stmt->fetch(\PDO::FETCH_ASSOC);

        if (!$kategori) return '';

        // Çevir
        $ceviri = self::cevir($kategori['kategori_adi'], $dil);

        // Kaydet
        $stmt = $pdo->prepare(
            "INSERT INTO kategori_ceviriler (kategori_id, dil_kodu, ceviri_adi)
            VALUES (:kategori_id, :dil, :adi)
            ON DUPLICATE KEY UPDATE ceviri_adi = VALUES(ceviri_adi)"
        );
        $stmt->execute([
            ':kategori_id' => $kategoriId,
            ':dil'         => $dil,
            ':adi'         => $ceviri,
        ]);

        return $ceviri;
    }
}