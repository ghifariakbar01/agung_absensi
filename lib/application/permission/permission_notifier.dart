import 'dart:developer';

import 'package:geofence_service/geofence_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_state.dart';

class PermissionNotifier extends StateNotifier<PermissionState> {
  PermissionNotifier() : super(PermissionState.initial());

  letYouThrough() => state = PermissionState.completed();

  Future<bool> isLocationDenied() async {
    final status = await Permission.location.status;

    return status.isPermanentlyDenied || status.isDenied;
  }

  Future<void> checkAndUpdateLocation() async {
    if (await Permission.location.status.isGranted &&
        await Permission.location.serviceStatus.isEnabled) {
      state = PermissionState.completed();
    } else {
      state = PermissionState.initial();
    }
  }

  Future<void> requestDenied() async {
    final status = await Permission.location.status;

    log('status.isPermanentlyDenied || status.isDenied ${status.isPermanentlyDenied || status.isDenied}');
    if (status.isPermanentlyDenied || status.isDenied) {
      openAppSettings();
    }
  }

  Future<void> requestLocation() async {
    await Permission.location.request();
  }
}

// void askCamera() async {
//   await Permission.camera.request();
//   await checkAllStatus(() => changeAuthorized(
//       state.locationAuthorized == true && state.cameraAuthorized == true));
// }'

// if (await Permission.camera.status.isPermanentlyDenied ||
//     await Permission.camera.status.isDenied) {
//   state = state.copyWith(cameraAuthorized: false);
// } else {
//   state = state.copyWith(cameraAuthorized: true);
// }

// void changeCamera(bool authorized) {
//   state = state.copyWith(cameraAuthorized: authorized);
// }
