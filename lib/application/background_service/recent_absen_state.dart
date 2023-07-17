import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'saved_location.dart';

part 'recent_absen_state.freezed.dart';

part 'recent_absen_state.g.dart';

@freezed
class RecentAbsenState with _$RecentAbsenState {
  const factory RecentAbsenState(
      {required SavedLocation savedLocation,
      required DateTime dateAbsen,
      required JenisAbsen jenisAbsen}) = _RecentAbsenState;

  factory RecentAbsenState.fromJson(Map<String, Object?> json) =>
      _$RecentAbsenStateFromJson(json);
}
