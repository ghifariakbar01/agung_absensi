import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/future_providers.dart';
import '../widgets/loading_overlay.dart';

class InitUserScaffold extends ConsumerStatefulWidget {
  const InitUserScaffold();

  @override
  ConsumerState<InitUserScaffold> createState() => _InitUserScaffoldState();
}

class _InitUserScaffoldState extends ConsumerState<InitUserScaffold> {
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userInitFutureProvider(context).future);
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    final userInitFuture = ref.watch(userInitFutureProvider(context));

    return Scaffold(
      body: Stack(children: [
        userInitFuture.when(
            data: (_) =>
                LoadingOverlay(loadingMessage: 'Tunggu ya...', isLoading: true),
            error: ((error, stackTrace) =>
                Text('Error stack trace $error $stackTrace')),
            loading: () => LoadingOverlay(
                loadingMessage: 'Initializing User & Installatin ID...',
                isLoading: true)),
        //
      ]),
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }
}
