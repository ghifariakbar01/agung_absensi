import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/application/background_service/recent_absen_state.dart';
import 'package:face_net_authentication/application/background_service/saved_location.dart';
import 'package:face_net_authentication/domain/auto_absen_failure.dart';
import 'package:face_net_authentication/pages/absen_log/absen_log_scaffold.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/alert_helper.dart';

class AbsenLogPage extends ConsumerStatefulWidget {
  const AbsenLogPage();

  @override
  ConsumerState<AbsenLogPage> createState() => _AbsenLogPageState();
}

class _AbsenLogPageState extends ConsumerState<AbsenLogPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async =>
        await ref.read(autoAbsenNotifierProvider.notifier).getRecentAbsen());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Option<Either<AutoAbsenFailure, List<RecentAbsenState>>>>(
        autoAbsenNotifierProvider.select(
          (state) => state.failureOrSuccessOptionRecentAbsen,
        ),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
                    (failure) => AlertHelper.showSnackBar(
                          context,
                          message: failure.maybeMap(
                            storage: (_) => 'storage penuh',
                            orElse: () => '',
                          ),
                        ), (recentAbsens) {
                  debugger(message: 'called');

                  log('recentAbsens $recentAbsens');
                  ref
                      .read(autoAbsenNotifierProvider.notifier)
                      .changeRecentAbsen(recentAbsens);
                })));

    return Stack(
      children: [AbsenLogScaffold(), LoadingOverlay(isLoading: false)],
    );
  }
}
