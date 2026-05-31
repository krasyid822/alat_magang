import 'dart:io';

/// Bumps kBuildNumber (and resets it on a new calendar year) in lib/app_version.dart.
///
/// Usage (from project root):
///   dart scripts/increment_build.dart
///
/// To also bump the semantic version (kAppVersion), edit app_version.dart manually.
void main() {
  if (!Directory('lib').existsSync()) {
    stderr.writeln('Error: Please run this script from the project root.');
    exit(1);
  }

  final file = File('lib/app_version.dart');
  if (!file.existsSync()) {
    stderr.writeln('Error: app_version.dart not found at ${file.path}');
    exit(1);
  }

  var content = file.readAsStringSync();

  // Match: const int kBuildNumber = 2;
  final buildRegex = RegExp(r'const int kBuildNumber = (\d+);');
  // Match: const String kAppYear = '2026';
  final yearRegex = RegExp(r"const String kAppYear = '(\d+)';");

  final buildMatch = buildRegex.firstMatch(content);
  final yearMatch = yearRegex.firstMatch(content);

  if (buildMatch == null || yearMatch == null) {
    stderr.writeln('Error: Could not find kBuildNumber or kAppYear in app_version.dart');
    exit(1);
  }

  final currentYear = DateTime.now().year;
  final storedYear = int.parse(yearMatch.group(1)!);
  int buildNum = int.parse(buildMatch.group(1)!);

  if (storedYear == currentYear) {
    buildNum++;
  } else {
    // New calendar year — reset build counter
    buildNum = 0;
  }

  content = content
      .replaceFirst(buildRegex, 'const int kBuildNumber = $buildNum;')
      .replaceFirst(yearRegex, "const String kAppYear = '$currentYear';");

  file.writeAsStringSync(content);
  stdout.writeln('Build updated: v\${readSemver(content)}+$buildNum ($currentYear)');
}

String readSemver(String content) {
  final m = RegExp(r"const String kAppVersion = '([^']+)';").firstMatch(content);
  return m?.group(1) ?? '?';
}
