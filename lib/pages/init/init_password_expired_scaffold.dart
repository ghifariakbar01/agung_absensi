import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InitPasswordExpiredScaffold extends ConsumerStatefulWidget {
  const InitPasswordExpiredScaffold();

  @override
  ConsumerState<InitPasswordExpiredScaffold> createState() =>
      _InitPasswordExpiredScaffoldState();
}

class _InitPasswordExpiredScaffoldState
    extends ConsumerState<InitPasswordExpiredScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {});

    return Scaffold(
      body: Stack(children: [
        LoadingOverlay(
            loadingMessage: 'Initializing Password Expired...', isLoading: true)
      ]),
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }
}
