import "package:flutter/material.dart";
import 'package:gig_buddy/src/theme/material_theme.dart';

class PinkMaterialTheme extends MaterialTheme {
  final TextTheme textTheme;

  const PinkMaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff7f4d7b),
      surfaceTint: Color(0xff7f4d7b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffd7f6),
      onPrimaryContainer: Color(0xff653662),
      secondary: Color(0xff6d5869),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfff7daef),
      onSecondaryContainer: Color(0xff544151),
      tertiary: Color(0xff825246),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffdbd1),
      onTertiaryContainer: Color(0xff663b30),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff7f9),
      onSurface: Color(0xff201a1e),
      onSurfaceVariant: Color(0xff4e444b),
      outline: Color(0xff7f747c),
      outlineVariant: Color(0xffd1c3cb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff352e33),
      inversePrimary: Color(0xfff0b3e7),
      primaryFixed: Color(0xffffd7f6),
      onPrimaryFixed: Color(0xff330833),
      primaryFixedDim: Color(0xfff0b3e7),
      onPrimaryFixedVariant: Color(0xff653662),
      secondaryFixed: Color(0xfff7daef),
      onSecondaryFixed: Color(0xff261625),
      secondaryFixedDim: Color(0xffdabfd3),
      onSecondaryFixedVariant: Color(0xff544151),
      tertiaryFixed: Color(0xffffdbd1),
      onTertiaryFixed: Color(0xff321209),
      tertiaryFixedDim: Color(0xfff6b8a8),
      onTertiaryFixedVariant: Color(0xff663b30),
      surfaceDim: Color(0xffe3d7dd),
      surfaceBright: Color(0xfffff7f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffdf0f7),
      surfaceContainer: Color(0xfff7ebf1),
      surfaceContainerHigh: Color(0xfff1e5eb),
      surfaceContainerHighest: Color(0xffebdfe6),
    );
  }

  @override
  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff522550),
      surfaceTint: Color(0xff7f4d7b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff8f5c8a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff433040),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7d6678),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff532b21),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff926154),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff7f9),
      onSurface: Color(0xff150f14),
      onSurfaceVariant: Color(0xff3d333a),
      outline: Color(0xff5a4f57),
      outlineVariant: Color(0xff756a72),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff352e33),
      inversePrimary: Color(0xfff0b3e7),
      primaryFixed: Color(0xff8f5c8a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff744470),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff7d6678),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff634e5f),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff926154),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff77493d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcfc3ca),
      surfaceBright: Color(0xfffff7f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffdf0f7),
      surfaceContainer: Color(0xfff1e5eb),
      surfaceContainerHigh: Color(0xffe6dae0),
      surfaceContainerHighest: Color(0xffdaced5),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff461b45),
      surfaceTint: Color(0xff7f4d7b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff673864),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff382636),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff574353),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff472218),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff693e32),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff7f9),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff322a30),
      outlineVariant: Color(0xff50464e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff352e33),
      inversePrimary: Color(0xfff0b3e7),
      primaryFixed: Color(0xff673864),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff4e224c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff574353),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3f2d3c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff693e32),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4f281d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc1b6bc),
      surfaceBright: Color(0xfffff7f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffaedf4),
      surfaceContainer: Color(0xffebdfe6),
      surfaceContainerHigh: Color(0xffddd1d8),
      surfaceContainerHighest: Color(0xffcfc3ca),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff0b3e7),
      surfaceTint: Color(0xfff0b3e7),
      onPrimary: Color(0xff4b1f4a),
      primaryContainer: Color(0xff653662),
      onPrimaryContainer: Color(0xffffd7f6),
      secondary: Color(0xffdabfd3),
      onSecondary: Color(0xff3d2b3a),
      secondaryContainer: Color(0xff544151),
      onSecondaryContainer: Color(0xfff7daef),
      tertiary: Color(0xfff6b8a8),
      onTertiary: Color(0xff4c261b),
      tertiaryContainer: Color(0xff663b30),
      onTertiaryContainer: Color(0xffffdbd1),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff171216),
      onSurface: Color(0xffebdfe6),
      onSurfaceVariant: Color(0xffd1c3cb),
      outline: Color(0xff9a8d95),
      outlineVariant: Color(0xff4e444b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebdfe6),
      inversePrimary: Color(0xff7f4d7b),
      primaryFixed: Color(0xffffd7f6),
      onPrimaryFixed: Color(0xff330833),
      primaryFixedDim: Color(0xfff0b3e7),
      onPrimaryFixedVariant: Color(0xff653662),
      secondaryFixed: Color(0xfff7daef),
      onSecondaryFixed: Color(0xff261625),
      secondaryFixedDim: Color(0xffdabfd3),
      onSecondaryFixedVariant: Color(0xff544151),
      tertiaryFixed: Color(0xffffdbd1),
      onTertiaryFixed: Color(0xff321209),
      tertiaryFixedDim: Color(0xfff6b8a8),
      onTertiaryFixedVariant: Color(0xff663b30),
      surfaceDim: Color(0xff171216),
      surfaceBright: Color(0xff3e373c),
      surfaceContainerLowest: Color(0xff120d11),
      surfaceContainerLow: Color(0xff201a1e),
      surfaceContainer: Color(0xff241e22),
      surfaceContainerHigh: Color(0xff2f282d),
      surfaceContainerHighest: Color(0xff3a3338),
    );
  }

  @override
  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffcdf6),
      surfaceTint: Color(0xfff0b3e7),
      onPrimary: Color(0xff3f143e),
      primaryContainer: Color(0xffb67faf),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff0d4e9),
      onSecondary: Color(0xff31202f),
      secondaryContainer: Color(0xffa28a9c),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd2c7),
      onTertiary: Color(0xff3f1b12),
      tertiaryContainer: Color(0xffba8475),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff171216),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe7d8e1),
      outline: Color(0xffbcaeb7),
      outlineVariant: Color(0xff998d95),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebdfe6),
      inversePrimary: Color(0xff663763),
      primaryFixed: Color(0xffffd7f6),
      onPrimaryFixed: Color(0xff260027),
      primaryFixedDim: Color(0xfff0b3e7),
      onPrimaryFixedVariant: Color(0xff522550),
      secondaryFixed: Color(0xfff7daef),
      onSecondaryFixed: Color(0xff1b0c1a),
      secondaryFixedDim: Color(0xffdabfd3),
      onSecondaryFixedVariant: Color(0xff433040),
      tertiaryFixed: Color(0xffffdbd1),
      onTertiaryFixed: Color(0xff250802),
      tertiaryFixedDim: Color(0xfff6b8a8),
      onTertiaryFixedVariant: Color(0xff532b21),
      surfaceDim: Color(0xff171216),
      surfaceBright: Color(0xff4a4247),
      surfaceContainerLowest: Color(0xff0b060a),
      surfaceContainerLow: Color(0xff221c20),
      surfaceContainer: Color(0xff2c262b),
      surfaceContainerHigh: Color(0xff373135),
      surfaceContainerHighest: Color(0xff433c41),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffeaf8),
      surfaceTint: Color(0xfff0b3e7),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffecafe3),
      onPrimaryContainer: Color(0xff1c001d),
      secondary: Color(0xffffeaf8),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd6bbcf),
      onSecondaryContainer: Color(0xff140614),
      tertiary: Color(0xffffece7),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfff1b4a4),
      onTertiaryContainer: Color(0xff1d0301),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff171216),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfffbecf5),
      outlineVariant: Color(0xffcdbfc7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebdfe6),
      inversePrimary: Color(0xff663763),
      primaryFixed: Color(0xffffd7f6),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xfff0b3e7),
      onPrimaryFixedVariant: Color(0xff260027),
      secondaryFixed: Color(0xfff7daef),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffdabfd3),
      onSecondaryFixedVariant: Color(0xff1b0c1a),
      tertiaryFixed: Color(0xffffdbd1),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xfff6b8a8),
      onTertiaryFixedVariant: Color(0xff250802),
      surfaceDim: Color(0xff171216),
      surfaceBright: Color(0xff564e53),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff241e22),
      surfaceContainer: Color(0xff352e33),
      surfaceContainerHigh: Color(0xff40393e),
      surfaceContainerHighest: Color(0xff4c454a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.copyWith(
          bodyLarge: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          bodyMedium: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          bodySmall: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
          ),
          labelLarge: textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          labelMedium: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          labelSmall: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface,
          ),
          displayLarge: textTheme.displayLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          displayMedium: textTheme.displayMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          displaySmall: textTheme.displaySmall?.copyWith(
            color: colorScheme.onSurface,
          ),
          headlineLarge: textTheme.headlineLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          headlineMedium: textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          headlineSmall: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
          ),
          titleLarge: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          titleMedium: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          titleSmall: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          ),
        ),
        primaryTextTheme: textTheme,
        cardTheme: CardTheme(
          surfaceTintColor: colorScheme.onSecondaryContainer,
          color: colorScheme.inverseSurface,
          elevation: 0,
          shadowColor: colorScheme.shadow,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

List<ExtendedColor> get extendedColors => [];

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
