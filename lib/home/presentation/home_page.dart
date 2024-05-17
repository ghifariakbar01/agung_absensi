import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../init/presentation/init_geofence_scaffold.dart';
import '../../network_state/application/network_state_notifier.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage();

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(networkCallbackProvider, (_, __) {});

    return InitGeofenceScaffold();
  }
}
