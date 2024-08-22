import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../infrastructures/credentials_storage/credentials_storage.dart';
import '../../../shared/providers.dart';
import '../infrastructures/theme_repository.dart';
import '../infrastructures/theme_storage.dart';

part 'theme_notifier.g.dart';

final themeStorage = Provider<CredentialsStorage>(
  (ref) => ThemeStorage(ref.watch(flutterSecureStorageProvider)),
);

@Riverpod(keepAlive: true)
ThemeRepository themeRepository(ThemeRepositoryRef ref) {
  return ThemeRepository(
    ref.watch(themeStorage),
  );
}

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  FutureOr<String> build() async {
    final repo = ref.read(themeRepositoryProvider);

    return await repo.getTheme() ?? '';
  }

  Future<void> getCurrentTheme() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
        () async => await ref.read(themeRepositoryProvider).getTheme() ?? '');
  }
}

@riverpod
class ThemeController extends _$ThemeController {
  @override
  FutureOr<void> build() {}

  Future<void> saveTheme(String mode) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(
        () async => await ref.read(themeRepositoryProvider).saveTheme(mode));
  }
}
