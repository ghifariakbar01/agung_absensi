import 'package:dartz/dartz.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../background/application/saved_location.dart';
import '../../domain/absen_failure.dart';
import '../infrastructures/absen_repository.dart';
import 'absen_auth_state.dart';

class AbsenAuthNotifier extends StateNotifier<AbsenAuthState> {
  AbsenAuthNotifier(this._absenRepository) : super(AbsenAuthState.initial());

  final AbsenRepository _absenRepository;

  resetFoso() {
    state = state.copyWith(failureOrSuccessOption: none());
  }

  Future<void> absen({
    required int idUser,
    required String nama,
    required String imei,
    required List<SavedLocation> absenList,
  }) async {
    Either<AbsenFailure, Unit> failureOrSuccess;

    state = state.copyWith(
      isSubmitting: true,
      failureOrSuccessOption: none(),
    );

    failureOrSuccess = await _absenRepository.absen(
      idUser: idUser,
      nama: nama,
      imei: imei,
      absenList: absenList,
    );

    state = state.copyWith(
      isSubmitting: false,
      failureOrSuccessOption: optionOf(failureOrSuccess),
    );
  }
}
