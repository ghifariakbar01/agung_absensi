import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../style/style.dart';
import '../../core/shared/providers.dart';

class SignInForm extends HookConsumerWidget {
  const SignInForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showErrorMessages = ref.watch(
      signInFormNotifierProvider.select((state) => state.showErrorMessages),
    );

    return Form(
      autovalidateMode: showErrorMessages
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: Column(
        children: [
          TextFormField(
            decoration: Themes.formStyle('Masukkan nama / username'),
            keyboardType: TextInputType.name,
            onChanged: (value) => ref
                .read(signInFormNotifierProvider.notifier)
                .changeEmail(value),
            validator: (_) =>
                ref.read(signInFormNotifierProvider).email.value.fold(
                      (f) => f.maybeMap(
                        invalidEmail: (_) => 'invalid email',
                        empty: (_) => 'kosong',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            decoration: Themes.formStyle('Masukkan password'),
            obscureText: true,
            onChanged: (value) => ref
                .read(signInFormNotifierProvider.notifier)
                .changePassword(value),
            validator: (_) =>
                ref.read(signInFormNotifierProvider).password.value.fold(
                      (f) => f.maybeMap(
                        shortPassword: (_) => 'terlalu pendek',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
          ),
        ],
      ),
    );
  }
}
