import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../style/style.dart';

import '../../absen/widgets/user_info.dart';
import '../shared/providers.dart';
import 'widget/app_logo.dart';
import 'widget/proceed_widget.dart';

class WelcomeScaffold extends ConsumerWidget {
  const WelcomeScaffold();

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
            Visibility(
              visible: !permission.cameraAuthorized,
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: PermissionItem(
                    label:
                        'Kamera dibutuhkan untuk verifikasi wajah. \nPastikan kamera menyala.',
                    onPressed: () =>
                        ref.read(permissionProvider.notifier).askCamera(),
                    title: 'Nyalakan kamera anda',
                  )),
            ),
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

class PermissionItem extends StatelessWidget {
  const PermissionItem(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.label})
      : super(key: key);

  final Function() onPressed;
  final String title;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProceedWidget(onPressed, title),
        Text(
          label,
          style: Themes.black(FontWeight.normal, 14),
        ),
      ],
    );
  }
}
