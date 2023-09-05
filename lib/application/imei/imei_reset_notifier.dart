import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/imei_failure.dart';
import '../../domain/password_expired_failure.dart';
import '../../infrastructure/imei/imei_repository.dart';
import '../init_geofence/init_geofence_status.dart';
import '../init_imei/init_imei_status.dart';
import '../init_password_expired/init_password_expired_status.dart';
import '../init_user/init_user_status.dart';
import 'imei_reset_state.dart';

class ImeiResetNotifier extends StateNotifier<ImeiResetState> {
  ImeiResetNotifier(
    this._ref,
    this._imeiRepository,
  ) : super(ImeiResetState.initial()) {
    // PASSWORD EXPIRED
    _ref.listen<Option<Either<PasswordExpiredFailure, Unit>>>(
        passwordExpiredNotifierProvider
            .select((value) => value.failureOrSuccessOption),
        (__, failureOrSuccess) => failureOrSuccess.fold(() => null, (_) async {
              _ref.read(initUserStatusProvider.notifier).state =
                  InitUserStatus.init();

              _ref.read(initGeofenceStatusProvider.notifier).state =
                  InitGeofenceStatus.init();

              _ref.read(initImeiStatusProvider.notifier).state =
                  InitImeiStatus.init();

              _ref.read(initPasswordExpiredStatusProvider.notifier).state =
                  InitPasswordExpiredStatus.init();
              //
              await _ref
                  .read(imeiAuthNotifierProvider.notifier)
                  .resetSavedImei();
              await clearImeiFromStorage();
              //
              await _ref.read(userNotifierProvider.notifier).resetUserImei();
              await _ref.read(userNotifierProvider.notifier).setUserInitial();
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
