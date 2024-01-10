import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/err_log/application/err_log_notifier.dart';
import 'package:face_net_authentication/pages/widgets/async_value_ui.dart';
import 'package:face_net_authentication/pages/widgets/v_async_widget.dart';
import 'package:face_net_authentication/style/style.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/imei_failure.dart';
import '../../ip/application/ip_notifier.dart';
import '../../shared/future_providers.dart';
import '../../shared/providers.dart';
import '../widgets/alert_helper.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/v_button.dart';

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

    ref.listen<AsyncValue>(imeiInitFutureProvider(context), (_, state) {
      state.showAlertDialogOnError(context);
    });

    ref.listen<AsyncValue>(errLogControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    final ip = ref.watch(ipNotifierProvider);
    final errLog = ref.watch(errLogControllerProvider);

    return AsyncValueWidget(
      value: ip,
      data: (_) => AsyncValueWidget(
        value: errLog,
        data: (_) => Scaffold(
          body: Stack(children: [
            imeiInitFuture.when(
              data: (_) => LoadingOverlay(
                  loadingMessage: 'Initializing User & Installation ID...',
                  isLoading: true),
              loading: () => LoadingOverlay(
                  loadingMessage: 'Getting Data...', isLoading: true),
              error: (error, stackTrace) => ListView(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.error,
                        size: 50,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Center(
                      child: Text(
                    'Oops. Something Went Wrong.',
                    style: Themes.customColor(
                      FontWeight.bold,
                      18,
                    ),
                  )),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Palette.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Theme(
                        data: ThemeData(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          iconColor: Colors.black,
                          collapsedIconColor: Colors.black,
                          title: Text(
                            'Display Error',
                            style: Themes.customColor(
                              FontWeight.bold,
                              14,
                            ),
                          ),
                          subtitle: Text(
                            'Error & Stack Trace',
                            style: Themes.customColor(
                              FontWeight.bold,
                              14,
                            ),
                          ),
                          children: [
                            Text(
                              'idKary: ${ref.read(userNotifierProvider).user.idKary}\n '
                              'Error: $error \n'
                              'StackTrace: $stackTrace \n',
                              style: Themes.customColor(
                                FontWeight.normal,
                                12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  VButton(
                      label: 'Logout & Retry',
                      onPressed: () => ref
                          .read(imeiResetNotifierProvider.notifier)
                          .clearImeiFromStorage())
                ],
              ),
            ),
            //
          ]),
          // backgroundColor: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}
