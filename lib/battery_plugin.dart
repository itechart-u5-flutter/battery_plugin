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
      return _channel.invokeMethod('getCurrentLocation');
    } on PlatformException {
      throw Exception('Failed to get currentLocation');
    }
  }

  static Future<bool?> askPermittion() async {
    try {
      return _channel.invokeMethod<bool?>('askPermissionAndStartLocation');
    } on PlatformException {
      throw Exception('Failed to get currentLocation');
    }
  }
}
