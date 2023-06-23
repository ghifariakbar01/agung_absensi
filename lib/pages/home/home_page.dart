import 'dart:developer';

import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:face_net_authentication/application/absen/absen_request.dart';
import 'package:face_net_authentication/infrastructure/remote_response.dart';
import 'package:face_net_authentication/pages/home/home_scaffold.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../style/style.dart';
import '../../utils/geofence_utils.dart';
import '../widgets/v_dialogs.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocationLatitude = ref.watch(
        geofenceProvider.select((value) => value.currentLocation.latitude));

    final currentLocationLongitude = ref.watch(
        geofenceProvider.select((value) => value.currentLocation.longitude));

    ref.listen<RemoteResponse<AbsenRequest?>>(
        absenAuthNotifierProvidier.select((value) => value.absenId),
        (_, id) async {
      debugger(message: 'called');

      Placemark? lokasi = await getAddressFromCoordinates(
          currentLocationLatitude, currentLocationLongitude);

      if (lokasi == null) {
        lokasi = Placemark(
            street: 'LOCATION UKNOWN',
            subAdministrativeArea: '',
            postalCode: '');
      }

      id.when(
        withNewData: (absenRequest) => absenRequest?.when(
            absenIn: (id) => ref.read(absenAuthNotifierProvidier.notifier).absen(
                idAbsenMnl: '${id + 1}',
                lokasi:
                    '${lokasi?.street}, ${lokasi?.subAdministrativeArea}, ${lokasi?.postalCode}',
                latitude: '$currentLocationLatitude',
                longitude: '$currentLocationLongitude',
                inOrOut: JenisAbsen.absenIn),
            absenOut: (id) => ref.read(absenAuthNotifierProvidier.notifier).absen(
                idAbsenMnl: '${id + 1}',
                lokasi:
                    '${lokasi?.street}, ${lokasi?.subAdministrativeArea}, ${lokasi?.postalCode}',
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
                  color: Palette.red,
                )),
      );
    });

    final isLoading = ref.watch(
        absenAuthNotifierProvidier.select((value) => value.isSubmitting));

    return Stack(
        children: [const HomeScaffold(), LoadingOverlay(isLoading: isLoading)]);
  }
}
