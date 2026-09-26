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

Semua perintah deploy memakai satu skrip yang sama. Pilih sesuai terminal Anda:

```bash
./deploy.sh            # Linux, macOS, Git Bash
```

```powershell
.\deploy.ps1           # Windows PowerShell
```

Keduanya cuma launcher; logika deploy ada di `deploy.py`. Yang sama bisa
dipanggil langsung: `python deploy.py` (opsi `--yes` untuk skip konfirmasi).

Pipeline yang dijalankan:

| # | Langkah | Kenapa |
|---|---|---|
| 1 | Cek `dart`, `flutter`, `firebase` | Gagal cepat, bukan di tengah build |
| 2 | Cek kredensial Firebase | Token kedaluwarsa tetap menampilkan "Logged in" di `firebase login:list` — tanpa cek ini deploy baru gagal setelah build selesai |
| 3 | Cek working tree git bersih | Peringatan agar tidak deploy kode yang belum di-commit |
| 4 | `flutter pub get` | Sinkron dependency |
| 5 | `dart run build_runner build` | Regenerate `.g.dart` / `.freezed.dart` — **wajib**, kalau tidak release build bisa memakai kode lama |
| 6 | `dart analyze` | Gate: error menghentikan deploy |
| 7 | `dart scripts/increment_build.dart` | Naikkan build number + sinkronkan `pubspec.yaml` |
| 8 | `flutter build web --release` | Build ke `build/web` |
| 9 | Konfirmasi versi | Tampilkan versi yang akan live, lalu tanya |
| 10 | `firebase deploy --only hosting` | Upload |

Tidak ada yang dimutasi (build number) sampai langkah 6 lolos.

Kredensial Firebase kedaluwarsa secara rutin. Kalau deploy berhenti di langkah 2,
jalankan `firebase login` lalu ulangi.

Nomor build naik sendiri setiap deploy. `kAppVersion` (semantic version) tetap
diubah manual di `lib/app_version.dart`. Kalau `kAppYear` ternyata lebih besar
daripada tahun sistem, script berhenti dan menolak mengubah apa pun — itu
indikasi jam salah atau file pernah diedit manual.
## Development
Gunakan perintah berikut untuk menjalankan build runner dan mengupdate kode real-time:
```dart
dart run build_runner watch
```

## Open-code
  Session   Konfirmasi penggunaan Flutter
  Continue  opencode -s ses_f24538a10ffe3ytuXwzv4ooorH

## Jika deploy gagal
firebase login --reauth

## Catatan
sepertinya belum ada validator otomatis untuk memastikan semua device memiliki data yang sama, contohnya di satu device sudah ada beberapa data saat aplikasi belim mengimplementasikan firestore, satu device lagi baru membuka aplikasi datanya jadi berbeda karena ternyata dari device yang terlanjur punya data tidak melakukan upload ke firestore

jadikan kelengkapan data profil sebagai pengaman tambahan untuk device yang mau login dengan nim terdaftar. misalnya jika user sudah melengkapi data nama lengkap, device lain atau baru harus memasukkan nama lengkap tersebut. jika user lupa, piliannya adalah dengan melihat data profil di device yang sudah login atau implementasikan sejak awal user harus menginputkan nomor whatsappnya, sistem akan mengirimkan data profil lengkap user ke nomor tersebut berformat base64, jadi user harus menggunakn konverter base64 to text yang sudah banyak bertebaran di web, fitur ini tersedia saat user ingin login, ada shortcut lupa data disitu yanng ketika diklik user diminta untuk memasukkan nomor whatsappnya

implementasikan pemerikasa akun sedang login device mana saja, berapa jumlahnya, sediakan fitur logout all untuk keluar dari semua device yang login ke akun tersebut. letakkan fitur ini di halaman info aplikasi (yang ada tulisan alat magang web v1.0.0+<nomor build>)

logout semua perangkat belum punya fitur seperti logout biasa untuk validasi dahulu perangjat yangvterlogin agar menghapus data lokalnya (tapi sebelum itu pastikan sibkronisasi dahulu). kalau tidak bigini saja, beri user pilihan saat logout all apakah mau menunggu perangkat yang masih offline untuk online atau perintahkan perangkat terlogin yang offline untuk menghapus data lokalnya tanpa sinkronisasi begitu online

Aspek Penulisan	Aturan Resmi Polmed TA 2025/2026	Catatan & Tips
Ukuran & Bahan Kertas	A4 (21 cm x 29,7 cm), HVS 70 g/m², warna putih bersih.	Pastikan printer diatur ke A4 (bukan Letter).
Batas Tepi (Margin)	Atas: 3 cm, Kiri: 4 cm, Bawah: 3 cm, Kanan: 3 cm.	Margin kiri lebih lebar (4 cm) untuk ruang penjilidan draf.
Jenis Huruf (Font)	Times New Roman ukuran 12 pt untuk teks naskah dan judul tabel/gambar.	Kecuali isi tabel menggunakan ukuran 10 pt.
Jarak Baris (Spasi)	1,5 spasi untuk naskah utama.	1 spasi untuk kutipan langsung > 4 baris, judul bab, judul tabel/gambar, dan daftar pustaka.
Format Paragraf	Rata kiri-kanan (Justify).	Paragraf baru menjorok ke dalam. Kalimat awal wajib huruf kapital.
Warna Sampul (Cover)	Menggunakan hard cover dengan warna sesuai bendera jurusan masing-masing.	Dibuat sama persis dengan Lembar Judul laporan.

tambahkan fitur untuk menzip semua data alat magang dengan rapi terstruktur

perbaiki kamera yang inverted, tambahkan switch kamera, izinkan preview gambar penuh dan bisa zoom in/out

pembungkus RunningText

kartu bimbingan magang, laporan kehadiran magang dari perusahaan