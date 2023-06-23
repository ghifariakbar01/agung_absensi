import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:face_net_authentication/application/absen/absen_request.dart';
import 'package:face_net_authentication/infrastructure/absen/absen_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/absen_failure.dart';
import '../../infrastructure/remote_response.dart';
import 'absen_auth_state.dart';

class AbsenAuthNotifier extends StateNotifier<AbsenAuthState> {
  AbsenAuthNotifier(this._absenRepository) : super(AbsenAuthState.initial());

  final AbsenRepository _absenRepository;

  void absen({
    required String idAbsenMnl,
    required String lokasi,
    required String latitude,
    required String longitude,
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
      jenisAbsen: jenisAbsen,
    );

    debugger(message: 'called');

    log('failureOrSuccess $failureOrSuccess');

    state = state.copyWith(
        isSubmitting: false,
        failureOrSuccessOption: optionOf(failureOrSuccess));
  }

  Future<RemoteResponse<AbsenRequest>> getAbsenID(JenisAbsen jenisAbsen) async {
    final response = await _absenRepository.getAbsenId(jenisAbsen);

    debugger(message: 'called');

    log('id $response');

    return response;
  }

  void changeAbsenState(RemoteResponse<AbsenRequest> absenId) {
    debugger(message: 'called');

    log('absenId $absenId');

    state = state.copyWith(absenId: absenId);
  }

  void absenAndUpdate(JenisAbsen jenisAbsen) async {
    final absen = await getAbsenID(jenisAbsen);

    absen.when(
        withNewData: (withNewData) =>
            changeAbsenState(RemoteResponse.withNewData(withNewData)),
        failure: (_, __) {});
  }
}
