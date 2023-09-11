import 'package:freezed_annotation/freezed_annotation.dart';

part 'imei_auth_state.freezed.dart';

@freezed
class ImeiAuthState with _$ImeiAuthState {
  const factory ImeiAuthState.registered() = _Registered;
  const factory ImeiAuthState.empty() = _Empty;
  const factory ImeiAuthState.initial() = _Initial;
}
