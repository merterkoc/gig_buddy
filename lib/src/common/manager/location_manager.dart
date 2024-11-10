import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationManager {
  factory LocationManager._() {
    return _instance;
  }

  static final LocationManager _instance = LocationManager._();

  static late Position? _position;

  static Future<void> init() async {
    final locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    if (locationPermission == LocationPermission.deniedForever) {
      debugPrint('Location Permission Denied Forever');
    }
    try {
      _position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.lowest,
          timeLimit: Duration(seconds: 5),
        ),
      );
    } on TimeoutException {
      _position = await Geolocator.getLastKnownPosition();
    }
  }

  static Position? get position => _position;

  static String get currentLocation {
    return '${_position?.latitude},${_position?.longitude}';
  }
}
