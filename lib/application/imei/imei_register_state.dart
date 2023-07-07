import 'package:freezed_annotation/freezed_annotation.dart';

part 'imei_register_state.freezed.dart';

@freezed
class ImeiRegisterResponse with _$ImeiRegisterResponse {
  const factory ImeiRegisterResponse.withImei({required String imei}) =
      _WithImei;
  const factory ImeiRegisterResponse.failure(
      [int? errorCode, String? message]) = _ImeiFailure;

  const ImeiRegisterResponse._();
}
