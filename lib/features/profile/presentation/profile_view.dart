import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/providers.dart';
import '../../../style/style.dart';
import 'widgets/profile_item.dart';
import 'widgets/profile_password.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.watch(userNotifierProvider);
    final _baseUrl = ref
        .watch(dioProviderCuti)
        .options
        .baseUrl
        .replaceAll('/services', '/Img_User');

    return Column(
      children: [
        CachedNetworkImage(
            errorWidget: (context, url, error) {
              return Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Palette.primaryColor,
                ),
                child: Icon(
                  Icons.person,
                  size: 150,
                  color: Colors.white,
                ),
              );
            },
            imageUrl: '$_baseUrl/${userProvider.user.idUser}.jpg',
            imageBuilder: (context, imageProvider) => Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )),
        ProfileItem(
          text: userProvider.user.IdKary ?? '-',
          icon: Icons.person,
          label: 'NIK',
        ),
        ProfileItem(
          text: userProvider.user.fullname ?? '-',
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
              text: userProvider.user.nama ?? '-',
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
              text: userProvider.user.email ?? '-',
              icon: Icons.email,
              label: 'Email',
            ),
            ProfileItem(
              text: userProvider.user.email2 ?? '-',
              icon: Icons.email,
              label: 'Email 2',
            ),
            ProfileItem(
              text: userProvider.user.noTelp1 == null
                  ? '-'
                  : userProvider.user.noTelp1!.isEmpty
                      ? '-'
                      : userProvider.user.noTelp1!,
              icon: Icons.numbers,
              label: 'No HP',
            ),
            ProfileItem(
              text: userProvider.user.noTelp2 == null
                  ? '-'
                  : userProvider.user.noTelp2!.isEmpty
                      ? '-'
                      : userProvider.user.noTelp2!,
              icon: Icons.numbers,
              label: 'No HP 2',
            ),
            ProfileItem(
              text: userProvider.user.deptList ?? '-',
              icon: Icons.list,
              label: 'Departemen',
            ),
            ProfileItem(
              text: userProvider.user.company ?? '-',
              icon: Icons.location_city,
              label: 'Company',
            ),
            ProfileItem(
              icon: Icons.business_center,
              text: userProvider.user.jabatan ?? '-',
              label: 'Jabatan',
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
