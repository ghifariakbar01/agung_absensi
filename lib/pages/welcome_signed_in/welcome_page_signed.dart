import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/presentation/widgets/loading_overlay.dart';
import '../../style/style.dart';
import 'welome_scaffold_signed.dart';

class WelcomePageSigned extends HookConsumerWidget {
  const WelcomePageSigned();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        WelcomeScaffoldSigned(),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Center(
              child: TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'ganti akun',
              style: Themes.blackItalic(),
            ),
          )),
        ),
        LoadingOverlay(isLoading: false),
      ],
    );
  }
}
