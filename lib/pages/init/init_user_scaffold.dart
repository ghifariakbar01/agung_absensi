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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        // await Future.delayed(Duration(seconds: 1),
        //     () => ref.invalidate(imeiInitFutureProvider(context)));
        ref.read(imeiInitFutureProvider(context).future));
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
