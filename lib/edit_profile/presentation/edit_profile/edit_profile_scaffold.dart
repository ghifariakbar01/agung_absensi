import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/style.dart';
import '../../../widgets/v_button.dart';
import 'edit_profile_form.dart';

class EditProfileScaffold extends ConsumerWidget {
  const EditProfileScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // iconTheme: IconThemeData(color: Palette.primaryColor),
      ),
      floatingActionButton: VButton(
        label: 'SAVE PROFILE',
        onPressed: () => ref
            .read(editProfileNotifierProvider.notifier)
            .submitEdit(
                idKary: ref.read(userNotifierProvider).user.IdKary ?? 'null'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: KeyboardDismissOnTap(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Palette.primaryColor.withOpacity(0.1),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: const EditProfileForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
