import 'package:dartz/dartz.dart';
import 'package:face_net_authentication/pages/widgets/loading_overlay.dart';
import 'package:face_net_authentication/shared/providers.dart';

import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/background_service/saved_location.dart';
import '../../domain/background_failure.dart';
import '../widgets/alert_helper.dart';
import 'background_scaffold.dart';

class BackgroundPage extends ConsumerWidget {
  const BackgroundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      ),
                  (savedLocations) => ref
                      .read(backgroundNotifierProvider.notifier)
                      .processSavedLocations(
                        locations: savedLocations,
                        getAbsenSaved: ({required date, required onAbsen}) =>
                            ref
                                .read(absenNotifierProvidier.notifier)
                                .getAbsenSaved(date: date, onAbsen: onAbsen),
                        onProcessed: ({required items}) => ref
                            .read(backgroundNotifierProvider.notifier)
                            .changeBackgroundItems(items),
                      )),
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
