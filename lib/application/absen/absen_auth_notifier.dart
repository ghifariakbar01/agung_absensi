import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:face_net_authentication/application/absen/absen_request.dart';
import 'package:face_net_authentication/application/background/saved_location.dart';
import 'package:face_net_authentication/infrastructure/absen/absen_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/absen_failure.dart';
import '../../infrastructure/remote_response.dart';
import '../background/background_item_state.dart';
import 'absen_auth_state.dart';

class AbsenAuthNotifier extends StateNotifier<AbsenAuthState> {
  AbsenAuthNotifier(this._absenRepository) : super(AbsenAuthState.initial());

  final AbsenRepository _absenRepository;

  Future<void> absen({
    required String idAbsenMnl,
    required String lokasi,
    required String latitude,
    required String longitude,
    required String idGeof,
    required String imei,
    required DateTime date,
    required DateTime dbDate,
    required JenisAbsen inOrOut,
    String jenisAbsen = 'MNL',
  }) async {
    Either<AbsenFailure, Unit> failureOrSuccess;

    state = state.copyWith(isSubmitting: true, failureOrSuccessOption: none());

    failureOrSuccess = await _absenRepository.absen(
        idAbsenMnl: idAbsenMnl,
        date: date,
        dbDate: dbDate,
        lokasi: lokasi,
        latitude: latitude,
        longitude: longitude,
        inOrOut: inOrOut,
        jenisAbsen: jenisAbsen,
        idGeof: idGeof,
        imei: imei);

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
    required String idGeof,
    required String imei,
    required DateTime date,
    required DateTime dbDate,
    required JenisAbsen inOrOut,
    String jenisAbsen = 'MNL',
  }) async {
    Either<AbsenFailure, Unit> failureOrSuccess;

    state =
        state.copyWith(isSubmitting: true, failureOrSuccessOptionSaved: none());

    debugger();

    failureOrSuccess = await _absenRepository.absen(
        idAbsenMnl: idAbsenMnl,
        lokasi: lokasi,
        latitude: latitude,
        longitude: longitude,
        inOrOut: inOrOut,
        date: date,
        dbDate: dbDate,
        jenisAbsen: jenisAbsen,
        idGeof: idGeof,
        imei: imei);

    debugger();

    log('failureOrSuccess $failureOrSuccess');

    state = state.copyWith(
        isSubmitting: false,
        failureOrSuccessOptionSaved: optionOf(failureOrSuccess));
  }

  Future<RemoteResponse<AbsenRequest>> getAbsenID(JenisAbsen jenisAbsen) async {
    try {
      final response = await _absenRepository.getAbsenId(jenisAbsen);

      log('ABSEN ID: $response');
      return response;
    } catch (e) {
      log('ABSEN ID ERROR: $e');
    }

    return RemoteResponse.failure();
  }

  void changeAbsenState(RemoteResponse<AbsenRequest> absenId) {
    log('ABSEN ID CHANGE: $absenId');

    state = state.copyWith(absenId: absenId);
  }

  void changeIDAbsenStateSaved(RemoteResponse<AbsenRequest> absenId) {
    log('ABSEN ID SAVED CHANGE: $absenId');

    state = state.copyWith(backgroundIdSaved: absenId);
  }

  void _changeBackgroundAbsenStateSaved(
      BackgroundItemState backgroundItemState) {
    state = state.copyWith(backgroundItemState: backgroundItemState);
  }

  Future<void> absenOneLiner({
    required BackgroundItemState backgroundItemState,
    required JenisAbsen jenisAbsen,
    required String idGeof,
    required String imei,
    required Future<void> Function() onAbsen,
    required Future<void> Function() deleteSaved,
    required Future<void> Function() reinitializeDependencies,
    required Future<void> Function() getAbsenState,
    required Future<void> Function() showSuccessDialog,
    required Future<void> Function(String code, String message)
        showFailureDialog,
  }) async {
    this._changeBackgroundAbsenStateSaved(backgroundItemState);

    RemoteResponse<AbsenRequest> id =
        await absenAndUpdateSavedReturned(jenisAbsen: jenisAbsen);

    SavedLocation location = backgroundItemState.savedLocations;

    debugger();

    id.when(
      withNewData: (absenRequest) => absenRequest.when(
          absenIn: (id) async {
            try {
              await absenSaved(
                  idAbsenMnl: '${id + 1}',
                  lokasi: '${location.alamat}',
                  date: location.date,
                  dbDate: location.dbDate,
                  latitude: '${location.latitude ?? 0}',
                  longitude: '${location.longitude ?? 0}',
                  idGeof: idGeof,
                  imei: imei,
                  inOrOut: JenisAbsen.absenIn);
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

            try {
              await reinitializeDependencies();
            } catch (e) {
              showFailureDialog('', e.toString());
              return;
            }

            try {
              await getAbsenState();
            } catch (e) {
              showFailureDialog('', e.toString());
              return;
            }
            await showSuccessDialog();
          },
          absenOut: (id) async {
            try {
              await absenSaved(
                  idAbsenMnl: '${id + 1}',
                  lokasi: '${location.alamat}',
                  date: location.date,
                  dbDate: location.dbDate,
                  latitude: '${location.latitude ?? 0}',
                  longitude: '${location.longitude ?? 0}',
                  idGeof: idGeof,
                  imei: imei,
                  inOrOut: JenisAbsen.absenOut);
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

            try {
              await reinitializeDependencies();
            } catch (e) {
              showFailureDialog('', e.toString());
              return;
            }

            try {
              await getAbsenState();
            } catch (e) {
              showFailureDialog('', e.toString());
              return;
            }
            await showSuccessDialog();
          },
          absenUnknown: () => showFailureDialog('', 'ABSEN UNKNOWN')),
      failure: (code, message) => {
        showFailureDialog(code != null ? code.toString() : '', message ?? '')
      },
    );
  }

  Future<void> absenAndUpdate({
    required JenisAbsen jenisAbsen,
  }) async {
    state = state.copyWith(
        absenId: RemoteResponse.withNewData(AbsenRequest.absenUnknown()));

    final idResponse = await getAbsenID(jenisAbsen);

    state = state.copyWith(absenId: idResponse);
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
