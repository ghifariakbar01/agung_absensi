import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../../style/style.dart';
import '../widgets/app_logo.dart';
import 'sign_in_form.dart';

class SignInScaffold extends HookConsumerWidget {
  const SignInScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPasswordExpired = ref.watch(passwordExpiredNotifierStatusProvider);

    return KeyboardDismissOnTap(
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const AppLogo(),
              isPasswordExpired.maybeWhen(
                  expired: () => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Password Anda expired. Pastikan Password sudah diubah di E-HRMS dan di unlink oleh staff pihak berwenang.',
                          style: Themes.customColor(
                              FontWeight.bold, 11, Palette.red),
                        ),
                      ),
                  orElse: () => Container()),
              const SizedBox(height: 8),
              const SignInForm(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
