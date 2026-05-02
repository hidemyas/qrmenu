<?php

namespace App\Controllers;

use App\Models\RestoranUser;
use App\Models\Feedback;
use Core\Request;
use App\Services\TranslationService;

class RestoranController
{


    public function __construct()
    {
    }




    public function view(Request $request, ?string $segment1 = null, ?string $segment2 = null)
    {

        $modelRestoranUser = new RestoranUser();


        if ($modelRestoranUser->checkRestoran($segment1)){
            $restoran_id = $modelRestoranUser->getRestoranID($segment1)['id'];
            $modelRestoranUser->logQrVisit($restoran_id);
            $restoranData = $modelRestoranUser->getRestoran($restoran_id);
            $data['restoranID'] = $restoran_id;
            $data['restoranData'] = $restoranData;
            $data['restoranCategories'] = $modelRestoranUser->getRestoranCategories($restoran_id);
            $data['restoranMenu'] = $modelRestoranUser->getRestoranMenu($restoran_id);
            $data['csrfToken'] = \Core\Security::getCsrfToken();
            $data['havaDurumu'] = \App\Services\HavaDurumuService::getir($restoran_id);

        }else{
            return $this->page404($request);
        }


        return view([
            'restoran'
        ], $data );

    }


    public function api(Request $request)
{
    $form_type = $request->input('form_type') ?? '';
    $feedbackModel = new Feedback();

    if ($form_type === "setCustomerFeedback") {
        $response = $feedbackModel->setCustomerFeedback();
        return json($response);
    }
    if ($form_type === "getDovizKur") {
        $bugun = date('Y-m-d');
        $cacheFile = __DIR__ . '/../../storage/doviz_' . $bugun . '.json';

        // Cache dosyası varsa direkt dön
        if (file_exists($cacheFile)) {
            $kurlar = json_decode(file_get_contents($cacheFile), true);
            return json(['success' => true, 'kurlar' => $kurlar, 'tarih' => $bugun]);
        }

        // Yoksa API'den çek
        $url = 'https://api.frankfurter.app/latest?from=TRY&to=USD,EUR,GBP,JPY,CHF,CAD,AUD';
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        $response = curl_exec($ch);
        curl_close($ch);

        if (!$response) {
            return json(['success' => false, 'message' => 'Kur alınamadı']);
        }

        $data = json_decode($response, true);
        $kurlar = $data['rates'] ?? [];
        $kurlar['TRY'] = 1;

        // Klasör yoksa oluştur
        if (!is_dir(__DIR__ . '/../../storage')) {
            mkdir(__DIR__ . '/../../storage', 0755, true);
        }

        // Cache'e kaydet
        file_put_contents($cacheFile, json_encode($kurlar));

        return json(['success' => true, 'kurlar' => $kurlar, 'tarih' => $bugun]);
    }

    if ($form_type === "getMenuTranslation") {
        $dil        = $request->input('dil') ?? 'tr';
        $restoranId = (int)($request->input('restoran_id') ?? 0);

        // Güvenlik: sadece desteklenen diller
        if (!array_key_exists($dil, TranslationService::$destekliDiller)) {
            return json(['error' => 'Desteklenmeyen dil']);
        }

        $modelRestoranUser = new RestoranUser();
        $menu = $modelRestoranUser->getRestoranMenu($restoranId);

        // Türkçe ise çeviriye gerek yok
        if ($dil === 'tr') {
            return json(['success' => true, 'menu' => $menu]);
        }

        // Her ürün için çeviri yap ya da DB'den getir
        foreach ($menu as $catKey => &$kategori) {
        // Kategori ID'sini catKey'den çıkar (cat162 → 162)
        $kategoriId = (int) str_replace('cat', '', $catKey);
        $kategori['title'] = TranslationService::kategoriCevirisiGetir($kategoriId, $dil);

        foreach ($kategori['products'] as &$urun) {
                $ceviri = TranslationService::urunCevirisiGetir((int)$urun['id'], $dil);
                if (!empty($ceviri)) {
                    $urun['name']        = $ceviri['name'];
                    $urun['description'] = $ceviri['description'];
                }
            }
        }
        unset($kategori, $urun); // referans temizliği
        // Sabit metinleri çevir
        $sabitMetinler = [
            'fiyatBilgisi' => TranslationService::cevir('Fiyat bilgisi sadece bilgilendirme amaçlıdır', $dil),
            'urunHakkinda' => TranslationService::cevir('Bu ürünümüz özel tarifimizle hazırlanmaktadır. Taze ve kaliteli malzemeler kullanılarak özenle pişirilir. Alerjen bilgisi için lütfen garsonumuzla görüşün.', $dil),
        ];

        $urunHakkinda = TranslationService::sabitMetinGetir('urun_hakkinda', $dil);
        $urunHakkindaBaslik = TranslationService::sabitMetinGetir('urun_hakkinda_baslik', $dil);

        return json([
            'success' => true,
            'menu' => $menu,
            'urunHakkinda' => $urunHakkinda,
            'urunHakkindaBaslik' => $urunHakkindaBaslik
        ]);
    }

    return json(['name' => $request->query('name')]);
}

    public function page404(Request $request)
    {
        return view('page404')
            ->withStatus(404);
    }

}