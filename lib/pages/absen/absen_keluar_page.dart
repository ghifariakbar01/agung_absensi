import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../style/style.dart';
import '../../application/timer/timer_state.dart';
import '../../shared/providers.dart';

class AbsenKeluarPage extends HookConsumerWidget {
  const AbsenKeluarPage();

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const AppLogo(),
          const SizedBox(
            height: 8,
          ),
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
              'Berhasil\n Absen Keluar',
              textAlign: TextAlign.center,
              style: Themes.blue(FontWeight.bold, 36),
            ),
          ),
        ],
      ),
    );
  }
}
