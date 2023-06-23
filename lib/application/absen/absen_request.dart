import 'package:freezed_annotation/freezed_annotation.dart';

part 'absen_request.freezed.dart';

@freezed
class AbsenRequest with _$AbsenRequest {
  const factory AbsenRequest.absenIn({required int absenIdMnl}) = _AbsenIn;

  const factory AbsenRequest.absenOut({required int absenIdMnl}) = _AbsenOut;

  const factory AbsenRequest.absenUnknown() = _AbsenUnknown;
}
