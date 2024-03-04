import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/widgets/async_value_ui.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/imei_failure.dart';
import '../../err_log/application/err_log_notifier.dart';
import '../../ip/application/ip_notifier.dart';
import '../../shared/future_providers.dart';
import '../../shared/providers.dart';
import '../../widgets/alert_helper.dart';
import '../../widgets/error_message_widget.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/v_async_widget.dart';
import '../../widgets/v_button.dart';

class InitUserScaffold extends ConsumerStatefulWidget {
  const InitUserScaffold();

  @override
  ConsumerState<InitUserScaffold> createState() => _InitUserScaffoldState();
}

class _InitUserScaffoldState extends ConsumerState<InitUserScaffold> {
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback(
    //     (_) => ref.read(imeiInitFutureProvider(context).future));
  }

  @override
  Widget build(BuildContext context) {
    final imeiInitFuture = ref.watch(imeiInitFutureProvider(context));

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
                      empty: (value) => 'There is a problem with connection',
                    )),
                (_) => ref.read(userNotifierProvider.notifier).logout())));

    final ip = ref.watch(ipNotifierProvider);
    final errLog = ref.watch(errLogControllerProvider);

    return VAsyncWidgetScaffold(
      value: ip,
      data: (_) => VAsyncWidgetScaffold(
        value: errLog,
        data: (_) => Scaffold(
          body: Stack(children: [
            imeiInitFuture.when(
              data: (_) => LoadingOverlay(
                isLoading: true,
                loadingMessage: 'Initializing User & Installation ID...',
              ),
              loading: () => LoadingOverlay(
                  isLoading: true, loadingMessage: 'Getting Data...'),
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
        ),
      ),
    );
  }
}
