import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_absen_state.freezed.dart';

@freezed
class AutoAbsenState with _$AutoAbsenState {
  factory AutoAbsenState.initial() = _Initial;
}
