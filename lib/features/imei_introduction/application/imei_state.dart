import 'package:freezed_annotation/freezed_annotation.dart';

part 'imei_state.freezed.dart';

@freezed
class ImeiIntroductionState with _$ImeiIntroductionState {
  const factory ImeiIntroductionState.initial() = _Initial;
  const factory ImeiIntroductionState.visited() = _Visited;
}
