<?php $restoran = $data['getRestoranInfo']['data']; ?>
<!-- Store Information Page -->
<div id="storePage" class="page fade-in p-6" style="display: block">
    <div class="mb-6">
        <h2 class="text-2xl font-bold text-gray-800">Mağaza Bilgileri</h2>
        <p class="text-gray-600">Restoranınızın bilgilerini düzenleyin</p>
    </div>

    <div class="bg-white rounded-xl shadow-md p-6">
        <form onsubmit="saveStoreInfo(event)">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Restoran Adı</label>
                    <input type="text" id="restaurantName" value="<?= $restoran['name'] ?>" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Slogan</label>
                    <input type="text" id="restaurantSlogan" value="<?= $restoran['slogan'] ?>" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                <div class="md:col-span-2">
                    <label class="block text-sm font-medium text-gray-700 mb-2">Tam Adres</label>
                    <input type="text" id="restaurantAddress" value="<?= $restoran['adres'] ?>" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">İlçe</label>
                    <input type="text" id="restaurantAddressIlce" value="<?= $restoran['ilce'] ?>" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">İl</label>
                    <input type="text" id="restaurantAddressIl" value="<?= $restoran['sehir'] ?>" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Telefon</label>
                    <input type="text" id="restaurantPhone" value="<?= $restoran['phone'] ?>" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">E-posta</label>
                    <input type="email" id="restaurantEmail" disabled value="<?= $restoran['mail'] ?>" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
            </div>
            <div class="mt-6 flex justify-end">
                <button type="submit" class="bg-purple-600 text-white px-6 py-2 rounded-lg hover:bg-purple-700 transition">
                    <i class="fas fa-save mr-2"></i>Güncelle
                </button>
            </div>
        </form>
    </div>

    <!-- Hava Durumu Ayarları -->
    <div class="bg-white rounded-xl shadow-md p-6 mt-6">
        <h3 class="text-lg font-semibold text-gray-800 mb-1">
            <i class="fas fa-cloud-sun text-purple-600 mr-2"></i>Hava Durumu Göstergesi
        </h3>
        <p class="text-sm text-gray-500 mb-4">Restoranınızda açık alan veya teras varsa müşterilerinize anlık hava durumu gösterilebilir.</p>

        <div class="mb-4">
            <label class="flex items-center space-x-3 cursor-pointer">
                <div class="relative" onclick="terasToggle()">
                    <div id="terasToggleBg" class="w-12 h-6 <?= $restoran['teras_var'] ? 'bg-purple-600' : 'bg-gray-300' ?> rounded-full transition-colors duration-300"></div>
                    <div id="terasToggleDot" class="absolute top-1 left-1 w-4 h-4 bg-white rounded-full shadow transition-transform duration-300" style="transform: translateX(<?= $restoran['teras_var'] ? '24px' : '0' ?>)"></div>
                </div>
                <span class="text-gray-700 font-medium">Restoranımda açık alan / teras var</span>
            </label>
        </div>

        <div id="konumAlani" class="<?= $restoran['teras_var'] ? '' : 'hidden' ?>">
            <div class="bg-purple-50 border border-purple-200 rounded-lg p-4 mb-4">
                <p class="text-sm text-purple-700 font-medium mb-1">
                    <i class="fas fa-map-marker-alt mr-1"></i>Restoranınızın konumunu girin
                </p>
                <p class="text-xs text-purple-600">Google Maps'te restoranınızı bulun, sağ tıklayın ve koordinatları kopyalayın.</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Enlem (Latitude)</label>
                    <input type="text" id="konumLat" value="<?= $restoran['konum_lat'] ?? '' ?>" placeholder="Örn: 41.0082"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Boylam (Longitude)</label>
                    <input type="text" id="konumLng" value="<?= $restoran['konum_lng'] ?? '' ?>" placeholder="Örn: 28.9784"
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
            </div>

            <button onclick="konumuOtomatikAl()" class="mt-3 text-sm text-purple-600 hover:text-purple-800 transition">
                <i class="fas fa-crosshairs mr-1"></i>Konumumu otomatik al
            </button>

            <div id="havaDurumuOnizleme" class="<?= ($restoran['konum_lat'] && $restoran['konum_lng']) ? '' : 'hidden' ?> mt-4 bg-gray-50 border border-gray-200 rounded-lg p-4">
                <p class="text-xs text-gray-400 mb-2">Önizleme:</p>
                <div id="onizlemeIcerik"><p class="text-sm text-gray-500">Yükleniyor...</p></div>
            </div>
        </div>

        <div class="mt-4 flex justify-end">
            <button onclick="kaydetHavaDurumu()" class="bg-purple-600 text-white px-6 py-2 rounded-lg hover:bg-purple-700 transition">
                <i class="fas fa-save mr-2"></i>Hava Durumu Ayarlarını Kaydet
            </button>
        </div>
    </div>
</div>

<script>

