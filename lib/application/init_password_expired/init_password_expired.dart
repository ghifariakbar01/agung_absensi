import 'package:face_net_authentication/application/init_password_expired/init_password_expired_status.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upgrader/upgrader.dart';

import '../../application/password_expired/password_expired_state.dart';
import '../../shared/providers.dart';
import '../routes/route_names.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PasswordExpiredState passwordExpired =
          ref.read(passwordExpiredNotifierStatusProvider.notifier).state;

      await passwordExpired.maybeWhen(
          expired: () async {
            await ref
                .read(editProfileNotifierProvider.notifier)
                .clearImeiFromDB();

            await ref
                .read(passwordExpiredNotifierProvider.notifier)
                .clearPasswordExpired();
          },
          orElse: () => null);

      ref.read(initPasswordExpiredStatusProvider.notifier).state =
          InitPasswordExpiredStatus.success();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        editProfileNotifierProvider.select((value) => value.isSubmitting));

    return Scaffold(
      body: Stack(children: [
        LoadingOverlay(
            loadingMessage: 'Initializing Password Expired...',
            isLoading: isLoading)
      ]),
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }
}
