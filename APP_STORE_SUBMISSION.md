# Fixora — App Store Submission Guide

## 1. Xcode Build Ayarları

| Alan | Değer |
|---|---|
| Bundle Identifier | `com.ibrahimkaratas.fixora` |
| Version (CFBundleShortVersionString) | `1.0.0` |
| Build (CFBundleVersion) | `1` |
| Deployment Target | iOS 13.0+ |
| Signing | Automatic — Apple Developer hesabınızla |

### Build komutu

```bash
flutter build ipa --release
```

Çıktı: `build/ios/ipa/fixora.ipa`

### Xcode'da manuel adımlar
1. `ios/Runner.xcworkspace` dosyasını Xcode ile aç
2. Runner target → Signing & Capabilities → Team: kendi Apple Developer hesabı
3. Product → Archive
4. Organizer → Distribute App → App Store Connect → Upload

---

## 2. App Store Connect — Genel Bilgiler

| Alan | Değer |
|---|---|
| App Name | **Fixora** |
| Subtitle | **Makine Bakım Yönetimi** |
| Bundle ID | `com.ibrahimkaratas.fixora` |
| SKU | `fixora-001` |
| Primary Language | Türkçe |
| Primary Category | **Business** (İş) |
| Secondary Category | **Productivity** (Verimlilik) |
| Pricing | Ücretsiz (Free) |
| Availability | Tüm ülkeler / Türkiye öncelikli |

---

## 3. Uygulama Açıklaması (Türkçe)

### Kısa Açıklama (Promotional Text — max 170 karakter)
```
Makinelerinizi takip edin, arızaları kaydedin, bakımları planlayın. Fixora ile ekibinizle birlikte tüm bakım süreçleri tek ekranda.
```

### Tam Açıklama (Description — max 4000 karakter)
```
Fixora, endüstriyel tesisler ve üretim ortamları için tasarlanmış akıllı bir bakım yönetim sistemidir. Makinelerinizin sağlık durumunu anlık olarak takip edin, arızaları kolayca kaydedin ve bakım planlarınızı ekibinizle koordineli şekilde yönetin.

— ÖZELLİKLER —

Makine Takibi
• Tüm makinelerinizi tek ekranda görüntüleyin
• Sağlık skoru ile anlık durum takibi (Aktif / Uyarı / Kritik)
• Makine türü, konum, üretici ve model bilgisi

Arıza Kaydı
• Mekanik, elektriksel, hidrolik ve diğer arıza türleri
• Düşük / Orta / Yüksek / Kritik önem derecelendirmesi
• Arıza fotoğrafları ekleyerek görsel belgeleme
• Tüm ekip üyeleri arızaları gerçek zamanlı görebilir

Bakım Planlama
• Yaklaşan bakımları programlayın ve gecikmeleri önleyin
• Görev açıklaması ve tarih planlaması
• Planlanan ve geciken bakımları renk kodlu listede görüntüleyin

Tahmin & Analiz
• Makine sağlık skoruna dayalı risk değerlendirmesi
• Sonraki bakım tarihi tahmini
• Titreşim, sıcaklık, yük ve verimlilik metrikleri

Ekip Yönetimi
• Yönetici ve Çalışan rol sistemi
• Şirket kodu ile ekip üyelerini kolayca davet edin
• Tüm ekip aynı makine verilerini gerçek zamanlı paylaşır

Kullanıcı Dostu Arayüz
• Sezgisel ve modern tasarım
• Türkçe / İngilizce dil desteği
• Açık ve Koyu tema seçeneği

— KİM İÇİN? —
Fixora; fabrika, üretim tesisi, atölye ve endüstriyel bakım ekiplerinin verimliliğini artırmak için geliştirilmiştir.

— GÜVENLİK —
Verileriniz Firebase altyapısıyla güvenle saklanır. Şirket verileri yalnızca aynı şirketin üyeleri tarafından erişilebilir.
```

---

## 4. Uygulama Açıklaması (İngilizce)

