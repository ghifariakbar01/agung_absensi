import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/app_logo.dart';
import 'sign_in_form.dart';

class SignInScaffold extends HookConsumerWidget {
  const SignInScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const AppLogo(),
              const SizedBox(height: 58),
              const SignInForm(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
