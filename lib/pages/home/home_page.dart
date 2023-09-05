import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upgrader/upgrader.dart';

import '../widgets/loading_overlay.dart';
import 'home_scaffold.dart';

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
          showIgnore: false,
          showLater: false,
          showReleaseNotes: true,
          messages: MyUpgraderMessages()),
      child: Stack(
        children: [
          HomeScaffold(),
          LoadingOverlay(isLoading: false),
        ],
      ),
    );
  }
}

class MyUpgraderMessages extends UpgraderMessages {
  @override
  String get body => 'Lakukan update dengan versi aplikasi FINGER terbaru.';

  @override
  String get buttonTitleIgnore => '-';
}
