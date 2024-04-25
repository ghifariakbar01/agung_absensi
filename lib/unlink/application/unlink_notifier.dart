import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infrastructure/cache_storage/unlink_storage.dart';
import '../../infrastructure/credentials_storage/credentials_storage.dart';
import '../../shared/providers.dart';
import '../infrastructure/unlink_repository.dart';

part 'unlink_notifier.g.dart';

final unlinkSecureStorageProvider = Provider<CredentialsStorage>(
  (ref) => UnlinkSecureStorage(ref.watch(flutterSecureStorageProvider)),
);

final unlinkRepositoryProvider = Provider((ref) => UnlinkRepository(
      ref.watch(unlinkSecureStorageProvider),
    ));

@riverpod
class UnlinkNotifier extends _$UnlinkNotifier {
  @override
  FutureOr<String?> build() async {
    return ref.read(unlinkRepositoryProvider).getUnlink();
  }

  Future<void> saveUnlink() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(unlinkRepositoryProvider).saveUnlink();
      return ref.read(unlinkRepositoryProvider).getUnlink();
    });
  }
}
