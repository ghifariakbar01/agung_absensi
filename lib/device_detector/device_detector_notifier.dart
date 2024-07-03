import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_detector_notifier.g.dart';

@riverpod
class DeviceDetectorNotifier extends _$DeviceDetectorNotifier {
  @override
  FutureOr<bool> build() async {
    return Platform.isAndroid
        ? await _isRealAndroidDevice()
        : await _isRealiOSDevice();
  }

  Future<bool> _isRealAndroidDevice() async {
    AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.isPhysicalDevice;
  }

  Future<bool> _isRealiOSDevice() async {
    IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;
    return iosInfo.isPhysicalDevice;
  }
}
