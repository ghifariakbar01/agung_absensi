import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/loading_overlay.dart';
import '../application/permission_state.dart';
import '../application/shared/permission_introduction_providers.dart';
import 'permission_scaffold.dart';

class PermissionPage extends ConsumerStatefulWidget {
  const PermissionPage();

  @override
  ConsumerState<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends ConsumerState<PermissionPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ref.read(permissionNotifierProvider.notifier).checkAndUpdateLocation());
  }

  @override
  void didUpdateWidget(covariant PermissionPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ref.read(permissionNotifierProvider.notifier).checkAndUpdateLocation());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<PermissionState>(
        permissionNotifierProvider,
        (_, state) => state.maybeMap(
            completed: (_) => context.pop(), orElse: () => null));

    return Stack(
      children: const [
        PermissionScaffold(),
        LoadingOverlay(isLoading: false),
      ],
    );
  }
}
