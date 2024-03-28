import 'package:dartz/dartz.dart';
// import 'package:face_net_authentication/locator.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:upgrader/upgrader.dart';

import 'config/configuration.dart';
import 'imei_introduction/application/shared/imei_introduction_providers.dart';
import 'ip/application/ip_notifier.dart';
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
  await ref.read(imeiIntroNotifierProvider.notifier).checkAndUpdateImeiIntro();

  return unit;
});

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(initializationProvider(context), (_, __) {});

    final router = ref.watch(routerProvider);
    final routerDelegate = router.routerDelegate;

    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        themeMode: ThemeMode.light,
        theme: Themes.lightTheme(context),
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: routerDelegate,
        builder: (context, child) => UpgradeAlert(
            navigatorKey: routerDelegate.navigatorKey,
            child: child,
            upgrader: Upgrader(
              dialogStyle: UpgradeDialogStyle.cupertino,
              showLater: true,
              showIgnore: false,
              showReleaseNotes: false,
              messages: MyUpgraderMessages(),
            )));
  }
}

class MyUpgraderMessages extends UpgraderMessages {
  @override
  String get body => 'Mohon Lakukan update dengan versi aplikasi terbaru';

  @override
  String get buttonTitleIgnore => '-';

  @override
  String get title => 'Ada Pembaharuan';

  @override
  String get buttonTitleUpdate => 'Update';

  @override
  String get buttonTitleLater => 'Nanti Saja';

  @override
  String get prompt => '';
}
