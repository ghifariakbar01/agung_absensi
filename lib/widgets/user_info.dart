import 'package:face_net_authentication/constants/assets.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../style/style.dart';

class UserInfo extends ConsumerWidget {
  const UserInfo(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nama = ref.watch(
      userNotifierProvider.select((value) => value.user.nama ?? ''),
    );

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Image.asset(Assets.iconLogo),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            nama,
            style: Themes.customColor(
              20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
