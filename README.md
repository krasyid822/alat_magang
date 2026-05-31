# alat_magang

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build & Deploy
Gunakan perintah berikut untuk men-generate build web dengan auto-increment nomor build:
```bash
dart scripts/increment_build.dart && flutter build web --release && firebase deploy --only hosting
```
atau
```pwsh
.\deploy.ps1
```
## Development
Gunakan perintah berikut untuk menjalankan build runner dan mengupdate kode real-time:
```dart
dart run build_runner watch
```

## Catatan
sepertinya belum ada validator otomatis untuk memastikan semua device memiliki data yang sama, contohnya di satu device sudah ada beberapa data saat aplikasi belim mengimplementasikan firestore, satu device lagi baru membuka aplikasi datanya jadi berbeda karena ternyata dari device yang terlanjur punya data tidak melakukan upload ke firestore

jadikan kelengkapan data profil sebagai pengaman tambahan untuk device yang mau login dengan nim terdaftar. misalnya jika user sudah melengkapi data nama lengkap, device lain atau baru harus memasukkan nama lengkap tersebut. jika user lupa, piliannya adalah dengan melihat data profil di device yang sudah login atau implementasikan sejak awal user harus menginputkan nomor whatsappnya, sistem akan mengirimkan data profil lengkap user ke nomor tersebut berformat base64, jadi user harus menggunakn konverter base64 to text yang sudah banyak bertebaran di web, fitur ini tersedia saat user ingin login, ada shortcut lupa data disitu yanng ketika diklik user diminta untuk memasukkan nomor whatsappnya

implementasikan pemerikasa akun sedang login device mana saja, berapa jumlahnya, sediakan fitur logout all untuk keluar dari semua device yang login ke akun tersebut. letakkan fitur ini di halaman info aplikasi (yang ada tulisan alat magang web v1.0.0+<nomor build>)