# RULES.md — sudah dipindahkan

Aturan pengembangan proyek ini tidak lagi disimpan di file ini.

**Sumber tunggal: [`AGENTS.md`](./AGENTS.md)**

`AGENTS.md` adalah file yang dibaca otomatis oleh OpenCode (dan agen AI lain) di awal setiap sesi. OpenCode V2 hanya mengenali `AGENTS.md` — bukan `RULES.md` — jadi memindahkan isi ke sana membuat aturan benar-benar aktif, bukan sekadar dokumen.

## Isi yang dipindahkan

| Aturan lama | Lokasi sekarang |
|---|---|
| Fokus pengembangan web-only | `AGENTS.md` → *Project identity* |
| Plugin: `flutter_lints`, `freezed`, `flutter_riverpod` | `AGENTS.md` → *Project identity* |
| Provider Riverpod ditulis inline di atas class/fungsi | `AGENTS.md` → *Riverpod providers* |
| Arsitektur Feature-First | `AGENTS.md` → *Architecture rules* |
| Larangan logika bisnis di file UI | `AGENTS.md` → *Architecture rules* |
| Struktur `presentation/` `provider/` `data/` | `AGENTS.md` → *Architecture rules* |
| Batas 150 baris per file | `AGENTS.md` → *Architecture rules* |
| Single Responsibility Principle | `AGENTS.md` → *Architecture rules* |

## Satu catatan: `dart_code_metrics` tidak pernah aktif

Aturan lama menyebut `dart_code_metrics`, tetapi:

1. Paket itu **tidak pernah terpasang** — tidak ada di `dev_dependencies` `pubspec.yaml` maupun di `analysis_options.yaml`. Yang aktif hanya `flutter_lints`.
2. Paket itu sudah **discontinued**. Di pub.dev tertulis *"This package has been discontinued and is no longer maintained"* — versi 5.7.6, publisher `dcm.dev`, terbit 3 tahun lalu. Perusahaannya beralih ke model lisensi berbayar.

Jadi aturan tersebut tidak hanya tidak aktif, tapi juga sudah tidak layak dipasang. Kalau nanti butuh metrik kompleksitas atau pemeliharaan kode, pilihannya sekarang terbatas — dan untuk tujuan nyata proyek ini (jaga file tetap pendek, business logic tidak bocor ke UI), aturan di `AGENTS.md` plus lint di `analysis_options.yaml` sudah cukup.

## Cara memperbarui aturan

Edit `AGENTS.md`. Jangan menambah file instruksi lain — OpenCode hanya memuat `AGENTS.md` di setiap level folder.
