import 'package:dartz/dartz.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/auto_absen_failure.dart';
import '../background_service/background_item_state.dart';
import '../background_service/recent_absen_state.dart';

part 'auto_absen_state.freezed.dart';

@freezed
class AutoAbsenState with _$AutoAbsenState {
  const factory AutoAbsenState(
      {required bool isProcessing,
      required List<RecentAbsenState> recentAbsens,
      required List<BackgroundItemState> backgroundSavedItems,
      required Map<String, List<BackgroundItemState>>
          backgroundSavedItemsByDate,
      required Option<Either<AutoAbsenFailure, List<RecentAbsenState>>>
          failureOrSuccessOptionRecentAbsen}) = _AutoAbsenState;

  factory AutoAbsenState.initial() => AutoAbsenState(
        isProcessing: false,
        recentAbsens: [],
        backgroundSavedItems: [],
        backgroundSavedItemsByDate: {},
        failureOrSuccessOptionRecentAbsen: none(),
      );
}
