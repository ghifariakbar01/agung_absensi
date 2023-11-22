import 'package:face_net_authentication/application/routes/route_names.dart';
import 'package:face_net_authentication/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../style/style.dart';
import '../profile/widgets/profile_avatar.dart';

class WelcomeDrawer extends ConsumerWidget {
  const WelcomeDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.watch(userNotifierProvider);

    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // ProfileAvatarItem(
                //   color: Colors.white.withOpacity(0.1),
                //   url: userProvider.user.photo,
                // ),
                // SizedBox(
                //   height: 8,
                // ),
                Text(
                  'NIK : ${userProvider.user.idKary ?? ''}',
                  style: Themes.customColor(
                    FontWeight.bold,
                    15,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userProvider.user.fullname ?? '',
                      style: Themes.customColor(
                        FontWeight.bold,
                        15,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    TextButton(
                      onPressed: () =>
                          context.pushNamed(RouteNames.profileNameRoute),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                //
              ],
            ),
          ),
        ],
      ),
    );
  }
}
