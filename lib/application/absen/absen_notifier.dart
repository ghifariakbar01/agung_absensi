import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../infrastructure/absen/absen_repository.dart';
import 'absen_state.dart';

class AbsenNotifier extends StateNotifier<AbsenState> {
  AbsenNotifier(this._absenRepository) : super(AbsenState.empty());

  final AbsenRepository _absenRepository;

  Future<void> getAbsen({
    required DateTime date,
  }) async {
    state = await _absenRepository.getAbsen(date: date);
  }

  Future<void> getAbsenToday() async {
    state = await _absenRepository.getAbsen(date: DateTime.now());
  }

  setAbsenInitial() => state = AbsenState.empty();
}
