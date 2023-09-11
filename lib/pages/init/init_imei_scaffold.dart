import 'package:dartz/dartz.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../domain/imei_failure.dart';
import '../../pages/home/imei/home_imei.dart';
import '../../pages/widgets/loading_overlay.dart';
import '../../pages/widgets/v_dialogs.dart';
import '../../shared/providers.dart';

class InitImeiScaffold extends ConsumerStatefulWidget {
  const InitImeiScaffold();

  @override
  ConsumerState<InitImeiScaffold> createState() => _InitImeiScaffoldState();
}

class _InitImeiScaffoldState extends ConsumerState<InitImeiScaffold> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(imeiAuthNotifierProvider.notifier).checkAndUpdateImei();
      await ref.read(imeiNotifierProvider.notifier).getImeiCredentials();
      await ref.read(imeiNotifierProvider.notifier).getImei();
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // imeiFOSOProvder
    });

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
