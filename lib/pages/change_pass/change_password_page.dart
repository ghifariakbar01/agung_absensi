import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/loading_overlay.dart';
import '../widgets/v_button.dart';
import 'change_pass_scaffold.dart';

class ChangePasswordPage extends HookConsumerWidget {
  const ChangePasswordPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //

    // final isSubmitting = ref.watch(
    //   signInFormNotifierProvider.select((state) => state.isSubmitting),
    // );

    return Stack(
      children: [
        const ChangePassScaffold(),
        Align(
            alignment: Alignment.bottomCenter,
            child: VButton(
                label: 'SIMPAN', onPressed: () => Focus.of(context).unfocus())),
        LoadingOverlay(isLoading: false),
      ],
    );
  }
}
