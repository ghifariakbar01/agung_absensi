import 'package:face_net_authentication/application/imei/imei_auth_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImeiAuthNotifier extends StateNotifier<ImeiAuthState> {
  ImeiAuthNotifier() : super(ImeiAuthState.initial());

  Future<void> checkAndUpdateImei({required String imeiDb}) async {
    if (imeiDb.isNotEmpty) {
      state = const ImeiAuthState.registered();
    } else {
      state = const ImeiAuthState.empty();
    }
  }
}
