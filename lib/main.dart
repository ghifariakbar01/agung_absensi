import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_net_authentication/application/imei_introduction/shared/imei_introduction_providers.dart';
import 'package:face_net_authentication/application/tc/shared/tc_providers.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'application/permission/shared/permission_introduction_providers.dart';
import 'config/configuration.dart';
import 'shared/providers.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  Themes.initUiOverlayStyle();

  BuildConfig.init(flavor: const String.fromEnvironment('flavor'));

  setupServices();

  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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

  final permissionNotifier = ref.read(permissionNotifierProvider.notifier);
  await permissionNotifier.checkAndUpdateLocation();

  final tcNotifier = ref.read(tcNotifierProvider.notifier);
  await tcNotifier.checkAndUpdateStatusTC();

  final imeiInstructionNotifier =
      ref.read(imeiIntroductionNotifierProvider.notifier);
  await imeiInstructionNotifier.checkAndUpdateStatusIMEIIntroduction();

  // whenever your initialization is completed, remove the splash screen:
  // FlutterNativeSplash.remove();

  return unit;
});

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
