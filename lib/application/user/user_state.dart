import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/user_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/auth_failure.dart';
import 'user_model.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    required UserModelWithPassword user,
    required bool isGetting,
    required Option<Either<UserFailure, String?>> failureOrSuccessOption,
    required Option<Either<AuthFailure, Unit?>> failureOrSuccessOptionUpdate,
  }) = _UserState;

  factory UserState.initial() => UserState(
        user: UserModelWithPassword.initial(),
        isGetting: false,
        failureOrSuccessOption: none(),
        failureOrSuccessOptionUpdate: none(),
      );
}
