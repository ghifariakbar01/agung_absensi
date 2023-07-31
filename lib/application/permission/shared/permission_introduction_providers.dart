import 'package:face_net_authentication/application/permission/permission_notifier.dart';
import 'package:face_net_authentication/application/permission/permission_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// UNUSED
// final permissionStorageProvider = Provider<CredentialsStorage>(
//   (ref) => PermissionStorage(ref.watch(flutterSecureStorageProvider)),
// );

// final permissionRepositoryProvider = Provider(
//     (ref) => PermissionRepository(ref.watch(permissionStorageProvider)));

final permissionNotifierProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>(
        (ref) => PermissionNotifier());
