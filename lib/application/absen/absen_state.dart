import 'package:freezed_annotation/freezed_annotation.dart';

part 'absen_state.freezed.dart';

part 'absen_state.g.dart';

@freezed
class AbsenState with _$AbsenState {
  const factory AbsenState.empty() = _Empty;
  const factory AbsenState.absenIn() = _AbsenIn;
  const factory AbsenState.incomplete() = _Incomplete;
  const factory AbsenState.complete() = _Complete;
  const factory AbsenState.failure({
    int? errorCode,
    String? message,
  }) = _Failure;

  factory AbsenState.fromJson(Map<String, dynamic> json) =>
      _$AbsenStateFromJson(json);
}
