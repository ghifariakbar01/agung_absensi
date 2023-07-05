import 'package:face_net_authentication/application/imei/imei_state.dart';
import 'package:face_net_authentication/application/user/user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

class ImeiNotifier extends StateNotifier<ImeiState> {
  ImeiNotifier() : super(ImeiState.initial());

  void checkAndUpdateImei({required UserModelWithPassword user}) {
    if (user.imeiHp != null && user.imeiHp != '') {
      state = ImeiState.registered();
    } else {
      state = ImeiState.empty();
    }
  }

  Future<String> generateImei() async {
    var uuid = Uuid();

    return uuid.v4();
  }
}
