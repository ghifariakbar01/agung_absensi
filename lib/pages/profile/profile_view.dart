import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../../style/style.dart';
import '../widgets/alert_helper.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_item.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.watch(userNotifierProvider);

    final passwordVisible = ref.watch(passwordVisibleProvider);

    return Column(
      children: [
        ProfileAvatarItem(url: userProvider.user.photo),
        ProfileItem(
          text: userProvider.user.idKary ?? '',
          icon: Icons.person,
          label: 'NIK',
        ),
        ProfileItem(
          text: userProvider.user.fullname ?? '',
          icon: Icons.person,
          label: 'Full name',
        ),
        SizedBox(
          height: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileItem(
              text: userProvider.user.nama ?? '',
              icon: Icons.person,
              label: 'Username',
            ),
            ProfileItem(
              text: userProvider.user.ktp ?? '',
              icon: Icons.person,
              label: 'No KTP',
            ),
            SizedBox(
              height: 8,
            ),
            ProfileItem(
              text: userProvider.user.email ?? '',
              icon: Icons.email,
              label: 'Email',
            ),
            ProfileItem(
              text: userProvider.user.email2 ?? '',
              icon: Icons.email,
              label: 'Email 2',
            ),
            ProfileItem(
              text: userProvider.user.noTelp1 ?? '',
              icon: Icons.numbers,
              label: 'No HP',
            ),
            ProfileItem(
              text: userProvider.user.noTelp2 ?? '',
              icon: Icons.numbers,
              label: 'No HP 2',
            ),
            ProfileItem(
              text: userProvider.user.deptList ?? '',
              icon: Icons.list,
              label: 'Departemen',
            ),
            ProfileItem(
              text: userProvider.user.company ?? '',
              icon: Icons.location_city,
              label: 'Company',
            ),
            ProfileItem(
              icon: Icons.business_center,
              text: userProvider.user.jabatan ?? '',
              label: 'Jabatan',
            ),
            ProfileItem(
              text: userProvider.user.imeiHp ?? '',
              icon: Icons.numbers,
              label: 'Installation ID',
            ),
            SizedBox(
              height: 8,
            ),
            if (userProvider.user.password != null) ...[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.primaryColor),
                padding: EdgeInsets.all(4),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PASSWORD : ',
                      style:
                          Themes.customColor(FontWeight.bold, 15, Colors.white),
                    ),
                    Text(
                      '${passwordVisible ? userProvider.user.password ?? '' : '*'.padRight(userProvider.user.password!.length, '*')}',
                      style:
                          Themes.customColor(FontWeight.bold, 10, Colors.white),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 30,
                      child: TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () => ref
                            .read(passwordVisibleProvider.notifier)
                            .state = toggleVisibility(passwordVisible),
                        child: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      child: TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        onPressed: () => copyAndNotify(
                            userProvider.user.password ?? '', context),
                        child: Icon(
                          Icons.copy,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ]
          ],
        )
      ],
    );
  }

  bool toggleVisibility(bool visibility) {
    return visibility ? false : true;
  }

  void copyAndNotify(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));

    AlertHelper.showSnackBar(context, message: 'Password copied');
  }
}
