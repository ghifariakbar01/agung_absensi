import 'package:face_net_authentication/application/imei_introduction/imei_introduction_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'imei_state.dart';

class ImeiIntroductionNotifier extends StateNotifier<ImeiIntroductionState> {
  ImeiIntroductionNotifier(this._repository)
      : super(ImeiIntroductionState.initial());

  final ImeiIntroductionRepository _repository;

  Future<void> checkAndUpdateStatusIMEIIntroduction() async {
    final imeiIntroductionStatus = await _repository.getSaved();

    if (imeiIntroductionStatus == null) {
      state = ImeiIntroductionState.initial();
    } else {
      state = ImeiIntroductionState.visited();
    }
  }

  Future<void> saveVisitedIMEIIntroduction(String visited) async {
    await _repository.save(visited);
  }

  Future<void> clearVisitedIMEIIntroduction() async {
    await _repository.clear();
  }
}
