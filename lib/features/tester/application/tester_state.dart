import 'package:freezed_annotation/freezed_annotation.dart';

part 'tester_state.freezed.dart';

@freezed
class TesterState with _$TesterState {
  const factory TesterState.initial() = _Initial;
  const factory TesterState.tester() = _Tester;
  const factory TesterState.forcedRegularUser() = _ForcedRegularUser;
}
