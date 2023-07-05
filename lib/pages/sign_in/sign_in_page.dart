import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/routes/route_names.dart';

import '../../domain/auth_failure.dart';
import '../../shared/providers.dart';

import '../permission/permission_page.dart';
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
                      ), (_) async {
                final visiitedInstructionPage =
                    await ref.read(imeiIntroductionPreference.future);

                if (visiitedInstructionPage == true) {
                  context.replaceNamed(RouteNames.welcomeNameRoute);
                } else {
                  context.replaceNamed(RouteNames.imeiInstructionNameRoute);
                }
              }),
            ));

    final isSubmitting = ref.watch(
      signInFormNotifierProvider.select((state) => state.isSubmitting),
    );

    return Stack(
      children: [
        const SignInScaffold(),
        Align(
            alignment: Alignment.bottomCenter,
            child: VButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                ref.read(signInFormNotifierProvider.notifier).signInAndRemember(
                    signIn: () => ref
                        .read(signInFormNotifierProvider.notifier)
                        .signInWithUserIdEmailAndPassword(),
                    remember: () => ref
                        .read(signInFormNotifierProvider.notifier)
                        .rememberInfo(),
                    clear: () => ref
                        .read(signInFormNotifierProvider.notifier)
                        .clearInfo());
              },
              label: 'LOGIN',
            )),
        LoadingOverlay(isLoading: isSubmitting),
      ],
    );
  }
}
