import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../cross_auth/application/cross_auth_notifier.dart';
import '../../cross_auth/application/is_user_crossed.dart';
import '../../domain/imei_failure.dart';
import '../../err_log/application/err_log_notifier.dart';
import '../../firebase/remote_config/application/firebase_remote_config_notifier.dart';
import '../../imei_introduction/application/shared/imei_introduction_providers.dart';
import '../../shared/future_providers.dart';
import '../../shared/providers.dart';
import '../../style/style.dart';
import '../../tc/application/shared/tc_providers.dart';
import '../../widgets/alert_helper.dart';
import '../../widgets/error_message_widget.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/v_async_widget.dart';
import '../../widgets/v_button.dart';

class InitUserScaffold extends StatefulHookConsumerWidget {
  const InitUserScaffold();

  @override
  ConsumerState<InitUserScaffold> createState() => _InitUserScaffoldState();
}

class _InitUserScaffoldState extends ConsumerState<InitUserScaffold> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authNotifierProvider.notifier).checkAndUpdateAuthStatus();
      await ref.read(tcNotifierProvider.notifier).checkAndUpdateStatusTC();
      await ref
          .read(imeiIntroNotifierProvider.notifier)
          .checkAndUpdateImeiIntro();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<IsUserCrossedState>>(isUserCrossedProvider,
        (__, state) async {
      if (!state.isLoading &&
          state.hasValue &&
          state.value != null &&
          state.hasError == false) {
        await _uncross(state);
      }

      return state.showAlertDialogOnError(context, ref);
    });

    ref.listen<AsyncValue>(imeiInitFutureProvider(context), (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    ref.listen<AsyncValue>(errLogControllerProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    ref.listen<Option<Either<ImeiFailure, Unit?>>>(
        imeiResetNotifierProvider
            .select((value) => value.failureOrSuccessOption),
        (_, foso) => foso.fold(
            () {},
            (either) => either.fold(
                    (l) => AlertHelper.showSnackBar(context,
                        message: l.map(
                          unknown: (value) => 'Error Unknown',
                          errorParsing: (value) => 'Error Parsing $value',
                          storage: (value) => 'There is a problem with storage',
                          empty: (value) =>
                              'There is a problem with connection',
                        )), (_) async {
                  await ref.read(userNotifierProvider.notifier).logout();
                  await ref
                      .read(authNotifierProvider.notifier)
                      .checkAndUpdateAuthStatus();
                })));

    final errLog = ref.watch(errLogControllerProvider);
    final _isUserCrossed = ref.watch(isUserCrossedProvider);

    final imeiInitFuture = ref.watch(imeiInitFutureProvider(context));

    final _controller = useAnimationController();

    return VAsyncWidgetScaffold(
      value: errLog,
      data: (_) => VAsyncWidgetScaffold<IsUserCrossedState>(
        value: _isUserCrossed,
        data: (data) {
          final _isCrossed = data.when(
            crossed: () => true,
            notCrossed: () => false,
          );

          return Scaffold(
            body: Stack(
                //
                children: [
                  imeiInitFuture.when(
                    data: (_) => LoadingOverlay(
                      isLoading: true,
                      loadingMessage: _isCrossed
                          ? 'Uncrossing User...'
                          : 'Initializing User & Installation ID...',
                    ),
                    loading: () => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/avatar.json',
                          controller: _controller,
                          onLoaded: (composition) {
                            _controller
                              ..duration = composition.duration
                              ..forward()
                              ..repeat();
                          },
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Getting User...',
                          style: Themes.customColor(
                            20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    error: (error, stackTrace) => ErrorMessageWidget(
                      errorMessage: error.toString(),
                      additionalWidgets: [
                        VButton(
                            label: 'Logout & Retry',
                            onPressed: () => ref
                                .read(imeiResetNotifierProvider.notifier)
                                .clearImeiFromStorage())
                      ],
                    ),
                  ),
                ]),
          );
        },
      ),
    );
  }

  Future<void> _uncross(AsyncValue<IsUserCrossedState> state) async {
    final user = ref.read(userNotifierProvider).user;
    final _data = state.requireValue;

    final _isCrossed = _data.when(
      crossed: () => true,
      notCrossed: () => false,
    );

    final _ptMap = await ref
        .read(firebaseRemoteConfigNotifierProvider.notifier)
        .getPtMap();

    if (_isCrossed) {
      await ref.read(crossAuthNotifierProvider.notifier).uncross(
            url: _ptMap,
            userId: user.nama!,
            password: user.password!,
          );
    }
  }
}
