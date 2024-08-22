import 'package:freezed_annotation/freezed_annotation.dart';

import '../../user/application/user_model.dart';

part 'cross_auth_response.freezed.dart';
part 'cross_auth_response.g.dart';

@freezed
class CrossAuthResponse with _$CrossAuthResponse {
  const factory CrossAuthResponse.withUser(UserModelWithPassword user) =
      _WithUser;
  const factory CrossAuthResponse.failure({
    int? errorCode,
    String? message,
  }) = _Failure;

  factory CrossAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$CrossAuthResponseFromJson(json);
}
