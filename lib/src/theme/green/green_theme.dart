import "package:flutter/material.dart";
import 'package:gig_buddy/src/theme/material_theme.dart';

class GreenMaterialTheme extends MaterialTheme {
  final TextTheme textTheme;

  const GreenMaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff326941),
      surfaceTint: Color(0xff326941),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffb4f1bd),
      onPrimaryContainer: Color(0xff18512b),
      secondary: Color(0xff506352),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd3e8d2),
      onSecondaryContainer: Color(0xff394b3b),
      tertiary: Color(0xff3a656e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffbdeaf5),
      onTertiaryContainer: Color(0xff204d56),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff6fbf3),
      onSurface: Color(0xff181d18),
      onSurfaceVariant: Color(0xff414941),
      outline: Color(0xff717970),
      outlineVariant: Color(0xffc1c9bf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xff99d4a3),
      primaryFixed: Color(0xffb4f1bd),
      onPrimaryFixed: Color(0xff00210b),
      primaryFixedDim: Color(0xff99d4a3),
      onPrimaryFixedVariant: Color(0xff18512b),
      secondaryFixed: Color(0xffd3e8d2),
      onSecondaryFixed: Color(0xff0e1f12),
      secondaryFixedDim: Color(0xffb7ccb7),
      onSecondaryFixedVariant: Color(0xff394b3b),
      tertiaryFixed: Color(0xffbdeaf5),
      onTertiaryFixed: Color(0xff001f25),
      tertiaryFixedDim: Color(0xffa2ced8),
      onTertiaryFixedVariant: Color(0xff204d56),
      surfaceDim: Color(0xffd7dbd4),
      surfaceBright: Color(0xfff6fbf3),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ed),
      surfaceContainer: Color(0xffebefe7),
      surfaceContainerHigh: Color(0xffe5eae2),
      surfaceContainerHighest: Color(0xffdfe4dc),
    );
  }

  @override
  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00401c),
      surfaceTint: Color(0xff326941),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff41794f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff283a2b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5e7260),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff093c44),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff49747d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf3),
      onSurface: Color(0xff0e120e),
      onSurfaceVariant: Color(0xff313831),
      outline: Color(0xff4d544c),
      outlineVariant: Color(0xff676f67),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xff99d4a3),
      primaryFixed: Color(0xff41794f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff286038),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5e7260),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff475949),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff49747d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff2f5b64),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc3c8c0),
      surfaceBright: Color(0xfff6fbf3),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f5ed),
      surfaceContainer: Color(0xffe5eae2),
      surfaceContainerHigh: Color(0xffdaded6),
      surfaceContainerHighest: Color(0xffced3cb),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003416),
      surfaceTint: Color(0xff326941),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1a532d),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff1f3022),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff3b4e3d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003139),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff234f58),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff6fbf3),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff272e27),
      outlineVariant: Color(0xff444b43),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d322c),
      inversePrimary: Color(0xff99d4a3),
      primaryFixed: Color(0xff1a532d),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003c1a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff3b4e3d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff253728),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff234f58),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff043841),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb5bab3),
      surfaceBright: Color(0xfff6fbf3),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeef2ea),
      surfaceContainer: Color(0xffdfe4dc),
      surfaceContainerHigh: Color(0xffd1d6ce),
      surfaceContainerHighest: Color(0xffc3c8c0),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff99d4a3),
      surfaceTint: Color(0xff99d4a3),
      onPrimary: Color(0xff003918),
      primaryContainer: Color(0xff18512b),
      onPrimaryContainer: Color(0xffb4f1bd),
      secondary: Color(0xffb7ccb7),
      onSecondary: Color(0xff233426),
      secondaryContainer: Color(0xff394b3b),
      onSecondaryContainer: Color(0xffd3e8d2),
      tertiary: Color(0xffa2ced8),
      onTertiary: Color(0xff01363e),
      tertiaryContainer: Color(0xff204d56),
      onTertiaryContainer: Color(0xffbdeaf5),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff101510),
      onSurface: Color(0xffdfe4dc),
      onSurfaceVariant: Color(0xffc1c9bf),
      outline: Color(0xff8b938a),
      outlineVariant: Color(0xff414941),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dc),
      inversePrimary: Color(0xff326941),
      primaryFixed: Color(0xffb4f1bd),
      onPrimaryFixed: Color(0xff00210b),
      primaryFixedDim: Color(0xff99d4a3),
      onPrimaryFixedVariant: Color(0xff18512b),
      secondaryFixed: Color(0xffd3e8d2),
      onSecondaryFixed: Color(0xff0e1f12),
      secondaryFixedDim: Color(0xffb7ccb7),
      onSecondaryFixedVariant: Color(0xff394b3b),
      tertiaryFixed: Color(0xffbdeaf5),
      onTertiaryFixed: Color(0xff001f25),
      tertiaryFixedDim: Color(0xffa2ced8),
      onTertiaryFixedVariant: Color(0xff204d56),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff353a35),
      surfaceContainerLowest: Color(0xff0b0f0b),
      surfaceContainerLow: Color(0xff181d18),
      surfaceContainer: Color(0xff1c211c),
      surfaceContainerHigh: Color(0xff262b26),
      surfaceContainerHighest: Color(0xff313631),
    );
  }

  @override
  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffaeebb7),
      surfaceTint: Color(0xff99d4a3),
      onPrimary: Color(0xff002d12),
      primaryContainer: Color(0xff649d70),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffcde2cc),
      onSecondary: Color(0xff182a1b),
      secondaryContainer: Color(0xff829683),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffb7e4ee),
      onTertiary: Color(0xff002a31),
      tertiaryContainer: Color(0xff6c98a1),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101510),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd7dfd4),
      outline: Color(0xffacb4aa),
      outlineVariant: Color(0xff8b9289),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dc),
      inversePrimary: Color(0xff19522c),
      primaryFixed: Color(0xffb4f1bd),
      onPrimaryFixed: Color(0xff001506),
      primaryFixedDim: Color(0xff99d4a3),
      onPrimaryFixedVariant: Color(0xff00401c),
      secondaryFixed: Color(0xffd3e8d2),
      onSecondaryFixed: Color(0xff041508),
      secondaryFixedDim: Color(0xffb7ccb7),
      onSecondaryFixedVariant: Color(0xff283a2b),
      tertiaryFixed: Color(0xffbdeaf5),
      onTertiaryFixed: Color(0xff001418),
      tertiaryFixedDim: Color(0xffa2ced8),
      onTertiaryFixedVariant: Color(0xff093c44),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff414640),
      surfaceContainerLowest: Color(0xff050805),
      surfaceContainerLow: Color(0xff1a1f1a),
      surfaceContainer: Color(0xff242924),
      surfaceContainerHigh: Color(0xff2f342f),
      surfaceContainerHighest: Color(0xff3a3f39),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc1ffca),
      surfaceTint: Color(0xff99d4a3),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff95d09f),
      onPrimaryContainer: Color(0xff000f03),
      secondary: Color(0xffe0f6e0),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb3c8b3),
      onSecondaryContainer: Color(0xff010e04),
      tertiary: Color(0xffd2f6ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff9ecad4),
      onTertiaryContainer: Color(0xff000d11),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff101510),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffebf2e7),
      outlineVariant: Color(0xffbdc5bb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdfe4dc),
      inversePrimary: Color(0xff19522c),
      primaryFixed: Color(0xffb4f1bd),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff99d4a3),
      onPrimaryFixedVariant: Color(0xff001506),
      secondaryFixed: Color(0xffd3e8d2),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb7ccb7),
      onSecondaryFixedVariant: Color(0xff041508),
      tertiaryFixed: Color(0xffbdeaf5),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa2ced8),
      onTertiaryFixedVariant: Color(0xff001418),
      surfaceDim: Color(0xff101510),
      surfaceBright: Color(0xff4c514c),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1c211c),
      surfaceContainer: Color(0xff2d322c),
      surfaceContainerHigh: Color(0xff383d37),
      surfaceContainerHighest: Color(0xff434842),
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
    cardTheme: CardThemeData(
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
