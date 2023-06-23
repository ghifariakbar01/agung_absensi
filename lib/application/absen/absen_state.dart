import 'package:freezed_annotation/freezed_annotation.dart';

part 'absen_state.freezed.dart';

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
}
