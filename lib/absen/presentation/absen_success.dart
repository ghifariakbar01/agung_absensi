import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../riwayat_absen/application/riwayat_absen_notifier.dart';
import '../../routes/application/route_names.dart';
import '../../style/style.dart';

class Success extends HookConsumerWidget {
  const Success(this.jam);
  final String jam;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = useAnimationController();

    return ColoredBox(
      color: Palette.green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 450,
            child: Lottie.asset(
              'assets/success.json',
              controller: _controller,
              frameRate: FrameRate(60),
              onLoaded: (composition) async {
                final _riwayat = ref.read(riwayatAbsenNotifierProvider);

                await ref
                    .read(riwayatAbsenNotifierProvider.notifier)
                    .getAndReplace(
                      dateFirst: _riwayat.dateFirst,
                      dateSecond: _riwayat.dateSecond,
                    );

                _controller
                  ..duration = Duration(seconds: 3)
                  ..forward().then((_) {
                    context.pop();
                    context.pushNamed(
                      RouteNames.riwayatAbsenRoute,
                      extra: true,
                    );
                  });
              },
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Berhasil Absen',
            style: Themes.customColor(
              30,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            jam,
            style: Themes.customColor(
              45,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
