import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/absen/absen_enum.dart';
import '../../application/absen/absen_request.dart';
import '../../constants/assets.dart';
import '../../infrastructure/remote_response.dart';
import '../../shared/providers.dart';
import '../../utils/geofence_utils.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/v_dialogs.dart';
import 'absen_middle_scaffold.dart';

class AbsenPage extends HookConsumerWidget {
  const AbsenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userNotifierProvider.notifier).getUser();
      await ref.read(backgroundNotifierProvider.notifier).getSavedLocations();
      await ref.read(geofenceProvider.notifier).getGeofenceList();
    });

    final currentLocationLatitude = ref.watch(
        geofenceProvider.select((value) => value.currentLocation.latitude));

    final currentLocationLongitude = ref.watch(
        geofenceProvider.select((value) => value.currentLocation.longitude));

    ref.listen<RemoteResponse<AbsenRequest?>>(
        absenAuthNotifierProvidier.select((value) => value.absenId),
        (_, id) async {
      debugger(message: 'called');

      final lokasi = await getLokasi(
          latitude: currentLocationLatitude,
          longitude: currentLocationLongitude);

      id.when(
        withNewData: (absenRequest) => absenRequest?.when(
            absenIn: (id) => ref.read(absenAuthNotifierProvidier.notifier).absen(
                idAbsenMnl: '${id + 1}',
                lokasi:
                    '${lokasi?.street}, ${lokasi?.subAdministrativeArea}, ${lokasi?.postalCode}.',
                date: DateTime.now(),
                latitude: '$currentLocationLatitude',
                longitude: '$currentLocationLongitude',
                inOrOut: JenisAbsen.absenIn),
            absenOut: (id) => ref.read(absenAuthNotifierProvidier.notifier).absen(
                idAbsenMnl: '${id + 1}',
                lokasi:
                    '${lokasi?.street}, ${lokasi?.subAdministrativeArea}, ${lokasi?.postalCode}.',
                date: DateTime.now(),
                latitude: '$currentLocationLatitude',
                longitude: '$currentLocationLongitude',
                inOrOut: JenisAbsen.absenOut),
            absenUnknown: () {}),
        failure: (code, message) => showDialog(
            context: context,
            builder: (_) => VSimpleDialog(
                  asset: Assets.iconCrossed,
                  label: '$code',
                  labelDescription: '$message',
                )),
      );
    });

    final isLoading = ref.watch(
        absenAuthNotifierProvidier.select((value) => value.isSubmitting));

    return Stack(children: [
      const AbsenMiddleScaffold(),
      LoadingOverlay(isLoading: isLoading)
    ]);
  }

  Future<Placemark?> getLokasi({
    required double? latitude,
    required double? longitude,
  }) async {
    Placemark? lokasi =
        await getAddressFromCoordinates(latitude ?? 0, longitude ?? 0);

    if (lokasi == null) {
      lokasi = Placemark(
          street: 'LOCATION UKNOWN', subAdministrativeArea: '', postalCode: '');
    }

    return lokasi;
  }
}
