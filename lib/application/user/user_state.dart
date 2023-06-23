import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/domain/user_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState({
    required UserModel user,
    required bool isGetting,
    required Option<Either<UserFailure, String?>> failureOrSuccessOption,
  }) = _UserState;

  factory UserState.initial() => UserState(
        user: UserModel.initial(),
        isGetting: false,
        failureOrSuccessOption: none(),
      );
}
