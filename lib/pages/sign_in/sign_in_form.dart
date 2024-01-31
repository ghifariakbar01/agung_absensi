import 'dart:convert';

import 'package:face_net_authentication/application/remember_me/remember_me_state.dart';
import 'package:face_net_authentication/ip/application/ip_notifier.dart';
import 'package:face_net_authentication/pages/profile/widgets/profile_label.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../style/style.dart';
import '../../shared/providers.dart';
import '../tc/tc_page.dart';

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
      ref.read(passwordVisibleProvider.notifier).state = false;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getString('remember_me');

      if (rememberMe != null) {
        final saved = RememberMeModel.fromJson(jsonDecode(rememberMe));
        final savedPt = saved.ptName;

        ref.read(signInFormNotifierProvider.notifier).changeAllData(
              isChecked: true,
              ptNameStr: savedPt,
              userStr: saved.nama,
              idKaryawanStr: saved.nik,
              passwordStr: saved.password,
              isKaryawan: saved.isKaryawan,
            );

        if (savedPt.isNotEmpty) {
          ref
              .read(signInFormNotifierProvider.notifier)
              .changeInitializeNamaPT(namaPT: savedPt);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final passwordVisible = ref.watch(passwordVisibleProvider);

    final signInForm = ref.watch(signInFormNotifierProvider);

    final userId = signInForm.userId.getOrLeave('');
    final password = signInForm.password.getOrLeave('');

    final ptDropdownSelected = signInForm.ptDropdownSelected;

    return Form(
      autovalidateMode: signInForm.showErrorMessages
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      child: Column(
        children: [
          ProfileLabel(icon: Icons.business, label: 'PT'),
          SizedBox(
            height: 4,
          ),
          DropdownButtonFormField<String>(
            value: ptDropdownSelected,
            elevation: 16,
            iconSize: 20,
            icon: const Icon(Icons.arrow_downward),
            decoration: Themes.formStyle('Masukkan PT'),
            // style: const TextStyle(color: Palette.primaryColor),
            onChanged: (String? value) => ref
                .read(signInFormNotifierProvider)
                .ptMap
                .forEach((serverName, ptNameStrList) {
              for (final ptNameStr in ptNameStrList) {
                if (value == ptNameStr && value != null) {
                  ref.read(ipNotifierProvider.notifier).initOnLogin(value);
                  ref
                      .read(signInFormNotifierProvider.notifier)
                      .changePTNameAndDropdown(
                        changePTName: () => ref
                            .read(signInFormNotifierProvider.notifier)
                            .changePTName(serverName),
                        changeDropdownSelected: () => ref
                            .read(signInFormNotifierProvider.notifier)
                            .changeDropdownSelected(value),
                      );
                }
              }
            }),
            items: signInForm.ptDropdownList
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: Themes.customColor(
                    12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ProfileLabel(icon: Icons.person, label: 'Username'),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            initialValue: signInForm.userId.getOrLeave(''),
            decoration: Themes.formStyle(
              userId != ''
                  ? userId + ' (ketik untuk ubah teks)'
                  : 'Masukkan username',
            ),
            style: Themes.customColor(
              14,
              fontWeight: FontWeight.normal,
            ),
            cursorColor: Palette.primaryColor,
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
            style: Themes.customColor(
              14,
              fontWeight: FontWeight.normal,
            ),
            cursorColor: Palette.primaryColor,
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
                  checkColor: Theme.of(context).primaryColorLight,
                  fillColor: MaterialStateProperty.resolveWith(
                      (state) => getColor(state, context)),
                  value: signInForm.isKaryawan,
                  onChanged: (_) => ref
                      .read(signInFormNotifierProvider.notifier)
                      .changeIsKaryawan(toggleBool(signInForm.isKaryawan))),
              SizedBox(
                width: 4,
              ),
              Text(
                'Saya Karyawan dengan Jadwal Shift',
                style: Themes.customColor(
                  14,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  bool toggleBool(bool visibility) {
    return visibility ? false : true;
  }
}
