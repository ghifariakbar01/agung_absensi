import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../infrastructure/karyawan/karyawan_repository.dart';

class KaryawanShiftNotifier extends StateNotifier<bool> {
  KaryawanShiftNotifier(this._repository) : super(false);

  KaryawanShiftRepository _repository;

  Future<bool> isKaryawanShift() => _repository.isKaryawanShift();
}
