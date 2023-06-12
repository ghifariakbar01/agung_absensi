import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../style/style.dart';

import '../../../core/application/routes/route_names.dart';
import '../welcome/presentation/widget/proceed_widget.dart';
import 'widgets/absen_in_button.dart';
import 'widgets/user_info.dart';

class AbsenScaffold extends HookConsumerWidget {
  const AbsenScaffold();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // const AppLogo(),
          const UserInfo(title: 'User'),
          const SizedBox(height: 8),
          ProceedWidget(() => context.pushNamed(RouteNames.riwayatNameRoute),
              'Riwayat waktu tersimpan'),
          const AbsenInButton(),
          const SizedBox(
            height: 8,
          ),
          TextButton(
            onPressed: () => context.pushNamed(RouteNames.absenKeluarNameRoute),
            child: Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Palette.greyDisabled,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  'ABSEN OUT',
                  style: Themes.grey(
                    FontWeight.bold,
                    16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 90),
          Center(
              child: TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'ganti akun',
              style: Themes.blackItalic(),
            ),
          )),
        ],
      ),
    );
  }
}
