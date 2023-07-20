import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:face_net_authentication/application/absen/absen_request.dart';
import 'package:face_net_authentication/infrastructure/absen/absen_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/absen_failure.dart';
import '../../infrastructure/remote_response.dart';
import '../background_service/background_item_state.dart';
import 'absen_auth_state.dart';

class AbsenAuthNotifier extends StateNotifier<AbsenAuthState> {
  AbsenAuthNotifier(this._absenRepository) : super(AbsenAuthState.initial());

  final AbsenRepository _absenRepository;

  Future<void> absen({
    required String idAbsenMnl,
    required String lokasi,
    required String latitude,
    required String longitude,
    required DateTime date,
    required JenisAbsen inOrOut,
    String jenisAbsen = 'MNL',
  }) async {
    Either<AbsenFailure, Unit> failureOrSuccess;

    state = state.copyWith(isSubmitting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _absenRepository.absen(
      idAbsenMnl: idAbsenMnl,
      lokasi: lokasi,
      latitude: latitude,
      longitude: longitude,
      inOrOut: inOrOut,
      date: date,
      jenisAbsen: jenisAbsen,
    );

    debugger(message: 'called');

    log('failureOrSuccess $failureOrSuccess');

    state = state.copyWith(
        isSubmitting: false,
        failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<void> absenSaved({
    required String idAbsenMnl,
    required String lokasi,
    required String latitude,
    required String longitude,
    required DateTime date,
    required JenisAbsen inOrOut,
    String jenisAbsen = 'MNL',
  }) async {
    Either<AbsenFailure, Unit> failureOrSuccess;

    state =
        state.copyWith(isSubmitting: true, failureOrSuccessOptionSaved: none());

    debugger(message: 'called');

    failureOrSuccess = await _absenRepository.absen(
      idAbsenMnl: idAbsenMnl,
      lokasi: lokasi,
      latitude: latitude,
      longitude: longitude,
      inOrOut: inOrOut,
      date: date,
      jenisAbsen: jenisAbsen,
    );

    log('failureOrSuccess $failureOrSuccess');

    state = state.copyWith(
        isSubmitting: false,
        failureOrSuccessOptionSaved: optionOf(failureOrSuccess));
  }

  Future<RemoteResponse<AbsenRequest>> getAbsenID(JenisAbsen jenisAbsen) async {
    try {
      final response = await _absenRepository.getAbsenId(jenisAbsen);

      log('response $response');

      debugger(message: 'called');

      return response;
    } catch (e) {
      log('response error $e');

      debugger(message: 'called');
    }

    return RemoteResponse.failure();
  }

  void changeAbsenState(RemoteResponse<AbsenRequest> absenId) {
    log('absenId $absenId');

    debugger(message: 'called');

    state = state.copyWith(absenId: absenId);
  }

  void changeIDAbsenStateSaved(RemoteResponse<AbsenRequest> absenId) {
    debugger(message: 'called');

    log('absenId $absenId');

    state = state.copyWith(backgroundIdSaved: absenId);
  }

  void changeBackgroundAbsenStateSaved(
      BackgroundItemState backgroundItemState) {
    debugger(message: 'called');

    state = state.copyWith(backgroundItemState: backgroundItemState);
  }

  Future<void> absenOneLiner({
    required BackgroundItemState backgroundItemState,
    required JenisAbsen jenisAbsen,
    required Future<void> Function() onAbsen,
    required Future<void> Function() deleteSaved,
    required Future<void> Function() reinitializeDependencies,
    required Future<void> Function() getAbsenState,
    required Future<void> Function() showSuccessDialog,
  }) async {
    changeBackgroundAbsenStateSaved(backgroundItemState);

    final id = await absenAndUpdateSavedReturned(jenisAbsen: jenisAbsen);

    final location = backgroundItemState.savedLocations;

    id.when(
      withNewData: (absenRequest) => absenRequest.when(
          absenIn: (id) async {
            await absenSaved(
                idAbsenMnl: '${id + 1}',
                lokasi: '${location.alamat}',
                date: location.date,
                latitude: '${location.latitude ?? 0}',
                longitude: '${location.longitude ?? 0}',
                inOrOut: JenisAbsen.absenIn);

            await onAbsen();
            await deleteSaved();
            await reinitializeDependencies();
            await getAbsenState();
            await showSuccessDialog();
          },
          absenOut: (id) async {
            await absenSaved(
                idAbsenMnl: '${id + 1}',
                lokasi: '${location.alamat}',
                date: location.date,
                latitude: '${location.latitude ?? 0}',
                longitude: '${location.longitude ?? 0}',
                inOrOut: JenisAbsen.absenOut);

            await onAbsen();
            await deleteSaved();
            await reinitializeDependencies();
            await getAbsenState();
            await showSuccessDialog();
          },
          absenUnknown: () {}),
      failure: (code, message) => {},
    );
  }

  Future<void> absenAndUpdate(JenisAbsen jenisAbsen) async {
    state = state.copyWith(
        absenId: RemoteResponse.withNewData(AbsenRequest.absenUnknown()));

    final absen = await getAbsenID(jenisAbsen);

    state = state.copyWith(absenId: absen);
  }

  Future<void> absenAndUpdateSaved({
    required JenisAbsen jenisAbsen,
  }) async {
    final absen = await getAbsenID(jenisAbsen);

    absen.when(
        withNewData: (absenId) =>
            changeIDAbsenStateSaved(RemoteResponse.withNewData(absenId)),
        failure: (_, __) {});
  }

  Future<RemoteResponse<AbsenRequest>> absenAndUpdateSavedReturned({
    required JenisAbsen jenisAbsen,
  }) async {
    final absen = await getAbsenID(jenisAbsen);

    return absen;
  }
}
