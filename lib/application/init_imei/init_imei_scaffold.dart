import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../pages/home/imei/home_imei.dart';

class InitImeiScaffold extends ConsumerStatefulWidget {
  const InitImeiScaffold();

  @override
  ConsumerState<InitImeiScaffold> createState() => _InitImeiScaffoldState();
}

class _InitImeiScaffoldState extends ConsumerState<InitImeiScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        HomeImei(),
        LoadingOverlay(
            loadingMessage: 'Initializing Installation ID...', isLoading: true)
      ]),
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }
}
