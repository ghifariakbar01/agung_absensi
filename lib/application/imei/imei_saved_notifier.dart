import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:face_net_authentication/application/imei/imei_auth_state.dart';

import '../../domain/imei_failure.dart';
import '../../infrastructure/imei/imei_repository.dart';

class ImeiAuthNotifier extends StateNotifier<ImeiAuthState> {
  ImeiAuthNotifier(this._imeiRepository) : super(ImeiAuthState.initial());

  final ImeiRepository _imeiRepository;

  Future<bool> hasImei() => _imeiRepository.hasImei();

  Future<void> getImeiCredentials() async {
    Either<ImeiFailure, String?> failureOrSuccessOption;

    state = state.copyWith(isGetting: true, failureOrSuccessOption: none());

    failureOrSuccessOption = await _imeiRepository.getImeiCredentials();

    state = state.copyWith(
        isGetting: false,
        failureOrSuccessOption: optionOf(failureOrSuccessOption));
  }

  void changeSavedImei(String imei) {
    state = state.copyWith(imei: imei);
  }
}
