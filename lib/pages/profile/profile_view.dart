import 'package:face_net_authentication/pages/profile/widgets/profile_password.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/profile_item.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.watch(userNotifierProvider);

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
              ProfilePassword(),
              SizedBox(
                height: 8,
              ),
            ]
          ],
        )
      ],
    );
  }
}
