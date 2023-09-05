import 'package:freezed_annotation/freezed_annotation.dart';

part 'init_imei_status.freezed.dart';

@freezed
class InitImeiStatus with _$InitImeiStatus {
  const factory InitImeiStatus.init() = _Init;
  const factory InitImeiStatus.failure() = _Failure;
  const factory InitImeiStatus.success() = _Success;
}
