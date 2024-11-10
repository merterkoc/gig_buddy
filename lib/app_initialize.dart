import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gig_buddy/src/cache/shared_preferences.dart';
import 'package:gig_buddy/src/common/manager/location_manager.dart';
import 'package:gig_buddy/src/helper/device_info/device_info_helper.dart';
import 'package:gig_buddy/src/helper/device_info/package_info_helper.dart';
import 'package:gig_buddy/src/route/router.dart';

class AppInitializationService {
  AppInitializationService._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await Shared().init();
    await settingsController.loadSettings();
    await DeviceInfoHelper.init();
    await PackageInfoHelper.init();
    await LocationManager.init();
  }
}
