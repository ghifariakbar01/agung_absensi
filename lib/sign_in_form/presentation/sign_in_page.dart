import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/imei/application/imei_auth_state.dart';
import 'package:face_net_authentication/imei/application/imei_notifier.dart';
import 'package:face_net_authentication/imei_introduction/application/shared/imei_introduction_providers.dart';
import 'package:face_net_authentication/ip/application/ip_notifier.dart';
import 'package:face_net_authentication/tc/application/shared/tc_providers.dart';
import 'package:face_net_authentication/unlink/application/unlink_notifier.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:face_net_authentication/widgets/v_async_widget.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../constants/assets.dart';
import '../../constants/constants.dart';
import '../../domain/auth_failure.dart';
import '../../imei/application/imei_state.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';
import '../../widgets/alert_helper.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/v_button.dart';
import '../../widgets/v_dialogs.dart';
import 'sign_in_scaffold.dart';

// MIGHT FAIL

class SignInPage extends HookConsumerWidget {
  const SignInPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<Option<Either<AuthFailure, Unit>>>(
        signInFormNotifierProvider.select(
          (state) => state.failureOrSuccessOption,
        ),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                    (failure) => AlertHelper.showSnackBar(
                          context,
                          message: failure.map(
                            passwordWrong: (_) => 'password Salah',
                            passwordExpired: (_) => 'password Expired',
                            noConnection: (_) => 'tidak ada koneksi',
                            server: (value) => value.message ?? 'Server error',
                            storage: (_) =>
                                'Mohon maaf Storage Anda penuh. Mohon luangkan storage agar bisa menyimpan data user.',
                          ),
                        ), (_) async {
                  final imeiNotifier = ref.read(imeiNotifierProvider.notifier);
                  final user = await ref
                      .read(userNotifierProvider.notifier)
                      .getUserString();

                  final imei = await imeiNotifier.getImeiStringFromServer(
                    idKary: user.IdKary ?? '-',
                  );
                  final savedImei =
                      await imeiNotifier.getImeiStringFromStorage();

                  final imeiAuthState = imei.isEmpty
                      ? ImeiAuthState.empty()
                      : ImeiAuthState.registered();

                  return imeiNotifier.processImei(
                    imei: imei,
                    nama: user.nama ?? '-',
                    savedImei: savedImei,
                    imeiAuthState: imeiAuthState,
                  );
                })));

    ref.listen<AsyncValue<ImeiState>>(imeiNotifierProvider, (_, state) {
      final imeiNotifier = ref.read(imeiNotifierProvider.notifier);

      final idKary = ref.read(userNotifierProvider).user.IdKary ?? '-';
      final generateImei = imeiNotifier.generateImei();

      if (!state.isLoading &&
          state.hasValue &&
          state.value != '' &&
          state.value != null &&
          state.hasError == false) {
        state.requireValue.maybeWhen(
          alreadyRegistered: () async {
            await imeiNotifier.onImeiAlreadyRegistered(
              idKary: idKary,
            );

            return showErrorDialog(
              context,
              Constants.imeiAlreadyRegistered,
            ).then(
              (_) => logout(ref),
            );
          },
          notRegistered: () async {
            await imeiNotifier.registerImei(
              imei: generateImei,
              idKary: idKary,
            );

            return showSuccessDialog(context).then(
              (_) => login(ref),
            );
          },
          ok: () => login(ref),
          initial: () => login(ref),
          rejected: () => logout(ref),
          orElse: () {},
        );
      } else {
        if (state.hasError) state.showAlertDialogOnError(context, ref);
      }
    });

    final ip = ref.watch(ipNotifierProvider);
    final unlink = ref.watch(unlinkNotifierProvider);

    final isSubmitting = ref.watch(
      signInFormNotifierProvider.select((state) => state.isSubmitting),
    );

    final _serverSelected = ref.watch(signInFormNotifierProvider.select(
      (value) => value.ptServerSelected.getOrLeave(''),
    ));

    final imei = ref.watch(imeiNotifierProvider);

    return SafeArea(
      child: VAsyncWidgetScaffold(
        value: ip,
        data: (_) => VAsyncValueWidget<String?>(
          value: unlink,
          data: (date) => date == null
              ? VAsyncValueWidget<ImeiState>(
                  value: imei,
                  data: (p0) => Stack(
                    children: [
                      const SignInScaffold(),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: VButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              await ref
                                  .read(signInFormNotifierProvider.notifier)
                                  .signInAndRemember(
                                    init: () => _initSignIn(ref),
                                    remember: () => ref
                                        .read(
                                            signInFormNotifierProvider.notifier)
                                        .rememberInfo(),
                                    clearSaved: () => ref
                                        .read(
                                            signInFormNotifierProvider.notifier)
                                        .clearInfo(),
                                    showDialogAndLogout: () =>
                                        _showDialogAndLogout(context, ref),
                                    signIn: () => _serverSelected == 'gs_18'
                                        ? ref
                                            .read(signInFormNotifierProvider
                                                .notifier)
                                            .signInWithUserIdEmailAndPasswordARV()
                                        : ref
                                            .read(signInFormNotifierProvider
                                                .notifier)
                                            .signInWithUserIdEmailAndPasswordACT(),
                                  );
                            },
                            label:
                                'LOGIN ${Constants.isDev ? '(APK TESTING)' : ''}',
                          )),
                      LoadingOverlay(isLoading: isSubmitting),
                    ],
                  ),
                )
              : Scaffold(
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Anda Telah Unlink Pada ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(date))}.\n\nMohon Uninstall dan Install kembali Aplikasi dari Play Store / App Store.',
                        style: Themes.customColor(
                          12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _showDialogAndLogout(BuildContext context, WidgetRef ref) {
    return showDialog(
        context: context,
        builder: (context) => VSimpleDialog(
              label: 'Error',
              labelDescription:
                  'Mohon maaf storage anda penuh sehingga Aplikasi gagal menyimpan data user. Mohon luangkan storage dan dicoba login kembali',
              asset: Assets.iconCrossed,
            )).then(
      (_) => ref.read(userNotifierProvider.notifier).logout(),
    );
  }

  _initSignIn(WidgetRef ref) {
    final _signIn = ref.read(signInFormNotifierProvider);

    final server = _signIn.ptServerSelected.getOrLeave('');
    final username = _signIn.userId.getOrLeave('');
    final password = _signIn.password.getOrLeave('');

    ref.read(dioRequestProvider).addAll({
      "server": server,
      "username": username,
      "password": password,
    });
  }

  Future<void> showSuccessDialog(BuildContext context) => showDialog(
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
              asset: Assets.iconCrossed,
            ),
          ));

  Future<void> showErrorDialog(
    BuildContext context,
    String message,
  ) =>
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => VSimpleDialog(
          label: 'Oops',
          color: Palette.red,
          labelDescription: message,
          asset: Assets.iconCrossed,
        ),
      );

  logout(WidgetRef ref) async {
    await ref.read(userNotifierProvider.notifier).logout();
    await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
  }

  login(WidgetRef ref) async {
    await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
    await ref.read(tcNotifierProvider.notifier).checkAndUpdateStatusTC();
    await ref
        .read(imeiIntroNotifierProvider.notifier)
        .checkAndUpdateImeiIntro();
  }
}
