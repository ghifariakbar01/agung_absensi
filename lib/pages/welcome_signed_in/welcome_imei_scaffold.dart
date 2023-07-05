import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/auth/auth_notifier.dart';
import '../../application/routes/route_names.dart';
import '../../application/user/user_model.dart';
import '../../constants/assets.dart';
import '../../domain/edit_failure.dart';
import '../../domain/value_objects_copy.dart';
import '../../shared/providers.dart';
import '../widgets/alert_helper.dart';
import '../widgets/v_dialogs.dart';

class WelcomeImeiScaffold extends ConsumerWidget {
  const WelcomeImeiScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<Option<Either<EditFailure, String?>>>(
        editProfileNotifierProvider.select(
          (state) => state.failureOrSuccessOptionGettingImei,
        ),
        (_, failureOrSuccessOptionGettingImei) =>
            failureOrSuccessOptionGettingImei.fold(
              () {},
              (either) => either.fold(
                  (failure) => AlertHelper.showSnackBar(
                        context,
                        message: failure.map(
                          server: (value) =>
                              '${value.message} ${value.errorCode}',
                          noConnection: (_) => 'tidak ada koneksi',
                        ),
                      ), (imeiResponse) async {
                final savedImei =
                    ref.read(imeiAuthNotifierProvider.notifier).state.imei;

                final imeiDBState =
                    ref.read(imeiNotifierProvider.notifier).state;

                final user = ref.read(userNotifierProvider.notifier).state.user;

                log('called saved here');
                log('savedImei imeiDBState imeiResponse user $savedImei $imeiDBState $imeiResponse ${user.imeiHp}');

                await ref.read(editProfileNotifierProvider.notifier).onImei(
                    savedImei: savedImei,
                    imeiDBState: imeiDBState,
                    imeiDBString: imeiResponse,
                    onImeiNotRegistered: () async {
                      final generatedImei = await ref
                          .read(imeiNotifierProvider.notifier)
                          .generateImei();

                      await ref
                          .read(editProfileNotifierProvider.notifier)
                          .registerAndShowDialog(
                            register: () => ref
                                .read(editProfileNotifierProvider.notifier)
                                .registerImei(imei: generatedImei),
                            saveImei: () => ref
                                .read(imeiAuthNotifierProvider.notifier)
                                .saveImei(imei: generatedImei),
                            getImeiCredentials: () => ref
                                .read(imeiAuthNotifierProvider.notifier)
                                .getImeiCredentials(),
                            onImeiComplete: () => ref
                                .read(editProfileNotifierProvider.notifier)
                                .onEditProfile(
                                    saveUser: () => ref
                                        .read(userNotifierProvider.notifier)
                                        .saveUserAfterUpdate(
                                            idKaryawan:
                                                IdKaryawan(user.idKary ?? ''),
                                            password:
                                                Password(user.password ?? ''),
                                            userId: UserId(user.nama ?? '')),
                                    onUser: () => ref
                                        .read(userNotifierProvider.notifier)
                                        .getUser()),
                            showDialog: () => showDialog(
                              context: context,
                              builder: (_) => VSimpleDialog(
                                label: 'Berhasil',
                                labelDescription:
                                    'Sukses daftar INSTALLATION ID',
                                asset: Assets.iconChecked,
                              ),
                            ).then((_) => showDialog(
                                  context: context,
                                  builder: (_) => VSimpleDialog(
                                    color: Palette.red,
                                    label: 'Warning',
                                    labelDescription:
                                        'Jika uninstall, unlink hp di setting profil',
                                    asset: Assets.iconChecked,
                                  ),
                                )),
                          );
                    },
                    onImeiAlreadyRegistered: () async => ref
                        .read(editProfileNotifierProvider.notifier)
                        .onImeiAlreadyRegistered(
                          showDialog: () => showDialog(
                            context: context,
                            builder: (_) => VSimpleDialog(
                              label: 'Gagal',
                              labelDescription: 'Sudah punya INSTALLATION ID',
                              asset: Assets.iconCrossed,
                            ),
                          ),
                          logout: () => ref
                              .read(userNotifierProvider.notifier)
                              .logout(UserModelWithPassword.initial()),
                          checkAndUpdateAuthStatus: () => ref
                              .read(authNotifierProvider.notifier)
                              .checkAndUpdateAuthStatus(),
                          redirect: () {
                            final isLoggedIn = ref.watch(authNotifierProvider);

                            isLoggedIn == AuthState.authenticated()
                                ? context
                                    .replaceNamed(RouteNames.welcomeNameRoute)
                                : context
                                    .replaceNamed(RouteNames.signInNameRoute);
                          },
                        ));
              }),
            ));

    return Container();
  }
}
