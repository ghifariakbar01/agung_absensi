import 'package:flutter/material.dart';

import '../../../style/style.dart';
import 'profile_label.dart';

class ProfileItem extends StatelessWidget {
  const ProfileItem(
      {Key? key, required this.text, required this.icon, required this.label})
      : super(key: key);

  final String text;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 8,
        ),
        ProfileLabel(
          icon: icon,
          label: label,
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          text,
          style: Themes.customColor(FontWeight.bold, 15, Colors.black),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
