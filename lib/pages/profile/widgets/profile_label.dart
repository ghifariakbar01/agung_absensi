import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';

import '../../../style/style.dart';

class ProfileLabel extends StatelessWidget {
  const ProfileLabel({Key? key, required this.icon, required this.label})
      : super(key: key);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Palette.primaryColor,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          label,
          style: Themes.blueSpaced(FontWeight.bold, 13),
        )
      ],
    );
  }
}
