import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/permission/shared/permission_introduction_providers.dart';
import '../widgets/loading_overlay.dart';
import 'permission_scaffold.dart';

class PermissionPage extends HookConsumerWidget {
  const PermissionPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(testerNotifierProvider.notifier)
          .checkAndUpdateTesterState();

      final testerState = ref.read(testerNotifierProvider);

      testerState.maybeWhen(
          tester: () =>
              ref.read(permissionNotifierProvider.notifier).letYouThrough(),
          orElse: () {});
    });

    return Stack(
      children: const [
        PermissionScaffold(),
        LoadingOverlay(isLoading: false),
      ],
    );
  }
}
