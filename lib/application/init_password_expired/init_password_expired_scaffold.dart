import 'dart:developer';

import 'package:face_net_authentication/application/init_password_expired/init_password_expired_status.dart';
import 'package:face_net_authentication/application/init_user/init_user_status.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/password_expired/password_expired_state.dart';
import '../../shared/providers.dart';

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

            // RELOAD USER
            ref.read(initUserStatusProvider.notifier).state =
                InitUserStatus.init();

            debugger();
          },
          orElse: () => null);

      debugger();

      ref.read(initPasswordExpiredStatusProvider.notifier).state =
          InitPasswordExpiredStatus.success();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        LoadingOverlay(
            loadingMessage: 'Initializing Password Expired...', isLoading: true)
      ]),
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }
}