let terasAcik = <?= $restoran['teras_var'] ? 'true' : 'false' ?>;

    function saveStoreInfo(e) {
        e.preventDefault();
        
        // Linki al
        var linkValue = document.getElementById('googleMapsUrl').value;
        
        // Konsola yazdır (F12 ile bak)
        console.log("Gönderilen Link:", linkValue);

        const btn = e.target.querySelector('button[type="submit"]');
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Kaydediliyor...';
        btn.disabled = true;

        const formData = new FormData();
        formData.append('form_type', 'updateRestoranInfo');
        formData.append('restoranName', document.getElementById('restaurantName').value);
        formData.append('restoranSlogan', document.getElementById('restaurantSlogan').value);
        formData.append('restoranAddress', document.getElementById('restaurantAddress').value);
        formData.append('restoranAddressIlce', document.getElementById('restaurantAddressIlce').value);
        formData.append('restoranAddressIl', document.getElementById('restaurantAddressIl').value);
        formData.append('restoranAddressPhone', document.getElementById('restaurantPhone').value);
        // Burada formData'ya ekliyoruz

        fetch('/yonetim/api', {
            method: 'POST',
            body: formData
        })
        .then(r => r.json())
        .then(data => {
            console.log("Sunucu Cevabı:", data); // Gelen cevabı kontrol et
            if (data.success) {
                showToast('Bilgiler başarıyla güncellendi!', 'success');
            } else {
                showToast(data.message || 'Hata oluştu', 'error');
            }
        })
        .catch(err => {
            console.error(err);
            showToast('Sunucu hatası', 'error');
        })
        .finally(() => {
            btn.innerHTML = originalText;
            btn.disabled = false;
        });
    }
    function showToast(mesaj, tip = 'success') {
        const renk = tip === 'success' ? 'bg-purple-600' : 'bg-red-500';
        const ikon = tip === 'success' ? 'fa-check-circle' : 'fa-times-circle';

        const toast = document.createElement('div');
        toast.className = `fixed top-6 right-6 z-50 flex items-center space-x-3 ${renk} text-white px-5 py-3 rounded-xl shadow-xl transition-all duration-500 opacity-0`;
        toast.innerHTML = `<i class="fas ${ikon}"></i><span>${mesaj}</span>`;
        document.body.appendChild(toast);

        setTimeout(() => toast.style.opacity = '1', 50);
        setTimeout(() => {
            toast.style.opacity = '0';
            setTimeout(() => toast.remove(), 500);
        }, 3000);
    }

function terasToggle() {
    terasAcik = !terasAcik;
    const bg   = document.getElementById('terasToggleBg');
    const dot  = document.getElementById('terasToggleDot');
    const alan = document.getElementById('konumAlani');

    if (terasAcik) {
        bg.classList.remove('bg-gray-300');
        bg.classList.add('bg-purple-600');
        dot.style.transform = 'translateX(24px)';
        alan.classList.remove('hidden');
    } else {
        bg.classList.add('bg-gray-300');
        bg.classList.remove('bg-purple-600');
        dot.style.transform = 'translateX(0)';
        alan.classList.add('hidden');
    }
}

function konumuOtomatikAl() {
    if (!navigator.geolocation) {
        alert('Tarayıcınız konum almayı desteklemiyor.');
        return;
    }
    navigator.geolocation.getCurrentPosition(function(pos) {
        document.getElementById('konumLat').value = pos.coords.latitude.toFixed(6);
        document.getElementById('konumLng').value = pos.coords.longitude.toFixed(6);
        havaDurumuOnizle();
    }, function() {
        alert('Konum alınamadı. Lütfen manuel girin.');
    });
}

function havaDurumuOnizle() {
    const lat    = document.getElementById('konumLat').value;
    const lng    = document.getElementById('konumLng').value;
    if (!lat || !lng) return;

    const onizleme = document.getElementById('havaDurumuOnizleme');
    const icerik   = document.getElementById('onizlemeIcerik');
    onizleme.classList.remove('hidden');
    icerik.innerHTML = '<p class="text-sm text-gray-500">Yükleniyor...</p>';

    const f = new FormData();
    f.append('form_type', 'getHavaDurumu');
    f.append('lat', lat);
    f.append('lng', lng);

    fetch('/yonetim/api', { method: 'POST', body: f })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            const h = data.hava;
            icerik.innerHTML = `
                <div class="flex items-center space-x-4">
                    <span class="text-4xl">${h.ikon}</span>
                    <div>
                        <p class="text-2xl font-bold text-gray-800">${h.sicaklik}°C</p>
                        <p class="text-sm text-gray-500">${h.durum} · Nem: %${h.nem} · Rüzgar: ${h.ruzgar} km/s</p>
                    </div>
                </div>
            `;
        } else {
            icerik.innerHTML = '<p class="text-sm text-red-500">Hava durumu alınamadı.</p>';
        }
    });
}

function kaydetHavaDurumu() {
    const lat = document.getElementById('konumLat').value;
    const lng = document.getElementById('konumLng').value;

    const f = new FormData();
    f.append('form_type', 'saveHavaDurumuAyar');
    f.append('teras_var', terasAcik ? 1 : 0);
    f.append('konum_lat', lat);
    f.append('konum_lng', lng);

    fetch('/yonetim/api', { method: 'POST', body: f })
    .then(r => r.json())
    .then(data => {
        if (data.success) {
            showToast('Hava durumu ayarları kaydedildi!', 'success');
            if (lat && lng) havaDurumuOnizle();
        }
    });
}

document.getElementById('konumLat')?.addEventListener('blur', havaDurumuOnizle);
document.getElementById('konumLng')?.addEventListener('blur', havaDurumuOnizle);

window.addEventListener('load', function() {
    const lat = document.getElementById('konumLat').value;
    const lng = document.getElementById('konumLng').value;
    if (lat && lng) havaDurumuOnizle();
});
</script>