import 'package:face_net_authentication/widgets/v_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:geofence_service/geofence_service.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/app_logo.dart';
import '../../widgets/copyright_text.dart';
import '../../widgets/welcome_label.dart';
import '../application/permission_state.dart';
import '../application/shared/permission_introduction_providers.dart';
import 'widget/permission_item.dart';

class PermissionPage extends ConsumerWidget {
  const PermissionPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PermissionState>(
        permissionNotifierProvider,
        (_, state) => state.maybeMap(
            completed: (_) => context.pop(), orElse: () => null));

    final permission = ref.watch(permissionNotifierProvider);

    final space = SizedBox(height: 35);
    final spaceHuge = SizedBox(height: 70);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        // iconTheme: IconThemeData(color: Palette.primaryColor),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                spaceHuge,
                const AppLogo(),
                spaceHuge,
                const WelcomeLabel(title: 'Selamat datang'),
                space,
                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: permission.when(
                        completed: () => PermissionItem(
                              label: 'Sukses',
                              title: 'Lokasi anda sudah nyala',
                              onPressed: context.pop,
                            ),
                        initial: () => PermissionItem(
                              title: 'Nyalakan lokasi anda',
                              label:
                                  'Lokasi dibutuhkan untuk memastikan anda berada di lokasi kantor agung group.',
                              onPressed: () async {
                                if (!await FlLocation
                                    .isLocationServicesEnabled) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => VSimpleDialog(
                                        label: 'GPS Tidak Berfungsi',
                                        labelDescription:
                                            'Mohon nyalakan GPS pada device anda. Terimakasih',
                                        asset: 'assets/ic_location_off.svg'),
                                  );
                                  return;
                                } else {
                                  await ref
                                      .read(permissionNotifierProvider.notifier)
                                      .requestLocation();

                                  await ref
                                      .read(permissionNotifierProvider.notifier)
                                      .requestDenied();

                                  await ref
                                      .read(permissionNotifierProvider.notifier)
                                      .checkAndUpdateLocation();
                                  return;
                                }
                              },
                            ))),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CopyrightAgung(),
            ),
          ],
        ),
      ),
    );
  }
}

// Visibility(
                //   visible: !permission.cameraAuthorized,
                //   child: Padding(
                //       padding: const EdgeInsets.all(12.0),
                //       child: PermissionItem(
                //         label:
                //             'Kamera dibutuhkan untuk verifikasi wajah. \nPastikan kamera menyala.',
                //         onPressed: () =>
                //             ref.read(permissionProvider.notifier).askCamera(),
                //         title: 'Nyalakan kamera anda',
                //       )),
                // ),
