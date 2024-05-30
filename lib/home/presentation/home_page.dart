import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upgrader/upgrader.dart';

import '../../firebase/remote_config/application/firebase_remote_cfg.dart';
import '../../firebase/remote_config/application/firebase_remote_config_notifier.dart';
import '../../init/presentation/init_geofence_scaffold.dart';
import '../../main.dart';
import '../../network_state/application/network_state_notifier.dart';
import '../../shared/providers.dart';
import '../../widgets/v_async_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage();

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(networkCallbackProvider, (_, __) {});
    final router = ref.watch(routerProvider);
    final firebaseRemoteCfg = ref.watch(firebaseRemoteConfigNotifierProvider);

    return VAsyncValueWidget<FirebaseRemoteCfg>(
      value: firebaseRemoteCfg,
      data: (cfg) => UpgradeAlert(
        key: UniqueKey(),
        child: InitGeofenceScaffold(),
        navigatorKey: router.routerDelegate.navigatorKey,
        upgrader: Upgrader(
            minAppVersion: cfg.minApp,
            durationUntilAlertAgain: Duration(hours: 3),
            messages: MyUpgraderMessages()),
      ),
    );
  }
}
