import 'package:freezed_annotation/freezed_annotation.dart';

part 'tc_state.freezed.dart';

@freezed
class TCState with _$TCState {
  const factory TCState.initial() = _Initial;
  const factory TCState.visited() = _Visited;
}
