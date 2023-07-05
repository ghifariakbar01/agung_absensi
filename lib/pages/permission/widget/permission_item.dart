import 'package:flutter/material.dart';

import '../../../../style/style.dart';
import '../../widgets/proceed_widget.dart';

class PermissionItem extends StatelessWidget {
  const PermissionItem(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.label})
      : super(key: key);

  final Function() onPressed;
  final String title;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProceedWidget(onPressed, title),
        Text(
          label,
          style: Themes.customColor(FontWeight.normal, 14, Colors.black),
        ),
      ],
    );
  }
}
