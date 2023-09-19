import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:geocoding/geocoding.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../../utils/geofence_utils.dart';
import 'absen_prep_state.dart';

class AbsenPrepNotifier extends StateNotifier<AbsenPrepState> {
  AbsenPrepNotifier(this._ref) : super(AbsenPrepState.initial());

  final Ref _ref;

  String getImei() =>
      _ref.read(imeiNotifierProvider.select((value) => value.imei));
  String getIdGeofence() => _ref
      .read(geofenceProvider.select((value) => value.nearestCoordinates.id));

  Future<String> getLokasi({required double lat, required double long}) async {
    Placemark? placeMark =
        await GeofenceUtil.getLokasi(latitude: lat, longitude: long);

    if (placeMark != null) {
      return '${placeMark.street}, ${placeMark.locality}, ${placeMark.administrativeArea}. ${placeMark.postalCode}';
    } else {
      return 'LOCATION UNKNOWN';
    }
  }

  Future<DateTime> getNetworkTime() async {
    debugger();
    await Future.delayed(
        Duration(seconds: 1), () => _ref.invalidate(networkTimeFutureProvider));

    final networkTime = await _ref.read(networkTimeFutureProvider.future);

    return networkTime;
  }

  Future<Unit> setup({required double lat, required double long}) async {
    debugger();
    String imei = getImei();
    String idGeofencec = getIdGeofence();
    debugger();

    String lokasi = await getLokasi(lat: lat, long: long);
    //
    debugger();

    DateTime networkTime = await getNetworkTime();

    if (isValid(imei: imei, lokasi: lokasi, idGeofence: idGeofencec)) {
      debugger();

      state = AbsenPrepState(
          imei: imei,
          lokasi: lokasi,
          idGeofence: idGeofencec,
          networkTime: networkTime);
    } else {
      debugger();
    }

    return unit;
  }

  bool isValid({
    required String imei,
    required String lokasi,
    required String idGeofence,
  }) {
    if (imei.isNotEmpty && lokasi.isNotEmpty && idGeofence.isNotEmpty) {
      debugger();

      return true;
    } else {
      debugger();

      return false;
    }
  }
}
