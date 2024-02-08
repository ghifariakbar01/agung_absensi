import 'package:freezed_annotation/freezed_annotation.dart';

import '../../user/application/user_model.dart';

part 'auth_response.freezed.dart';

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse.withUser(UserModelWithPassword user) = _WithUser;
  const factory AuthResponse.failure({
    int? errorCode,
    String? message,
  }) = _Failure;

  const AuthResponse._();
}
