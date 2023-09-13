import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      await ref.read(userNotifierProvider.notifier).getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(userFOSOProvider(context).future);
      await ref.read(userFOSOUpdateProvider(context).future);
      await ref.read(imeiFOSOProvder(context).future);
      await ref.read(imeiFOSOGetProvider(context).future);
      await ref.read(passwordExpProvider.future);
      //
    });

    return Scaffold(
      body: Stack(children: [
        LoadingOverlay(
            loadingMessage: 'Initializing User & Installation ID...',
            isLoading: true)
      ]),
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }
}
