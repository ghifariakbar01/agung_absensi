import 'dart:convert';
import 'dart:developer';

import 'package:face_net_authentication/application/remember_me/remember_me_state.dart';
import 'package:face_net_authentication/pages/profile/widgets/profile_label.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../style/style.dart';
import '../../shared/providers.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm();

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final rememberMe = prefs.getString('remember_me');

      log('rememberMe ${rememberMe != null}');

      if (rememberMe != null) {
        ref.read(signInFormNotifierProvider.notifier).changeRemember(true);

        ref.read(passwordVisibleProvider.notifier).state = false;

        final rememberMeModel =
            RememberMeModel.fromJson(jsonDecode(rememberMe));

        ref.read(signInFormNotifierProvider.notifier).changeAllData(
            idKaryawanStr: rememberMeModel.nik,
            passwordStr: rememberMeModel.password,
            userStr: rememberMeModel.nama);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final signInForm = ref.watch(signInFormNotifierProvider);

    final passwordVisible = ref.watch(passwordVisibleProvider);

    final idKaryawan = signInForm.idKaryawan.getOrLeave('');
    final userId = signInForm.userId.getOrLeave('');
    final password = signInForm.password.getOrLeave('');

    return Form(
      autovalidateMode: signInForm.showErrorMessages
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: Column(
        children: [
          ProfileLabel(icon: Icons.person, label: 'Nomor induk karyawan'),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            initialValue: signInForm.idKaryawan.getOrLeave(''),
            decoration: Themes.formStyle(idKaryawan != ''
                ? idKaryawan + ' (ketik untuk ubah teks)'
                : 'Masukkan nomor induk karyawan'),
            keyboardType: TextInputType.number,
            onChanged: (value) => ref
                .read(signInFormNotifierProvider.notifier)
                .changeIdKaryawan(value),
            validator: (_) =>
                ref.read(signInFormNotifierProvider).idKaryawan.value.fold(
                      (f) => f.maybeMap(
                        invalidIdKaryawan: (_) => 'id karyawan invalid',
                        empty: (_) => 'kosong',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
          ),
          const SizedBox(height: 16),
          ProfileLabel(icon: Icons.person, label: 'Nama / username'),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            initialValue: signInForm.userId.getOrLeave(''),
            decoration: Themes.formStyle(userId != ''
                ? userId + ' (ketik untuk ubah teks)'
                : 'Masukkan user id'),
            keyboardType: TextInputType.name,
            onChanged: (value) => ref
                .read(signInFormNotifierProvider.notifier)
                .changeUserId(value),
            validator: (_) =>
                ref.read(signInFormNotifierProvider).userId.value.fold(
                      (f) => f.maybeMap(
                        empty: (_) => 'kosong',
                        orElse: () => null,
                      ),
                      (_) => null,
                    ),
          ),
          const SizedBox(height: 16),
          ProfileLabel(icon: Icons.lock_rounded, label: 'Password'),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            initialValue: signInForm.password.getOrLeave(''),
            decoration: Themes.formStyle(
              password != ''
                  ? '*password tersimpan*' + ' (ketik untuk ubah teks)'
                  : 'Masukkan password',
              icon: IconButton(
                  onPressed: () => ref
                      .read(passwordVisibleProvider.notifier)
                      .state = toggleBool(passwordVisible),
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Palette.primaryColor,
                  )),
            ),
            obscureText: !passwordVisible,
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
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                  key: UniqueKey(),
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: signInForm.isChecked,
                  onChanged: (_) => ref
                      .read(signInFormNotifierProvider.notifier)
                      .changeRemember(toggleBool(signInForm.isChecked))),
              SizedBox(
                width: 4,
              ),
              Text(
                'Remember Me ? ',
                style: Themes.blue(FontWeight.normal, 14),
              )
            ],
          )
        ],
      ),
    );
  }

  bool toggleBool(bool visibility) {
    return visibility ? false : true;
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Palette.primaryColor;
  }
}
