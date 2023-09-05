import 'package:face_net_authentication/application/imei/imei_state.dart';
import 'package:face_net_authentication/application/user/user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class ImeiNotifier extends StateNotifier<ImeiState> {
  ImeiNotifier(this.user) : super(ImeiState.initial());

  final UserModelWithPassword user;

  checkAndUpdateImei() {
    bool isRegistered = user.imeiHp != null && user.imeiHp != '';

    if (isRegistered) {
      state = ImeiState.registered();
    } else {
      state = ImeiState.empty();
    }
  }

  String generateImei() => Uuid().v4();
}
