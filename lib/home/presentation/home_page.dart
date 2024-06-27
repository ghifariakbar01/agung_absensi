import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../init/presentation/init_geofence_scaffold.dart';
import '../../init_user/presentation/init_user_scaffold.dart';
import '../../shared/providers.dart';

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
