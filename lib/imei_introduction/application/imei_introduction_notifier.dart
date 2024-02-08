import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'imei_introduction_repository.dart';
import 'imei_state.dart';

class ImeiIntroductionNotifier extends StateNotifier<ImeiIntroductionState> {
  ImeiIntroductionNotifier(this._repository)
      : super(ImeiIntroductionState.initial());

  final ImeiIntroductionRepository _repository;

  Future<void> checkAndUpdateImeiIntro() async {
    final imeiIntroductionStatus = await _repository.getSaved();

    if (imeiIntroductionStatus == null) {
      state = const ImeiIntroductionState.initial();
    } else {
      state = const ImeiIntroductionState.visited();
    }
  }

  Future<void> saveVisitedIMEIIntroduction(String visited) {
    return _repository.save(visited);
  }

  Future<void> clearVisitedIMEIIntroduction() {
    return _repository.clear();
  }
}
