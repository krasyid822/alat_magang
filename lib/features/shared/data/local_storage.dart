import 'dart:html' as html;
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'local_storage.g.dart';

@riverpod
LocalStorage localStorage(Ref ref) {
  return LocalStorage();
}

class LocalStorage {
  static const String _nimKey = 'alat_magang_nim';
  static const String _deviceIdKey = 'alat_magang_device_id';
  static const String _loginTimestampKey = 'alat_magang_login_ts';

  /// Mendapatkan atau membuat Device ID unik untuk browser ini
  String getDeviceId() {
    try {
      var id = html.window.localStorage[_deviceIdKey];
      if (id == null || id.isEmpty) {
        final randVal = 1000 + Random().nextInt(9000);
        id = 'dev_${DateTime.now().millisecondsSinceEpoch}_$randVal';
        html.window.localStorage[_deviceIdKey] = id;
      }
      return id;
    } catch (_) {
      return 'unknown_device';
    }
  }

  void saveLoginTimestamp() {
    try {
      html.window.localStorage[_loginTimestampKey] = DateTime.now().millisecondsSinceEpoch.toString();
    } catch (_) {}
  }

  int getLoginTimestamp() {
    try {
      final ts = html.window.localStorage[_loginTimestampKey];
      return ts != null ? int.parse(ts) : 0;
    } catch (_) {
      return 0;
    }
  }

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

  /// Menghapus semua data lokal mahasiswa dari LocalStorage.
  void clearAllData(String nim) {
    try {
      html.window.localStorage.remove('profile_$nim');
      html.window.localStorage.remove('logs_$nim');
      html.window.localStorage.remove('jobs_$nim');
      html.window.localStorage.remove('research_$nim');
      html.window.localStorage.remove('documents_$nim');
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
