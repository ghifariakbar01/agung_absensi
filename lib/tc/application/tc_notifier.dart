import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'tc_repository.dart';
import 'tc_state.dart';

class TCNotifier extends StateNotifier<TCState> {
  TCNotifier(this._repository) : super(TCState.visited());

  final TCRepository _repository;

  Future<void> checkAndUpdateStatusTC() async {
    final tcStatus = await _repository.getSaved();

    if (tcStatus == null) {
      state = const TCState.initial();
    } else {
      state = const TCState.visited();
    }
  }

  Future<void> saveVisitedTC(String visited) {
    return _repository.save(visited);
  }

  Future<void> clearVisitedTC() {
    return _repository.clear();
  }
}
