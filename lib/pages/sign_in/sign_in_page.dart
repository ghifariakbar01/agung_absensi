import 'package:dartz/dartz.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/assets.dart';
import '../../domain/auth_failure.dart';
import '../../shared/providers.dart';
import '../widgets/alert_helper.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/v_button.dart';
import '../widgets/v_dialogs.dart';
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

    return SafeArea(
      child: Stack(
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
                        init: () async {
                          final String server = ref
                              .read(signInFormNotifierProvider)
                              .ptServerSelected
                              .getOrLeave('');
                          final String username = ref
                              .read(signInFormNotifierProvider)
                              .userId
                              .getOrLeave('');
                          final String password = ref
                              .read(signInFormNotifierProvider)
                              .password
                              .getOrLeave('');

                          await Future.delayed(
                              Duration(seconds: 1),
                              () => ref.read(dioRequestProvider).addAll({
                                    "server": server,
                                    "username": username,
                                    "password": password
                                  }));
                        },
                        remember: () => ref
                            .read(signInFormNotifierProvider.notifier)
                            .rememberInfo(),
                        clearSaved: () => ref
                            .read(signInFormNotifierProvider.notifier)
                            .clearInfo(),
                        showDialogAndLogout: () => showDialog(
                            context: context,
                            builder: (context) => VSimpleDialog(
                                  label: 'Error',
                                  labelDescription:
                                      'Mohon maaf storage anda penuh sehingga Aplikasi gagal menyimpan data user. Mohon luangkan storage dan dicoba login kembali',
                                  asset: Assets.iconCrossed,
                                )).then((_) =>
                            ref.read(userNotifierProvider.notifier).logout()),
                        signIn: () => ref
                            .read(signInFormNotifierProvider.notifier)
                            .signInWithUserIdEmailAndPassword(),
                      );
                },
                label: 'LOGIN',
              )),
          LoadingOverlay(isLoading: isSubmitting),
        ],
      ),
    );
  }
}

// final initializeServices =
//     FutureProvider.family<Unit, BuildContext>((ref, context) async {
//   CameraService _cameraService = locator<CameraService>();
//   MLService _mlService = locator<MLService>();
//   FaceDetectorService _mlKitService = locator<FaceDetectorService>();

//   if (_cameraService.cameraController == null) {
//     try {
//       await _cameraService.initialize(context);
//       await _mlService.initialize(context);
//       _mlKitService.initialize();
//     } catch (_) {
//       AlertHelper.showSnackBar(context,
//           message: 'Kamera tidak bisa digunakan.');

//       ref.read(isInitializedProvider.notifier).state = false;
//     }
//   } else {
//     ref.read(isInitializedProvider.notifier).state = true;
//   }

//   return unit;
// });

// final isInitializedProvider = StateProvider<bool>((ref) => true);