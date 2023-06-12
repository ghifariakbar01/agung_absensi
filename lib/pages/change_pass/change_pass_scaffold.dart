import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/presentation/widgets/app_bar.dart';

import '../welcome/presentation/widget/app_logo.dart';
import 'change_pass_form.dart';

class ChangePassScaffold extends HookConsumerWidget {
  const ChangePassScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const AppLogo(),
            const SizedBox(height: 58),
            const ChangePassForm(),
            const SizedBox(height: 8),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
