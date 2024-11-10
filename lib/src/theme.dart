import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278585359),
      surfaceTint: Color(4284243559),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280822322),
      onPrimaryContainer: Color(4290098881),
      secondary: Color(4286077440),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294954062),
      onSecondaryContainer: Color(4283448064),
      tertiary: Color(4278190080),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280165690),
      onTertiaryContainer: Color(4289376459),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294768889),
      onSurface: Color(4280032028),
      onSurfaceVariant: Color(4282795595),
      outline: Color(4286019196),
      outlineVariant: Color(4291282635),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413681),
      inversePrimary: Color(4291151569),
      primaryFixed: Color(4292993517),
      onPrimaryFixed: Color(4279835427),
      primaryFixedDim: Color(4291151569),
      onPrimaryFixedVariant: Color(4282730063),
      secondaryFixed: Color(4294959002),
      onSecondaryFixed: Color(4280621568),
      secondaryFixedDim: Color(4294491648),
      onSecondaryFixedVariant: Color(4284105472),
      tertiaryFixed: Color(4292600317),
      onTertiaryFixed: Color(4279507759),
      tertiaryFixedDim: Color(4290758369),
      onTertiaryFixedVariant: Color(4282336860),
      surfaceDim: Color(4292663770),
      surfaceBright: Color(4294768889),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294374387),
      surfaceContainer: Color(4294045165),
      surfaceContainerHigh: Color(4293650408),
      surfaceContainerHighest: Color(4293255906),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278585359),
      surfaceTint: Color(4284243559),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280822322),
      onPrimaryContainer: Color(4293059309),
      secondary: Color(4283842304),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4287852288),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278190080),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280165690),
      onTertiaryContainer: Color(4292205559),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294768889),
      onSurface: Color(4280032028),
      onSurfaceVariant: Color(4282532423),
      outline: Color(4284440420),
      outlineVariant: Color(4286216831),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413681),
      inversePrimary: Color(4291151569),
      primaryFixed: Color(4285756542),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4284111717),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4287852288),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4285880320),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4285363340),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4283784051),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292663770),
      surfaceBright: Color(4294768889),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294374387),
      surfaceContainer: Color(4294045165),
      surfaceContainerHigh: Color(4293650408),
      surfaceContainerHighest: Color(4293255906),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278585359),
      surfaceTint: Color(4284243559),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280822322),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281147392),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4283842304),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278190080),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280165690),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294768889),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280493096),
      outline: Color(4282532423),
      outlineVariant: Color(4282532423),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281413681),
      inversePrimary: Color(4293651447),
      primaryFixed: Color(4282466891),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4280953909),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4283842304),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4282001920),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4282073688),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4280626241),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292663770),
      surfaceBright: Color(4294768889),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294374387),
      surfaceContainer: Color(4294045165),
      surfaceContainerHigh: Color(4293650408),
      surfaceContainerHighest: Color(4293255906),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4291151569),
      surfaceTint: Color(4291151569),
      onPrimary: Color(4281217081),
      primaryContainer: Color(4279506462),
      onPrimaryContainer: Color(4288782764),
      secondary: Color(4294963414),
      onSecondary: Color(4282330624),
      secondaryContainer: Color(4294557184),
      onSecondaryContainer: Color(4282856448),
      tertiary: Color(4290758369),
      onTertiary: Color(4280889413),
      tertiaryContainer: Color(4278784035),
      onTertiaryContainer: Color(4288126391),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279440148),
      onSurface: Color(4293255906),
      onSurfaceVariant: Color(4291282635),
      outline: Color(4287729814),
      outlineVariant: Color(4282795595),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293255906),
      inversePrimary: Color(4284243559),
      primaryFixed: Color(4292993517),
      onPrimaryFixed: Color(4279835427),
      primaryFixedDim: Color(4291151569),
      onPrimaryFixedVariant: Color(4282730063),
      secondaryFixed: Color(4294959002),
      onSecondaryFixed: Color(4280621568),
      secondaryFixedDim: Color(4294491648),
      onSecondaryFixedVariant: Color(4284105472),
      tertiaryFixed: Color(4292600317),
      onTertiaryFixed: Color(4279507759),
      tertiaryFixedDim: Color(4290758369),
      onTertiaryFixedVariant: Color(4282336860),
      surfaceDim: Color(4279440148),
      surfaceBright: Color(4282005817),
      surfaceContainerLowest: Color(4279111183),
      surfaceContainerLow: Color(4280032028),
      surfaceContainer: Color(4280295200),
      surfaceContainerHigh: Color(4280953386),
      surfaceContainerHighest: Color(4281676853),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4291414741),
      surfaceTint: Color(4291151569),
      onPrimary: Color(4279506462),
      primaryContainer: Color(4287598746),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294963414),
      onSecondary: Color(4282330624),
      secondaryContainer: Color(4294557184),
      onSecondaryContainer: Color(4279898368),
      tertiary: Color(4291021541),
      onTertiary: Color(4279113001),
      tertiaryContainer: Color(4287205545),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279440148),
      onSurface: Color(4294900474),
      onSurfaceVariant: Color(4291545808),
      outline: Color(4288914088),
      outlineVariant: Color(4286808712),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293255906),
      inversePrimary: Color(4282795857),
      primaryFixed: Color(4292993517),
      onPrimaryFixed: Color(4279177496),
      primaryFixedDim: Color(4291151569),
      onPrimaryFixedVariant: Color(4281611838),
      secondaryFixed: Color(4294959002),
      onSecondaryFixed: Color(4279767040),
      secondaryFixedDim: Color(4294491648),
      onSecondaryFixedVariant: Color(4282790656),
      tertiaryFixed: Color(4292600317),
      onTertiaryFixed: Color(4278784036),
      tertiaryFixedDim: Color(4290758369),
      onTertiaryFixedVariant: Color(4281283915),
      surfaceDim: Color(4279440148),
      surfaceBright: Color(4282005817),
      surfaceContainerLowest: Color(4279111183),
      surfaceContainerLow: Color(4280032028),
      surfaceContainer: Color(4280295200),
      surfaceContainerHigh: Color(4280953386),
      surfaceContainerHighest: Color(4281676853),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294769407),
      surfaceTint: Color(4291151569),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4291414741),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294966007),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4294885888),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294769407),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4291021541),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279440148),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294769407),
      outline: Color(4291545808),
      outlineVariant: Color(4291545808),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293255906),
      inversePrimary: Color(4280822322),
      primaryFixed: Color(4293322481),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4291414741),
      onPrimaryFixedVariant: Color(4279506462),
      secondaryFixed: Color(4294960300),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4294885888),
      onSecondaryFixedVariant: Color(4280227072),
      tertiaryFixed: Color(4292994815),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4291021541),
      onTertiaryFixedVariant: Color(4279113001),
      surfaceDim: Color(4279440148),
      surfaceBright: Color(4282005817),
      surfaceContainerLowest: Color(4279111183),
      surfaceContainerLow: Color(4280032028),
      surfaceContainer: Color(4280295200),
      surfaceContainerHigh: Color(4280953386),
      surfaceContainerHighest: Color(4281676853),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
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
