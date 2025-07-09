import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gig_buddy/core/localization/gig_buddy_localizations.dart';
import 'package:intl/intl.dart';

class LocalizationManager {
  factory LocalizationManager() {
    _instance ??= LocalizationManager._();
    return _instance!;
  }

  LocalizationManager._();

  static LocalizationManager? _instance;
  static late AppLocalizations? _appLocalizations;

  late ValueNotifier<Locale?> _locale;

  ValueNotifier<Locale?> get locale => _locale;

  Future<void> initialize() async {
    _locale = ValueNotifier<Locale?>(null);
    _appLocalizations = await load();
  }

  Future<AppLocalizations> load() async {
    final appLocale = Platform.localeName;
    const supportedLocales = AppLocalizations.supportedLocales;
    final languageCode = supportedLocales.firstWhere(
      (l) => l.languageCode == appLocale,
      orElse: () => supportedLocales.first,
    );
    _locale.value = languageCode;

    final localization = await AppLocalizations.delegate.load(_locale.value!);

    /// Intl.systemLocale required for using by DateFormat
    Intl.defaultLocale = _locale.value!.languageCode;
    Intl.systemLocale = _locale.value!.languageCode;
    _appLocalizations = localization;
    return localization;
  }

  AppLocalizations get l10 => _appLocalizations!;
}
