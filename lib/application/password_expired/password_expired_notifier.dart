import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/password_expired_failure.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../infrastructure/password_expired_repository.dart';
import '../absen/absen_state.dart';
import 'password_expired_notifier_state.dart';

class PasswordExpiredNotifier
    extends StateNotifier<PasswordExpiredNotifierState> {
  PasswordExpiredNotifier(
    this._ref,
    this._repository,
  ) : super(PasswordExpiredNotifierState.initial()) {
    _ref.listen<AbsenState>(
        absenNotifierProvidier,
        (__, absen) => absen.maybeWhen(
            failure: (errorCode, message) =>
                errorCode == 4 && message == 'Password Expired'
                    ? () async {
                        await _ref
                            .read(passwordExpiredNotifierProvider.notifier)
                            .savePasswordExpired();
                      }()
                    : null,
            orElse: () => null));
  }

  final Ref _ref;
  final PasswordExpiredRepository _repository;

  Future<void> savePasswordExpired() async {
    Either<PasswordExpiredFailure, Unit>? saveFailureOrSuccess;

    state = state.copyWith(failureOrSuccessOption: none());

    saveFailureOrSuccess = await _repository.passwordExpired();

    state =
        state.copyWith(failureOrSuccessOption: optionOf(saveFailureOrSuccess));
  }

  Future<void> clearPasswordExpired() async {
    Either<PasswordExpiredFailure, Unit>? saveFailureOrSuccess;

    state = state.copyWith(failureOrSuccessOptionClear: none());

    saveFailureOrSuccess = await _repository.clearPasswordExpired();

    state = state.copyWith(
        failureOrSuccessOptionClear: optionOf(saveFailureOrSuccess));
  }
}
