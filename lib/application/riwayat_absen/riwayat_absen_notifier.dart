import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/riwayat_absen/riwayat_absen_model.dart';
import 'package:face_net_authentication/application/riwayat_absen/riwayat_absen_state.dart';
import 'package:face_net_authentication/domain/riwayat_absen_failure.dart';
import 'package:face_net_authentication/infrastructure/absen/absen_repository.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RiwayatAbsenNotifier extends StateNotifier<RiwayatAbsenState> {
  RiwayatAbsenNotifier(this._absenRepository)
      : super(RiwayatAbsenState.initial());

  final AbsenRepository _absenRepository;

  Future<void> getAbsenRiwayat({
    required int page,
    required String? dateFirst,
    required String? dateSecond,
  }) async {
    Either<RiwayatAbsenFailure, List<RiwayatAbsenModel>> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _absenRepository.getRiwayatAbsen(
        page: page, dateFirst: dateFirst, dateSecond: dateSecond);

    state = state.copyWith(
        isGetting: false, failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<void> getAbsenRiwayatByID(
      {required int page, required String? date}) async {
    Either<RiwayatAbsenFailure, RiwayatAbsenModel> failureOrSuccess;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccess =
        await _absenRepository.getRiwayatAbsenByID(page: page, date: date);

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOptionByID: optionOf(failureOrSuccess));
  }

  void changeAbsenRiwayat(
      List<RiwayatAbsenModel> listAbsenOld, List<RiwayatAbsenModel> listAbsen) {
    final list = [...listAbsenOld, ...listAbsen].toSet().toList();

    state = state.copyWith(riwayatAbsen: [...list]);
  }

  void changePage(int page) {
    state = state.copyWith(page: page);
  }

  void changeFilter(String? dateFirst, String? dateSecond) {
    state = state.copyWith(dateFirst: dateFirst, dateSecond: dateSecond);
  }

  void changeIsMore(bool isMore) {
    state = state.copyWith(isMore: isMore);
  }

  void changeIsGetting(bool isGetting) {
    state = state.copyWith(isGetting: isGetting);
  }

  Future<void> startFilter(
      {required Function changePage,
      required Function changeFilter,
      required Function onAllChanged}) async {
    changePage();
    changeFilter();
    await onAllChanged();
  }
}

final riwayatAbsenNotifierProvider =
    StateNotifierProvider.autoDispose<RiwayatAbsenNotifier, RiwayatAbsenState>(
        (ref) => RiwayatAbsenNotifier(ref.watch(absenRepositoryProvider)));

final maxScrollExtentProvider = StateProvider<double>((ref) => 0);
