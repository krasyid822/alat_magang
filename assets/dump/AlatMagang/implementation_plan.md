# Implementation Plan: Fitur Eksport ZIP, Perbaikan Kamera, dan Preview Zoomable Gambar

Rencana ini dibuat untuk mengimplementasikan fitur ekspor data magang terstruktur ke dalam format ZIP, memperbaiki bug kamera terbalik (inverted), menambahkan tombol ganti kamera (depan/belakang), dan menyediakan pratinjau gambar penuh yang dapat diperbesar (zoomable).

## User Review Required

> [!IMPORTANT]
> * **Library Baru**: Menggunakan library `archive` (sudah ditambahkan ke pubspec) untuk membundel file ZIP di sisi client (web browser).
> * **Keamanan Kamera**: Mengubah izin webcam untuk mendukung ganti kamera secara dinamis dengan menghentikan track aktif sebelumnya.

## Proposed Changes

### Shared & Data Layer
#### [NEW] [zip_service.dart](file:///home/rasyidk/vscode/alat_magang/lib/features/shared/data/zip_service.dart)
* Buat kelas helper baru `ZipService` yang akan:
  * Mengumpulkan data profil, logbook, detail pekerjaan, riset bab 2, dan checklist dokumen dari provider/storage.
  * Mengompres data tersebut menjadi file ZIP.
  * Struktur ZIP:
    * `profil_mahasiswa.json`
    * `logbook/logbook_mingguan.json`
    * `logbook/foto_kegiatan/` (mengambil data Base64 foto logbook ke format `.jpg`)
    * `pekerjaan/daftar_tugas.json`
    * `pekerjaan/dokumentasi/` (mengambil Base64 foto tugas)
    * `riset/bahan_bab2.json`
    * `dokumen/checklist.json`
  * Menyediakan fungsi download otomatis di browser (`html.AnchorElement`).

---

### Camera & Image Preview Enhancements
#### [MODIFY] [job_form.dart](file:///home/rasyidk/vscode/alat_magang/lib/features/job_details/presentation/widgets/job_form.dart)
* Ubah antarmuka overlay webcam di `_captureFromCamera`:
  * Tambahkan tombol **Ganti Kamera** (Kamera Depan vs Kamera Belakang).
  * Tambahkan tombol **Mirror View** (untuk memutar balik video jika terbalik).
  * Secara dinamis atur `facingMode` (antara `'user'` dan `'environment'`).
  * Jika menggunakan kamera depan (`'user'`), aktifkan auto-mirror (`scaleX(-1)`), sedangkan kamera belakang dinonaktifkan (`scaleX(1)`).
  * Sesuaikan koordinat canvas drawing sesuai mode cermin (`_isMirrored`).
* Tambahkan gesture tap pada preview foto di form agar memanggil dialog pratinjau gambar zoomable.

#### [MODIFY] [job_detail_card.dart](file:///home/rasyidk/vscode/alat_magang/lib/features/job_details/presentation/widgets/job_detail_card.dart)
* Tambahkan deteksi klik/tap pada header gambar kartu tugas dan gambar di dialog detail agar membuka dialog pratinjau zoomable.

---

### UI Integration
#### [MODIFY] [documents_screen.dart](file:///home/rasyidk/vscode/alat_magang/lib/features/documents/presentation/documents_screen.dart)
* Tambahkan tombol premium **"Ekspor & Download Semua Data Magang (ZIP)"** di bagian atas tab Berkas Dokumen.
* Sambungkan tombol ke `ZipService.downloadInternshipZip(nim, ref)`.

---

## Verification Plan

### Automated Tests
* Jalankan `flutter build web` untuk memastikan tidak ada kesalahan kompilasi library `archive` pada target Web.

### Manual Verification
* **ZIP**: Klik tombol ekspor, buka file ZIP yang didownload, dan pastikan struktur direktori rapi serta gambar-gambar logbook/pekerjaan dapat dibuka.
* **Kamera**: Buka overlay kamera, klik ganti kamera, dan pastikan kamera belakang tidak terbalik (mirror mati) sementara kamera depan terbalik secara benar.
* **Zoom**: Ketuk gambar pada logbook atau tugas, pastikan dialog interaktif terbuka dan bisa di-pinch/scroll untuk zoom.
