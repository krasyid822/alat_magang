# Fokus pengembangan hanya web-only

# Gunakan plugin flutter dart_code_metrics, flutter_lints, freezed, flutter_riverpod

# "Saya menggunakan riverpod_generator. Tolong buatkan provider untuk fitur [Nama Fitur] menggunakan anotasi @riverpod. Jangan tulis provider di luar file, tapi tulis langsung di atas class/fungsi logic-nya."

# "Saya sedang mengerjakan proyek Flutter dengan arsitektur Feature-First. Tolong patuhi aturan ini setiap kali menulis kode:
	- Jangan pernah menaruh logika bisnis (perhitungan, API, service) di dalam file UI (Widget).
	- Jika fitur baru, buatlah folder di lib/features/<nama_fitur>/.
	- Pisahkan menjadi file: presentation/ (untuk UI), provider/ (untuk state), dan data/ (untuk API/repo).
	- Jika file melebihi 150 baris, otomatis pecah menjadi beberapa sub-widget atau file.
	- Gunakan pendekatan 'Single Responsibility Principle'."