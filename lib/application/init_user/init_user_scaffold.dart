import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/init_user/init_user_status.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../domain/auth_failure.dart';
import '../../domain/user_failure.dart';
import '../../domain/value_objects_copy.dart';
import '../../pages/widgets/v_dialogs.dart';
import '../../shared/providers.dart';

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
    ref.listen<Option<Either<UserFailure, String?>>>(
        userNotifierProvider.select(
          (state) => state.failureOrSuccessOption,
        ),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                    (failure) => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => VSimpleDialog(
                            label: 'Error',
                            labelDescription: failure.maybeMap(
                                empty: (_) => 'No user found',
                                unknown: (unkn) =>
                                    '${unkn.errorCode} ${unkn.message}',
                                orElse: () => ''),
                            asset: Assets.iconCrossed,
                          ),
                        ), (userString) async {
                  final userParsed = ref
                      .read(userNotifierProvider.notifier)
                      .parseUser(userString);

                  // GET RECENT USER VALUES FROM DB
                  userParsed.fold(
                      (failure) => showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) => VSimpleDialog(
                              label: 'Error',
                              labelDescription: failure.maybeMap(
                                  errorParsing: (error) =>
                                      'Error while parsing user. ${error.message}',
                                  orElse: () => ''),
                              asset: Assets.iconCrossed,
                            ),
                          ),
                      (user) async =>
                          ref.read(absenOfflineModeProvider.notifier).state
                              ? await ref
                                  .read(userNotifierProvider.notifier)
                                  .onUserParsedRaw(
                                      ref: ref, userModelWithPassword: user)
                              : await ref
                                  .read(userNotifierProvider.notifier)
                                  .saveUserAfterUpdate(
                                      idKaryawan: IdKaryawan(user.idKary ?? ''),
                                      password: Password(user.password ?? ''),
                                      userId: UserId(user.nama ?? ''),
                                      server: PTName(user.ptServer)));
                })));

    ref.listen<Option<Either<AuthFailure, Unit?>>>(
      userNotifierProvider.select(
        (state) => state.failureOrSuccessOptionUpdate,
      ),
      (_, failureOrSuccessOptionUpdate) => failureOrSuccessOptionUpdate.fold(
          () {},
          (either) => either.fold(
                  (failure) => failure.maybeMap(
                        noConnection: (_) =>
                            ref.read(userNotifierProvider.notifier).getUser(),
                        passwordExpired: (_) => ref
                            .read(passwordExpiredNotifierProvider.notifier)
                            .savePasswordExpired(),
                        orElse: () => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => VSimpleDialog(
                            label: 'Error',
                            labelDescription: failure.maybeMap(
                                server: (server) =>
                                    '${server.errorCode} ${server.message}',
                                storage: (_) => 'storage penuh',
                                orElse: () => ''),
                            asset: Assets.iconCrossed,
                          ),
                        ),
                      ), (_) async {
                final userString = await ref
                    .read(userNotifierProvider.notifier)
                    .getUserString();

                final userParsed = ref
                    .read(userNotifierProvider.notifier)
                    .parseUser(userString);

                //
                await userParsed.fold(
                    (failure) => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => VSimpleDialog(
                            label: 'Error',
                            labelDescription: failure.maybeMap(
                                errorParsing: (error) =>
                                    'Error while parsing user. ${error.message}',
                                orElse: () => ''),
                            asset: Assets.iconCrossed,
                          ),
                        ),
                    (userUpdated) async => await ref
                        .read(userNotifierProvider.notifier)
                        .onUserParsedRaw(
                            ref: ref, userModelWithPassword: userUpdated));

                ref.read(initUserStatusProvider.notifier).state =
                    InitUserStatus.success();
              })),
    );

    final isLoading =
        ref.watch(userNotifierProvider.select((value) => value.isGetting));

    return Scaffold(
      body: Stack(children: [
        LoadingOverlay(
            loadingMessage: 'Initializing User...', isLoading: isLoading)
      ]),
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }
}
