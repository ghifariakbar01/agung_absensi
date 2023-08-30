import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_location.freezed.dart';

part 'saved_location.g.dart';

@freezed
class SavedLocation with _$SavedLocation {
  const factory SavedLocation({
    required double? latitude,
    required double? longitude,
    required String? alamat,
    required DateTime date,
    required DateTime dbDate,
  }) = _SavedLocation;

  factory SavedLocation.fromJson(Map<String, Object?> json) =>
      _$SavedLocationFromJson(json);

  factory SavedLocation.initial() => SavedLocation(
      latitude: 0,
      longitude: 0,
      alamat: '',
      date: DateTime.now(),
      dbDate: DateTime.now());
}
