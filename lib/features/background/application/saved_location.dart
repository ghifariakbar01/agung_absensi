import 'package:freezed_annotation/freezed_annotation.dart';

import '../../absen/application/absen_state.dart';

part 'saved_location.freezed.dart';

part 'saved_location.g.dart';

@freezed
class SavedLocation with _$SavedLocation {
  const factory SavedLocation({
    required int id,
    required DateTime date,
    required String? alamat,
    required String? idGeof,
    required DateTime dbDate,
    required double? latitude,
    required double? longitude,
    required AbsenState absenState,
  }) = _SavedLocation;

  factory SavedLocation.fromJson(Map<String, Object?> json) =>
      _$SavedLocationFromJson(json);

  factory SavedLocation.initial() => SavedLocation(
      id: 0,
      idGeof: '',
      alamat: '',
      latitude: 0,
      longitude: 0,
      date: DateTime.now(),
      dbDate: DateTime.now(),
      absenState: AbsenState.empty());
}
