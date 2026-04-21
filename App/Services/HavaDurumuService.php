<?php

namespace App\Services;

use Core\Database;

class HavaDurumuService
{
    /**
     * Restoranın hava durumunu getirir.
     * 1 saatten eskiyse API'den çeker, değilse DB'den döner.
     */
    public static function getir(int $restoranId): ?array
    {
        $pdo = Database::getConnection();

        // DB'den mevcut veriyi çek
        $stmt = $pdo->prepare("
            SELECT teras_var, konum_lat, konum_lng, 
                   hava_durumu_cache, hava_durumu_guncelleme
            FROM restoranlar 
            WHERE id = :id
        ");
        $stmt->execute([':id' => $restoranId]);
        $restoran = $stmt->fetch(\PDO::FETCH_ASSOC);

        // Teras yoksa null dön
        if (!$restoran || !$restoran['teras_var']) {
            return null;
        }

        // Koordinat yoksa null dön
        if (!$restoran['konum_lat'] || !$restoran['konum_lng']) {
            return null;
        }

        // Cache varsa ve 1 saatten yeniyse DB'den dön
        if (
            $restoran['hava_durumu_cache'] &&
            $restoran['hava_durumu_guncelleme'] &&
            (time() - strtotime($restoran['hava_durumu_guncelleme'])) < 3600
        ) {
            return json_decode($restoran['hava_durumu_cache'], true);
        }

        // API'den çek
        $hava = self::apidentCek(
            $restoran['konum_lat'],
            $restoran['konum_lng']
        );

        if (!$hava) return null;

        // DB'ye kaydet
        $stmt = $pdo->prepare("
            UPDATE restoranlar 
            SET hava_durumu_cache = :cache,
                hava_durumu_guncelleme = NOW()
            WHERE id = :id
        ");
        $stmt->execute([
            ':cache' => json_encode($hava),
            ':id'    => $restoranId
        ]);

        return $hava;
    }

    /**
     * Open-Meteo API'den hava durumu çeker
     */
    public static function apidentCek(string $lat, string $lng): ?array
    {
        $url = "https://api.open-meteo.com/v1/forecast"
            . "?latitude={$lat}&longitude={$lng}"
            . "&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code"
            . "&wind_speed_unit=kmh";

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        $response = curl_exec($ch);
        curl_close($ch);

        if (!$response) return null;

        $data    = json_decode($response, true);
        $current = $data['current'] ?? [];

        $kod = $current['weather_code'] ?? 0;
        if ($kod == 0)          { $ikon = '☀️';  $durum = 'Açık'; }
        elseif ($kod <= 3)      { $ikon = '⛅';  $durum = 'Parçalı Bulutlu'; }
        elseif ($kod <= 48)     { $ikon = '🌫️'; $durum = 'Sisli'; }
        elseif ($kod <= 67)     { $ikon = '🌧️'; $durum = 'Yağmurlu'; }
        elseif ($kod <= 77)     { $ikon = '🌨️'; $durum = 'Karlı'; }
        elseif ($kod <= 82)     { $ikon = '🌦️'; $durum = 'Sağanak'; }
        else                    { $ikon = '⛈️';  $durum = 'Fırtınalı'; }

        return [
            'sicaklik' => round($current['temperature_2m'] ?? 0),
            'nem'      => round($current['relative_humidity_2m'] ?? 0),
            'ruzgar'   => round($current['wind_speed_10m'] ?? 0),
            'ikon'     => $ikon,
            'durum'    => $durum,
        ];
    }
}