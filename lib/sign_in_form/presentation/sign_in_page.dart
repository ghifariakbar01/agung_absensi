import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/ip/application/ip_notifier.dart';
import 'package:face_net_authentication/tc/application/shared/tc_providers.dart';
import 'package:face_net_authentication/unlink/application/unlink_notifier.dart';
import 'package:face_net_authentication/widgets/v_async_widget.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../constants/assets.dart';
import '../../domain/auth_failure.dart';
import '../../imei_introduction/application/shared/imei_introduction_providers.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';
import '../../widgets/alert_helper.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/v_button.dart';
import '../../widgets/v_dialogs.dart';
import 'sign_in_scaffold.dart';

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
                        passwordWrong: (_) => 'Password Salah',
                        passwordExpired: (_) => 'Password Expired',
                        noConnection: (_) => 'tidak ada koneksi',
                        server: (value) => value.message ?? 'server error',
                        storage: (_) =>
                            'Mohon maaf Storage Anda penuh. Mohon luangkan storage agar bisa menyimpan data user.',
                      ),
                    ),
                (_) => ref
                    .read(signInFormNotifierProvider.notifier)
                    .initializeAndRedirect(
                      initializeSavedLocations: () => ref
                          .read(backgroundNotifierProvider.notifier)
                          .getSavedLocations(),
                      initializeGeofenceList: () =>
                          ref.read(geofenceProvider.notifier).getGeofenceList(),
                      redirect: () => ref
                          .read(authNotifierProvider.notifier)
                          .checkAndUpdateAuthStatus(),
                    ))));

    final isSubmitting = ref.watch(
      signInFormNotifierProvider.select((state) => state.isSubmitting),
    );

    final _tc = ref.watch(tcNotifierProvider);
    final _imei = ref.watch(imeiIntroNotifierProvider);
    final _hasVisitedScreens =
        (_tc.maybeWhen(orElse: () => false, visited: () => true) &&
            _imei.maybeWhen(orElse: () => false, visited: () => true));

    final ip = ref.watch(ipNotifierProvider);
    final unlink = ref.watch(unlinkNotifierProvider);

    return VAsyncWidgetScaffold(
      value: ip,
      data: (_) => SafeArea(
          child: VAsyncValueWidget<String?>(
        value: unlink,
        data: (date) => date == null
            ? Stack(
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
                                    .read(signInFormNotifierProvider.notifier)
                                    .rememberInfo(),
                                clearSaved: () => ref
                                    .read(signInFormNotifierProvider.notifier)
                                    .clearInfo(),
                                showDialogAndLogout: () =>
                                    _showDialogAndLogout(context, ref),
                                signIn: () => ref
                                    .read(signInFormNotifierProvider.notifier)
                                    .signInWithUserIdEmailAndPasswordACT(),
                                onSuccessLoginAfterRemember: () => ref
                                    .read(authNotifierProvider.notifier)
                                    .checkAndUpdateAuthStatus(),
                              );
                        },
                        label: 'LOGIN (APK TESTING)',
                      )),
                  LoadingOverlay(isLoading: isSubmitting || _hasVisitedScreens),
                ],
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
      )),
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
            )).then((_) => ref.read(userNotifierProvider.notifier).logout());
  }

  _initSignIn(WidgetRef ref) {
    String server =
        ref.read(signInFormNotifierProvider).ptServerSelected.getOrLeave('');
    String username =
        ref.read(signInFormNotifierProvider).userId.getOrLeave('');
    String password =
        ref.read(signInFormNotifierProvider).password.getOrLeave('');

    ref
        .read(dioRequestProvider)
        .addAll({"server": server, "username": username, "password": password});
  }
}
