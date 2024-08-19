import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/device_detector/device_detector_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../background/application/saved_location.dart';
import '../../config/configuration.dart';
import '../../domain/background_failure.dart';
import '../../domain/geofence_failure.dart';
import '../../err_log/application/err_log_notifier.dart';
import '../../geofence/application/geofence_response.dart';

import '../../geofence/geofence_helper.dart';
import '../../home/presentation/home_saved.dart';
import '../../shared/common_widgets.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';
import '../../widgets/v_async_widget.dart';

class InitGeofenceScaffold extends StatefulHookConsumerWidget {
  const InitGeofenceScaffold({Key? key}) : super(key: key);

  @override
  ConsumerState<InitGeofenceScaffold> createState() =>
      _InitGeofenceScaffoldState();
}

class _InitGeofenceScaffoldState extends ConsumerState<InitGeofenceScaffold> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(backgroundNotifierProvider.notifier).getSavedLocations();

      final hasOfflineData =
          await ref.read(geofenceProvider.notifier).hasOfflineData();

      if (hasOfflineData) {
        await ref.read(geofenceProvider.notifier).getGeofenceListFromStorage();
      } else {
        await ref.read(geofenceProvider.notifier).getGeofenceList();
      }
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    final geofenceHelper = GeofenceHelper(ref, context);

    // SAVED ABSEN
    ref.listen<Option<Either<BackgroundFailure, List<SavedLocation>>>>(
        backgroundNotifierProvider.select(
          (state) => state.failureOrSuccessOption,
        ),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                geofenceHelper.savedBackgroundItemsError,
                ref
                    .read(backgroundNotifierProvider.notifier)
                    .changeBackgroundItems)));

    // GEOFENCE
    ref.listen<Option<Either<GeofenceFailure, List<GeofenceResponse>>>>(
      geofenceProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
          () {},
          (either) => either.fold((failure) {
                failure.maybeWhen(
                    noConnection: () => ref
                        .read(geofenceProvider.notifier)
                        .getGeofenceListFromStorage(),
                    empty: () => geofenceHelper.geofenceEmptyError(),
                    orElse: () => geofenceHelper.otherError(failure));
              },
                  (geofenceList) =>
                      geofenceHelper.getAndInitializeGeofence(geofenceList))),
    );

    final isLoading =
        ref.watch(geofenceProvider.select((value) => value.isGetting)) ||
            ref.watch(
                backgroundNotifierProvider.select((value) => value.isGetting));

    ref.listen<AsyncValue>(errLogControllerProvider, (_, state) {
      state.showAlertDialogOnError(context, ref);
    });

    final errLog = ref.watch(errLogControllerProvider);

    final _controller = useAnimationController();

    final _device = ref.watch(deviceDetectorNotifierProvider);

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          if (!isLoading) ...[
            VAsyncValueWidget<bool>(
                value: _device,
                data: (dev) {
                  bool cond = false;

                  if (BuildConfig.isProduction) {
                    cond = dev == false;
                  } else {
                    cond = dev;
                  }

                  return cond
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Anda dideteksi menggunakan emulator. Harap gunakan aplikasi E-FINGER pada device fisik anda.',
                              textAlign: TextAlign.center,
                              style: Themes.customColor(
                                20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : HomeSaved();
                }),
          ],
          if (isLoading) ...[
            Align(
              alignment: Alignment.center,
              child: CommonWidget().lottie(
                'assets/location.json',
                'Initializing Geofence...',
                _controller,
              ),
            )
          ]
        ]),
      ),
    );
  }
}
