import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../style/style.dart';
import '../../application/timer/timer_state.dart';
import '../../shared/providers.dart';
import '../widgets/app_logo.dart';

class AbsenMasukPage extends HookConsumerWidget {
  const AbsenMasukPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ref.read(timerProvider.notifier).start());

    ref.listen<TimerModel>(timerProvider, (_, timer) {
      if (timer.timeLeft == '00:00') {
        context.pop();
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
                'Berhasil\n Absen Masuk',
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
