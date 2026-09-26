import 'dart:io';

/// Menaikkan `kBuildNumber` di `lib/app_version.dart` (dan me-reset-nya saat
/// pergantian tahun kalender), lalu menyelaraskan `version:` di pubspec.yaml
/// supaya tidak ada dua sumber kebenaran yang berbeda.
///
/// Usage (dari project root):
///   dart scripts/increment_build.dart
///
/// `kAppVersion` (semantic version) tetap diubah manual di app_version.dart.
void main() {
  if (!Directory('lib').existsSync()) {
    stderr.writeln('Error: Jalankan script ini dari project root.');
    exit(1);
  }

  final versionFile = File('lib/app_version.dart');
  if (!versionFile.existsSync()) {
    stderr.writeln('Error: app_version.dart tidak ditemukan di ${versionFile.path}');
    exit(1);
  }

  var content = versionFile.readAsStringSync();

  final semverRegex = RegExp(r"const String kAppVersion = '([^']+)';");
  final yearRegex = RegExp(r"const String kAppYear = '(\d+)';");
  final buildRegex = RegExp(r'const int kBuildNumber = (\d+);');

  final semverMatch = semverRegex.firstMatch(content);
  final yearMatch = yearRegex.firstMatch(content);
  final buildMatch = buildRegex.firstMatch(content);

  if (semverMatch == null || yearMatch == null || buildMatch == null) {
    stderr.writeln('Error: kAppVersion / kAppYear / kBuildNumber tidak ditemukan '
        'di app_version.dart');
    exit(1);
  }

  final semver = semverMatch.group(1)!;
  final storedYear = int.parse(yearMatch.group(1)!);
  final currentYear = DateTime.now().year;

  final int buildNum;
  if (storedYear == currentYear) {
    buildNum = int.parse(buildMatch.group(1)!) + 1;
  } else if (storedYear < currentYear) {
    // Tahun baru — mulai dari 1 agar konsisten dengan konvensi pubspec (1.0.0+1).
    buildNum = 1;
  } else {
    // kAppYear di masa depan: jam sistem salah, atau file pernah diedit manual.
    // Jangan diam-diam reset — itu menghapus histori build number.
    stderr.writeln(
      'Error: kAppYear ($storedYear) lebih besar dari tahun sistem ($currentYear).\n'
      '       Perbaiki kAppYear secara manual bila memang ini tahun yang benar,\n'
      '       atau perbaiki jam sistem Anda. Counter build sengaja tidak diubah.',
    );
    exit(1);
  }

  content = content
      .replaceFirst(buildRegex, 'const int kBuildNumber = $buildNum;')
      .replaceFirst(yearRegex, "const String kAppYear = '$currentYear';");
  versionFile.writeAsStringSync(content);

  _syncPubspecVersion(semver, buildNum);

  stdout.writeln('Build updated: v$semver+$buildNum ($currentYear)');
}

/// Selaraskan `version:` di pubspec.yaml dengan app_version.dart.
void _syncPubspecVersion(String semver, int buildNum) {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) return;

  final content = pubspec.readAsStringSync();
  final match = RegExp(r'^version:.*$', multiLine: true).firstMatch(content);
  if (match == null) return;

  pubspec.writeAsStringSync(
    content.replaceFirst(match.group(0)!, 'version: $semver+$buildNum'),
  );
}
