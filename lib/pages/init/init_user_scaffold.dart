import 'package:dartz/dartz.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/imei_introduction/shared/imei_introduction_providers.dart';
import '../../application/imei_introduction/imei_state.dart';
import '../../application/init_user/init_user_status.dart';
import '../../application/tc/shared/tc_providers.dart';
import '../../application/tc/tc_state.dart';
import '../../domain/imei_failure.dart';
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

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ref.read(imeiInitFutureProvider(context).future));
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
                    message: 'Error Clear Imei $l, FOSO: $foso'),
                (_) => ref.read(userNotifierProvider.notifier).logout())));

    return Scaffold(
      body: Stack(children: [
        imeiInitFuture.when(
          data: (_) => LoadingOverlay(
              loadingMessage: 'Initializing User & Installation ID...',
              isLoading: true),
          loading: () => LoadingOverlay(
              loadingMessage: 'Initializing User & Installation ID Loading...',
              isLoading: true),
          error: (error, stackTrace) => ListView(
            children: [
              Text('idKary: ${ref.read(userNotifierProvider).user.idKary}\n' +
                  'Error & Stack Trace : $error $stackTrace'),
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
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }
}
