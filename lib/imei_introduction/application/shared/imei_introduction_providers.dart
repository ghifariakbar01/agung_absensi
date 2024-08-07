import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../infrastructures/cache_storage/imei_intro_storage.dart';

import '../../../shared/providers.dart';
import '../imei_introduction_notifier.dart';
import '../imei_introduction_repository.dart';
import '../imei_state.dart';

part 'imei_introduction_providers.g.dart';

@Riverpod(keepAlive: true)
ImeiIntroductionStorage imeiIntroductionStorage(
    ImeiIntroductionStorageRef ref) {
  return ImeiIntroductionStorage(
    ref.watch(flutterSecureStorageProvider),
  );
}

@Riverpod(keepAlive: true)
ImeiIntroductionRepository imeiIntroductionRepository(
    ImeiIntroductionRepositoryRef ref) {
  return ImeiIntroductionRepository(
    ref.watch(imeiIntroductionStorageProvider),
  );
}

final imeiIntroNotifierProvider =
    StateNotifierProvider<ImeiIntroductionNotifier, ImeiIntroductionState>(
        (ref) => ImeiIntroductionNotifier(
            ref.watch(imeiIntroductionRepositoryProvider)));
