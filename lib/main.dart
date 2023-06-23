import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'config/configuration.dart';
import 'shared/providers.dart';

// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//     as bg;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Themes.initUiOverlayStyle();

  BuildConfig.init(flavor: const String.fromEnvironment('flavor'));

  setupServices();
  runApp(ProviderScope(child: MyApp()));
}

final initializationProvider = FutureProvider<Unit>((ref) async {
  // await ref.read(hiveProvider).init();
  ref.read(dioProvider)
    ..options = BaseOptions(
      connectTimeout: BuildConfig.get().connectTimeout,
      receiveTimeout: BuildConfig.get().receiveTimeout,
      validateStatus: (status) {
        return true;
      },
      baseUrl: BuildConfig.get().baseUrl,
    );
  // ..interceptors.add(ref.read(authInterceptorProvider));

  if (!BuildConfig.isProduction) {
    ref.read(dioProvider).interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ));
  }

  final authNotifier = ref.read(authNotifierProvider.notifier);
  await authNotifier.checkAndUpdateAuthStatus();

  // await ref.watch(backgroundLocationProvider.future);

  return unit;
});

// final backgroundLocationProvider = FutureProvider<Unit>((ref) {
//   ////
//   // 1.  Listen to events (See docs for all 12 available events).
//   //

//   // Fired whenever a location is recorded
//   bg.BackgroundGeolocation.onLocation((bg.Location location) {
//     print('[location] - $location');
//   });

//   // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
//   bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
//     print('[motionchange] - $location');
//   });

//   // Fired whenever the state of location-services changes.  Always fired at boot
//   bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
//     print('[providerchange] - $event');
//   });

//   ////
//   // 2.  Configure the plugin
//   //
//   bg.BackgroundGeolocation.ready(bg.Config(
//           desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
//           distanceFilter: 10.0,
//           stopOnTerminate: false,
//           startOnBoot: true,
//           debug: true,
//           logLevel: bg.Config.LOG_LEVEL_VERBOSE))
//       .then((bg.State state) {
//     if (!state.enabled) {
//       ////
//       // 3.  Start the plugin.
//       //
//       bg.BackgroundGeolocation.start();
//     }
//   });

//   return unit;
// });

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(initializationProvider, (_, __) {});

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
