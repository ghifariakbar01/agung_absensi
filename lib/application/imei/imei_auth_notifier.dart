import 'package:face_net_authentication/application/imei/imei_auth_state.dart';
import 'package:face_net_authentication/infrastructure/profile/edit_profile_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImeiAuthNotifier extends StateNotifier<ImeiAuthState> {
  ImeiAuthNotifier(this._repository) : super(ImeiAuthState.initial());

  final EditProfileRepostiroy _repository;

  Future<void> checkAndUpdateImei({required String idKary}) async {
    bool isRegistered = await _repository.hasImei(idKary: idKary);

    if (isRegistered) {
      state = const ImeiAuthState.registered();
    } else {
      state = const ImeiAuthState.empty();
    }
  }

  Future<void> checkAndUpdateImeiByGivenParam({required String imeiDb}) async {
    if (imeiDb.isNotEmpty) {
      state = const ImeiAuthState.registered();
    } else {
      state = const ImeiAuthState.empty();
    }
  }
}
