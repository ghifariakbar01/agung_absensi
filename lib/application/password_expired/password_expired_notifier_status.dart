import 'package:face_net_authentication/shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../infrastructure/password_expired_repository.dart';
import 'password_expired_notifier_state.dart';
import 'password_expired_state.dart';

class PasswordExpiredNotifierStatus
    extends StateNotifier<PasswordExpiredState> {
  PasswordExpiredNotifierStatus(
    this._ref,
    this._repository,
  ) : super(PasswordExpiredState.initial()) {
    _ref.listen<PasswordExpiredNotifierState>(
        passwordExpiredNotifierProvider,
        (__, passwordExpired) => passwordExpired.failureOrSuccessOption
            .fold(() => null, (_) => checkAndUpdateExpired()));

    _ref.listen<PasswordExpiredNotifierState>(
        passwordExpiredNotifierProvider,
        (__, passwordExpired) => passwordExpired.failureOrSuccessOptionClear
            .fold(() => null, (_) => checkAndUpdateExpired()));
  }

  final Ref _ref;
  final PasswordExpiredRepository _repository;

  Future<void> checkAndUpdateExpired() async {
    final isExpired = await _repository.isPasswordExpired();

    if (isExpired) {
      state = PasswordExpiredState.expired();
    } else {
      state = PasswordExpiredState.notExpired();
    }
  }
}
