import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/presentation/widgets/loading_overlay.dart';
import '../../style/style.dart';
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
          child: TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              // ref
              //     .read(signInFormNotifierProvider.notifier)
              //     .signInWithEmailAndPassword();
            },
            child: Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Palette.primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  'SIMPAN',
                  style: Themes.blueSpaced(
                    FontWeight.bold,
                    16,
                  ),
                ),
              ),
            ),
          ),
        ),
        LoadingOverlay(isLoading: false),
      ],
    );
  }
}
