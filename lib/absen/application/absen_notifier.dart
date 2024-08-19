import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../infrastructures/absen_repository.dart';
import 'absen_state.dart';

class AbsenNotifier extends StateNotifier<AbsenState> {
  AbsenNotifier(this._absenRepository) : super(AbsenState.complete());

  final AbsenRepository _absenRepository;

  Future<void> getAbsenTodayFromStorage() async {
    state = await _absenRepository.getAbsenFromStorage(
      date: DateTime.now(),
    );
  }

  setAbsenInitial() => state = AbsenState.empty();
}
