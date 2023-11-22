import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upgrader/upgrader.dart';

import '../init/init_geofence_scaffold.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage();

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
        upgrader: Upgrader(
            dialogStyle: UpgradeDialogStyle.cupertino,
            showLater: true,
            showIgnore: false,
            showReleaseNotes: true,
            messages: MyUpgraderMessages()),
        child: InitGeofenceScaffold());
  }
}

class MyUpgraderMessages extends UpgraderMessages {
  @override
  String get body => 'Lakukan update dengan versi aplikasi E-FINGER terbaru.';

  @override
  String get buttonTitleIgnore => '-';
}
