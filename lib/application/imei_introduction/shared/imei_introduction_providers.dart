import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../infrastructure/cache_storage/imei_intro_storage.dart';
import '../../../infrastructure/credentials_storage/credentials_storage.dart';

import '../../../shared/providers.dart';
import '../imei_introduction_notifier.dart';
import '../imei_introduction_repository.dart';
import '../imei_state.dart';

final imeiIntroductionStorageProvider = Provider<CredentialsStorage>(
  (ref) => ImeiIntroductionStorage(ref.watch(flutterSecureStorageProvider)),
);

final imeiIntroductionRepositoryProvider = Provider((ref) =>
    ImeiIntroductionRepository(ref.watch(imeiIntroductionStorageProvider)));

final imeiIntroductionNotifierProvider =
    StateNotifierProvider<ImeiIntroductionNotifier, ImeiIntroductionState>(
        (ref) => ImeiIntroductionNotifier(
            ref.watch(imeiIntroductionRepositoryProvider)));
