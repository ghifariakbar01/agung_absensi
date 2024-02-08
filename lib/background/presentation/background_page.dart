import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/widgets/loading_overlay.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/background_failure.dart';
import '../../widgets/alert_helper.dart';
import '../application/saved_location.dart';
import 'background_scaffold.dart';

class BackgroundPage extends ConsumerStatefulWidget {
  const BackgroundPage({Key? key}) : super(key: key);

  @override
  ConsumerState<BackgroundPage> createState() => _BackgroundPageState();
}

class _BackgroundPageState extends ConsumerState<BackgroundPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async => await ref
        .read(backgroundNotifierProvider.notifier)
        .getSavedLocations());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Option<Either<BackgroundFailure, List<SavedLocation>>>>(
        backgroundNotifierProvider.select(
          (state) => state.failureOrSuccessOption,
        ),
        (_, failureOrSuccessOption) => failureOrSuccessOption.fold(
              () {},
              (either) => either.fold(
                  (failure) => AlertHelper.showSnackBar(
                        context,
                        message: failure.map(
                          empty: (_) => '',
                          unknown: (value) =>
                              'Error ${value.errorCode} ${value.message} ',
                        ),
                      ), (savedLocations) {
                if (savedLocations.isNotEmpty) {
                  // debugger(message: 'called');

                  log('savedLocations $savedLocations');

                  ref
                      .read(backgroundNotifierProvider.notifier)
                      .changeBackgroundItems(savedLocations);
                } else {
                  ref
                      .read(backgroundNotifierProvider.notifier)
                      .changeBackgroundItems([]);
                }
              }),
            ));

    final isLoading = ref.watch(
            backgroundNotifierProvider.select((value) => value.isGetting)) ||
        ref.watch(
            absenAuthNotifierProvidier.select((value) => value.isSubmitting));

    return Stack(
      children: [
        const BackgroundScaffold(),
        LoadingOverlay(isLoading: isLoading)
      ],
    );
  }
}
