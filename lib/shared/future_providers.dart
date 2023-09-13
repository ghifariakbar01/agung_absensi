import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../application/imei/imei_auth_state.dart';

import '../application/init_user/init_user_status.dart';
import '../application/password_expired/password_expired_state.dart';
import '../application/user/user_model.dart';
import '../constants/assets.dart';
import '../domain/auth_failure.dart';
import '../domain/edit_failure.dart';
import '../domain/imei_failure.dart';
import '../domain/user_failure.dart';

import '../pages/widgets/v_dialogs.dart';
import '../style/style.dart';
import 'providers.dart';

// USER FUTURE PROVIDERS
final userFOSOProvider =
    FutureProvider.family<void, BuildContext>((ref, context) async {
  // debugger();

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
                // GET FROM DB
                final userParsed = ref
                    .read(userNotifierProvider.notifier)
                    .parseUser(userString);

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
                    (user) => ref
                        .read(userNotifierProvider.notifier)
                        .saveUserAfterUpdate(user: user));
              })));
});

final userFOSOUpdateProvider =
    FutureProvider.family<void, BuildContext>((ref, context) async {
  // debugger();

  //
  void letYouThrough() {
    ref.read(initUserStatusProvider.notifier).state = InitUserStatus.success();
  }

  ref.listen<Option<Either<AuthFailure, Unit?>>>(
    userNotifierProvider.select(
      (state) => state.failureOrSuccessOptionUpdate,
    ),
    (_, failureOrSuccessOptionUpdate) => failureOrSuccessOptionUpdate.fold(
        () {},
        (either) => either.fold(
                (failure) => failure.maybeMap(
                      noConnection: (_) => letYouThrough(),
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
              String userString =
                  await ref.read(userNotifierProvider.notifier).getUserString();
              final parseEither =
                  ref.read(userNotifierProvider.notifier).parseUser(userString);

              // debugger();

              // PARSE USER SUCCESS / FAILURE
              await parseEither.fold(
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
                      ), (userUpdated) async {
                // debugger();

                // FINALIZE USER
                await ref.read(userNotifierProvider.notifier).onUserParsedRaw(
                    ref: ref, userModelWithPassword: userUpdated);

                // TRIGGER IMEI FUTURE PROVIDERS
                await ref
                    .read(imeiNotifierProvider.notifier)
                    .getImeiCredentials();
                await ref.read(imeiNotifierProvider.notifier).getImei();
              });
            })),
  );
});

// IMEI FUTURE PROVIDERS

// GET IMEI STORAGE
final imeiFOSOProvder =
    FutureProvider.family<void, BuildContext>((ref, context) {
  ref.listen<Option<Either<ImeiFailure, String?>>>(
    imeiNotifierProvider.select(
      (state) => state.failureOrSuccessOption,
    ),
    (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
        () {},
        (either) => either.fold(
            (failure) => failure.maybeMap(
                empty: (_) => Future.value(),
                orElse: () => showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => VSimpleDialog(
                        label: 'Error',
                        labelDescription: failure.maybeWhen(
                            errorParsing: (errorParsing) =>
                                'Error $errorParsing',
                            storage: () =>
                                'Storage Penuh. Tidak bisa menyimpan Installation ID.',
                            orElse: () => ''),
                        asset: Assets.iconChecked,
                      ),
                    )),
            (imei) => ref
                .read(imeiNotifierProvider.notifier)
                .changeSavedImei(imei ?? ''))),
  );
});

