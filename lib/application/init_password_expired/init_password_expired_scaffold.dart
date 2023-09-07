import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/init_password_expired/init_password_expired_status.dart';
import 'package:face_net_authentication/application/init_user/init_user_status.dart';
import 'package:face_net_authentication/application/user/user_model.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/password_expired/password_expired_state.dart';
import '../../domain/user_failure.dart';
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

      passwordExpired.maybeWhen(
          expired: () async {
            // SET USER
            final userNotifier = ref.read(userNotifierProvider.notifier);

            String userInString = await userNotifier.getUserString();
            Either<UserFailure, UserModelWithPassword> userWithPassword =
                userNotifier.parseUser(userInString);

            debugger();

            await userWithPassword.fold(
                (_) => null, (user) => userNotifier.setUser(user));

            await ref
                .read(editProfileNotifierProvider.notifier)
                .clearImeiFromDB();

            await ref
                .read(passwordExpiredNotifierProvider.notifier)
                .clearPasswordExpired();

            // RELOAD USER
            ref.read(initUserStatusProvider.notifier).state =
                InitUserStatus.init();

            ref.read(initPasswordExpiredStatusProvider.notifier).state =
                InitPasswordExpiredStatus.success();
          },
          orElse: () => ref
              .read(initPasswordExpiredStatusProvider.notifier)
              .state = InitPasswordExpiredStatus.success());

      debugger();
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
