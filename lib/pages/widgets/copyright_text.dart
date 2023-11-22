import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';

class CopyrightAgung extends StatelessWidget {
  const CopyrightAgung({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'FILL IN AND GENERAL EMPLOYEE INFORMATION\n © M.I.S AGUNG LOGISTICS 2023',
      textAlign: TextAlign.center,
      maxLines: 2,
      style: Themes.customColor(
        FontWeight.bold,
        8,
      ),
    );
  }
}
