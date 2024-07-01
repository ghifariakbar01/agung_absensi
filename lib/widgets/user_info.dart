import 'package:flutter/material.dart';

import '../constants/assets.dart';
import '../style/style.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({required this.title, required this.user});

  final String title;
  final String user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 325,
          height: 100,
          child: Image.asset(Assets.iconLogo),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            user,
            style: Themes.customColor(
              40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
