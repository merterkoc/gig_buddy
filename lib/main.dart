import 'package:flutter/material.dart';
import 'package:gig_buddy/app.dart';
import 'package:gig_buddy/app_initialize.dart';
import 'package:gig_buddy/src/route/router.dart';

Future<void> main() async {
  await AppInitializationService.initialize();
  return runApp(
    GigBuddyApp(
      settingsController: settingsController,
    ),
  );
}
