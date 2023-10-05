import 'package:freezed_annotation/freezed_annotation.dart';

part 'mock_location_state.freezed.dart';

@freezed
class MockLocationState with _$MockLocationState {
  const factory MockLocationState.initial() = _Initial;
  const factory MockLocationState.original() = _Original;
  const factory MockLocationState.mocked() = _Mocked;
}
