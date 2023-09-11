import 'package:face_net_authentication/application/imei/imei_auth_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../infrastructure/imei/imei_repository.dart';

class ImeiAuthNotifier extends StateNotifier<ImeiAuthState> {
  ImeiAuthNotifier(this._imeiRepository) : super(ImeiAuthState.initial());

  final ImeiRepository _imeiRepository;

  Future<void> checkAndUpdateImei() async {
    bool isRegistered = await _imeiRepository.hasImei();

    if (isRegistered) {
      state = const ImeiAuthState.registered();
    } else {
      state = const ImeiAuthState.empty();
    }
  }
}
