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
      backgroundColor: Palette.primaryColor.withOpacity(0.9),
      child: ListView(
        children: [
          ColoredBox(
            color: Palette.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ProfileAvatarItem(
                    color: Palette.primaryDarker,
                    url: userProvider.user.photo,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'NIK : ${userProvider.user.idKary ?? ''}',
                    style:
                        Themes.customColor(FontWeight.bold, 15, Colors.white),
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
                            FontWeight.bold, 15, Colors.white),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      TextButton(
                        onPressed: () =>
                            context.pushNamed(RouteNames.profileNameRoute),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
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
          ),
        ],
      ),
    );
  }
}
