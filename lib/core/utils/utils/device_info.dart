import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../constants/app_constants.dart';

class DeviceInfo {
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final Map<String, dynamic> deviceInfo = {};

    final device = DeviceInfoPlugin();
    final networkInfo = NetworkInfo();
    final packageInfo = await PackageInfo.fromPlatform();

    String? deviceId;

    if (Platform.isAndroid) {
      final androidInfo = await device.androidInfo;
      deviceId = androidInfo.id; // ANDROID_ID
      deviceInfo[IS_PHYSICAL_DEVICE] = androidInfo.isPhysicalDevice;
      deviceInfo[MODEL] = androidInfo.manufacturer;
      deviceInfo[DEVICE_NAME] = androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await device.iosInfo;
      deviceId = iosInfo.identifierForVendor;
      deviceInfo[IS_PHYSICAL_DEVICE] = iosInfo.isPhysicalDevice;
      deviceInfo[MODEL] = iosInfo.model;
      deviceInfo[DEVICE_NAME] = iosInfo.name;
    }

    deviceInfo[OS] = Platform.isAndroid ? 'Android' : 'iOS';
    deviceInfo[IP] = await networkInfo.getWifiIP();
    deviceInfo[VERSION] = packageInfo.version;
    deviceInfo[DEVICE_ID] = deviceId ?? 'unknown';

    debugPrint('Running on device id: ${deviceInfo[DEVICE_ID]}');

    return deviceInfo;
  }
}
