import 'package:flutter/material.dart';
import 'package:gig_buddy/app.dart';
import 'package:gig_buddy/app_initialize.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppInitializationService.initialize();
  FlutterNativeSplash.remove();
  return runApp(
    GigBuddyApp(
      settingsController: settingsController,
    ),
  );
}
