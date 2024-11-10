// ignore_for_file: use_full_hex_values_for_flutter_colors

import "package:flutter/material.dart";
import 'package:gig_buddy/src/theme/material_theme.dart';

class DefaultMaterialTheme extends MaterialTheme {
  final TextTheme textTheme;

  const DefaultMaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4284899348),
      surfaceTint: Color(4284899348),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4293846412),
      onPrimaryContainer: Color(4280228864),
      secondary: Color(4284702529),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4293518270),
      onSecondaryContainer: Color(4280163333),
      tertiary: Color(4282345043),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4290899156),
      onTertiaryContainer: Color(4278198548),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294900203),
      onSurface: Color(4280097812),
      onSurfaceVariant: Color(4282992442),
      outline: Color(4286216040),
      outlineVariant: Color(4291545013),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281479464),
      inversePrimary: Color(4292004211),
      primaryFixed: Color(4293846412),
      onPrimaryFixed: Color(4280228864),
      primaryFixedDim: Color(4292004211),
      onPrimaryFixedVariant: Color(4283254784),
      secondaryFixed: Color(4293518270),
      onSecondaryFixed: Color(4280163333),
      secondaryFixedDim: Color(4291676067),
      onSecondaryFixedVariant: Color(4283123756),
      tertiaryFixed: Color(4290899156),
      onTertiaryFixed: Color(4278198548),
      tertiaryFixedDim: Color(4289122489),
      onTertiaryFixedVariant: Color(4280831549),
      surfaceDim: Color(4292795085),
      surfaceBright: Color(4294900203),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294505446),
      surfaceContainer: Color(4294110944),
      surfaceContainerHigh: Color(4293781722),
      surfaceContainerHighest: Color(4293386965),
    );
  }

  @override
  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4282991616),
      surfaceTint: Color(4284899348),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4286412329),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4282860584),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4286149974),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4280502841),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4283792745),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294900203),
      onSurface: Color(4280097812),
      onSurfaceVariant: Color(4282729270),
      outline: Color(4284637009),
      outlineVariant: Color(4286479212),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281479464),
      inversePrimary: Color(4292004211),
      primaryFixed: Color(4286412329),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4284767761),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4286149974),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4284505407),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4283792745),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4282213457),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292795085),
      surfaceBright: Color(4294900203),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294505446),
      surfaceContainer: Color(4294110944),
      surfaceContainerHigh: Color(4293781722),
      surfaceContainerHighest: Color(4293386965),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4280689408),
      surfaceTint: Color(4284899348),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282991616),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4280623882),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4282860584),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278200346),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280502841),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294900203),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280689689),
      outline: Color(4282729270),
      outlineVariant: Color(4282729270),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281479464),
      inversePrimary: Color(4294504340),
      primaryFixed: Color(4282991616),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4281413120),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4282860584),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4281347348),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4280502841),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278858531),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292795085),
      surfaceBright: Color(4294900203),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294505446),
      surfaceContainer: Color(4294110944),
      surfaceContainerHigh: Color(4293781722),
      surfaceContainerHighest: Color(4293386965),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4292004211),
      surfaceTint: Color(4292004211),
      onPrimary: Color(4281676032),
      primaryContainer: Color(4283254784),
      onPrimaryContainer: Color(4293846412),
      secondary: Color(4291676067),
      onSecondary: Color(4281610519),
      secondaryContainer: Color(4283123756),
      onSecondaryContainer: Color(4293518270),
      tertiary: Color(4289122489),
      onTertiary: Color(4279187239),
      tertiaryContainer: Color(4280831549),
      onTertiaryContainer: Color(4290899156),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279571468),
      onSurface: Color(4293386965),
      onSurfaceVariant: Color(4291545013),
      outline: Color(4287926657),
      outlineVariant: Color(4282992442),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293386965),
      inversePrimary: Color(4284899348),
      primaryFixed: Color(4293846412),
      onPrimaryFixed: Color(4280228864),
      primaryFixedDim: Color(4292004211),
      onPrimaryFixedVariant: Color(4283254784),
      secondaryFixed: Color(4293518270),
      onSecondaryFixed: Color(4280163333),
      secondaryFixedDim: Color(4291676067),
      onSecondaryFixedVariant: Color(4283123756),
      tertiaryFixed: Color(4290899156),
      onTertiaryFixed: Color(4278198548),
      tertiaryFixedDim: Color(4289122489),
      onTertiaryFixedVariant: Color(4280831549),
      surfaceDim: Color(4279571468),
      surfaceBright: Color(4282071344),
      surfaceContainerLowest: Color(4279176711),
      surfaceContainerLow: Color(4280097812),
      surfaceContainer: Color(4280360983),
      surfaceContainerHigh: Color(4281084449),
      surfaceContainerHighest: Color(4281742636),
    );
  }

  @override
  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4292267382),
      surfaceTint: Color(4292004211),
      onPrimary: Color(4279834368),
      primaryContainer: Color(4288320323),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4291939495),
      onSecondary: Color(4279834370),
      secondaryContainer: Color(4288057968),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4289385661),
      onTertiary: Color(4278197008),
      tertiaryContainer: Color(4285634948),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279571468),
      onSurface: Color(4294966001),
      onSurfaceVariant: Color(4291808185),
      outline: Color(4289176467),
      outlineVariant: Color(4287005556),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293386965),
      inversePrimary: Color(4283386112),
      primaryFixed: Color(4293846412),
      onPrimaryFixed: Color(4279505408),
      primaryFixedDim: Color(4292004211),
      onPrimaryFixedVariant: Color(4282070784),
      secondaryFixed: Color(4293518270),
      onSecondaryFixed: Color(4279439872),
      secondaryFixedDim: Color(4291676067),
      onSecondaryFixedVariant: Color(4282005277),
      tertiaryFixed: Color(4290899156),
      onTertiaryFixed: Color(4278195468),
      tertiaryFixedDim: Color(4289122489),
      onTertiaryFixedVariant: Color(4279647533),
      surfaceDim: Color(4279571468),
      surfaceBright: Color(4282071344),
      surfaceContainerLowest: Color(4279176711),
      surfaceContainerLow: Color(4280097812),
      surfaceContainer: Color(4280360983),
      surfaceContainerHigh: Color(4281084449),
      surfaceContainerHighest: Color(4281742636),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294966001),
      surfaceTint: Color(4292004211),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4292267382),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294966001),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4291939495),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4293853171),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4289385661),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279571468),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294966001),
      outline: Color(4291808185),
      outlineVariant: Color(4291808185),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293386965),
      inversePrimary: Color(4281215744),
      primaryFixed: Color(4294175375),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4292267382),
      onPrimaryFixedVariant: Color(4279834368),
      secondaryFixed: Color(4293847234),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4291939495),
      onSecondaryFixedVariant: Color(4279834370),
      tertiaryFixed: Color(4291228121),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4289385661),
      onTertiaryFixedVariant: Color(4278197008),
      surfaceDim: Color(4279571468),
      surfaceBright: Color(4282071344),
      surfaceContainerLowest: Color(4279176711),
      surfaceContainerLow: Color(4280097812),
      surfaceContainer: Color(4280360983),
      surfaceContainerHigh: Color(4281084449),
      surfaceContainerHighest: Color(4281742636),
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
