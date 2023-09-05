import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/imei_failure.dart';
import '../../../shared/providers.dart';
import 'home_imei_scaffold.dart';

class HomeImei extends ConsumerStatefulWidget {
  const HomeImei();

  @override
  ConsumerState<HomeImei> createState() => _HomeImeiState();
}

class _HomeImeiState extends ConsumerState<HomeImei> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(imeiAuthNotifierProvider.notifier).getImeiCredentials();
      await ref.read(editProfileNotifierProvider.notifier).getImei();
    });

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

    return Column(
      children: [
        HomeImeiScaffold(),
        Container(),
      ],
    );
  }
}
