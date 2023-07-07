import 'dart:developer';

import 'package:face_net_authentication/application/absen/absen_enum.dart';
import 'package:face_net_authentication/application/absen/absen_state.dart';
import 'package:face_net_authentication/application/routes/route_names.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/string_utils.dart';
import '../widgets/v_button.dart';
import '../widgets/v_dialogs.dart';

class HomeBody extends ConsumerWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final absen = ref.watch(absenNotifierProvidier);
    final nearest = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.remainingDistance));

    final minDistance = ref.watch(geofenceProvider
        .select((value) => value.nearestCoordinates.minDistance));

    final savedIsNotEmpty = ref.watch(backgroundNotifierProvider
        .select((value) => value.savedBackgroundItems.isNotEmpty));

    return Column(
      children: [
        // Absen Masuk
        VButton(
            label: 'ABSEN IN',
            isEnabled: absen == AbsenState.empty() &&
                    nearest < minDistance &&
                    nearest != 0 ||
                absen == AbsenState.incomplete() &&
                    nearest < 100 &&
                    nearest != 0,
            onPressed: () => showCupertinoDialog(
                context: context,
                builder: (_) => VAlertDialog(
                    label: 'Ingin absen-in ?',
                    labelDescription:
                        'JAM: ${StringUtils.hoursDate(DateTime.now())}',
                    onPressed: () async {
                      context.pop();

                      debugger(message: 'called');

                      ref
                          .read(absenAuthNotifierProvidier.notifier)
                          .absenAndUpdate(JenisAbsen.absenIn);
                    }))),

        // Absen Keluar
        VButton(
            label: 'ABSEN OUT',
            isEnabled: absen == AbsenState.empty() &&
                    nearest < minDistance &&
                    nearest != 0 ||
                absen == AbsenState.incomplete() &&
                    nearest < minDistance &&
                    nearest != 0 ||
                absen == AbsenState.absenIn() &&
                    nearest < minDistance &&
                    nearest != 0,
            onPressed: () => showCupertinoDialog(
                context: context,
                builder: (_) => VAlertDialog(
                      label: 'Ingin absen-out ?',
                      labelDescription:
                          'JAM: ${StringUtils.hoursDate(DateTime.now())}',
                      onPressed: () async {
                        context.pop();

                        ref
                            .read(absenAuthNotifierProvidier.notifier)
                            .absenAndUpdate(JenisAbsen.absenOut);
                      },
                    ))),

        Visibility(
            visible: savedIsNotEmpty,
            child: VButton(
                label: 'ABSEN TERSIMPAN',
                onPressed: () async {
                  await ref
                      .read(backgroundNotifierProvider.notifier)
                      .getSavedLocations();

                  context.pushNamed(RouteNames.absenTersimpanNameRoute);
                }))
      ],
    );
  }
}
