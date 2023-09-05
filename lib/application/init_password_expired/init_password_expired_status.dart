import 'package:freezed_annotation/freezed_annotation.dart';

part 'init_password_expired_status.freezed.dart';

@freezed
class InitPasswordExpiredStatus with _$InitPasswordExpiredStatus {
  const factory InitPasswordExpiredStatus.init() = _Init;
  const factory InitPasswordExpiredStatus.failure() = _Failure;
  const factory InitPasswordExpiredStatus.success() = _Success;
}
