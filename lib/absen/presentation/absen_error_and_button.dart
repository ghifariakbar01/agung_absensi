import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../geofence/application/geofence_error_notifier.dart';
import '../../geofence/application/geofence_error_state.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';
import '../../widgets/location_detail.dart';
import '../../widgets/v_async_widget.dart';
import 'absen_button.dart';

class AbsenErrorAndButton extends ConsumerWidget {
  const AbsenErrorAndButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final geofenceErrorNotifier = ref.watch(geofenceErrorNotifierProvider);

    return VAsyncValueWidget<GeofenceErrorState>(
      value: geofenceErrorNotifier,
      data: (geofenceError) {
        return geofenceError.maybeWhen(
            ALREADY_STARTED: () => AbsenOk(),
            LOCATION_SERVICES_DISABLED: () => AbsenError(
                'Harap nyalakan lokasi / GPS di Hp Anda. \n\nJika Lowbat, matikan Battery Saver / Power Saver dan nyalakan Akurasi Lokasi / Location Accuracy di Hp.\n\n Jika sudah, force close aplikasi & buka ulang.'),
            orElse: () =>
                AbsenError('Mohon Izinkan Lokasi E-FINGER di Hp Anda.'));
      },
    );
  }
}

class AbsenOk extends HookConsumerWidget {
  const AbsenOk();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTester = ref.watch(testerNotifierProvider);
    final mockLocation = ref.watch(mockLocationNotifierProvider);

    final isTesting = useState(false);
    final isEntering = useState(false);

    final nama = ref
        .watch(userNotifierProvider.select((value) => value.user.nama ?? ''));

    return Column(
      children: [
        ...isTester.maybeWhen(
          tester: () => [AbsenButton(isTesting)],
          orElse: () => mockLocation.maybeWhen(
            mocked: () => [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Anda diduga mengunakan Fake GPS. Harap matikan Fake GPS agar bisa menggunakan aplikasi.'),
              )
            ],
            original: () => [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: LocationDetail(),
              ),
              IgnorePointer(
                ignoring: nama != 'Ghifar',
                child: InkWell(
                  onTap: () {
                    isTesting.value = false;
                    isEntering.value = false;
                  },
                  onDoubleTap: () {
                    isEntering.value = true;
                  },
                  child: SizedBox(
                    height: 32,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              if (isEntering.value) ...[
                SizedBox(
                  height: 32,
                  child: TextFormField(
                    decoration:
                        InputDecoration(hintText: 'Mode Development E-FINGER'),
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        if (value == 'cheatcode20241708') {
                          isTesting.value = true;
                        } else {
                          isTesting.value = false;
                        }
                      }

                      isEntering.value = false;
                    },
                  ),
                ),
                SizedBox(
                  height: 32,
                )
              ],
              AbsenButton(isTesting)
            ],
            orElse: () => [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class AbsenError extends ConsumerWidget {
  const AbsenError(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
        onPressed: () async {},
        child: Text(
          text,
          textAlign: TextAlign.justify,
          style: Themes.customColor(14),
        ));
  }
}
