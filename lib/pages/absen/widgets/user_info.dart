import 'package:flutter/material.dart';

import '../../../../../style/style.dart';

class WelcomeLabel extends StatelessWidget {
  const WelcomeLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            title,
            style: Themes.grey(FontWeight.normal, 18),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({required this.title, required this.user});

  final String title;
  final String user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            title,
            style: Themes.grey(FontWeight.normal, 18),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            user,
            style: Themes.customColor(FontWeight.bold, 24, Colors.black),
          ),
        ),
      ],
    );
  }
}
