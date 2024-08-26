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
    state = state.copyWith(failureOrSuccessOptionList: []);
  }

  reset() {
    state = state.copyWith(
      absenProcessedList: [],
      failureOrSuccessOptionList: [],
    );
  }

  Future<void> absen({
    required int idUser,
    required String nama,
    required String imei,
    required List<SavedLocation> absenList,
  }) async {
    List<Option<Either<AbsenFailure, SavedLocation>>> failureOrSuccess = [];

    state = state.copyWith(
      isSubmitting: true,
      failureOrSuccessOptionList: [],
    );

    for (int i = 0; i < absenList.length; i++) {
      final item = absenList[i];

      final _failureOrSuccess = await _absenRepository.absen(
        idUser: idUser,
        nama: nama,
        imei: imei,
        item: item,
        onSuccess: changeAbsenSuccessList,
      );

      failureOrSuccess.add(_failureOrSuccess);
    }

    state = state.copyWith(
      isSubmitting: false,
      failureOrSuccessOptionList: failureOrSuccess,
    );
  }

  changeAbsenSuccessList(SavedLocation item) {
    state = state.copyWith(absenProcessedList: [
      ...state.absenProcessedList,
      item,
    ]);
  }
}
