import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../background/application/saved_location.dart';
import '../../routes/application/route_names.dart';
import '../../../shared/providers.dart';
import '../../../style/style.dart';

class Success extends HookConsumerWidget {
  const Success(this.processedAbsen);

  final List<SavedLocation> processedAbsen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _controller = useAnimationController();

    return Container(
      color: Palette.green,
      width: double.infinity,
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
                _controller
                  ..duration = processedAbsen.length > 1
                      ? Duration(seconds: 10)
                      : Duration(seconds: 2)
                  ..forward().then((_) {
                    ref.read(geofenceProvider.notifier).resetFOSO();
                    context.pop();
                    context.pushReplacementNamed(
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
            processedAbsen
                .map((e) => DateFormat('dd MMM HH:mm').format(e.date))
                .toList()
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '\n')
                .replaceAll(',', '\n'),
            textAlign: TextAlign.center,
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
