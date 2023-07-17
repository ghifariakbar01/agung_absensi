import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/background_failure.dart';
import 'background_item_state.dart';
import 'saved_location.dart';

part 'background_state.freezed.dart';

@freezed
class BackgroundState with _$BackgroundState {
  const factory BackgroundState({
    required List<BackgroundItemState> savedBackgroundItems,
    required bool isGetting,
    required Option<Either<BackgroundFailure, List<SavedLocation>>>
        failureOrSuccessOption,
    required Option<Either<BackgroundFailure, Unit>> failureOrSuccessOptionSave,
  }) = _BackgroundState;

  factory BackgroundState.initial() => BackgroundState(
      savedBackgroundItems: [],
      isGetting: false,
      failureOrSuccessOption: none(),
      failureOrSuccessOptionSave: none());
}
