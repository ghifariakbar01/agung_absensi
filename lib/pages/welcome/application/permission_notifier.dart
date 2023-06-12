import 'package:face_net_authentication/pages/welcome/application/permission_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionNotifier extends StateNotifier<PermissionState> {
  PermissionNotifier() : super(PermissionState.initial());

  void askCamera() async {
    await Permission.camera.request();
    await checkAllStatus(() => changeAuthorized(
        state.locationAuthorized == true && state.cameraAuthorized == true));
  }

  void askLocation() async {
    await Permission.location.request();
    await checkAllStatus(() => changeAuthorized(
        state.locationAuthorized == true && state.cameraAuthorized == true));
  }

  Future<bool> isGranted() async {
    return await Permission.camera.request().isGranted &&
        await Permission.location.request().isGranted &&
        await Permission.activityRecognition.request().isGranted;
  }

  Future<void> checkAllStatus(Function() onCheck) async {
    if (await Permission.camera.status.isPermanentlyDenied ||
        await Permission.camera.status.isDenied) {
      state = state.copyWith(cameraAuthorized: false);
    } else {
      state = state.copyWith(cameraAuthorized: true);
    }

    if (await Permission.location.status.isPermanentlyDenied ||
        await Permission.location.status.isDenied) {
      state = state.copyWith(locationAuthorized: false);
    } else {
      state = state.copyWith(locationAuthorized: true);
    }

    onCheck();
  }

  void changeCamera(bool authorized) {
    state = state.copyWith(cameraAuthorized: authorized);
  }

  void changeLocation(bool authorized) {
    state = state.copyWith(locationAuthorized: authorized);
  }

  void onAuthorized(Function() onAuthorize) {
    if (state.isAuthorized == true) {
      onAuthorize();
    }
  }

  void changeAuthorized(bool isAuthorized) {
    state = state.copyWith(isAuthorized: isAuthorized);
  }
}
