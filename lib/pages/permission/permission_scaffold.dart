import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../absen/widgets/user_info.dart';

import '../widgets/app_logo.dart';
import 'widget/permission_item.dart';

class PermissionScaffold extends ConsumerWidget {
  const PermissionScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(permissionProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 70),
            const AppLogo(),
            const SizedBox(height: 70),
            const WelcomeLabel(title: 'Selamat datang'),
            const SizedBox(height: 35),
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
            Visibility(
              visible: !permission.locationAuthorized,
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: PermissionItem(
                    label:
                        'Lokasi dibutuhkan untuk memastikan anda berada di lokasi kantor agung group.',
                    onPressed: () =>
                        ref.read(permissionProvider.notifier).askLocation(),
                    title: 'Nyalakan lokasi anda',
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
