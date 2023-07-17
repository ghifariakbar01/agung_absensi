import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application/routes/route_names.dart';
import '../../domain/auth_failure.dart';
import '../../shared/providers.dart';
import '../widgets/alert_helper.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/v_button.dart';
import 'sign_in_scaffold.dart';

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
                      storage: (_) => 'storage penuh',
                      server: (value) => value.message ?? 'server error',
                      noConnection: (_) => 'tidak ada koneksi',
                    ),
                  ),
                  (_) => ref
                      .read(signInFormNotifierProvider.notifier)
                      .initializeAndRedirect(
                        initializeSavedLocations: () => ref
                            .read(backgroundNotifierProvider.notifier)
                            .getSavedLocations(),
                        initializeGeofenceList: () => ref
                            .read(geofenceProvider.notifier)
                            .getGeofenceList(),
                        redirect: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          final introduction =
                              prefs.getBool('imei_introduction');

                          if (introduction != null && introduction == true) {
                            context.replaceNamed(RouteNames.welcomeNameRoute);
                          } else {
                            context.replaceNamed(
                                RouteNames.imeiInstructionNameRoute,
                                extra: true);
                          }
                        },
                      ),
                )));

    final isSubmitting = ref.watch(
      signInFormNotifierProvider.select((state) => state.isSubmitting),
    );

    return Stack(
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
                      signIn: () => ref
                          .read(signInFormNotifierProvider.notifier)
                          .signInWithUserIdEmailAndPassword(),
                      remember: () => ref
                          .read(signInFormNotifierProvider.notifier)
                          .rememberInfo(),
                      clear: () => ref
                          .read(signInFormNotifierProvider.notifier)
                          .clearInfo(),
                    );
              },
              label: 'LOGIN',
            )),
        LoadingOverlay(isLoading: isSubmitting),
      ],
    );
  }
}
