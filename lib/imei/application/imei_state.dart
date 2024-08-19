import 'package:freezed_annotation/freezed_annotation.dart';

part 'imei_state.freezed.dart';

@freezed
class ImeiState with _$ImeiState {
  const factory ImeiState.ok() = _OK;
  const factory ImeiState.alreadyRegistered() = _AlreadyRegistered;
  const factory ImeiState.notRegistered() = _NotRegistered;
  const factory ImeiState.notRegisteredAfterAbsen() = _NotRegisteredAfterAbsen;
  const factory ImeiState.initial() = _Initial;
  const factory ImeiState.rejected() = _Rejected;
  const factory ImeiState.cleared() = _Cleared;
}
