import 'dart:async';

import 'package:flutter/services.dart';

class BatteryPlugin {
  static const MethodChannel _channel = const MethodChannel('battery_plugin');

  static Future<String?> get platformVersion async {
    try {
      final String? version = await _channel.invokeMethod('getPlatformVersion');
      return version;
    } on PlatformException {
      throw Exception('Failed to get platform version!');
    }
  }

  static Future<String?> getCurrentLocation() async {
    try {
      final result1 =
          await _channel.invokeMethod('askPermissionAndStartLocation');
      print("askPermissionAndStartLocation - $result1");
      final result2 = await _channel.invokeMethod('getCurrentLocation');
      print("getCurrentLocation - $result2");
    } on PlatformException {
      throw Exception('Failed to get currentLocation');
    }
  }
}
