import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../profile/presentation/widgets/profile_label.dart';
import '../../../shared/providers.dart';
import '../../../style/style.dart';

class EditProfileForm extends ConsumerWidget {
  const EditProfileForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider.select((value) => value.user));

    final showErrorMessages = ref.watch(
      editProfileNotifierProvider.select((state) => state.showErrorMessages),
    );

    return Form(
      autovalidateMode: showErrorMessages
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: Column(
        children: [
          ProfileLabel(
            icon: Icons.email,
            label: 'Email 1',
          ),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            // decoration: Themes.formStyle('Masukkan email'),
            style: Themes.customColor(
              15,
              fontWeight: FontWeight.w500,
            ),
            keyboardType: TextInputType.emailAddress,
            initialValue: user.email,
            onChanged: (value) => ref
                .read(editProfileNotifierProvider.notifier)
                .changeEmail1(value),
            validator: (_) =>
                ref.read(editProfileNotifierProvider).email1.value.fold(
                      (f) => f.maybeMap(
                        invalidEmail: (_) => 'email invalid',
                        empty: (_) => 'kosong',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
          ),
          const SizedBox(height: 16),
          ProfileLabel(
            icon: Icons.email,
            label: 'Email 2',
          ),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            // decoration: Themes.formStyle('Masukkan email 2'),
            style: Themes.customColor(
              15,
              fontWeight: FontWeight.w500,
            ),
            keyboardType: TextInputType.emailAddress,
            initialValue: user.email2,
            onChanged: (value) => ref
                .read(editProfileNotifierProvider.notifier)
                .changeEmail2(value),
            validator: (_) =>
                ref.read(editProfileNotifierProvider).email1.value.fold(
                      (f) => f.maybeMap(
                        invalidEmail: (_) => 'email invalid',
                        empty: (_) => 'kosong',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
          ),
          const SizedBox(height: 16),
          ProfileLabel(
            icon: Icons.numbers,
            label: 'No HP 1',
          ),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            // decoration: Themes.formStyle('Masukkan No. HP 1'),
            style: Themes.customColor(
              15,
              fontWeight: FontWeight.w500,
            ),
            keyboardType: TextInputType.phone,
            initialValue: user.noTelp1,
            onChanged: (value) => ref
                .read(editProfileNotifierProvider.notifier)
                .changePhone1(value),
            validator: (_) =>
                ref.read(editProfileNotifierProvider).telp1.value.fold(
                      (f) => f.maybeMap(
                        invalidNoHP: (_) => 'no hp invalid',
                        empty: (_) => 'kosong',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
          ),
          const SizedBox(height: 16),
          ProfileLabel(
            icon: Icons.numbers,
            label: 'No HP 2',
          ),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            // decoration: Themes.formStyle('Masukkan No. HP 2'),
            style: Themes.customColor(
              15,
              fontWeight: FontWeight.w500,
            ),
            keyboardType: TextInputType.phone,
            initialValue: user.noTelp2,
            onChanged: (value) => ref
                .read(editProfileNotifierProvider.notifier)
                .changePhone2(value),
            validator: (_) =>
                ref.read(editProfileNotifierProvider).telp2.value.fold(
                      (f) => f.maybeMap(
                        invalidNoHP: (_) => 'no hp invalid',
                        empty: (_) => 'kosong',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
