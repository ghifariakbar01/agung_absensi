import 'package:freezed_annotation/freezed_annotation.dart';

part 'imei_state.freezed.dart';

@freezed
class ImeiState with _$ImeiState {
  const factory ImeiState.registered() = _Registered;
  const factory ImeiState.empty() = _Empty;
  const factory ImeiState.initial() = _Initial;
}
