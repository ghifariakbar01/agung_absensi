import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../style/style.dart';

class ChangePassForm extends HookConsumerWidget {
  const ChangePassForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showErrorMessages = false;

    return Form(
      autovalidateMode: showErrorMessages
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: Column(
        children: [
          TextFormField(
              decoration: Themes.formStyle('Masukkan password'),
              obscureText: true,
              onChanged: (value) => {},
              validator: (_) => ''),
          const SizedBox(height: 8),
          TextFormField(
              decoration: Themes.formStyle('Konfirm password'),
              obscureText: true,
              onChanged: (value) => {},
              validator: (_) => ''),
        ],
      ),
    );
  }
}
