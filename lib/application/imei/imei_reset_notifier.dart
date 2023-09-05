import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/imei_failure.dart';
import '../../domain/password_expired_failure.dart';
import '../../infrastructure/imei/imei_repository.dart';
import 'imei_reset_state.dart';

class ImeiResetNotifier extends StateNotifier<ImeiResetState> {
  ImeiResetNotifier(
    this._ref,
    this._imeiRepository,
  ) : super(ImeiResetState.initial()) {
    _ref.listen<Option<Either<PasswordExpiredFailure, Unit>>>(
        passwordExpiredNotifierProvider
            .select((value) => value.failureOrSuccessOption),
        (__, failureOrSuccess) => failureOrSuccess.fold(() => null, (_) async {
              _ref.invalidate(resetInitProvider);
              await _ref.read(userNotifierProvider.notifier).setUserInitial();
              await _ref
                  .read(imeiAuthNotifierProvider.notifier)
                  .resetSavedImei();
              await clearImeiFromStorage();
              await _ref.read(userNotifierProvider.notifier).logout();
            }));
  }

  final Ref _ref;
  final ImeiRepository _imeiRepository;

  clearImeiFromStorage() async {
    Either<ImeiFailure, Unit?> failureOrSuccessOption;

    state = state.copyWith(isClearing: true, failureOrSuccessOption: none());

    failureOrSuccessOption = await _imeiRepository.clearImeiCredentials();

    state = state.copyWith(
        isClearing: false,
        failureOrSuccessOption: optionOf(failureOrSuccessOption));
  }
}
