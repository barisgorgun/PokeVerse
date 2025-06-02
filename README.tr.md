# 🎮 PokeVerse

PokeVerse, iOS için modern mimariyle geliştirilmiş kapsamlı bir **Pokémon** keşif ve favorileme uygulamasıdır.  
Swift & UIKit ile yazılmıştır; modüler, test edilebilir ve sürdürülebilir bir kod tabanına sahiptir.

---

## 🚀 Özellikler

- **Pokémon Listesi:**  
  Tüm Pokémon'ları görselleri ve isimleriyle birlikte hızlıca listeleyin.
- **Detay Ekranı:**  
  Hakkında, istatistikler ve evrim zinciri gibi bölümlerle zengin Pokémon detayları.
- **Favorilere Ekleme & Favoriler Listesi:**  
  Sevdiğiniz Pokémon’ları favorileyip, yalnızca favori listenizi görüntüleyin.
- **Offline Favori Takibi:**  
  Favoriler, cihazda güvenle **CoreData** ile saklanır.
- **Modern Arayüz & UX:**  
  Sade, hızlı ve erişilebilir arayüz.
- **Sekmeli Detay Görünümü:**  
  Detay ekranında “Hakkında”, “İstatistikler” ve “Evrim” sekmeleriyle kolay gezinme.
- **Arka Planda Resim Cache’leme:**  
  Pokémon görselleri hızlı ve verimli yüklenir.
- **Analitik:**  
  **Firebase Analytics** ile ekran ve buton etkileşimleri takip edilir.
- **Kapsamlı Unit Testler:**  
  Kritik işlevler için detaylı birim testleri.
- **Gerçek Zamanlı Veri Akışı:**  
  Tüm servis istekleri ve veri işlemleri `async/await` ile asenkron yapılır.
- **Çoklu Dil Desteği:**  
  Uygulama Türkçe ve İngilizce dillerinde kullanılabilir. Sistem dilinize göre otomatik uyum sağlar.

---

## 🏛️ Mimari & Teknik Detaylar

- **Katmanlı Mimari:**  
  Uygulama, Presenter, Interactor, Service, ViewController olarak ayrılmıştır.
- **Dependency Injection**
- **Protokol Bazlı Tasarım**
- **Asenkron Programlama:**  
  Tüm ağ istekleri ve veri işlemleri Swift’in `async/await` altyapısı ile yapılır.
- **CoreData:**  
  Favori Pokémon'larınız cihazınızda saklanır, offline kullanılabilir.
- **Firebase Analytics:**  
  Kullanıcı davranışları ve uygulama etkileşimleri izlenir.
- **SwiftUI:**  
  Splash ekranı SwiftUI ile modern şekilde hazırlanmıştır.

---

## 🧪 Testler

Proje kapsamlı **unit testler** içerir:
- Hem iş mantığı (Interactor, Presenter) hem de servis katmanları için testler yazılmıştır.
- Hata/başarı senaryoları, favori ekleme/çıkarma, veri çekme, hata yönetimi gibi akışlar kapsanır.
- Test raporları otomatik olarak `fastlane/test_output` altında HTML olarak üretilir.

Testleri çalıştırmak için:
```bash
Cmd + U
```

---

## 🛠️ Kullanılan Teknolojiler & Kütüphaneler

- **Swift (UIKit + SwiftUI)**
- **CoreData**
- **Firebase Analytics**
- **PokeAPI** (REST)
- **async/await** (Swift 5.5+)
- **XCTest**
- **Katmanlı mimari**
- **Lokalizasyon (Türkçe & İngilizce)**

---

## 🌐 Dil Desteği

PokeVerse, **Türkçe** ve **İngilizce** olmak üzere iki farklı dilde kullanılabilir.  
Uygulama, sistem dilinizi otomatik olarak algılar ve uygun dili gösterir.  
Yeni bir dil desteği eklemek için lokalizasyon dosyalarını genişletebilirsiniz.

---

## ⚡ Kurulum

1. Depoyu klonlayın:
   ```bash
   git clone https://github.com/barisgorgun/PokeVerse.git
   ```
2. Xcode ile açın.
3. Bağımlılıklar otomatik yönetilir.
4. Firebase için kendi `GoogleService-Info.plist` dosyanızı ekleyin (zorunlu değil).
5. Simülatörde veya gerçek cihazda çalıştırın.

---

## 📱 Ekranlar

- **Pokémon Listesi**  
- **Detay**  
- **Favoriler**

---

## 🤝 Katkı ve Lisans

Pull request ve issue’lara açıksınız.  
Kodunuzu testlerle güçlendirmeyi unutmayın!

---

**Geliştirici:** [Barış Görgün](https://github.com/barisgorgun)

[🇬🇧 For English, click here](README.md)