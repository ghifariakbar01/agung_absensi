import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/init_user/init_user_status.dart';
import '../../shared/future_providers.dart';
import '../../shared/providers.dart';
import '../widgets/loading_overlay.dart';

class InitUserScaffold extends ConsumerStatefulWidget {
  const InitUserScaffold();

  @override
  ConsumerState<InitUserScaffold> createState() => _InitUserScaffoldState();
}

class _InitUserScaffoldState extends ConsumerState<InitUserScaffold> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isOffline = ref.read(absenOfflineModeProvider);

      if (!isOffline) {
        await ref.read(imeiInitFutureProvider(context).future);
      } else {
        ref.read(initUserStatusProvider.notifier).state =
            InitUserStatus.success();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    final imeiInitFuture = ref.watch(imeiInitFutureProvider(context));

    return Scaffold(
      body: Stack(children: [
        imeiInitFuture.when(
            data: (_) =>
                LoadingOverlay(loadingMessage: 'Tunggu ya...', isLoading: true),
            error: ((error, stackTrace) =>
                Text('Error stack trace $error $stackTrace')),
            loading: () => LoadingOverlay(
                loadingMessage: 'Initializing User & Installation ID...',
                isLoading: true)),
        //
      ]),
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }
}
