import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'local_storage.dart';

part 'theme_provider.g.dart';

enum ThemeColorVariant {
  standard,
  gold,
  emerald,
  deepBlue,
}

class ToolColors extends ThemeExtension<ToolColors> {
  final Color job;
  final Color logbook;
  final Color research;
  final Color documents;

  const ToolColors({
    required this.job,
    required this.logbook,
    required this.research,
    required this.documents,
  });

  @override
  ThemeExtension<ToolColors> copyWith({
    Color? job,
    Color? logbook,
    Color? research,
    Color? documents,
  }) {
    return ToolColors(
      job: job ?? this.job,
      logbook: logbook ?? this.logbook,
      research: research ?? this.research,
      documents: documents ?? this.documents,
    );
  }

  @override
  ThemeExtension<ToolColors> lerp(ThemeExtension<ToolColors>? other, double t) {
    if (other is! ToolColors) {
      return this;
    }
    return ToolColors(
      job: Color.lerp(job, other.job, t)!,
      logbook: Color.lerp(logbook, other.logbook, t)!,
      research: Color.lerp(research, other.research, t)!,
      documents: Color.lerp(documents, other.documents, t)!,
    );
  }
}

class ThemeState {
  final ThemeMode themeMode;
  final ThemeColorVariant colorVariant;

  const ThemeState({
    required this.themeMode,
    required this.colorVariant,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    ThemeColorVariant? colorVariant,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      colorVariant: colorVariant ?? this.colorVariant,
    );
  }
}

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeState build() {
    final local = ref.watch(localStorageProvider);
    final isDark = local.read('theme_is_dark') != 'false'; // default to dark
    final variantStr = local.read('theme_color_variant') ?? 'standard';
    
    final themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final colorVariant = ThemeColorVariant.values.firstWhere(
      (e) => e.name == variantStr,
      orElse: () => ThemeColorVariant.standard,
    );

    return ThemeState(themeMode: themeMode, colorVariant: colorVariant);
  }

  void setThemeMode(ThemeMode mode) {
    final local = ref.read(localStorageProvider);
    local.write('theme_is_dark', (mode == ThemeMode.dark).toString());
    state = state.copyWith(themeMode: mode);
  }

  void setColorVariant(ThemeColorVariant variant) {
    final local = ref.read(localStorageProvider);
    local.write('theme_color_variant', variant.name);
    state = state.copyWith(colorVariant: variant);
  }
}

extension ToolColorsTheme on BuildContext {
  ToolColors get toolColors => Theme.of(this).extension<ToolColors>() ?? const ToolColors(
    job: Color(0xFF0D9488),
    logbook: Color(0xFF38BDF8),
    research: Color(0xFFF59E0B),
    documents: Color(0xFFEC4899),
  );
}
