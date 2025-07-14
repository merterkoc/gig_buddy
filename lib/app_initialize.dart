import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gig_buddy/core/localization/manager/localization_manager.dart';
import 'package:gig_buddy/src/cache/shared_preferences.dart';
import 'package:gig_buddy/src/common/environment_manager/environment_manager.dart';
import 'package:gig_buddy/src/common/manager/location_manager.dart';
import 'package:gig_buddy/src/helper/device_info/device_info_helper.dart';
import 'package:gig_buddy/src/helper/device_info/package_info_helper.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/notification_service.dart';

class AppInitializationService {
  AppInitializationService._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Future.wait([
      EnvironmentManager().init(),
      Firebase.initializeApp().then(
        (value) => NotificationService().initialize(),
      ),
      Shared().init().then(
            (value) => settingsController.loadSettings(),
          ),
      DeviceInfoHelper.init(),
      PackageInfoHelper.init(),
      LocationManager.init(),
      LocalizationManager().initialize(),
    ]);
  }
}
