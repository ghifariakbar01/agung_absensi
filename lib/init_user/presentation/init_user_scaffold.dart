import 'package:face_net_authentication/widgets/async_value_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../cross_auth/application/cross_auth_notifier.dart';
import '../../cross_auth/application/is_user_crossed.dart';
import '../../err_log/application/err_log_notifier.dart';
import '../../imei_introduction/application/shared/imei_introduction_providers.dart';
import '../../shared/common_widgets.dart';
import '../../shared/future_providers.dart';
import '../../shared/providers.dart';
import '../../tc/application/shared/tc_providers.dart';
import '../../utils/dialog_helper.dart';
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
    ref.listen<AsyncValue>(imeiInitFutureProvider(context), (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    ref.listen<AsyncValue>(errLogControllerProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

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
            body: Stack(children: [
              imeiInitFuture.when(
                data: (_) => LoadingOverlay(
                  isLoading: true,
                  loadingMessage: _isCrossed
                      ? 'Uncrossing User...'
                      : 'Initializing User & Installation ID...',
                ),
                loading: () => Center(
                  child: CommonWidget().lottie(
                    'assets/avatar.json',
                    'Getting User...',
                    _controller,
                  ),
                ),
                error: (error, stackTrace) => ErrorMessageWidget(
                  errorMessage: error.toString(),
                  additionalWidgets: [
                    VButton(
                        label: 'Retry',
                        onPressed: () =>
                            ref.refresh(imeiInitFutureProvider(context))),
                    if (error.toString().toLowerCase().contains('timeout') ==
                        false)
                      VButton(
                          label: 'Logout & Retry',
                          onPressed: () async {
                            return DialogHelper.showConfirmationDialog(
                                context: context,
                                label:
                                    '(PERINGATAN) Jika Tap Ya, anda akan LOGOUT dari E-Finger / ( PERLU INTERNET UNTUK LOGIN ). ',
                                onPressed: () async {
                                  await ref
                                      .read(userNotifierProvider.notifier)
                                      .logout();
                                  await ref
                                      .read(authNotifierProvider.notifier)
                                      .checkAndUpdateAuthStatus();
                                });
                          }),
                  ],
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
