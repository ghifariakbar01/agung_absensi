import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/imei_failure.dart';
import '../../pages/home/imei/home_imei.dart';
import '../../shared/providers.dart';

class InitImeiScaffold extends ConsumerStatefulWidget {
  const InitImeiScaffold();

  @override
  ConsumerState<InitImeiScaffold> createState() => _InitImeiScaffoldState();
}

class _InitImeiScaffoldState extends ConsumerState<InitImeiScaffold> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(imeiNotifierProvider.notifier).checkAndUpdateImei();
      await ref.read(imeiAuthNotifierProvider.notifier).getImeiCredentials();
      await ref.read(editProfileNotifierProvider.notifier).getImei();
    });
  }

  @override
  Widget build(BuildContext context) {
    // GET IMEI STORAGE
    ref.listen<Option<Either<ImeiFailure, String?>>>(
      imeiAuthNotifierProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
              (failure) => (_) => log('imei failure $failure'),
              (imei) => ref
                  .read(imeiAuthNotifierProvider.notifier)
                  .changeSavedImei(imei ?? ''))),
    );

    return Scaffold(
      body: Stack(children: [
        HomeImei(),
        LoadingOverlay(
            loadingMessage: 'Initializing Installation ID...', isLoading: true)
      ]),
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }
}
