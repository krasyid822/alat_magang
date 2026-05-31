import 'dart:html' as html;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'local_storage.g.dart';

@riverpod
LocalStorage localStorage(Ref ref) {
  return LocalStorage();
}

class LocalStorage {
  static const String _nimKey = 'alat_magang_nim';

  /// Membaca NIM yang tersimpan di LocalStorage browser.
  String? getNim() {
    try {
      return html.window.localStorage[_nimKey];
    } catch (_) {
      return null;
    }
  }

  /// Menyimpan NIM ke LocalStorage browser.
  void saveNim(String nim) {
    try {
      html.window.localStorage[_nimKey] = nim.trim();
    } catch (_) {}
  }

  /// Menghapus NIM dari LocalStorage browser.
  void clearNim() {
    try {
      html.window.localStorage.remove(_nimKey);
    } catch (_) {}
  }

  /// Menyimpan data teks kustom ke LocalStorage
  void write(String key, String value) {
    try {
      html.window.localStorage[key] = value;
    } catch (_) {}
  }

  /// Membaca data teks kustom dari LocalStorage
  String? read(String key) {
    try {
      return html.window.localStorage[key];
    } catch (_) {
      return null;
    }
  }
}
