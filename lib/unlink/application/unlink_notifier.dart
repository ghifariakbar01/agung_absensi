import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infrastructures/cache_storage/unlink_storage.dart';
import '../../shared/providers.dart';
import '../infrastructures/unlink_repository.dart';

part 'unlink_notifier.g.dart';

@Riverpod(keepAlive: true)
UnlinkSecureStorage unlinkSecureStorage(UnlinkSecureStorageRef ref) {
  return UnlinkSecureStorage(ref.watch(flutterSecureStorageProvider));
}

@Riverpod(keepAlive: true)
UnlinkRepository unlinkRepository(UnlinkRepositoryRef ref) {
  return UnlinkRepository(ref.watch(unlinkSecureStorageProvider));
}

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
