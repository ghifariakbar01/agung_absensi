import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/theme/application/theme_notifier.dart';
// import 'package:face_net_authentication/locator.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'config/configuration.dart';
import 'imei_introduction/application/shared/imei_introduction_providers.dart';
import 'ip/application/ip_notifier.dart';
import 'permission/application/shared/permission_introduction_providers.dart';
import 'shared/providers.dart';
import 'style/style.dart';
import 'tc/application/shared/tc_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Themes.initUiOverlayStyle();

  BuildConfig.init(flavor: const String.fromEnvironment('flavor'));

  runApp(ProviderScope(child: MyApp()));
}

final initializationProvider =
    FutureProvider.family<Unit, BuildContext>((ref, context) async {
  await ref.read(ipNotifierProvider.future);

  if (!BuildConfig.isProduction) {
    ref.read(dioProvider).interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ));
  }

  await ref.read(tcNotifierProvider.notifier).checkAndUpdateStatusTC();
  await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
  await ref.read(permissionNotifierProvider.notifier).checkAndUpdateLocation();
  await ref.read(imeiIntroNotifierProvider.notifier).checkAndUpdateImeiIntro();

  return unit;
});

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(initializationProvider(context), (_, __) {});

    final router = ref.watch(routerProvider);
    final theme = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        theme: Themes.lightTheme(context),
        darkTheme: Themes.darkTheme(context),
        themeMode: theme.when(
          data: (t) => t.isEmpty
              ? ThemeMode.system
              : t == 'dark'
                  ? ThemeMode.dark
                  : ThemeMode.light,
          loading: () => ThemeMode.dark,
          error: (__, _) => ThemeMode.system,
        ));
  }
}
