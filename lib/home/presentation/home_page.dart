import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upgrader/upgrader.dart';

import '../../firebase/remote_config/application/firebase_remote_cfg.dart';
import '../../firebase/remote_config/application/firebase_remote_config_notifier.dart';
import '../../init/presentation/init_geofence_scaffold.dart';
import '../../init_user/presentation/init_user_scaffold.dart';
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
    final status = ref.watch(initUserStatusNotifierProvider);

    return status.maybeWhen(
      success: () => InitGeofenceScaffold(),
      orElse: () => InitUserScaffold(),
    );
  }
}
