import 'package:freezed_annotation/freezed_annotation.dart';

part 'absen_prep_state.freezed.dart';

@freezed
class AbsenPrepState with _$AbsenPrepState {
  const factory AbsenPrepState({
    required String imei,
    required String lokasi,
    required String idGeofence,
    required DateTime networkTime,
  }) = _AbsenAuth;

  factory AbsenPrepState.initial() => AbsenPrepState(
      imei: '', lokasi: '', idGeofence: '', networkTime: DateTime.now());
}
