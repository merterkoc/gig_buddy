import 'package:flutter/material.dart';
import 'package:gig_buddy/src/cache/shared_preferences.dart';
import 'package:gig_buddy/src/route/router.dart';

class AppInitializationService {
  AppInitializationService._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Shared().init();
    await settingsController.loadSettings();
  }
}
