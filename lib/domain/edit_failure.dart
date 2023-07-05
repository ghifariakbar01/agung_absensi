import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_failure.freezed.dart';

@freezed
class EditFailure with _$EditFailure {
  const factory EditFailure.server([int? errorCode, String? message]) = _Server;
  const factory EditFailure.noConnection() = _NoConnection;
}
