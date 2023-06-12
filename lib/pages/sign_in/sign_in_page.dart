import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/application/routes/route_names.dart';
import '../../core/domain/auth_failure.dart';

import '../../core/presentation/widgets/alert_helper.dart';
import '../../core/presentation/widgets/loading_overlay.dart';
import '../../core/shared/providers.dart';
import '../../locator.dart';
import '../../services/camera.service.dart';
import '../../services/face_detector_service.dart';
import '../../services/ml_service.dart';
import '../../style/style.dart';
import 'sign_in_scaffold.dart';

final initializeServices =
    FutureProvider.family<Unit, BuildContext>((_, context) async {
  CameraService _cameraService = locator<CameraService>();
  MLService _mlService = locator<MLService>();
  FaceDetectorService _mlKitService = locator<FaceDetectorService>();

  if (_cameraService.cameraController == null) {
    try {
      await _cameraService.initialize(context);
      await _mlService.initialize(context);
      _mlKitService.initialize();
    } catch (_) {
      AlertHelper.showSnackBar(context,
          message: 'Kamera tidak bisa digunakan.');
      context.pop();
    }
  }

  return unit;
});

class SignInPage extends HookConsumerWidget {
  const SignInPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(initializeServices(context), (_, __) {});

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
              .read(authNotifierProvider.notifier)
              .checkAndUpdateAuthStatus(),
        ),
      ),
    );

    final isSubmitting = ref.watch(
      signInFormNotifierProvider.select((state) => state.isSubmitting),
    );

    return Stack(
      children: [
        const SignInScaffold(),
        Align(
          alignment: Alignment.bottomCenter,
          child: TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              // ref
              //     .read(signInFormNotifierProvider.notifier)
              //     .signInWithEmailAndPassword();
              context.pushNamed(RouteNames.signUpNameRoute);
            },
            child: Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Palette.primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  'LOGIN',
                  style: Themes.blueSpaced(
                    FontWeight.bold,
                    16,
                  ),
                ),
              ),
            ),
          ),
        ),
        LoadingOverlay(isLoading: isSubmitting),
      ],
    );
  }
}
