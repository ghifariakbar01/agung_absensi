import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/loading_overlay.dart';
import 'permission_scaffold.dart';

class PermissionPage extends HookConsumerWidget {
  const PermissionPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: const [
        PermissionScaffold(),
        LoadingOverlay(isLoading: false),
      ],
    );
  }
}
