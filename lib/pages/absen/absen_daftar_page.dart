import 'package:face_net_authentication/core/application/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../style/style.dart';
import '../../application/timer/timer_state.dart';
import '../../core/shared/providers.dart';
import '../welcome/presentation/widget/app_logo.dart';

class AbsenDaftarPage extends HookConsumerWidget {
  const AbsenDaftarPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ref.read(timerProvider.notifier).start());

    ref.listen<TimerModel>(timerProvider, (_, timer) {
      if (timer.timeLeft == '00:00') {
        context.replaceNamed(RouteNames.welcomeSignedNameRoute);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Selamat anda',
                style: Themes.grey(FontWeight.normal, 18),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Text(
                'Berhasil\n Daftar',
                textAlign: TextAlign.center,
                style: Themes.blue(FontWeight.bold, 36),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
