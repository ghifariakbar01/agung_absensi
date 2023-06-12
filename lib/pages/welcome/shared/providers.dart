import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../application/permission_notifier.dart';
import '../application/permission_state.dart';

final permissionProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>(
        (ref) => PermissionNotifier());