// CHECK IMEI FROM INTERNET
final imeiFOSOGetProvider =
    FutureProvider.family<void, BuildContext>((ref, context) {
  //
  void letYouThrough() {
    ref.read(initUserStatusProvider.notifier).state = InitUserStatus.success();
  }

  void hold() {
    ref.read(initUserStatusProvider.notifier).state = InitUserStatus.init();
  }

  // debugger();
  ref.listen<Option<Either<EditFailure, String?>>>(
      imeiNotifierProvider.select(
        (state) => state.failureOrSuccessOptionGetImei,
      ),
      (_, failureOrSuccessOptionGetImei) => failureOrSuccessOptionGetImei.fold(
            () {},
            (either) => either.fold(
                (failure) => failure.maybeMap(
                      noConnection: (_) => letYouThrough(),
                      orElse: () => showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => VSimpleDialog(
                          label: 'Error',
                          labelDescription: failure.maybeMap(
                              server: (server) => 'error server $server',
                              orElse: () => ''),
                          asset: Assets.iconCrossed,
                        ),
                      ),
                    ), (imeiResponse) async {
              await ref
                  .read(imeiAuthNotifierProvider.notifier)
                  .checkAndUpdateImei();

              ImeiAuthState imeiAuthState = ref.read(imeiAuthNotifierProvider);
              String savedImei =
                  ref.read(imeiNotifierProvider.select((value) => value.imei));
              UserModelWithPassword user =
                  ref.read(userNotifierProvider.select((value) => value.user));

              // debugger();

              await ref.read(imeiNotifierProvider.notifier).onImei(
                  savedImei: savedImei,
                  imeiAuthState: imeiAuthState,
                  imeiDBString: imeiResponse,
                  onImeiNotRegistered: () async {
                    final generatedImeiString =
                        ref.read(imeiNotifierProvider.notifier).generateImei();

                    await ref
                        .read(editProfileNotifierProvider.notifier)
                        .registerAndShowDialog(
                            register: () => ref
                                .read(imeiNotifierProvider.notifier)
                                .registerImei(imei: generatedImeiString),
                            getImeiCredentials: () => ref
                                .read(imeiNotifierProvider.notifier)
                                .getImeiCredentials(),
                            onImeiComplete: () => ref
                                .read(editProfileNotifierProvider.notifier)
                                .onEditProfile(
                                    saveUser: () => ref
                                        .read(userNotifierProvider.notifier)
                                        .saveUserAfterUpdate(user: user),
                                    onUser: () => ref
                                        .read(userNotifierProvider.notifier)
                                        .getUser()),
                            showDialog: () => showSuccessDialog(context));

                    // debugger();
                    letYouThrough();
                  },
                  onImeiOK: () => letYouThrough(),
                  onImeiAlreadyRegistered: () async {
                    await ref
                        .read(imeiNotifierProvider.notifier)
                        .onImeiAlreadyRegistered(
                          showDialog: () => showFailedDialog(context),
                          logout: () =>
                              ref.read(userNotifierProvider.notifier).logout(),
                        );

                    hold();
                    // debugger();
                  });
            }),
          ));
});

Future<void> showSuccessDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => VSimpleDialog(
      label: 'Berhasil',
      labelDescription: 'Sukses daftar INSTALLATION ID',
      asset: Assets.iconChecked,
    ),
  ).then((_) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
          color: Palette.red,
          label: 'Warning',
          labelDescription: 'Jika uninstall, unlink hp di setting profil',
          asset: Assets.iconChecked,
        ),
      ));
}

Future<void> showFailedDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => VSimpleDialog(
      label: 'Gagal',
      labelDescription: 'Sudah punya INSTALLATION ID',
      asset: Assets.iconCrossed,
    ),
  );
}

final passwordExpProvider = FutureProvider<PasswordExpiredState>((ref) {
  PasswordExpiredState passwordExpired =
      ref.watch(passwordExpiredNotifierStatusProvider);

  // debugger();

  passwordExpired.maybeWhen(
      expired: () async {
        await ref
            .read(passwordExpiredNotifierProvider.notifier)
            .clearPasswordExpired();

        // SET USER
        final userNotifier = ref.watch(userNotifierProvider.notifier);

        String userInString = await userNotifier.getUserString();
        final userWithPasswordEither = userNotifier.parseUser(userInString);

        await userWithPasswordEither.fold(
            (_) {}, (user) => userNotifier.setUser(user));

        await ref
            .read(passwordExpiredNotifierStatusProvider.notifier)
            .checkAndUpdateExpired();

        // RELOAD USER
        // debugger();
      },
      orElse: () => {});

  log('passwordExpired $passwordExpired');

  // debugger();

  return passwordExpired;
});
