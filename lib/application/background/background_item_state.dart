import 'package:face_net_authentication/application/background/saved_location.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../absen/absen_state.dart';

part 'background_item_state.freezed.dart';

@freezed
class BackgroundItemState with _$BackgroundItemState {
  const factory BackgroundItemState({
    required SavedLocation savedLocations,
    required AbsenState abenStates,
  }) = _BackgroundItemState;

  factory BackgroundItemState.initial() => BackgroundItemState(
        savedLocations: SavedLocation.initial(),
        abenStates: AbsenState.complete(),
      );
}
