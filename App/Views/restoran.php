<?php
// Kullanıcı giriş sayfası.
// layouts/header.php ve layouts/footer.php arasında çağrılacaktır.
use Core\Security; // CSRF token için Security sınıfını kullanıyoruz


?>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= $restoranData['name']; ?></title>
    <link rel="icon" href="/public/assets/img/qr-menu.png" type="image/png">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .doviz-btn {
            background: #f3f4f6;
            color: #4b5563;
        }
        .doviz-btn:hover {
            background: #ede9fe;
            color: #7c3aed;
        }
        .active-doviz {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white !important;
        }
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');
        body { font-family: 'Poppins', sans-serif; }
        .page { display: none; }
        .page.active { display: block; }
        .fade-in { animation: fadeIn 0.3s ease-in; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .category-card { transition: all 0.3s ease; }
        .category-card:hover { transform: translateY(-5px); }
        .product-card { transition: all 0.3s ease; }
        .product-card:hover { transform: scale(1.02); }
        .notification-badge { animation: pulse 2s infinite; }
        @keyframes pulse { 0%, 100% { transform: scale(1); } 50% { transform: scale(1.1); } }
        .gradient-bg { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .gradient-text { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
    </style>
</head>
<body class="bg-gray-50">
<!-- Header -->
<header class="gradient-bg text-white shadow-lg sticky top-0 z-50">
    <div class="container mx-auto px-4 py-4">
        <div class="flex justify-between items-center">
            <div class="flex items-center space-x-3">
                <i class="fas fa-utensils text-2xl"></i>
                <h1 class="text-xl font-bold"><?= $restoranData['name']; ?></h1>
            </div>
            <!-- Dil Seçici -->
            <div class="relative" id="dilDropdownWrapper">
                <button onclick="toggleDilMenu()" 
                    class="flex items-center space-x-2 bg-white/20 hover:bg-white/30 text-white px-3 py-2 rounded-lg border border-white/40 transition text-sm font-semibold shadow">
                    <span id="secilenDilAdi">Türkçe</span>
                    <i class="fas fa-chevron-down text-xs ml-1"></i>
                </button>
                <div id="dilMenusu" class="hidden absolute right-0 mt-2 w-44 bg-white rounded-xl shadow-xl z-50 border border-gray-100 max-h-64 overflow-y-auto">
                    <div onclick="dilSec('tr','Türkçe')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Türkçe</div>
                    <div onclick="dilSec('en','English')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">English</div>
                    <div onclick="dilSec('zh','中文')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">中文</div>
                    <div onclick="dilSec('hi','हिन्दी')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">हिन्दी</div>
                    <div onclick="dilSec('es','Español')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Español</div>
                    <div onclick="dilSec('fr','Français')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Français</div>
                    <div onclick="dilSec('ar','العربية')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">العربية</div>
                    <div onclick="dilSec('bn','বাংলা')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">বাংলা</div>
                    <div onclick="dilSec('pt','Português')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Português</div>
                    <div onclick="dilSec('ru','Русский')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Русский</div>
                    <div onclick="dilSec('ur','اردو')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">اردو</div>
                    <div onclick="dilSec('id','Indonesia')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Indonesia</div>
                    <div onclick="dilSec('de','Deutsch')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Deutsch</div>
                    <div onclick="dilSec('ja','日本語')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">日本語</div>
                    <div onclick="dilSec('sw','Kiswahili')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Kiswahili</div>
                    <div onclick="dilSec('mr','मराठी')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">मराठी</div>
                    <div onclick="dilSec('te','తెలుగు')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">తెలుగు</div>
                    <div onclick="dilSec('ko','한국어')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">한국어</div>
                    <div onclick="dilSec('vi','Tiếng Việt')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Tiếng Việt</div>
                    <div onclick="dilSec('ta','தமிழ்')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">தமிழ்</div>
                    <div onclick="dilSec('it','Italiano')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Italiano</div>
                    <div onclick="dilSec('th','ภาษาไทย')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">ภาษาไทย</div>
                    <div onclick="dilSec('gu','ગુજરાતી')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">ગુજરાતી</div>
                    <div onclick="dilSec('fa','فارسی')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">فارسی</div>
                    <div onclick="dilSec('pl','Polski')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Polski</div>
                    <div onclick="dilSec('nl','Nederlands')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Nederlands</div>
                    <div onclick="dilSec('uk','Українська')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Українська</div>
                    <div onclick="dilSec('ms','Melayu')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Melayu</div>
                    <div onclick="dilSec('ro','Română')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Română</div>
                    <div onclick="dilSec('el','Ελληνικά')" class="px-4 py-3 hover:bg-purple-50 cursor-pointer text-gray-700 font-medium transition text-sm">Ελληνικά</div>
                </div>
            </div>
            </select>
            <div class="flex items-center space-x-4">
                <button onclick="toggleStoreInfo()" class="relative">
                    <i class="fas fa-info-circle text-xl"></i>
                    <span id="notificationBadge" class="notification-badge absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">!</span>
                </button>
                <button onclick="showPage('home')" class="text-white hover:text-gray-200 transition">
                    <i class="fas fa-home text-xl"></i>
                </button>
            </div>
        </div>
    </div>
</header>
<?php if (!empty($havaDurumu)): ?>
<div class="bg-white border-b border-gray-100 shadow-sm">
    <div class="container mx-auto px-4 py-2">
        <div class="flex items-center justify-center space-x-6 text-sm text-gray-600">
            <span class="text-lg"><?= $havaDurumu['ikon'] ?></span>
            <span class="font-semibold text-gray-800"><?= $havaDurumu['sicaklik'] ?>°C</span>
            <span><?= $havaDurumu['durum'] ?></span>
            <span class="text-gray-400">|</span>
            <span><i class="fas fa-tint text-blue-400 mr-1"></i>%<?= $havaDurumu['nem'] ?></span>
            <span><i class="fas fa-wind text-gray-400 mr-1"></i><?= $havaDurumu['ruzgar'] ?> km/s</span>
        </div>
    </div>
</div>
<?php endif; ?>
<!-- Store Info Modal -->
<div id="storeInfoModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden">
    <div class="flex items-center justify-center min-h-screen p-4">
        <div class="bg-white rounded-2xl max-w-md w-full p-6 fade-in">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-2xl font-bold gradient-text">Restoran Bilgileri</h2>
                <button onclick="toggleStoreInfo()" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            <div class="space-y-4">
                <div class="flex items-center space-x-3">
                    <i class="fas fa-store text-purple-600"></i>
                    <div>
                        <p class="font-semibold"><?= $restoranData['name']; ?></p>
                        <p class="text-sm text-gray-600"><?= $restoranData['slogan']; ?></p>
                    </div>
                </div>
                <div class="flex items-center space-x-3">
                    <i class="fas fa-map-marker-alt text-purple-600"></i>
                    <p class="text-sm"><?= $restoranData['adres']; ?> <?= $restoranData['ilce']; ?>/<?= $restoranData['sehir']; ?></p>
                </div>
                <div class="flex items-center space-x-3">
                    <i class="fas fa-phone text-purple-600"></i>
                    <p class="text-sm"><?= $restoranData['phone']; ?></p>
                </div>


            </div>
        </div>
    </div>
</div>

<!-- Main Content -->
<main class="container mx-auto px-4 py-6">
    <!-- Home Page -->
    <div id="homePage" class="page active fade-in">
        <div class="mb-6">
            <h2 class="text-3xl font-bold text-gray-800 mb-2">Menü Kategorileri</h2>
            <p class="text-gray-600">Lezzetli seçeneklerimizi keşfedin</p>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
            <!-- Categories with real food images -->
            <?php foreach ($restoranCategories as $cat): ?>
                <div onclick="showCategory('cat<?=$cat['kategori_id']?>')" class="category-card bg-white rounded-xl shadow-lg overflow-hidden cursor-pointer">
                <div class="h-40 relative">
                    <img src="<?=$cat['file_url']?>" alt="<?=$cat['kategori_adi']?>" class="w-full h-full object-contain">
                    <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                    <div class="absolute bottom-3 left-3 text-white">
                        <h3 class="font-bold text-lg"><?=$cat['kategori_adi']?></h3>
                        <p class="text-xs opacity-90"><?=$cat['urun_sayisi']?> Ürün</p>
                    </div>
                </div>
            </div>
            <?php endforeach; ?>
        </div>

        <!-- Quick Actions -->
        <div class="mt-8 flex justify-center space-x-4">
            <button onclick="showPage('feedback')" class="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-6 py-3 rounded-full font-semibold hover:shadow-lg transition transform hover:scale-105">
                <i class="fas fa-comment-dots mr-2"></i>Geri Bildirim
            </button>
        </div>
    </div>

    <!-- Category Detail Page -->
    <div id="categoryPage" class="page fade-in">
        <button onclick="showPage('home')" class="mb-4 text-purple-600 hover:text-purple-800 transition">
            <i class="fas fa-arrow-left mr-2"></i>Geri
        </button>
        <h2 id="categoryTitle" class="text-3xl font-bold text-gray-800 mb-6"></h2>
        <div id="categoryProducts" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <!-- Products will be loaded here -->
        </div>
    </div>

    <!-- Product Detail Page -->
    <div id="productPage" class="page fade-in">
        <button onclick="showCategory(currentCategory)" class="mb-4 text-purple-600 hover:text-purple-800 transition">
            <i class="fas fa-arrow-left mr-2"></i>Geri
        </button>
        <div id="productDetail" class="bg-white rounded-2xl shadow-xl overflow-hidden">
            <!-- Product details will be loaded here -->
        </div>
    </div>

    <!-- Feedback Page -->
    <div id="feedbackPage" class="page fade-in">
        <button onclick="showPage('home')" class="mb-4 text-purple-600 hover:text-purple-800 transition">
            <i class="fas fa-arrow-left mr-2"></i>Geri
        </button>
        <div class="max-w-2xl mx-auto">
            <h2 class="text-3xl font-bold text-gray-800 mb-6">Geri Bildirim</h2>

            <div class="bg-white rounded-2xl shadow-lg p-6">
                <form onsubmit="submitFeedback(event)">
                    <!-- Menu Rating -->
                    <div class="mb-6" id="menu-rating">
                        <label class="block text-gray-700 font-semibold mb-3">
                            <i class="fas fa-utensils mr-2 text-purple-600"></i>Menü Değerlendirmesi
                        </label>
                        <div class="flex space-x-2">
                            <button type="button" onclick="setRating('menu', 1)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                            <button type="button" onclick="setRating('menu', 2)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                            <button type="button" onclick="setRating('menu', 3)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                            <button type="button" onclick="setRating('menu', 4)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                            <button type="button" onclick="setRating('menu', 5)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Service Rating -->
                    <div class="mb-6" id="service-rating">
                        <label class="block text-gray-700 font-semibold mb-3">
                            <i class="fas fa-concierge-bell mr-2 text-purple-600"></i>Hizmet Değerlendirmesi
                        </label>
                        <div class="flex space-x-2">
                            <button type="button" onclick="setRating('service', 1)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                            <button type="button" onclick="setRating('service', 2)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                            <button type="button" onclick="setRating('service', 3)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                            <button type="button" onclick="setRating('service', 4)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                            <button type="button" onclick="setRating('service', 5)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Venue Rating -->
                    <div class="mb-6" id="venue-rating">
                        <label class="block text-gray-700 font-semibold mb-3">
                            <i class="fas fa-store mr-2 text-purple-600"></i>Mekan Değerlendirmesi
                        </label>
                        <div class="flex space-x-2">
                            <button type="button" onclick="setRating('venue', 1)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                            <button type="button" onclick="setRating('venue', 2)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                            <button type="button" onclick="setRating('venue', 3)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                            <button type="button" onclick="setRating('venue', 4)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                            <button type="button" onclick="setRating('venue', 5)" class="rating-btn text-3xl text-gray-300 hover:text-yellow-400 transition">
                                <i class="fas fa-star"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Comment -->
                    <div class="mb-6">
                        <label class="block text-gray-700 font-semibold mb-3">
                            <i class="fas fa-comment mr-2 text-purple-600"></i>Yorumunuz
                        </label>
                        <textarea id="feedbackComment" rows="4" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500" placeholder="Deneyiminizi bizimle paylaşın..."></textarea>
                    </div>

                    <!-- Name -->
                    <div class="mb-6">
                        <label class="block text-gray-700 font-semibold mb-3">
                            <i class="fas fa-user mr-2 text-purple-600"></i>Adınız
                        </label>
                        <input type="text" id="feedbackName" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500" placeholder="Adınız Soyadınız">
                    </div>

                    <button type="submit" class="w-full bg-gradient-to-r from-purple-500 to-pink-500 text-white py-3 rounded-lg font-semibold hover:shadow-lg transition transform hover:scale-105">
                        <i class="fas fa-paper-plane mr-2"></i>Geri Bildirim Gönder
                    </button>
                </form>
            </div>

            <!-- Success Message -->
            <div id="successMessage" class="hidden mt-4 bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-lg">
                <i class="fas fa-check-circle mr-2"></i>Geri bildiriminiz için teşekkür ederiz!
            </div>
        </div>
    </div>
    <!-- Döviz Seçici Widget -->
    <div class="fixed bottom-4 right-4 z-50">
        <div id="dovizWidget" class="bg-white rounded-xl shadow-xl border border-gray-100 overflow-hidden">
            <div class="gradient-bg px-3 py-2 flex items-center justify-between">
                <span class="text-white text-xs font-semibold">
                    <i class="fas fa-coins mr-1"></i>Para Birimi
                </span>
                <button onclick="toggleDovizWidget()" class="text-white/80 hover:text-white transition ml-3">
                    <i id="dovizToggleIcon" class="fas fa-chevron-down text-xs"></i>
                </button>
            </div>
            <div id="dovizListesi" class="hidden p-2 grid grid-cols-3 gap-1 w-44">
                <button onclick="paraBirimiSec('TRY','₺','TL')" id="btn-TRY" class="doviz-btn active-doviz text-xs py-1 px-2 rounded-lg font-semibold transition">₺ TL</button>
                <button onclick="paraBirimiSec('USD','$','USD')" id="btn-USD" class="doviz-btn text-xs py-1 px-2 rounded-lg font-semibold transition">$ USD</button>
                <button onclick="paraBirimiSec('EUR','€','EUR')" id="btn-EUR" class="doviz-btn text-xs py-1 px-2 rounded-lg font-semibold transition">€ EUR</button>
                <button onclick="paraBirimiSec('GBP','£','GBP')" id="btn-GBP" class="doviz-btn text-xs py-1 px-2 rounded-lg font-semibold transition">£ GBP</button>
                <button onclick="paraBirimiSec('JPY','¥','JPY')" id="btn-JPY" class="doviz-btn text-xs py-1 px-2 rounded-lg font-semibold transition">¥ JPY</button>
                <button onclick="paraBirimiSec('CHF','₣','CHF')" id="btn-CHF" class="doviz-btn text-xs py-1 px-2 rounded-lg font-semibold transition">₣ CHF</button>
                <button onclick="paraBirimiSec('CAD','C$','CAD')" id="btn-CAD" class="doviz-btn text-xs py-1 px-2 rounded-lg font-semibold transition">C$ CAD</button>
                <button onclick="paraBirimiSec('AUD','A$','AUD')" id="btn-AUD" class="doviz-btn text-xs py-1 px-2 rounded-lg font-semibold transition">A$ AUD</button>
            </div>
            <div class="px-3 py-1 bg-gray-50 border-t border-gray-100">
                <p id="kurBilgisi" class="text-xs text-gray-400 text-center">Yükleniyor...</p>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="bg-gray-800 text-white mt-12 py-6">
    <div class="container mx-auto px-4 text-center">
        <p class="text-sm">© <?= date('Y') ?> <?= $restoranData['name']; ?> - Tüm hakları saklıdır</p>
        <p class="text-xs mt-2 text-gray-400">QR Menü Sistemi v1.0</p>
    </div>
</footer>

<script>
    const restoranID = <?= $restoranData['id']; ?>;
    const csrfToken = "<?= $csrfToken ?>";
    // Sample data
    let menuData = <?= json_encode($restoranMenu); ?>;
    let currentProductId = null;

    let currentCategory = '';
    let ratings = {
        menu: 0,
        service: 0,
        venue: 0
    };
    let sabitMetinler = {
        fiyatBilgisi: 'Fiyat bilgisi sadece bilgilendirme amaçlıdır',
        urunHakkinda: 'Bu ürünümüz özel tarifimizle hazırlanmaktadır. Taze ve kaliteli malzemeler kullanılarak özenle pişirilir. Alerjen bilgisi için lütfen garsonumuzla görüşün.'
    };
    let dilYukleniyor = false;
    let urunHakkindaMetni = 'Bu ürünümüz özel tarifimizle hazırlanmaktadır. Taze ve kaliteli malzemeler kullanılarak özenle pişirilir. Alerjen bilgisi için lütfen garsonumuzla görüşün.';
    let urunHakkindaBaslik = 'Ürün Hakkında';
    let kurlar = {};
    let secilenBirim = 'TRY';
    let secilenSembol = '₺';
    let dovizWidgetAcik = false;

    // Page navigation
    function showPage(pageId) {
        document.querySelectorAll('.page').forEach(page => {
            page.classList.remove('active');
        });
        document.getElementById(pageId + 'Page').classList.add('active');
    }

    // Show category
    function showCategory(categoryId) {
        currentCategory = categoryId;
        const category = menuData[categoryId];
        document.getElementById('categoryTitle').textContent = category.title;

        const productsHtml = category.products.map(product => `
            <div onclick="showProduct(${product.id})" class="product-card bg-white rounded-xl shadow-lg overflow-hidden cursor-pointer">
                <img src="${product.image || ''}" alt="${product.name}" class="w-full h-48 object-contain">
                <div class="p-4">
                    <h3 class="font-semibold text-lg text-gray-800">${product.name}</h3>
                    <p class="text-sm text-gray-600 mt-2">${product.description || ''}</p>
                    <div class="mt-4">
                        <span class="text-2xl font-bold text-purple-600">${secilenSembol}${tldenCevir(product.price, secilenBirim)}</span>
                    </div>
                </div>
            </div>
        `).join('');

        document.getElementById('categoryProducts').innerHTML = productsHtml;
        showPage('category');
    }

    function showProduct(productId) {
        currentProductId = productId;
        let product = null;
        for (let category in menuData) {
            product = menuData[category].products.find(p => p.id === productId);
            if (product) break;
        }

        if (product) {
            const fiyat = tldenCevir(product.price, secilenBirim);
            const productHtml = `
                <img src="${product.image || ''}" alt="${product.name}" class="w-full h-64 object-contain">
                <div class="p-6">
                    <h2 class="text-3xl font-bold text-gray-800 mb-4">${product.name}</h2>
                    <p class="text-gray-600 mb-6 text-lg">${product.description || ''}</p>
                    <div class="bg-purple-50 rounded-lg p-4 mb-6">
                        <div class="flex justify-between items-center">
                            <span class="text-2xl font-bold text-purple-600">${secilenSembol}${fiyat}</span>
                            <span class="text-sm text-gray-500">
                                <i class="fas fa-info-circle mr-1"></i>
                                Fiyat bilgisi sadece bilgilendirme amaçlıdır
                            </span>
                        </div>
                    </div>
                    <div class="border-t pt-4">
                        <h3 class="font-semibold text-gray-700 mb-2">${urunHakkindaBaslik}</h3>
                        <p class="text-gray-600">${urunHakkindaMetni}</p>
                    </div>
                </div>
            `;
            document.getElementById('productDetail').innerHTML = productHtml;
            showPage('product');
        }
    }

    // Toggle store info modal
    function toggleStoreInfo() {
        const modal = document.getElementById('storeInfoModal');
        modal.classList.toggle('hidden');
    }

    // Set rating
    function setRating(type, value) {
        ratings[type] = value;
        const buttons = document.querySelectorAll(`#feedbackPage #${type}-rating .rating-btn`);
        buttons.forEach((btn, index) => {
            const btnType = btn.onclick.toString().match(/setRating\('(\w+)', (\d+)\)/);
            if (btnType && btnType[1] === type) {
                if (index < value) {
                    btn.classList.remove('text-gray-300');
                    btn.classList.add('text-yellow-400');
                } else {
                    btn.classList.remove('text-yellow-400');
                    btn.classList.add('text-gray-300');
                }
            }
        });
    }

    // Submit feedback
    function submitFeedback(event) {
        event.preventDefault();
        const comment = document.getElementById('feedbackComment').value;
        const name = document.getElementById('feedbackName').value;

        if (ratings.menu === 0 || ratings.service === 0 || ratings.venue === 0) {
            alert('Lütfen tüm alanları değerlendirin');
            return;
        }

        console.log(ratings,comment,name,restoranID);

        const formData = new FormData();
        formData.append('restoranID', restoranID);
        formData.append('customerName', name);
        formData.append('customerComment', comment);
        formData.append('customerMenuRating', ratings.menu);
        formData.append('customerServiceRating', ratings.service);
        formData.append('customerVenueRating', ratings.venue);
        formData.append('form_type', 'setCustomerFeedback');
        formData.append('_token', "<?= Security::getCsrfToken() ?>");

        // API isteği
        fetch('/restoran/api', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => {
            if (data.success == 1) {
                // Show success message
                document.getElementById('successMessage').classList.remove('hidden');

                // Reset form
                setTimeout(() => {
                    document.getElementById('feedbackComment').value = '';
                    document.getElementById('feedbackName').value = '';
                    ratings = { menu: 0, service: 0, venue: 0 };
                    document.querySelectorAll('.rating-btn').forEach(btn => {
                        btn.classList.remove('text-yellow-400');
                        btn.classList.add('text-gray-300');
                    });
                    document.getElementById('successMessage').classList.add('hidden');
                    showPage('home');
                }, 2000);
            } else {
                // Hata mesajı göster
                alert(data.message || 'Bir hata oluştu, lütfen tekrar deneyin.');
            }
            })
            .catch(err => {
                console.error('Upload error:', err);
                console.log('Sunucuya bağlanırken hata oluştu!');
            });




    }
    // Check store status
    function checkStoreStatus() {
        const statusElement = document.getElementById('storeStatus');
        if (!statusElement) return;
        const now = new Date();
        const hours = now.getHours();
        if (hours >= 10 && hours < 23) {
            statusElement.textContent = 'Açık';
            statusElement.className = 'text-green-500 font-semibold mt-1';
        } else {
            statusElement.textContent = 'Kapalı';
            statusElement.className = 'text-red-500 font-semibold mt-1';
        }
    }

    function toggleDilMenu() {
        const menu = document.getElementById('dilMenusu');
        menu.classList.toggle('hidden');
    }

    function dilSec(kod, ad) {
        document.getElementById('secilenDilAdi').textContent = ad;
        document.getElementById('dilMenusu').classList.add('hidden');
        dilDegistir(kod);
    }
    // Menü dışına tıklanınca kapat
    document.addEventListener('click', function(e) {
        const wrapper = document.getElementById('dilDropdownWrapper');
        if (wrapper && !wrapper.contains(e.target)) {
            document.getElementById('dilMenusu').classList.add('hidden');
        }
    });

    function dilDegistir(dil) {
        if (dilYukleniyor) return;
        dilYukleniyor = true;

        const formData = new FormData();
        formData.append('form_type', 'getMenuTranslation');
        formData.append('dil', dil);
        formData.append('restoran_id', restoranID);

        fetch('/restoran/api', {
            method: 'POST',
            body: formData
        })
        .then(r => r.json())
        .then(data => {
            if (data.success && data.menu) {

                // menuData güncelle
                for (const catKey in data.menu) {
                    if (menuData[catKey]) {
                        menuData[catKey].title    = data.menu[catKey].title;
                        menuData[catKey].products = data.menu[catKey].products;
                    }
                }

                // Ana sayfadaki kategori kartı başlıklarını güncelle
                for (const catKey in data.menu) {
                    const titleEl = document.querySelector(`[onclick="showCategory('${catKey}')"] h3`);
                    if (titleEl) {
                        titleEl.textContent = data.menu[catKey].title;
                    }
                }

                // Ürün hakkında metnini güncelle
                if (data.urunHakkinda) {
                    urunHakkindaMetni = data.urunHakkinda;
                }
                if (data.urunHakkindaBaslik) {
                    urunHakkindaBaslik = data.urunHakkindaBaslik;
                }

                // Kategori sayfası açıksa yenile
                if (currentCategory && document.getElementById('categoryPage').classList.contains('active')) {
                    showCategory(currentCategory);
                }

                // Ürün sayfası açıksa yenile
                if (currentProductId && document.getElementById('productPage').classList.contains('active')) {
                    showProduct(currentProductId);
                }
            }
        })
        .catch(err => console.error('Çeviri hatası:', err))
        .finally(() => {
            dilYukleniyor = false;
        });
    }

    async function kurlariYukle() {
        const bugun = new Date().toISOString().split('T')[0];
        const cacheTarih = localStorage.getItem('doviz_tarih');
        const cacheKurlar = localStorage.getItem('doviz_kurlar');

        if (cacheTarih === bugun && cacheKurlar) {
            kurlar = JSON.parse(cacheKurlar);
            document.getElementById('kurBilgisi').textContent = '✓ Güncel kur yüklendi';
            return;
        }

        const f = new FormData();
        f.append('form_type', 'getDovizKur');

        try {
            const res = await fetch('/restoran/api', { method: 'POST', body: f });
            const data = await res.json();

            if (data.success) {
                kurlar = data.kurlar;
                localStorage.setItem('doviz_tarih', bugun);
                localStorage.setItem('doviz_kurlar', JSON.stringify(kurlar));
                document.getElementById('kurBilgisi').textContent = '✓ Güncel kur yüklendi';
            } else {
                document.getElementById('kurBilgisi').textContent = '⚠ Kur yüklenemedi';
            }
        } catch(e) {
            document.getElementById('kurBilgisi').textContent = '⚠ Kur yüklenemedi';
        }
    }

    function tldenCevir(tlFiyat, hedefBirim) {
        if (hedefBirim === 'TRY') return tlFiyat;
        if (!kurlar[hedefBirim]) return tlFiyat;
        return (tlFiyat * kurlar[hedefBirim]).toFixed(2);
    }

    function paraBirimiSec(birim, sembol, ad) {
        secilenBirim = birim;
        secilenSembol = sembol;

        // Aktif butonu güncelle
        document.querySelectorAll('.doviz-btn').forEach(btn => {
            btn.classList.remove('active-doviz');
        });
        document.getElementById('btn-' + birim).classList.add('active-doviz');

        // Kur bilgisini güncelle
        if (birim === 'TRY') {
            document.getElementById('kurBilgisi').textContent = 'Türk Lirası seçildi';
        } else {
            const kur = kurlar[birim];
            if (kur) {
                document.getElementById('kurBilgisi').textContent = `1 ₺ = ${kur} ${ad}`;
            }
        }

        // Eğer kategori sayfasındaysak ürünleri yenile
        if (currentCategory && document.getElementById('categoryPage').classList.contains('active')) {
            showCategory(currentCategory);
        }
        // Ürün sayfası açıksa yenile
        if (document.getElementById('productPage').classList.contains('active')) {
            showProduct(currentProductId);
        }
    }

    function toggleDovizWidget() {
        dovizWidgetAcik = !dovizWidgetAcik;
        const liste = document.getElementById('dovizListesi');
        const icon = document.getElementById('dovizToggleIcon');
        if (dovizWidgetAcik) {
            liste.classList.remove('hidden');
            icon.className = 'fas fa-chevron-down text-xs';
        } else {
            liste.classList.add('hidden');
            icon.className = 'fas fa-chevron-up text-xs';
        }
    }

    // Kurları sayfa açılınca yükle
    kurlariYukle();
    // Initialize
    checkStoreStatus();
    setInterval(checkStoreStatus, 60000); // Check every minute
</script>
</body>
</html>