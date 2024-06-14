import 'package:dartz/dartz.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:upgrader/upgrader.dart';

import 'config/configuration.dart';

import 'firebase/remote_config/application/firebase_remote_cfg.dart';
import 'firebase/remote_config/application/firebase_remote_config_notifier.dart';
import 'firebase/remote_config/helper/firebase_remote_config_initializer.dart';
import 'helper.dart';

import 'imei_introduction/application/shared/imei_introduction_providers.dart';
import 'ip/application/ip_notifier.dart';
import 'shared/providers.dart';
import 'style/style.dart';
import 'tc/application/shared/tc_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgets/v_async_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Themes.initUiOverlayStyle();
  BuildConfig.init();

  runApp(ProviderScope(child: MyApp()));
}

final initializationProvider = FutureProvider<Unit>((ref) async {
  await FirebaseRemoteConfigInitializer.setupRemoteConfig(ref);

  final helper = HelperImpl();
  // await helper.storageDebugMode(ref, isDebug: true);
  await helper.fixStorageOnAndroidDevices(ref);

  if (!BuildConfig.isProduction) {
    ref.read(dioProvider).interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ));
  }

  await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
  await ref.read(tcNotifierProvider.notifier).checkAndUpdateStatusTC();
  await ref.read(imeiIntroNotifierProvider.notifier).checkAndUpdateImeiIntro();

  return unit;
});

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(initializationProvider, (_, __) {});

    final router = ref.watch(routerProvider);
    final routerDelegate = router.routerDelegate;

    final firebaseRemoteCfg = ref.watch(firebaseRemoteConfigNotifierProvider);
    final ipNotifier = ref.watch(ipNotifierProvider);

    return VAsyncWidgetScaffoldWrappedMaterial<FirebaseRemoteCfg>(
      value: firebaseRemoteCfg,
      data: (cfg) => VAsyncWidgetScaffoldWrappedMaterial<void>(
          value: ipNotifier,
          data: (_) => MaterialApp.router(
              debugShowCheckedModeBanner: false,
              debugShowMaterialGrid: false,
              themeMode: ThemeMode.light,
              theme: Themes.lightTheme(context),
              routeInformationProvider: router.routeInformationProvider,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: routerDelegate,
              builder: (_, c) => UpgradeAlert(
                    key: UniqueKey(),
                    navigatorKey: routerDelegate.navigatorKey,
                    child: c,
                    upgrader: Upgrader(
                      messages: MyUpgraderMessages(),
                      minAppVersion: cfg.minApp,
                      durationUntilAlertAgain: Duration(hours: 3),
                    ),
                  ))),
    );
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
