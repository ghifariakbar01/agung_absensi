import 'package:dartz/dartz.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../absen/infrastructures/absen_repository.dart';
import '../../domain/riwayat_absen_failure.dart';
import 'riwayat_absen_model.dart';
import 'riwayat_absen_state.dart';

class RiwayatAbsenNotifier extends StateNotifier<RiwayatAbsenState> {
  RiwayatAbsenNotifier(this._absenRepository)
      : super(RiwayatAbsenState.initial());

  final AbsenRepository _absenRepository;

  Future<bool> hasOfflineData() => _absenRepository
      .getRiwayatAbsenFromStorage()
      .then((value) => value.isNotEmpty);

  reset() {
    state = RiwayatAbsenState.initial();
  }

  resetFoso() {
    state = state.copyWith(failureOrSuccessOption: none());
  }

  Future<void> getAbsenRiwayat({
    required int idUser,
    required String? dateFirst,
    required String? dateSecond,
  }) async {
    Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>> failureOrSuccess;

    state = state.copyWith(
      isGetting: true,
      failureOrSuccessOption: none(),
    );

    failureOrSuccess = await _absenRepository.getRiwayatAbsen(
      idUser: idUser,
      dateFirst: dateFirst,
      dateSecond: dateSecond,
    );

    state = state.copyWith(
      isGetting: false,
      failureOrSuccessOption: optionOf(failureOrSuccess),
    );
  }

  Future<void> filterRiwayatAbsen({
    required int idUser,
    required String? dateFirst,
    required String? dateSecond,
    bool isFilter = false,
  }) async {
    Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>> failureOrSuccess;

    state = state.copyWith(
      isGetting: true,
      failureOrSuccessOption: none(),
    );

    failureOrSuccess = await _absenRepository.filterRiwayatAbsen(
      idUser: idUser,
      dateFirst: dateFirst,
      dateSecond: dateSecond,
    );

    state = state.copyWith(
      isGetting: false,
      failureOrSuccessOption: optionOf(failureOrSuccess),
    );
  }

  Future<void> getAbsenRiwayatFromStorage() async {
    state = state.copyWith(
      isGetting: true,
      failureOrSuccessOption: none(),
    );

    final _item = await _absenRepository.getRiwayatAbsenFromStorage();

    state = state.copyWith(
      isGetting: false,
      failureOrSuccessOption: optionOf(
        right(_item),
      ),
    );
  }

  void replaceAbsenRiwayat(List<RiwayatAbsenModel> listAbsen) {
    final list = [...listAbsen].toSet().toList();

    state = state.copyWith(riwayatAbsen: [...list]);
  }

  void resetAbsenFOSO() {
    state = state.copyWith(failureOrSuccessOption: none());
  }

  void changeFilter(
    String dateFirst,
    String dateSecond,
  ) {
    state = state.copyWith(
      dateFirst: dateFirst,
      dateSecond: dateSecond,
    );
  }

  void changeIsGetting(bool isGetting) {
    state = state.copyWith(isGetting: isGetting);
  }

  Future<void> startFilter({
    required Function changeFilter,
    required Function onAllChanged,
  }) async {
    changeFilter();
    await onAllChanged();
  }
}
