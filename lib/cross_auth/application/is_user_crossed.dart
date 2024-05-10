import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_user_crossed.freezed.dart';

@freezed
class IsUserCrossedState with _$IsUserCrossedState {
  factory IsUserCrossedState.crossed() = _Crossed;
  factory IsUserCrossedState.notCrossed() = _NotCrossed;
}
