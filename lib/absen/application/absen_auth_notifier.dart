import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../background/application/saved_location.dart';
import '../../domain/absen_failure.dart';
import '../../utils/enums.dart';
import '../infrastructures/absen_repository.dart';
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
        date: date,
        dbDate: dbDate,
        lokasi: lokasi,
        latitude: latitude,
        longitude: longitude,
        inOrOut: inOrOut,
        idGeof: idGeof,
        imei: imei);

    log('failureOrSuccess $failureOrSuccess');

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
    required Function() onSuccess,
    required Function() onFailure,
    required Future<void> Function(String code, String message)
        showFailureDialog,
  }) async {
    state = state.copyWith(isSubmitting: true);

    this._changeBackgroundAbsenStateSaved(backgroundItemState);
    final SavedLocation location = backgroundItemState;

    try {
      await absen(
          date: location.date,
          dbDate: location.dbDate,
          idGeof: idGeof,
          imei: imei,
          inOrOut: jenisAbsen,
          lokasi: '${location.alamat}',
          latitude: '${location.latitude ?? 0}',
          longitude: '${location.longitude ?? 0}');
    } catch (e) {
      await onFailure();
      await showFailureDialog('', e.toString());
      return;
    }

    try {
      await onAbsen();
    } catch (e) {
      await onFailure();
      await showFailureDialog('', e.toString());
      return;
    }
    try {
      await deleteSaved();
    } catch (e) {
      await onFailure();
      await showFailureDialog('', e.toString());
      return;
    }

    state = state.copyWith(isSubmitting: false);
    await onSuccess();
  }
}
