import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/presentation/widgets/loading_overlay.dart';

import 'absen_scaffold.dart';

class AbsenPage extends HookConsumerWidget {
  const AbsenPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: const [
        AbsenScaffold(),
        LoadingOverlay(isLoading: false),
      ],
    );
  }
}
