import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/user_failure.dart';
import '../../shared/providers.dart';
import '../widgets/alert_helper.dart';
import 'welcome_imei_scaffold.dart';

class WelcomeImei extends ConsumerStatefulWidget {
  const WelcomeImei();

  @override
  ConsumerState<WelcomeImei> createState() => _WelcomeImeiState();
}

class _WelcomeImeiState extends ConsumerState<WelcomeImei> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(imeiAuthNotifierProvider.notifier).getImeiCredentials();
      await ref.read(editProfileNotifierProvider.notifier).getImei();
    });

    ref.listen<Option<Either<UserFailure, String?>>>(
      imeiAuthNotifierProvider.select(
        (state) => state.failureOrSuccessOption,
      ),
      (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
              (failure) => AlertHelper.showSnackBar(
                    context,
                    message: failure.map(
                        empty: (_) => 'Installation ID belum ada',
                        errorParsing: (_) => 'Error parsing Installation ID',
                        unknown: (_) => 'Unknown Installation ID error'),
                  ),
              (imei) => ref
                  .read(imeiAuthNotifierProvider.notifier)
                  .changeSavedImei(imei ?? ''))),
    );

    return Column(
      children: [
        WelcomeImeiScaffold(),
        Container(),
      ],
    );
  }
}
