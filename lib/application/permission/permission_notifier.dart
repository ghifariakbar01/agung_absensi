import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_state.dart';

class PermissionNotifier extends StateNotifier<PermissionState> {
  PermissionNotifier() : super(PermissionState.initial());

  Future<void> checkAndUpdateLocation() async {
    if (await Permission.location.status.isGranted) {
      state = PermissionState.completed();
    } else {
      state = PermissionState.initial();
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
