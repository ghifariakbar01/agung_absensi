import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:face_net_authentication/application/background/saved_location.dart';
import 'package:face_net_authentication/infrastructure/absen/absen_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/absen_failure.dart';
import 'absen_auth_state.dart';

class AbsenAuthNotifier extends StateNotifier<AbsenAuthState> {
  AbsenAuthNotifier(this._absenRepository) : super(AbsenAuthState.initial());

  final AbsenRepository _absenRepository;

  Future<void> absen({
    required String lokasi,
    required String latitude,
    required String longitude,
    required String idGeof,
    required String imei,
    required DateTime date,
    required DateTime dbDate,
    required JenisAbsen inOrOut,
  }) async {
    Either<AbsenFailure, Unit> failureOrSuccess;

    state = state.copyWith(isSubmitting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _absenRepository.absen(
      imei: imei,
      date: date,
      idGeof: idGeof,
      dbDate: dbDate,
      lokasi: lokasi,
      inOrOut: inOrOut,
      latitude: latitude,
      longitude: longitude,
    );

    state = state.copyWith(
        isSubmitting: false,
        failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  void _changeBackgroundAbsenStateSaved(SavedLocation backgroundItemState) {
    state = state.copyWith(backgroundItemState: backgroundItemState);
  }

  Future<void> absenOneLiner({
    required SavedLocation backgroundItemState,
    required JenisAbsen jenisAbsen,
    required String idGeof,
    required String imei,
    required Future<void> Function() onAbsen,
    required Future<void> Function() deleteSaved,
    required Future<void> Function() showSuccessDialog,
    required Future<void> Function(String code, String message)
        showFailureDialog,
  }) async {
    state = state.copyWith(isSubmitting: true);

    this._changeBackgroundAbsenStateSaved(backgroundItemState);

    SavedLocation location = backgroundItemState;

    // debugger();

    try {
      await absen(
          lokasi: '${location.alamat}',
          date: location.date,
          dbDate: location.dbDate,
          latitude: '${location.latitude ?? 0}',
          longitude: '${location.longitude ?? 0}',
          idGeof: idGeof,
          imei: imei,
          inOrOut: jenisAbsen);
    } catch (e) {
      showFailureDialog('', e.toString());
      return;
    }

    try {
      await onAbsen();
    } catch (e) {
      showFailureDialog('', e.toString());
      return;
    }
    try {
      await deleteSaved();
    } catch (e) {
      showFailureDialog('', e.toString());
      return;
    }

    state = state.copyWith(isSubmitting: false);
    await showSuccessDialog();
  }
}