### Promotional Text
```
Track your machines, log failures, plan maintenance. Fixora keeps your entire maintenance team in sync — all in one place.
```

### Description
```
Fixora is a smart maintenance management system designed for industrial facilities and production environments. Monitor your machines in real time, log failures instantly, and manage maintenance schedules in coordination with your team.

— FEATURES —

Machine Tracking
• View all machines on a single dashboard
• Real-time health score monitoring (Active / Warning / Critical)
• Machine type, location, manufacturer and model details

Failure Logging
• Mechanical, electrical, hydraulic and other failure types
• Low / Medium / High / Critical severity levels
• Attach photos to failures for visual documentation
• All team members see updates in real time

Maintenance Planning
• Schedule upcoming maintenance and prevent delays
• Task description and date planning
• Color-coded list of scheduled and overdue maintenance

Predictions & Analytics
• Risk assessment based on machine health score
• Next service date estimation
• Vibration, temperature, load and efficiency metrics

Team Management
• Manager and Worker role system
• Invite team members easily with a company code
• Entire team shares machine data in real time

User-Friendly Interface
• Intuitive and modern design
• Turkish / English language support
• Light and Dark theme options

— WHO IS IT FOR? —
Fixora is built to boost the efficiency of maintenance teams in factories, production facilities, workshops and industrial environments.

— SECURITY —
Your data is securely stored on Firebase infrastructure. Company data is accessible only to members of the same company.
```

---

## 5. Anahtar Kelimeler (Keywords — max 100 karakter, virgülle ayrılır)

```
bakım,arıza,makine,üretim,fabrika,maintenance,failure,machine,endüstri,CMMS
```

> Not: Her iki dil için ayrı keyword alanı girilir. Uygulama adı ve açıklamada geçen kelimeleri keyword'e eklemeyin.

---

## 6. Support & URL Bilgileri

| Alan | Değer |
|---|---|
| Support URL | `https://wa.me/905343358496` (WhatsApp destek hattı) |
| Marketing URL | *(opsiyonel — web siteniz varsa)* |
| Privacy Policy URL | Aşağıda hazır şablon var |

---

## 7. Privacy Policy (Gizlilik Politikası)

App Store'a yüklemek için Privacy Policy zorunludur. Aşağıdaki metni bir web sayfasına (GitHub Pages, Notion, veya basit bir hosting) koyun ve URL'sini App Store Connect'e girin.

```
Fixora Gizlilik Politikası
Son güncelleme: Nisan 2026

Bu uygulama, hizmet sunmak amacıyla aşağıdaki verileri toplar:

1. Hesap Bilgileri: Kayıt sırasında girilen ad, e-posta adresi ve şifre (şifreler Firebase Auth tarafından şifreli saklanır).

2. Şirket & Makine Verileri: Kullanıcı tarafından girilen makine, arıza ve bakım kayıtları Firebase Firestore'da saklanır.

3. Fotoğraflar: Arıza kaydı sırasında yüklenen fotoğraflar Firebase Storage'da saklanır ve yalnızca aynı şirket üyeleri tarafından erişilebilir.

4. Cihaz İzinleri:
   - Kamera: Arıza fotoğrafı çekmek için kullanılır.
   - Fotoğraf Galerisi: Mevcut fotoğraflardan seçim yapmak için kullanılır.

5. Veri Paylaşımı: Kullanıcı verileri üçüncü taraflarla paylaşılmaz. Veriler yalnızca Firebase (Google LLC) altyapısında saklanır.

6. Veri Silme: Hesabınızı silmek için destek hattımıza başvurabilirsiniz: +90 534 335 84 96

Sorularınız için: ibrahimmkaratas@gmail.com
```

---

## 8. Ekran Görüntüleri (Screenshots)

App Store'a en az 1 ekran görüntüsü zorunludur. Önerilen boyutlar:

