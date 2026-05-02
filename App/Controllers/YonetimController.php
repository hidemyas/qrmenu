<?php

namespace App\Controllers;

use Core\Request;
use App\Models\RestoranUser;
use App\Models\Feedback;

use Core\Config;

class YonetimController
{

    public $restoran_slug;

    public function __construct()
    {
        // Oturumları başlatmak için session_start() çağrısı genellikle public/index.php'de yapılır.
        // Eğer yapılmadıysa burada veya uygulamanın en başında yapılması gerekir.
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        // Admin paneli metotlarına erişimden önce yetkilendirme kontrolü
        if (!RestoranUser::isLoggedIn()) { // User modelindeki isLoggedIn statik metodunu kullanıyoruz
            header("Location: /auth/login"); // Giriş sayfasına yönlendir
            exit(); // Yönlendirmeden sonra scriptin çalışmasını durdur
        }



        $userModel = new RestoranUser();
        if ($userModel->isActiveRestoran()==0) {
            $id=$_SESSION['user_id'];
            header("Location: /waitRestoran?id=$id"); // Giriş sayfasına yönlendir
            exit(); // Yönlendirmeden sonra scriptin çalışmasını durdur
        }

        $this->restoran_slug = $userModel->getRestoranSlug();
    }

    /**
     * Admin paneli ana sayfası - Tüm blog yazılarını listeler.
     * URL: /yonetim/index
     * @param Request $request Gelen HTTP isteği
     * @return \Core\Response
     */
    public function index(Request $request)
    {
        return $this->dashboard($request);
    }


    public function category(Request $request)
    {
        $data['pageInfo']=[
            'title'=>'Kategorileri Düzenleyin',
            'route'=>'yonetim/category'
        ];

        $userModel = new RestoranUser();
        $data['uploadedImages'] = $userModel->getUserImages();
        $data['getRestoranCategories'] = $userModel->getRestoranCategories();

        return view(['yonetim.header','yonetim.category','yonetim.footer'], ['data' => $data]);
    }


    public function menus(Request $request)
    {
        $data['pageInfo']=[
            'title'=>'Menülerinizi Düzenleyin',
            'route'=>'yonetim/menus'
        ];

        $userModel = new RestoranUser();
        $data['uploadedImages'] = $userModel->getUserImages();
        $data['getRestoranCategories'] = $userModel->getRestoranCategories();
        $data['getRestoranMenus'] = $userModel->getRestoranProducts();

        return view(['yonetim.header','yonetim.menu','yonetim.footer'], ['data' => $data]);
    }

    public function seller(Request $request)
    {
        $data['pageInfo']=[
            'title'=>'Mağaza Bilgileri',
            'route'=>'yonetim/seller'
        ];

        $userModel = new RestoranUser();
        $data['uploadedImages'] = $userModel->getUserImages();

        $data['getRestoranInfo'] = $userModel->getRestoranInfo();

        return view(['yonetim.header','yonetim.seller','yonetim.footer'], ['data' => $data]);
    }


    public function feedback(Request $request)
    {
        $data['pageInfo']=[
            'title'=>'Müşeteri Geri Bildirimleri',
            'route'=>'yonetim/feedback'
        ];

        $userModel = new RestoranUser();
        $data['uploadedImages'] = $userModel->getUserImages();

        $feedbackModel = new Feedback();
        $data['feedbacks'] = $feedbackModel->getCustomerFeedbacks();
        // getCustomerFeedbacks


        return view(['yonetim.header','yonetim.feedback','yonetim.footer'], ['data' => $data]);
    }


    public function qrCode(Request $request)
    {
        $data['pageInfo']=[
            'title'=>'QR Kod Oluşturma',
            'route'=>'yonetim/qrCode'
        ];

        $userModel = new RestoranUser();
        $data['uploadedImages'] = $userModel->getUserImages();

        // getCustomerFeedbacks
        $data['restoranSlug'] = $userModel->getRestoranSlug();


        return view(['yonetim.header','yonetim.qrCode','yonetim.footer'], ['data' => $data]);
    }


