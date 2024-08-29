import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/dialog_helper.dart';
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
    final _shouldMove = useState(true);

    return SafeArea(
      child: Container(
        color: Palette.green,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 64,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Lottie.asset(
                'assets/success.json',
                controller: _controller,
                frameRate: FrameRate(60),
                onLoaded: (composition) {
                  _controller
                    ..duration = processedAbsen.length > 1
                        ? Duration(seconds: 5)
                        : Duration(seconds: 2)
                    ..forward().then((_) {
                      if (_shouldMove.value) {
                        _runCommand(ref, context);
                      }
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
            if (processedAbsen.length == 1) ...[
              Text(
                DateFormat('dd MMM HH:mm').format(processedAbsen.first.date),
                textAlign: TextAlign.center,
                style: Themes.customColor(
                  45,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else ...[
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Text(
                    processedAbsen
                        .map((e) => DateFormat('dd MMM HH:mm').format(e.date))
                        .toList()
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', '\n')
                        .replaceAll(',', '\n'),
                    textAlign: TextAlign.center,
                    style: Themes.customColor(
                      25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            Spacer(),
            if (processedAbsen.length > 1) ...[
              TextButton(
                onPressed: () {
                  _shouldMove.value = false;
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Palette.greyDisabled.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          _shouldMove.value == true
                              ? ' Tetap di Halaman ? (Untuk Screenshot)'
                              : ' Silahkan lakukan Screenshot ',
                          textAlign: TextAlign.center,
                          style: Themes.customColor(
                            12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              if (_shouldMove.value == false)
                IconButton(
                  onPressed: () async {
                    final result = await DialogHelper.showConfirmationDialog(
                        label:
                            ' Sudah selesai screenshot & ingin melanjutkan ? ',
                        context: context);

                    if (result) {
                      return _runCommand(ref, context);
                    }
                  },
                  icon: Icon(
                    Icons.arrow_circle_right_rounded,
                    color: Colors.white,
                  ),
                )
            ]
          ],
        ),
      ),
    );
  }

  void _runCommand(WidgetRef ref, BuildContext context) {
    ref.read(geofenceProvider.notifier).resetFOSO();

    context.pushReplacementNamed(
      RouteNames.riwayatAbsenRoute,
      extra: true,
    );
  }
}
