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

## Catatan
tambahkan loading screen splash screen saat aplikasi baru dibuka

