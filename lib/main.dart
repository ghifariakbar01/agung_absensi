import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/theme/application/theme_notifier.dart';
// import 'package:face_net_authentication/locator.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:upgrader/upgrader.dart';

import 'application/imei_introduction/shared/imei_introduction_providers.dart';
import 'application/permission/shared/permission_introduction_providers.dart';
import 'application/tc/shared/tc_providers.dart';
import 'config/configuration.dart';
import 'ip/application/ip_notifier.dart';
import 'shared/providers.dart';
import 'style/style.dart';

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
      key: router.routerDelegate.navigatorKey,
      routerDelegate: router.routerDelegate,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: Themes.lightTheme(context),
      darkTheme: Themes.darkTheme(context),
      builder: (_, child) {
        return UpgradeAlert(
            upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                showLater: true,
                showIgnore: false,
                messages: MyUpgraderMessages()),
            child: child);
      },
      themeMode: theme.when(
        data: (theme) => theme.isEmpty
            ? ThemeMode.system
            : theme == 'dark'
                ? ThemeMode.dark
                : ThemeMode.light,
        loading: () => ThemeMode.dark,
        error: (__, _) => ThemeMode.system,
      ),
    );
  }

  MaterialColor getMaterialColor(Color color) {
    final int red = color.red;
    final int green = color.green;
    final int blue = color.blue;
    final int alpha = color.alpha;

    final Map<int, Color> shades = {
      50: Color.fromARGB(alpha, red, green, blue),
      100: Color.fromARGB(alpha, red, green, blue),
      200: Color.fromARGB(alpha, red, green, blue),
      300: Color.fromARGB(alpha, red, green, blue),
      400: Color.fromARGB(alpha, red, green, blue),
      500: Color.fromARGB(alpha, red, green, blue),
      600: Color.fromARGB(alpha, red, green, blue),
      700: Color.fromARGB(alpha, red, green, blue),
      800: Color.fromARGB(alpha, red, green, blue),
      900: Color.fromARGB(alpha, red, green, blue),
    };

    return MaterialColor(color.value, shades);
  }
}

class MyUpgraderMessages extends UpgraderMessages {
  @override
  String get body => 'Lakukan update dengan versi aplikasi E-FINGER terbaru.';

  @override
  String get buttonTitleIgnore => '-';
}
