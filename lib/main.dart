// ignore_for_file: unused_result

import 'package:dartz/dartz.dart';
// import 'package:face_net_authentication/helper.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:upgrader/upgrader.dart';

import 'config/configuration.dart';

import 'firebase/remote_config/helper/firebase_remote_config_initializer.dart';
// import 'helper.dart';

import 'imei_introduction/application/shared/imei_introduction_providers.dart';
// import 'shared/future_providers.dart';
import 'shared/providers.dart';
import 'style/style.dart';
import 'tc/application/shared/tc_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'utils/upgrader_message.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.camera.request();
  // await Permission.microphone.request();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Themes.initUiOverlayStyle();

  const bool isProduction = bool.fromEnvironment('dart.vm.product');
  BuildConfig.init(flavor: isProduction ? 'production' : 'development');

  runApp(ProviderScope(
    child: MyApp(),
  ));
}

final initializationProvider = FutureProvider<Unit>((ref) async {
  // final helper = HelperImpl();
  // await helper.storageDebugMode(ref, isDebug: true);
  // await helper.fixStorage(ref);

  await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
  await ref.read(tcNotifierProvider.notifier).checkAndUpdateStatusTC();
  await ref.read(imeiIntroNotifierProvider.notifier).checkAndUpdateImeiIntro();

  await FirebaseRemoteConfigInitializer.setupRemoteConfig(ref);

  if (!BuildConfig.isProduction) {
    ref.read(dioProvider).interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ));
  }

  return unit;
});

class MyApp extends ConsumerStatefulWidget {
  const MyApp();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // await ref.refresh(imeiInitFutureProvider(context).future);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(initializationProvider, (_, __) {});

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
        builder: (_, c) => UpgradeAlert(
            key: UniqueKey(),
            navigatorKey: routerDelegate.navigatorKey,
            child: c,
            upgrader: Upgrader(
                messages: MyUpgraderMessages(),
                durationUntilAlertAgain: Duration(hours: 3))));
  }
}