| Cihaz | Boyut | Gerekli mi? |
|---|---|---|
| iPhone 6.9" (iPhone 15 Pro Max) | 1320 × 2868 px | **Zorunlu** |
| iPhone 6.5" (iPhone 14 Plus) | 1284 × 2778 px | Önerilen |
| iPhone 5.5" (iPhone 8 Plus) | 1242 × 2208 px | Opsiyonel |

### Önerilen ekran sırası
1. **Dashboard** — Ana sayfa, makine istatistikleri
2. **Makineler** — Makine listesi ve durum kartları
3. **Arıza Girişi** — Fotoğraflı arıza kayıt ekranı
4. **Makine Detay** — Sağlık skoru ve son arızalar
5. **Tahminler** — Risk analizi ekranı

> Ekran görüntüsü almak için emülatörde `Command+S` (Xcode Simulator) ya da gerçek cihazda yan buton + ses tuşu kombinasyonu kullanın.

---

## 9. App Review Bilgileri

App Store Review ekibine şu bilgileri girin:

### Demo Hesap
```
E-posta : demo@fixora.app   ← Bu hesabı Firebase'de oluşturun
Şifre   : Demo1234!
Rol     : Yönetici (Manager)
```

> Demo hesabını uygulamayı submit etmeden önce Firebase Authentication'da oluşturun ve birkaç makine + arıza kaydı ekleyin.

### Review Notları
```
Fixora, endüstriyel bakım ekipleri için makine arıza ve bakım yönetim uygulamasıdır.

Giriş: demo@fixora.app / Demo1234!

Temel akış:
1. Giriş yapın → Dashboard'da makine istatistikleri görünür
2. Makineler sekmesi → makine listesi ve detay
3. Arıza Gir butonu → fotoğraf ekleyerek arıza kaydedin
4. Profil → dil değiştirme, tema, şifre değiştirme özellikleri

Uygulama şirket kodlu davet sistemi kullanmaktadır. Demo hesabı şirket kodu: Firebase'de oluşturduğunuz şirketin ID'si.
```

---

## 10. Age Rating (Yaş Sınırı)

Tüm soruları **"Hayır / None"** olarak işaretleyin.

Sonuç: **4+** (Herkes için uygun)

---

## 11. iOS İzin Açıklamaları (Info.plist — Zaten Ekli)

| Anahtar | Açıklama |
|---|---|
| `NSCameraUsageDescription` | Arıza fotoğrafı çekmek için kameraya erişim gerekiyor. |
| `NSPhotoLibraryUsageDescription` | Arıza fotoğrafı eklemek için galeri erişimi gerekiyor. |

---

## 12. App Store'a Yükleme Adımları (Özet)

```
1. developer.apple.com → Certificates, IDs & Profiles
   → App ID oluştur: com.ibrahimkaratas.fixora

2. App Store Connect (appstoreconnect.apple.com)
   → My Apps → + → New App
   → Platform: iOS
   → Name: Fixora
   → Bundle ID: com.ibrahimkaratas.fixora
   → SKU: fixora-001

3. Terminal:
   flutter build ipa --release

4. Xcode → Product → Archive → Distribute App → App Store Connect

   VEYA

   xcrun altool / Transporter uygulaması ile .ipa yükle

5. App Store Connect → Build seçin → Metadata doldurun → Submit for Review
```

---

## 13. Kontrol Listesi (Submit Öncesi)

- [ ] Bundle ID `com.ibrahimkaratas.fixora` Apple Developer'da kayıtlı
- [ ] App Store Connect'te uygulama oluşturuldu
- [ ] Privacy Policy URL'si canlı bir sayfada yayında
- [ ] Demo hesabı Firebase'de oluşturuldu ve içerik girildi
- [ ] En az 1 ekran görüntüsü hazır (1320×2868 px)
- [ ] `flutter build ipa --release` hatasız çalışıyor
- [ ] Info.plist'te kamera izin metinleri mevcut
- [ ] `remove_alpha_ios: true` eklenerek launcher icon yeniden üretildi
- [ ] App Store Connect'te tüm zorunlu alanlar dolduruldu
