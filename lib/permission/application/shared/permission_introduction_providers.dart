import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../permission_notifier.dart';
import '../permission_state.dart';

// UNUSED
// final permissionStorageProvider = Provider<CredentialsStorage>(
//   (ref) => PermissionStorage(ref.watch(flutterSecureStorageProvider)),
// );

// final permissionRepositoryProvider = Provider(
//     (ref) => PermissionRepository(ref.watch(permissionStorageProvider)));

final permissionNotifierProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>(
        (ref) => PermissionNotifier());