    public function dashboard(Request $request)
    {
        $data['pageInfo']=[
            'title'=>'Panel',
            'route'=>'yonetim/dashboard'
        ];

        $userModel = new RestoranUser();
        $data['uploadedImages'] = $userModel->getUserImages();
        $data['getRestoranCategories'] = $userModel->getRestoranCategories();

        $data['restoranSlug'] = $userModel->getRestoranSlug();

        $data['restoranMetrikler'] = $userModel->getDashboardStats();
        $data['restoranStatics'] = $userModel->getRestoranStatics();

        // getCustomerFeedbacks
//        $data['restoranSlug'] = $userModel->getRestoranSlug();


        return view(['yonetim.header','yonetim.index','yonetim.footer'], ['data' => $data]);
    }



    public function preview(Request $request)
    {
        $data['pageInfo']=[
            'title'=>'Restoranı Önizleyin',
            'route'=>'yonetim/preview'
        ];

        $userModel = new RestoranUser();

        $data['uploadedImages'] = $userModel->getUserImages();
        $restoran_slug = $this->restoran_slug['slug'];
        $data['previewURL'] = Config::SITE_URL . "/restoran/view/" . $restoran_slug ;



        return view(['yonetim.header','yonetim.preview','yonetim.footer'], ['data' => $data]);
    }




    public function api(Request $request)
    {
        $form_type = $request->input('form_type')??'';
        $userModel = new RestoranUser();

        if ($form_type=="uploadImage"){

            $response = $userModel->uploadAttachment();
            return json($response);

        }
        if ($form_type=="addCategory"){

            $response = $userModel->addCategory();
            return json($response);

        }
        if ($form_type=="getCategoryInfo"){

            $response = $userModel->getCategoryInfo();
            return json($response);

        }
        if ($form_type=="updateCategory"){

            $response = $userModel->updateCategory();
            return json($response);

        }

        if ($form_type=="deleteCategory"){

            $response = $userModel->deleteCategory();
            return json($response);

        }
        if ($form_type=="addProduct"){

            $response = $userModel->addProduct();
            return json($response);

        }

        if ($form_type=="toggleProductStatus"){
            $response = $userModel->toggleProductStatus();
            return json($response);
        }

        if ($form_type=="getProductInfo"){
            $response = $userModel->getProductInfo();
            return json($response);
        }


        if ($form_type=="updateMenu"){
            $response = $userModel->updateMenu();
            return json($response);
        }

        if ($form_type=="deleteMenu"){
            $response = $userModel->deleteProduct();
            return json($response);
        }

        if ($form_type=="updateRestoranInfo"){
            $response = $userModel->updateRestoranInfo();
            return json($response);
        }
        if ($form_type === "saveHavaDurumuAyar") {
            $restoranId = (int) $_SESSION['user_id'];
            $terasVar   = (int)($request->input('teras_var') ?? 0);
            $lat        = $request->input('konum_lat') ?: null;
            $lng        = $request->input('konum_lng') ?: null;

            $pdo = \Core\Database::getConnection();
            $stmt = $pdo->prepare("
                UPDATE restoranlar 
                SET teras_var = :teras_var, konum_lat = :lat, konum_lng = :lng
                WHERE id = :id
            ");
            $stmt->execute([
                ':teras_var' => $terasVar,
                ':lat'       => $lat,
                ':lng'       => $lng,
                ':id'        => $restoranId
            ]);

            return json(['success' => true, 'message' => 'Kaydedildi']);
        }

        if ($form_type === "getHavaDurumu") {
            $lat = $request->input('lat');
            $lng = $request->input('lng');
            $hava = \App\Services\HavaDurumuService::apidentCek($lat, $lng);
            if (!$hava) {
                return json(['success' => false, 'message' => 'Hava durumu alınamadı']);
            }
            return json(['success' => true, 'hava' => $hava]);
        }

        return json(['name' => $request->query('name')]);
    }



    /**
     * Verilen string'den SEO dostu Türkçe uyumlu slug oluşturur.
     *
     * Türkçe karakter desteği:
     * ç → c, ğ → g, ı → i, İ → i, ö → o, ş → s, ü → u
     *
     * @param string $string
     * @return string
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


}
