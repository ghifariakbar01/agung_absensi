import 'package:freezed_annotation/freezed_annotation.dart';

part 'init_user_status.freezed.dart';

@freezed
class InitUserStatus with _$InitUserStatus {
  const factory InitUserStatus.init() = _Init;
  const factory InitUserStatus.failure() = _Failure;
  const factory InitUserStatus.success() = _Success;
}
