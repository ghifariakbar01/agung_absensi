import 'package:flutter/material.dart';

import '../../../style/style.dart';
import '../../../widgets/icon_animated_widget.dart';

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
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(0),
          ),
          onPressed: onPressed,
          child: Row(
            children: [
              Text(
                '$title',
                style: Themes.customColor(
                  14,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              const IconAnimatedWidget()
            ],
          ),
        ),
        Text(
          label,
          style: Themes.customColor(
            14,
          ),
        ),
      ],
    );
  }
}
