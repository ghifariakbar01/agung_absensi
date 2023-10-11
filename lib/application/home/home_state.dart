import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.inProgress() = _InProgress;
  const factory HomeState.success() = _Success;
  const factory HomeState.failure() = _Failure;
}
