# HK Case Study
Bu proje, mobil uygulama üzerinden QR kod okutarak web uygulamasında güvenli giriş yapılmasını sağlayan bir authentication akışını içerir.  


# Kurulum Adımları

## Projeyi Klonla
```bash
git clone <repo-url>
```
## Flutter Bağımlılıklarını Yükle
```bash
flutter pub get
```
## Firebase Projesini Hazırla
```bash
Authentication → Phone Auth aktif

Firestore → users ve login_sessions collection’ları

Web + Android app Firebase’e eklenmiş olmalı

Android için google-services.json

Flutter için firebase_options.dart (FlutterFire CLI ile)
```
## Firebase Security Rules
```bash
/users/{uid} → sadece request.auth.uid == uid okuyabilir

/login_sessions/{sessionId}

Web → session oluşturabilir

Mobil (login olmuş user) → session onaylayabilir

Detaylı kurallar projede firestore.rules dosyasında yer alıyor.
```

## Cloud Function (Web Login Token)
```bash
firebase deploy --only functions
```
## Uygulamayı Çalıştır
```bash
flutter run
flutter run -d chrome
```

# Mimari Yaklaşım

## Kullanılan Mimari
* MVVM + Repository Pattern

* GetX → State Management & Routing

* Firebase → Auth, Firestore, Cloud Functions

## Repository Mantığı
- UserRepository

Firestore /users/{uid} okuma

- LoginSessionRepository

QR session oluşturma

Session onaylama

Session dinleme (stream)

Controller katmanı doğrudan Firebase API çağırmaz, sadece repository kullanır.

# QR Login Akışı
## Web – QR Session Oluşturma
Web kullanıcı “QR Oluştur” butonuna basar

Firestore’da /login_sessions/{id} oluşturulur

QR kod olarak sessionId gösterilir

## Mobil – QR Okutma & Onay

Mobil kullanıcı login olmuş durumdadır

QR okutulur → sessionId alınır

Mobil uygulama session’ı onaylar

## Cloud Function – Custom Token Üretimi
Session approved olunca Cloud Function tetiklenir

Kullanıcı için Firebase Custom Token üretilir

Token session dokümanına yazılır

## Web – Firebase Auth ile Giriş
Web session’ı dinler

customToken geldiğinde:
```dart
await FirebaseAuth.instance.signInWithCustomToken(token);
```

## Web Profile Ekranı

Web artık Firebase Auth içindedir

FirebaseAuth.currentUser.uid erişilebilir

/users/{uid} okunur

Profil ekranı açılır 

## Güvenlik Avantajları
* QR session tek kullanımlık

* Session süreli (expire)

* Web tarafı doğrudan userId alamaz

* Giriş onayı mobil cihazdan yapılır

* Firestore Rules + Firebase Auth birlikte çalışır