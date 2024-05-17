import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/imei_failure.dart';
import '../infrastructures/imei_repository.dart';
import 'imei_reset_state.dart';

class ImeiResetNotifier extends StateNotifier<ImeiResetState> {
  ImeiResetNotifier(
    this._imeiRepository,
  ) : super(ImeiResetState.initial());

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
